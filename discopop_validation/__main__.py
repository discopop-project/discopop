"""Discopop validation

Usage:
    discopop_validation [--path <path>] [--plugins <plugs>] \
[--reduction <reduction>] [--fmap <fmap>] [--ll-file <llfile>] [--json <jsonfile] \
[--profiling <value>] [--call-graph <value>] [--verbose <value>] [--data-race-output <path>] [--dp-build-path <path>] \
[--validation-time-limit <seconds>] [--thread-count <threads>] [--dp-profiling-executable <path>] [--pet-dump-file <path>]

Options:
    --path=<path>               Directory with input data [default: ./]
    --reduction=<reduction>     Reduction variables file [default: reduction.txt]
    --ll-file=<llfile>          Path to .ll file to be analyzed
    --json=<jsonfile>           Path to .json file, which contains parallelization suggestions to be analyzed
    --fmap=<fmap>               File mapping [default: FileMapping.txt]
    --plugins=<plugs>           Plugins to execute
    --profiling=<value>         Enable profiling mode. Values: true / false [default: false]
    --call-graph=<path>         Enable call graph creation and output result to given path.
    --verbose=<value>           Enable debug prints. Values: true / false [default: false]
    --data-race-output=<path>   Output found data races to the specified file if set.
    --dp-build-path=<path>      Path to discopop build folder. [default: build]
    --validation-time-limit=<seconds>   Maximum time in seconds to validate a single suggestion.
                                        Using this flag can lead to an underestimation of data races
                                        and nondeterministic results.
    --thread-count=<threads>    Thread count to be used for multithreaded program parts.
    --dp-profiling-executable=<path>   Path to an executable which is able to automatically execute the discopop profiling.
    --pet-dump-file=<path>      Path to the PET dump file. If existing, cu-xml, dep-file and loop-counter are not necessary.
                                The dump file will be overwritten if a modification in the source code has been detected!
    -h --help                   Show this screen
"""
import os
import sys
import cProfile
import time
from typing import List

from docopt import docopt
from schema import SchemaError, Schema, Use  # type: ignore

from discopop_explorer import PETGraphX
from discopop_validation.classes.Configuration import Configuration
#from discopop_validation.data_race_prediction.target_code_sections.extraction import \
#    identify_target_sections_from_suggestions
from discopop_validation.data_race_prediction.parallel_construct_graph.classes.EdgeType import EdgeType
from discopop_validation.data_race_prediction.parallel_construct_graph.classes.ResultObject import ResultObject
from discopop_validation.data_race_prediction.parallel_construct_graph.classes.PCGraph import PCGraph
from discopop_validation.memory_access_graph import MAGDataRace
from discopop_validation.memory_access_graph.DataRaceDetection import detect_data_races, print_data_races
from discopop_validation.memory_access_graph.MemoryAccessGraph import MemoryAccessGraph
from discopop_validation.source_code_modifications.core import handle_source_code_modifications
from discopop_validation.utils import __extract_data_sharing_clauses_from_pet, __preprocess_omp_pragmas, \
    __get_omp_pragmas
from .interfaces.discopop_explorer import get_pet_graph
from pycallgraph2 import PyCallGraph  # type: ignore
from pycallgraph2.output import GraphvizOutput  # type: ignore
from pycallgraph2 import Config
from pycallgraph2 import GlobbingFilter
from pycallgraph2 import Grouper

docopt_schema = Schema({
    '--path': Use(str),
    '--reduction': Use(str),
    '--ll-file': Use(str),
    '--json': Use(str),
    '--fmap': Use(str),
    '--plugins': Use(str),
    '--profiling': Use(str),
    '--call-graph': Use(str),
    '--verbose': Use(str),
    '--data-race-output': Use(str),
    '--dp-build-path': Use(str),
    '--validation-time-limit': Use(str),
    '--thread-count': Use(str),
    '--dp-profiling-executable': Use(str),
    '--pet-dump-file': Use(str),
})


def get_path(base_path: str, file_name: str) -> str:
    """Combines path and filename if it is not absolute

    :param base_path: path
    :param file_name: file name
    :return: path to file
    """
    return file_name if os.path.isabs(file_name) else os.path.join(base_path, file_name)


def main():
    """Argument handling."""
    arguments = docopt(__doc__)
    try:
        arguments = docopt_schema.validate(arguments)
    except SchemaError as e:
        exit(e)

    path = arguments["--path"]
    reduction_file = get_path(path, arguments['--reduction'])
    ll_file = get_path(path, arguments['--ll-file'])
    json_file = get_path(path, arguments['--json'])
    file_mapping = get_path(path, 'FileMapping.txt')
    verbose_mode = arguments["--verbose"] == "true"
    data_race_output_path = arguments["--data-race-output"]
    dp_build_path = arguments["--dp-build-path"]
    validation_time_limit = arguments["--validation-time-limit"]
    thread_count = arguments["--thread-count"]
    dp_profiling_executable = arguments["--dp-profiling-executable"]
    pet_dump_file = arguments["--pet-dump-file"]
    if thread_count == "None":
        thread_count = 1
    else:
        thread_count = int(thread_count)
    if data_race_output_path != "None":
        data_race_output_path = get_path(path, data_race_output_path)
    for file in [reduction_file, ll_file, pet_dump_file]:
        if not os.path.isfile(file):
            print(f"File not found: \"{file}\"")
            sys.exit()
    plugins = [] if arguments['--plugins'] == 'None' else arguments['--plugins'].split(' ')

    run_configuration = Configuration(path, reduction_file, json_file,
                                      file_mapping, ll_file, verbose_mode, data_race_output_path, dp_build_path,
                                      validation_time_limit, thread_count, dp_profiling_executable, pet_dump_file,
                                      arguments)

    if arguments["--call-graph"] != "None":
        print("call graph creation enabled...")
        groups = []
        for dir in os.walk(os.getcwd()+"/discopop_validation"):
            groups.append(dir[0].replace(os.getcwd()+"/", "").replace("/", ".")+".*")
        groups = sorted(groups, reverse=True)
        trace_grouper = Grouper(groups)

        config = Config()
        config.trace_grouper = trace_grouper
        config.trace_filter = GlobbingFilter(include=[
            'discopop_validation.*',
            '__main_*',
            'data_race_prediction.*',
        ])
        with PyCallGraph(output=GraphvizOutput(output_file=arguments["--call-graph"]), config=config):
            __main_start_execution(run_configuration)
    else:
        __main_start_execution(run_configuration)


def generic_preparation(pet, pc_graph, run_configuration, omp_pragmas):
    # insert nodes for called functions
    # pc_graph.insert_called_function_nodes_and_calls_edges(pet, omp_pragmas)

    # insert function nodes
    pc_graph.insert_function_nodes(pet)

    # insert contains edges between function nodes and contained pragma nodes
    pc_graph.insert_function_contains_edges()

    # identify target code sections of pragmas
    for node in pc_graph.graph.nodes:
        print("NODE: ", node)
        pc_graph.graph.nodes[node]["data"].identify_target_code_sections(pc_graph, run_configuration)
        print(pc_graph.graph.nodes[node]["data"].target_code_sections)

    # insert PCGraph nodes for lines inbetween contained pragmas
    pc_graph.insert_pcg_nodes_inbetween_pragmas()

    # if nodes are contained in each other, they are not part of the created sequence.
    # create contains edges for between such nodes
    pc_graph.draw_node_contains_edges()

    pc_graph.remove_redundant_contains_edges()

    # since no holes exists at this point in time, use the opportunity to draw accurate sequence edges
    # between children nodes
    pc_graph.draw_sequence_edges_for_contained_nodes()

    # create sequence edges between contained nodes, but this time it does not require perfect continuity
    pc_graph.draw_sequence_edges_for_contained_nodes_2()

    pc_graph.insert_behavior_models(run_configuration, pet, omp_pragmas)

    # remove PCGraphNodes without stored behavior information
    pc_graph.remove_empty_pcgraph_nodes()

    # insert calls edges
    pc_graph.insert_calls_edges(pet, omp_pragmas)
    # insert parallel sections for called functions
    pc_graph.insert_parallel_sections_for_called_functions()

    # pass shared clauses to child nodes
    pc_graph.pass_shared_clauses_to_childnodes()

    # identify target code sections of pragmas
    for node in pc_graph.graph.nodes:
        pc_graph.graph.nodes[node]["data"].identify_target_code_sections(pc_graph, run_configuration)

    pc_graph.insert_behavior_models(run_configuration, pet, omp_pragmas)

    #pc_graph.new_insert_behavior_storage_nodes()  # trivial, thus excluded for now for overview purposes

    # insert sequential edge from root to un-called function (no function call in pragma occured)
    pc_graph.include_uncalled_functions()

    # create implicit barriers
    pc_graph.insert_implicit_barriers()

    #(todo)  create sub-sequences for parallel regions (denoted by "belongs_to" relations to barriers)

    return pc_graph


def add_forking_information(pc_graph):
    pc_graph.mark_barrier_affiliations()

    pc_graph = fix_barrier_affiliations(pc_graph)

    # insert fork nodes
    pc_graph.insert_fork_nodes()

    pc_graph.remove_function_nodes()
    pc_graph.remove_bhv_nodes_if_not_contained_in_parallel_pragma()

    return pc_graph

def prepare_tasks(pet, pc_graph, run_configuration, omp_pragmas):
    pc_graph.redirect_tasks_successors()

    return pc_graph

def prepare_for(pet, pc_graph, run_configuration, omp_pragmas):
    pc_graph.new_replace_pragma_for_nodes()
    return pc_graph

def prepare_dependences(pet, pc_graph, run_configuration, omp_pragmas):
    pc_graph.add_depends_edges()

    pc_graph.replace_depends_with_sequential_edges()
    # redirect Task successor to proper barrier
    #pc_graph.redirect_tasks_successors()

    pc_graph.check_and_fix_dependences_to_barriers()
    return pc_graph

def fix_barrier_affiliations(pc_graph):
    pc_graph.fix_sibling_task_barrier_affiliation()

    return pc_graph


def __main_start_execution(run_configuration: Configuration):
    time_start_execution = time.time()
    if run_configuration.arguments["--profiling"] == "true":
        profile = cProfile.Profile()
        profile.enable()
        print("profiling enabled...")
    if run_configuration.verbose_mode:
        print("creating PET Graph...")
    time_start_ps = 0.0
    time_total_pc_graph = 0.0
    time_bhv_extraction_total = 0.0
    time_data_race_computation_total = 0.0

    # check whether re-profiling is required and modify PET to accommodate changed source code lines if required
    time_construct_pet_graph_start = time.time()
    pet: PETGraphX = get_pet_graph(run_configuration)
    time_modify_pet_graph_start = time.time()
    pet = handle_source_code_modifications(pet, run_configuration)
    time_modify_pet_graph_end = time.time()
    #pet.show()


    time_start_ps = time.time()
    omp_pragma_list = __get_omp_pragmas(run_configuration, pet)

    omp_pragma_list = __preprocess_omp_pragmas(omp_pragma_list)

    # extract data sharing clauses for pragmas from pet graph
    omp_pragma_list = __extract_data_sharing_clauses_from_pet(pet, omp_pragma_list)

    time_end_ps = time.time()
    data_race_txt_written = False
    if run_configuration.data_race_ouput_path != "None":
        if os.path.exists(run_configuration.data_race_ouput_path):
            os.remove(run_configuration.data_race_ouput_path)

    for omp_pragmas in omp_pragma_list:
        # construct parallel construct graph
        time_pc_graph_start = time.time()
        pc_graph = PCGraph()

        for pragma in omp_pragmas:
            pc_graph.add_pragma_node(pragma)

        pc_graph = generic_preparation(pet, pc_graph, run_configuration, omp_pragmas)

        pc_graph = prepare_for(pet, pc_graph, run_configuration, omp_pragmas)

        pc_graph = prepare_tasks(pet, pc_graph, run_configuration, omp_pragmas)

        pc_graph = prepare_dependences(pet, pc_graph, run_configuration, omp_pragmas)

        pc_graph = add_forking_information(pc_graph)


# actually not necessary, since behavior is stored in the pragma nodes themselves
#        pc_graph.insert_behavior_storage_nodes()  # trivial, thus excluded for now for overview purposes

#### OLD CODE

        # insert edges into the graph
#        pc_graph.add_edges(pet, omp_pragmas)
        #pc_graph.plot_graph()
#        pc_graph.remove_redundant_contains_edges()

        # remove all but the best fitting CALLS edges for each function call in the source code
#        pc_graph.remove_incorrect_function_contains_edges()

        # pass shared clauses to child nodes
#        pc_graph.pass_shared_clauses_to_childnodes()

        # identify pragma target code sections
#        for node in pc_graph.graph.nodes:
#            pc_graph.graph.nodes[node]["data"].identify_target_code_sections(pc_graph, run_configuration)

        # insert calls edges
#       pc_graph.insert_calls_edges(pet, omp_pragmas)

        # insert sequential edge from root to un-called function (no function call in pragma occured)
#        pc_graph.include_uncalled_functions()


        # insert parallel sections for called functions
#        pc_graph.insert_parallel_sections_for_called_functions()

#        for node in pc_graph.graph.nodes:
#            pc_graph.graph.nodes[node]["data"].identify_target_code_sections(pc_graph, run_configuration)

#        pc_graph.plot_graph()

        # remove threadprivate pragma and add specified variables to private clauses of contained pragmas
#        pc_graph.apply_and_remove_threadprivate_pragma()


        # remove redundant successor edges
#        pc_graph.remove_redundant_edges([EdgeType.SEQUENTIAL])
        # move successor edges if source is contained in a different pragma
#        pc_graph.move_successor_edges_if_source_is_contained_in_pragma()
        # move successor edges if target is contained in a different pragma
#        pc_graph.move_successor_edges_if_target_is_contained_in_pragma()
        # create implicit barriers
#        pc_graph.insert_implicit_barriers()

        # ORDER OF FOLLOWING 3 STATEMENTS MUST BE PRESERVED DUE TO MADE ASSUMPTIONS!
        # add depends edges between interdependent TASK nodes
#        pc_graph.add_depends_edges()
        # redirect successor edges of TASKS to next BARRIER or TASKWAIT
#        pc_graph.redirect_tasks_successors()
        # modify SEQUENTIAL edge to represent the behavior of identified DEPENDS edges
#        pc_graph.replace_depends_with_sequential_edges()
        # extract and insert behavior models for pragmas
#        time_bhv_extraction_start = time.time()
#        pc_graph.insert_behavior_models(run_configuration, pet, omp_pragmas)
#        time_bhv_extraction_end = time.time()
        # insert TaskGraphNodes to store behavior models
##        pc_graph.insert_behavior_storage_nodes()
#        pc_graph.new_insert_behavior_storage_nodes()
#        pc_graph.remove_redundant_contains_edges()
##        # create sequence for contained nodes of every node
##        pc_graph.create_sequence_for_contained_nodes()
##        pc_graph.new_create_sequence_for_contained_nodes()

        # remove sequential edges between tasks, as no ordering can be specified
#        pc_graph.remove_sequential_edges_between_tasks()

#        # if a node has multiple outgoing sequential edges, combine them into a single sequence
##        pc_graph.combined_out_sequential_edges_into_single_sequence()

        # restore sequence order after insertion of behavior storage nodes.
        # this step is not included in the insertion method to keep it slightly simpler.
##        pc_graph.restore_sequence_order()



        # remove FunctionNodes
        #pc_graph.plot_graph()
        #pc_graph.remove_function_nodes()
        #pc_graph.plot_graph()
        # remove redundant CONTAINS edges
#        pc_graph.remove_redundant_edges([EdgeType.CONTAINS])
        # replace SEQUENTIAL edges to Taskwait nodes with VIRTUAL_SEQUENTIAL edges
        # parallel_construct_graph.add_virtual_sequential_edges()
        # skip successive TASKWAIT node, if no prior TASK node exists
#        pc_graph.skip_taskwait_if_no_prior_task_exists()
#        pc_graph.add_fork_and_join_nodes()

        # make contained nodes part of the sequence

        #pc_graph.make_contained_nodes_part_of_sequence(0)  # 0 is the id of the ROOT node


### OLD OLD CODE


#        # remove TASKWAIT nodes without prior TASK node
#        pc_graph.remove_taskwait_without_prior_task()
#        #parallel_construct_graph.plot_graph()
#        # add join nodes prior to Barriers and Taskwait nodes
#        pc_graph.add_join_nodes_before_barriers()
#        # add join nodes at path merge points to reduce complexity
#        # NOT VALID
#        # parallel_construct_graph.add_join_nodes_before_path_merge()
#        # add fork nodes at path splits which are not caused by other FORK nodes
#        pc_graph.add_fork_nodes_at_path_splits()
#        # remove SINGLE nodes from graph and replace with contained nodes
#        pc_graph.plot_graph()
#        pc_graph.replace_pragma_single_nodes()
##        pc_graph.apply_pragma_single_nodes()
#        # remove FOR nodes from graph and replace with contained nodes
#        pc_graph.replace_pragma_for_nodes()
#        # remove join nodes with only one incoming SEQUENTIAL edge, if no ougoing sequential edge to Barrier or Taskwait exists
#        pc_graph.remove_single_incoming_join_node()
#        # remove sequential edges between Fork and Join nodes
#        pc_graph.remove_edges_between_fork_and_join()
#        # add BELONGS_TO edges between Fork and Join nodes
#        pc_graph.add_belongs_to_edges()
#        # mark behavior storage nodes which are already covered by fork nodes
#        pc_graph.mark_behavior_storage_nodes_covered_by_fork_nodes()
#        # add fork and join nodes around behavior storage node if it's not contained in a fork section
#        #pc_graph.add_fork_and_join_around_behavior_storage_nodes()
#
#        # remove behavior models from all but BehaviorStorageNodes
#        pc_graph.remove_behavior_models_from_nodes()
#
#        # replace successor edges of FORK node with outgoing CONTAINS edges and connect FORK node to JOIN node
#
#        # todo remove / ignore irrelevant join nodes
#        # todo enable nested fork nodes
#
        time_pc_graph_end = time.time()
#        time_total_pc_graph += time_pc_graph_end - time_pc_graph_start - (time_bhv_extraction_end - time_bhv_extraction_start)
#        time_bhv_extraction_total += time_bhv_extraction_end - time_bhv_extraction_start


        # replace PCGraphNodes with BehaviorModelNodes. In case of BehaviorModel.simulation_thread_count > 1, create
        # multiple nodes each of which represents a single behavior model and has a simulation_thread_count of 1.
        #pc_graph.replace_PCGraphNodes_with_BehaviorModelNodes()

        time_data_race_computation_start = time.time()

        # remove edges between ROOT and successors and create edges between ROOT and FORK nodes without incoming edges
        pc_graph.plot_graph()
        pc_graph.prepare_root_for_MAGraph_creation()

        memory_access_graph = MemoryAccessGraph(pc_graph, run_configuration)
        #memory_access_graph.plot_graph()
        data_races: List[MAGDataRace] = detect_data_races(memory_access_graph, pc_graph, pet)
        print_data_races(data_races, memory_access_graph)

        time_data_race_computation_end = time.time()
        time_data_race_computation_total += time_data_race_computation_end - time_data_race_computation_start



#        # trigger result computation
#        computed_result: ResultObject = parallel_construct_graph.compute_results()
#        # apply exception rules to detected data races
#        computed_result.apply_exception_rules_to_data_races(pet, parallel_construct_graph)
    #        time_data_race_computation_end = time.time()
#        time_data_race_computation_total += time_data_race_computation_end - time_data_race_computation_start
#        # print detected data races
#        computed_result.print_data_races()
#        # add identified data races to graph nodes for plotting
#        parallel_construct_graph.add_data_races_to_graph(computed_result)
#
#        #parallel_construct_graph.plot_graph(mark_data_races=True)
#        #parallel_construct_graph.plot_graph(mark_data_races=False)
#
#        # output found data races to file if requested
        if run_configuration.data_race_ouput_path != "None":
            buffer = []
            if data_race_txt_written:
                with open(run_configuration.data_race_ouput_path, "a+") as f:
                    # f.write("fileID;line;column\n")
                    for dr in data_races:
                    #for dr in computed_result.data_races:
                        # write line of first operation to file
                        dr_line_1 = str(dr.operation_1.line)
                        if dr_line_1 not in buffer:
                            f.write(dr_line_1 + " " + dr.operation_1.target_name + "\n")
                            buffer.append(dr_line_1)
                        # write line of second operation to file
                        dr_line_2 = str(dr.operation_2.line)
                        if dr_line_2 not in buffer:
                            f.write(dr_line_2 + " " + dr.operation_2.target_name + "\n")
                            buffer.append(dr_line_2)
            else:
                with open(run_configuration.data_race_ouput_path, "w+") as f:
                    data_race_txt_written = True
                    # f.write("fileID;line;column\n")
                    for dr in data_races:
                        # write data race line to file
                        dr_line_1 = str(dr.operation_1.line)
                        if dr_line_1 not in buffer:
                            f.write(dr_line_1 + " " + dr.operation_1.target_name + "\n")
                            buffer.append(dr_line_1)
                        # write line of second operation to file
                        dr_line_2 = str(dr.operation_2.line)
                        if dr_line_2 not in buffer:
                            f.write(dr_line_2 + " " + dr.operation_2.target_name + "\n")
                            buffer.append(dr_line_2)

    # correct tool support value in evaluation by creating data_races.txt file
    if not data_race_txt_written:
        if os.path.exists(run_configuration.data_race_ouput_path):
            os.remove(run_configuration.data_race_ouput_path)
        open(run_configuration.data_race_ouput_path, "w+")


    time_end_execution = time.time()
    print("### Measured Times: ###")
    print("--------------------------------------------------")
    print("--- Get PET graph: \t\t%.4f seconds ---" % (
                time_modify_pet_graph_start - time_construct_pet_graph_start))
    print("--- Modify PET graph: \t\t%.4f seconds ---" % (
                time_modify_pet_graph_end - time_modify_pet_graph_start))
    print("--- Get Pragmas: \t\t%.4f seconds ---" % (time_end_ps - time_start_ps))
    print("--- Create Task graph: \t\t%.4f seconds ---" % (time_total_pc_graph))
    print("--- Behavior Extraction: \t%.4f seconds ---" % (time_bhv_extraction_total))
    print("--- Detect Data races: \t\t%.4f seconds ---" % (time_data_race_computation_total))
    print("--- Total time: \t\t%.4f seconds ---" % (time_end_execution - time_start_execution))
    print("--------------------------------------------------")


if __name__ == "__main__":
    main()