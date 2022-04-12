"""Discopop validation

Usage:
    discopop_validation [--path <path>] [--cu-xml <cuxml>] [--dep-file <depfile>] [--plugins <plugs>] \
[--loop-counter <loopcount>] [--reduction <reduction>] [--fmap <fmap>] [--ll-file <llfile>] [--json <jsonfile] \
[--profiling <value>] [--call-graph <value>] [--verbose <value>] [--data-race-output <path>] [--dp-build-path <path>] \
[--validation-time-limit <seconds>] [--thread-count <threads>] [--omp-pragmas-file <path>]

Options:
    --path=<path>               Directory with input data [default: ./]
    --cu-xml=<cuxml>            CU node xml file [default: Data.xml]
    --dep-file=<depfile>        Dependencies text file [default: dp_run_dep.txt]
    --loop-counter=<loopcount>  Loop counter data [default: loop_counter_output.txt]
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
    --omp-pragmas-file=<path>   Check OpenMP pragmas in file. Specific formatting required!
    -h --help                   Show this screen
"""
import os
import sys
import cProfile
import time
import json
from typing import List, Dict

from docopt import docopt
from schema import SchemaError, Schema, Use

from discopop_explorer import PETGraphX, NodeType
from discopop_explorer.utils import classify_loop_variables, classify_task_vars
from discopop_validation.classes.Configuration import Configuration
from discopop_validation.classes.OmpPragma import OmpPragma, PragmaType
#from discopop_validation.data_race_prediction.target_code_sections.extraction import \
#    identify_target_sections_from_suggestions
from discopop_validation.data_race_prediction.task_graph.classes.EdgeType import EdgeType
from discopop_validation.data_race_prediction.task_graph.classes.ResultObject import ResultObject
from discopop_validation.data_race_prediction.task_graph.classes.TaskGraph import TaskGraph
from discopop_validation.data_race_prediction.utils import get_pet_node_id_from_source_code_lines
from discopop_validation.discopop_suggestion_interpreter.core import get_omp_pragmas_from_dp_suggestions
from .interfaces.discopop_explorer import get_pet_graph
from pycallgraph2 import PyCallGraph
from pycallgraph2.output import GraphvizOutput
from pycallgraph2 import Config
from pycallgraph2 import GlobbingFilter
from pycallgraph2 import Grouper

docopt_schema = Schema({
    '--path': Use(str),
    '--cu-xml': Use(str),
    '--dep-file': Use(str),
    '--loop-counter': Use(str),
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
    '--omp-pragmas-file': Use(str),
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
    cu_xml = get_path(path, arguments['--cu-xml'])
    dep_file = get_path(path, arguments['--dep-file'])
    loop_counter_file = get_path(path, arguments['--loop-counter'])
    reduction_file = get_path(path, arguments['--reduction'])
    ll_file = get_path(path, arguments['--ll-file'])
    json_file = get_path(path, arguments['--json'])
    file_mapping = get_path(path, 'FileMapping.txt')
    verbose_mode = arguments["--verbose"] == "true"
    data_race_output_path = arguments["--data-race-output"]
    dp_build_path = arguments["--dp-build-path"]
    validation_time_limit = arguments["--validation-time-limit"]
    thread_count = arguments["--thread-count"]
    omp_pragmas_file = get_path(path, arguments["--omp-pragmas-file"])
    if thread_count == "None":
        thread_count = 1
    else:
        thread_count = int(thread_count)
    if data_race_output_path != "None":
        data_race_output_path = get_path(path, data_race_output_path)
    for file in [cu_xml, dep_file, loop_counter_file, reduction_file, ll_file]:
        if not os.path.isfile(file):
            print(f"File not found: \"{file}\"")
            sys.exit()
    plugins = [] if arguments['--plugins'] == 'None' else arguments['--plugins'].split(' ')

    run_configuration = Configuration(path, cu_xml, dep_file, loop_counter_file, reduction_file, json_file,
                                      file_mapping, ll_file, verbose_mode, data_race_output_path, dp_build_path,
                                      validation_time_limit, thread_count, arguments, omp_pragmas_file)

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


def __extract_data_sharing_clauses_from_pet(pet, task_graph, omp_pragmas):
    pragma_to_cuid: Dict[OmpPragma, str] = dict()
    for pragma in omp_pragmas:
        cu_id = get_pet_node_id_from_source_code_lines(pet, pragma.file_id, pragma.start_line,
                                                       pragma.end_line)
        pragma_to_cuid[pragma] = cu_id

    print("####################################")
    print("PRAGMAS BEFORE ADDING FROM PET GRAPH")
    for pragma in omp_pragmas:
        print(pragma)
    print("####################################")

    for pragma in omp_pragmas:
        cu_id = pragma_to_cuid[pragma]
        if pet.node_at(cu_id).type == 2:
            # node is loop type
            fpriv, priv, lpriv, shared, red = classify_loop_variables(pet, pet.node_at(cu_id))
            for var in shared:
                if var.name not in pragma.get_variables_listed_as("shared"):
                    pragma.add_to_shared(var.name)
        #elif pragma.get_type() == PragmaType.TASK:
        #    fpriv, priv, shared, in_dep, out_dep, in_out_dep, red = classify_task_vars(pet, pet.node_at(cu_id), "", [], [])
        #    for var in shared:
        #        if var.name not in pragma.get_variables_listed_as("shared"):
        #            pragma.add_to_shared(var.name)
        elif pragma.get_type() == PragmaType.PARALLEL:
            # variables, which are declared outside the parallel region are shared
            # get a list of known variables and their definition lines from children nodes
            known_variables = []
            queue = [pet.node_at(cu_id)]
            visited = []
            while len(queue) > 0:
                current = queue.pop(0)
                visited.append(current)
                for local_var in current.local_vars:
                    known_variables.append((local_var.name, local_var.defLine))
                for global_var in current.global_vars:
                    known_variables.append((global_var.name, global_var.defLine))
                known_variables = list(set(known_variables))
                for child in pet.direct_children(current):
                    if child not in visited:
                        queue.append(child)
            # mark those variables which are defined outside the parallel region as shared
            shared_defined_outside = []
            for name, raw_def_line in known_variables:
                if raw_def_line == "LineNotFound":
                    continue
                if ":" in raw_def_line:
                    split_raw_def_line = raw_def_line.split(":")
                    def_line_file_id = int(split_raw_def_line[0])
                    def_line = int(split_raw_def_line[1])
                    if def_line_file_id == pragma.file_id:
                        if not pragma.start_line <= def_line <= pragma.end_line:
                            shared_defined_outside.append(name)
                elif raw_def_line == "GlobalVar":
                    shared_defined_outside.append(name)
                else:
                    raise ValueError("Unhandled definition line: ", raw_def_line)

            # todo maybe remove, reason it is included: save drastic amounts of computation time
            # remove variable from shared_defined_outside, if it's a loop index
            loop_indices_to_remove = []
            loops_start_lines = []
            for v in pet.subtree_of_type(pet.node_at(pragma_to_cuid[pragma]), NodeType.LOOP):
                loops_start_lines.append(v.start_position())
            for child in pet.direct_children(pet.node_at(pragma_to_cuid[pragma])):
                for var_name in shared_defined_outside:
                    if var_name in loop_indices_to_remove:
                        continue
                    if pet.is_loop_index(var_name, loops_start_lines, pet.subtree_of_type(pet.node_at(pragma_to_cuid[pragma]), NodeType.CU)):
                        loop_indices_to_remove.append(var_name)
            shared_defined_outside = [var for var in shared_defined_outside if var not in loop_indices_to_remove]

            # add outside-defined variables to list of shared variables
            for var_name in shared_defined_outside:
                if var_name not in pragma.get_variables_listed_as("shared"):
                    # check if var_name already use in another clause
                    if var_name not in pragma.get_known_variables():
                        pragma.add_to_shared(var_name)



    print("PRAGMAS AFTER ADDING FROM PET GRAPH")
    for pragma in omp_pragmas:
        print(pragma)
    print("###################################")

    return omp_pragmas


def __main_start_execution(run_configuration: Configuration):
    if run_configuration.arguments["--profiling"] == "true":
        profile = cProfile.Profile()
        profile.enable()
        print("profiling enabled...")
    if run_configuration.verbose_mode:
        print("creating PET Graph...")
    time_start_ps = time.time()
    pet: PETGraphX = get_pet_graph(run_configuration)

    # construct task graph
    task_graph = TaskGraph()

    omp_pragmas = __get_omp_pragmas(run_configuration)

    omp_pragmas = __preprocess_omp_pragmas(omp_pragmas)

    # extract data sharing clauses for pragmas from pet graph
    omp_pragmas = __extract_data_sharing_clauses_from_pet(pet, task_graph, omp_pragmas)


    time_end_ps = time.time()

    for pragma in omp_pragmas:
        task_graph.add_pragma_node(pragma)
    # insert nodes for called functions
    task_graph.insert_called_function_nodes_and_calls_edges(pet, omp_pragmas)
    # insert contains edges between function nodes and contained pragma nodes
    task_graph.insert_function_contains_edges()
    # remove all but the best fitting CALLS edges for each function call in the source code
    task_graph.remove_incorrect_function_contains_edges()

    # insert edges into the graph
    task_graph.add_edges(pet, omp_pragmas)
    # pass shared clauses to child nodes
    task_graph.pass_shared_clauses_to_childnodes()
    # remove redundant successor edges
    task_graph.remove_redundant_edges([EdgeType.SEQUENTIAL])
    # move successor edges if source is contained in a different pragma
    task_graph.move_successor_edges_if_source_is_contained_in_pragma()
    # move successor edges if target is contained in a different pragma
    task_graph.move_successor_edges_if_target_is_contained_in_pragma()
    # create implicit barriers
    task_graph.insert_implicit_barriers()

    # ORDER OF FOLLOWING 3 STATEMENTS MUST BE PRESERVED DUE TO MADE ASSUMPTIONS!
    # add depends edges between interdependent TASK nodes
    task_graph.add_depends_edges()
    # redirect successor edges of TASKS to next BARRIER or TASKWAIT
    task_graph.redirect_tasks_successors()
    # modify SEQUENTIAL edge to represent the behavior of identified DEPENDS edges
    task_graph.replace_depends_with_sequential_edges()

    # extract and insert behavior models for pragmas
    task_graph.insert_behavior_models(run_configuration, pet, omp_pragmas)
    # insert TaskGraphNodes to store behavior models
    task_graph.insert_behavior_storage_nodes()
    # remove CalledFunctionNodes
    task_graph.remove_called_function_nodes()
    # remove redundant CONTAINS edges
    task_graph.remove_redundant_edges([EdgeType.CONTAINS])
    # replace SEQUENTIAL edges to Taskwait nodes with VIRTUAL_SEQUENTIAL edges
    # task_graph.add_virtual_sequential_edges()
    # skip successive TASKWAIT node, if no prior TASK node exists
    task_graph.skip_taskwait_if_no_prior_task_exists()

    #task_graph.add_fork_and_join_nodes()
    # remove TASKWAIT nodes without prior TASK node
    task_graph.remove_taskwait_without_prior_task()
    #task_graph.plot_graph()
    # add join nodes prior to Barriers and Taskwait nodes
    task_graph.add_join_nodes_before_barriers()
    # add join nodes at path merge points to reduce complexity
    # NOT VALID
    # task_graph.add_join_nodes_before_path_merge()
    # add fork nodes at path splits which are not caused by other FORK nodes
    task_graph.add_fork_nodes_at_path_splits()
    # remove SINGLE nodes from graph and replace with contained nodes
    task_graph.replace_pragma_single_nodes()
    # remove FOR nodes from graph and replace with contained nodes
    task_graph.replace_pragma_for_nodes()
    # remove join nodes with only one incoming SEQUENTIAL edge, if no ougoing sequential edge to Barrier or Taskwait exists
    task_graph.remove_single_incoming_join_node()
    # remove sequential edges between Fork and Join nodes
    task_graph.remove_edges_between_fork_and_join()
    # add BELONGS_TO edges between Fork and Join nodes
    task_graph.add_belongs_to_edges()
    # mark behavior storage nodes which are already covered by fork nodes
    task_graph.mark_behavior_storage_nodes_covered_by_fork_nodes()
    # add fork and join nodes around behavior storage node if it's not contained in a fork section
    task_graph.add_fork_and_join_around_behavior_storage_nodes()

    # remove behavior models from all but BehaviorStorageNodes
    task_graph.remove_behavior_models_from_nodes()

    # replace successor edges of FORK node with outgoing CONTAINS edges and connect FORK node to JOIN node

    # todo remove / ignore irrelevant join nodes
    # todo enable nested fork nodes


    print("PRE COMPUTATION")
    #task_graph.plot_graph()

    # trigger result computation
    computed_result: ResultObject = task_graph.compute_results()
    # apply exception rules to detected data races
    computed_result.apply_exception_rules_to_data_races(pet, task_graph)
    # print detected data races
    computed_result.print_data_races()
    # add identified data races to graph nodes for plotting
    task_graph.add_data_races_to_graph(computed_result)

    #task_graph.plot_graph(mark_data_races=True)
    #task_graph.plot_graph(mark_data_races=False)

    # output found data races to file if requested
    if run_configuration.data_race_ouput_path != "None":
        if os.path.exists(run_configuration.data_race_ouput_path):
            os.remove(run_configuration.data_race_ouput_path)
        buffer = []
        with open(run_configuration.data_race_ouput_path, "w+") as f:
            # f.write("fileID;line;column\n")
            for dr in computed_result.data_races:
                # write data race line to file
                split_dr_info = dr.get_location_str().split(";")
                dr_line = split_dr_info[1]
                if dr_line not in buffer:
                    f.write(dr_line + "\n")
                    buffer.append(dr_line)
                # write line of previous action to file aswell
                last_access_lines = dr.get_relevant_previous_access_lines()
                for line in last_access_lines:
                    line = str(line)
                    if line not in buffer:
                        f.write(line + "\n")
                        buffer.append(line)


                #if dr.get_location_str() not in buffer:
                #    f.write(dr.get_location_str() + "\n")
                #    buffer.append(dr.get_location_str())

    time_end_validation = time.time()
    time_end_execution = time.time()
    print("\n### Measured Times: ###")
    print("-------------------------------------------")
    print("--- Get parallelization suggestions: %s seconds ---" % (time_end_ps - time_start_ps))
    print("--- Validating suggestions: %s seconds ---" % (time_end_validation - time_end_ps))
    #print("--- Create schedules: %s seconds ---" % (time_end_schedules - time_end_bb))
    #print("--- Check for Data Races: %s seconds ---" % (time_end_data_races - time_end_schedules))
    print("--- Total time: %s seconds ---" % (time_end_execution - time_start_ps))


def __preprocess_omp_pragmas(omp_pragmas: List[OmpPragma]):
    result = []
    for omp_pragma in omp_pragmas:
        # split parallel for pragma
        if omp_pragma.get_type() == PragmaType.PARALLEL_FOR:
            parallel_pragma = OmpPragma()
            parallel_pragma.file_id = omp_pragma.file_id
            parallel_pragma.start_line = omp_pragma.start_line-1
            parallel_pragma.end_line = omp_pragma.end_line
            first_privates = " ".join([var + "," for var in omp_pragma.get_variables_listed_as("first_private")])
            privates = " ".join([var + "," for var in omp_pragma.get_variables_listed_as("private")])
            last_privates = " ".join([var + "," for var in omp_pragma.get_variables_listed_as("last_private")])
            shared = " ".join([var + "," for var in omp_pragma.get_variables_listed_as("shared")])
            parallel_pragma.pragma = "parallel "
            parallel_pragma.pragma += "firstprivate(" + first_privates + ") "
            parallel_pragma.pragma += "private(" + privates + ") "
            parallel_pragma.pragma += "lastprivate(" + last_privates + ") "
            parallel_pragma.pragma += "shared(" + shared + ") "
            result.append(parallel_pragma)
            omp_pragma.pragma = omp_pragma.pragma.replace("parallel ", "")
        result.append(omp_pragma)
    return result



def __get_omp_pragmas(run_configuration: Configuration):
    omp_pragmas = []
    # parse openmp pragmas file if parameter is set and file exists
    if os.path.isfile(run_configuration.omp_pragmas_file):
        with open(run_configuration.omp_pragmas_file) as f:
            for line in f.readlines():
                line = line.replace("\n", "")
                while line.startswith(" "):
                    line = line[1:]
                if line.startswith("//"):
                    # use // as comment marker
                    continue
                while "  " in line:
                    line = line.replace("  ", " ")
                omp_pragmas.append(OmpPragma().init_with_pragma_line(line))
    # interpret DiscoPoP suggestions if parameter is set and file exists
    if os.path.isfile(run_configuration.json_file):
        with open(run_configuration.json_file) as f:
            parallelization_suggestions = json.load(f)
            omp_pragmas += get_omp_pragmas_from_dp_suggestions(parallelization_suggestions)
    return omp_pragmas


"""
def __old_main_start_execution(cu_xml, dep_file, loop_counter_file, reduction_file, json_file, file_mapping, ll_file, verbose_mode, data_race_output_path, arguments):
    if arguments["--profiling"] == "true":
        profile = cProfile.Profile()
        profile.enable()
        print("profiling enabled...")
    if verbose_mode:
        print("creating PET Graph...")
    time_start_ps = time.time()
    pet = get_pet_graph(cu_xml, dep_file, loop_counter_file, reduction_file)
    with open(json_file) as f:
        parallelization_suggestions = json.load(f)
    time_end_ps = time.time()
    if verbose_mode:
        print("identify target code sections")
    target_code_sections = identify_target_sections_from_suggestions(parallelization_suggestions)
    if verbose_mode:
        print("creating BB Graph...")
    bb_graph = execute_bb_graph_extraction(parallelization_suggestions, target_code_sections, file_mapping, ll_file, arguments["--dp-build-path"])
    if verbose_mode:
        print("insering critical sections into BB Graph...")
    insert_critical_sections(bb_graph, parallelization_suggestions)

    if verbose_mode:
        print("creating Schedules....")
    time_end_bb = time.time()
    sections_to_schedules_dict = create_schedules_for_sections(bb_graph,
                                                               get_possible_path_combinations_for_sections(
                                                                   bb_graph),
                                                               verbose=verbose_mode)
    if verbose_mode:
        print("checking for Data Races...")
    time_end_schedules = time.time()
    unfiltered_data_races = check_sections(sections_to_schedules_dict)
    if verbose_mode:
        print("filtering Data Races...")
    filtered_data_races = apply_exception_rules(unfiltered_data_races, pet, parallelization_suggestions)
    filtered_data_race_strings = get_filtered_data_race_strings(filtered_data_races)
    time_end_data_races = time.time()

    # print found data races
    for dr_str in filtered_data_race_strings:
        print(dr_str)

    # write found data races to file if requested
    try:
        os.remove(data_race_output_path)
    except OSError:
        pass
    if data_race_output_path != "None":
        with open(data_race_output_path, "w+") as f:
            for dr_str in filtered_data_race_strings:
                f.write(dr_str)

    print("\n###########################################")
    print("######### AUXILIARY INFORMATION ###########")
    print("###########################################\n")

    if arguments["--profiling"] == "true":
        profile.disable()
        profile.print_stats(sort="tottime")

    print("### DiscoPoP Do-All Suggestions: ###")
    print("-------------------------------------------")
    for suggestion in parallelization_suggestions["do_all"]:
        print("-->",suggestion, "\n")

    if "critical_section" in parallelization_suggestions:
        print("### DiscoPoP Critical-Section Suggestions: ###")
        print("-------------------------------------------")
        for suggestion in parallelization_suggestions["critical_section"]:
            print("-->", suggestion, "\n")

    # print graph information
    if verbose_mode:
        print("### Counted sections, paths and shared var operations: ###")
        print("-------------------------------------------")
        path_dict = get_paths_for_sections(bb_graph)
        total_paths = 0
        for section_id in path_dict:
            total_paths += len(path_dict[section_id])
        total_operations = 0
        for bb_node_id in bb_graph.graph.nodes:
            total_operations += len(bb_graph.graph.nodes[bb_node_id]["data"].operations)
        print("\ttotal section count: ", len(path_dict))
        print("\ttotal path count: ", total_paths)
        print("\ttotal operations count: ", total_operations)


    print("\n### Measured Times: ###")
    print("-------------------------------------------")
    print("--- Get Parallelization Suggestions: %s seconds ---" % (time_end_ps - time_start_ps))
    print("--- Construct BB Graph: %s seconds ---" % (time_end_bb - time_end_ps))
    print("--- Create Schedules: %s seconds ---" % (time_end_schedules - time_end_bb))
    print("--- Check for Data Races: %s seconds ---" % (time_end_data_races - time_end_schedules))
    print("--- Total time: %s seconds ---" % (time_end_data_races - time_start_ps))
"""

if __name__ == "__main__":
    main()


