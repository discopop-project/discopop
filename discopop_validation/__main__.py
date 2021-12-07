"""Discopop validation

Usage:
    discopop_validation [--path <path>] [--cu-xml <cuxml>] [--dep-file <depfile>] [--plugins <plugs>] \
[--loop-counter <loopcount>] [--reduction <reduction>] [--fmap <fmap>] [--ll-file <llfile>] [--json <jsonfile] \
[--profiling <value>] [--call-graph <value>] [--verbose <value>] [--data-race-output <path>] [--dp-build-path <path>]

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
    -h --help                   Show this screen
"""
import os
import sys
import cProfile
import time
import json

from docopt import docopt
from schema import SchemaError, Schema, Use

from discopop_validation.data_race_prediction.behavior_modeller.core.behavior_extraction import execute_bb_graph_extraction
from discopop_validation.data_race_prediction.behavior_modeller.classes.Operation import Operation
from discopop_validation.data_race_prediction.behavior_modeller.utils.utils import get_paths_for_sections, \
    get_possible_path_combinations_for_sections
from .vc_data_race_detector.data_race_detector import check_sections, get_filtered_data_race_strings
from discopop_validation.vc_data_race_detector.exception_rules.application import apply_exception_rules
from discopop_validation.data_race_prediction.scheduler.core.scheduler import create_schedules_for_sections
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
})


def get_path(base_path: str, file_name: str) -> str:
    """Combines path and filename if it is not absolute

    :param base_path: path
    :param file_name: file name
    :return: path to file
    """
    return file_name if os.path.isabs(file_name) else os.path.join(base_path, file_name)


def main():
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
    if data_race_output_path != "None":
        data_race_output_path = get_path(path, data_race_output_path)
    for file in [cu_xml, dep_file, loop_counter_file, reduction_file, ll_file]:
        if not os.path.isfile(file):
            print(f"File not found: \"{file}\"")
            sys.exit()
    plugins = [] if arguments['--plugins'] == 'None' else arguments['--plugins'].split(' ')

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
            __main_start_execution(cu_xml, dep_file, loop_counter_file, reduction_file, json_file, file_mapping, ll_file, verbose_mode, data_race_output_path, arguments)
    else:
        __main_start_execution(cu_xml, dep_file, loop_counter_file, reduction_file, json_file, file_mapping, ll_file, verbose_mode, data_race_output_path, arguments)


def __main_start_execution(cu_xml, dep_file, loop_counter_file, reduction_file, json_file, file_mapping, ll_file, verbose_mode, data_race_output_path, arguments):
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
        print("creating BB Graph...")
    bb_graph = execute_bb_graph_extraction(parallelization_suggestions, file_mapping, ll_file, arguments["--dp-build-path"])
    # todo move
    if verbose_mode:
        print("insering critical sections into BB Graph...")
    # insert critical sections (locking statements to random hash values) into bb_graph
    if "critical_section" in parallelization_suggestions:
        for critical_section in parallelization_suggestions["critical_section"]:
            cs_file_id = int(critical_section["start_line"].split(":")[0])
            cs_start_line = int(critical_section["start_line"].split(":")[1])
            cs_end_line = int(critical_section["end_line"].split(":")[1])
            # iterate over bb graph nodes
            for bb_node_id in bb_graph.graph.nodes:
                bb_node = bb_graph.graph.nodes[bb_node_id]["data"]
                # check if critical section is contained in bb_node
                if not cs_file_id == bb_node.file_id:
                    continue
                if not bb_node.start_pos[0] <= cs_start_line:
                    continue
                if not bb_node.end_pos[0] >= cs_end_line:
                    continue
                # determine insertion points of locking instructions into list of operations
                insert_idx_lock = 0
                insert_idx_unlock = len(bb_node.operations)
                operation_lines = [op.line for op in bb_node.operations]
                # determine lock index
                for idx, operation_line in enumerate(operation_lines):
                    if operation_line >= cs_start_line:
                        insert_idx_lock = idx
                        break
                # determine unlock index
                while insert_idx_unlock > 0 and operation_lines[insert_idx_unlock - 1] > cs_end_line:
                    insert_idx_unlock -= 1
                unlock_column = bb_node.operations[insert_idx_unlock-1].col + 1
                # get random "variable" name to lock
                import random
                hash = random.getrandbits(128)
                hash = "%032x" % hash
                # insert unlock operation
                unlock_operation = Operation("critical_section", None, None, "u", hash, cs_end_line, unlock_column, cs_end_line, unlock_column)
                bb_node.operations.insert(insert_idx_unlock, unlock_operation)
                # insert lock operation
                lock_operation = Operation("critical_section", None, None, "l", hash, cs_start_line, unlock_column, cs_start_line, unlock_column)
                bb_node.operations.insert(insert_idx_lock, lock_operation)


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

if __name__ == "__main__":
    main()