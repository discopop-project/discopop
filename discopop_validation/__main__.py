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

from docopt import docopt
from schema import SchemaError, Schema, Use

from discopop_explorer import PETGraphX
from discopop_validation.classes.Configuration import Configuration
from discopop_validation.classes.OmpPragma import OmpPragma
from discopop_validation.data_race_prediction.core import old_validate_omp_pragma
#from discopop_validation.data_race_prediction.target_code_sections.extraction import \
#    identify_target_sections_from_suggestions
from discopop_validation.data_race_prediction.task_graph.classes.TaskGraph import TaskGraph
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


def __main_start_execution(run_configuration: Configuration):
    if run_configuration.arguments["--profiling"] == "true":
        profile = cProfile.Profile()
        profile.enable()
        print("profiling enabled...")
    if run_configuration.verbose_mode:
        print("creating PET Graph...")
    time_start_ps = time.time()
    pet: PETGraphX = get_pet_graph(run_configuration)

    omp_pragmas = __get_omp_pragmas(run_configuration)

    time_end_ps = time.time()

    #for pragma in omp_pragmas:
    #    if run_configuration.verbose_mode:
    #        print("validating: ", pragma)
    #    # todo add Data Races as return type
    #    validate_omp_pragma(run_configuration, pet, pragma, omp_pragmas)
    #    if run_configuration.verbose_mode:
    #            print()

    # construct task graph
    task_graph = TaskGraph()
    for pragma in omp_pragmas:
        task_graph.add_pragma(pragma)
    # extract and insert behavior models for pragmas
    task_graph.insert_behavior_models()

    # trigger result computation
    # todo enable
    #task_graph.compute_results()
    task_graph.plot_graph()

    time_end_validation = time.time()
    time_end_execution = time.time()
    print("\n### Measured Times: ###")
    print("-------------------------------------------")
    print("--- Get parallelization suggestions: %s seconds ---" % (time_end_ps - time_start_ps))
    print("--- Validating suggestions: %s seconds ---" % (time_end_validation - time_end_ps))
    #print("--- Create schedules: %s seconds ---" % (time_end_schedules - time_end_bb))
    #print("--- Check for Data Races: %s seconds ---" % (time_end_data_races - time_end_schedules))
    print("--- Total time: %s seconds ---" % (time_end_execution - time_start_ps))


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
