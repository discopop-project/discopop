"""Discopop validation

Usage:
    discopop_validation [--path <path>] [--cu-xml <cuxml>] [--dep-file <depfile>] [--plugins <plugs>] \
[--loop-counter <loopcount>] [--reduction <reduction>] [--fmap <fmap>] [--ll-file <llfile>] [--json <jsonfile] \
[--profiling <value>]

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
    -h --help                   Show this screen
"""
import os
import sys
import cProfile
import time
import json

from docopt import docopt
from schema import SchemaError, Schema, Use

from .interfaces.behavior_extraction import execute_bb_graph_extraction
from .vc_data_race_detector.data_race_detector import check_sections, get_filtered_data_race_strings, \
    apply_exception_rules
from .vc_data_race_detector.scheduler import create_schedules_for_sections
from .interfaces.discopop_explorer import get_pet_graph, load_parallelization_suggestions

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
    if arguments["--profiling"] == "true":
        profile = cProfile.Profile()
        profile.enable()

    path = arguments["--path"]
    cu_xml = get_path(path, arguments['--cu-xml'])
    dep_file = get_path(path, arguments['--dep-file'])
    loop_counter_file = get_path(path, arguments['--loop-counter'])
    reduction_file = get_path(path, arguments['--reduction'])
    ll_file = get_path(path, arguments['--ll-file'])
    json_file = get_path(path, arguments['--json'])
    file_mapping = get_path(path, 'FileMapping.txt')
    for file in [cu_xml, dep_file, loop_counter_file, reduction_file, ll_file]:
        if not os.path.isfile(file):
            print(f"File not found: \"{file}\"")
            sys.exit()
    plugins = [] if arguments['--plugins'] == 'None' else arguments['--plugins'].split(' ')
    time_start_ps = time.time()
    pet = get_pet_graph(cu_xml, dep_file, loop_counter_file, reduction_file)
    with open(json_file) as f:
        parallelization_suggestions = json.load(f)
    time_end_ps = time.time()
    bb_graph = execute_bb_graph_extraction(parallelization_suggestions, file_mapping, ll_file)
    # todo remove
    # insert critical sections (locking statements to random hash values) into bb_graph
    for critical_section in parallelization_suggestions["critical_section"]:
        cs_file_id = critical_section["start_line"].split(":")[0]
        cs_start_line = critical_section["start_line"].split(":")[1]
        cs_end_line = critical_section["end_line"].split(":")[1]
        # iterate over bb graph nodes
        for bb_node in bb_graph.graph.nodes:
            # todo remove: list operations
            print("bb_node: ", bb_graph.graph.nodes[bb_node]["data"].start_pos[0], "->", bb_graph.graph.nodes[bb_node]["data"].end_pos[0])
            print([str(x) for x in bb_graph.graph.nodes[bb_node]["data"].operations])
            # check if critical section is contained in bb_node
            #if cs_file_id == bb_node
            for op_idx, operation in enumerate(bb_graph.graph.nodes[bb_node]["data"].operations):
                pass

            print()
    import sys
    sys.exit(0)

    time_end_bb = time.time()
    sections_to_schedules_dict = create_schedules_for_sections(bb_graph,
                                                               bb_graph.get_possible_path_combinations_for_sections())
    time_end_schedules = time.time()
    unfiltered_data_races = check_sections(sections_to_schedules_dict)
    filtered_data_races = apply_exception_rules(unfiltered_data_races, pet)
    filtered_data_race_strings = get_filtered_data_race_strings(filtered_data_races)
    time_end_data_races = time.time()
    # print found data races
    for dr_str in filtered_data_race_strings:
        print(dr_str)

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

    print("### DiscoPoP Critical-Section Suggestions: ###")
    print("-------------------------------------------")
    for suggestion in parallelization_suggestions["critical_section"]:
        print("-->", suggestion, "\n")


    print("\n### Measured Times: ###")
    print("-------------------------------------------")
    print("--- Get Parallelization Suggestions: %s seconds ---" % (time_end_ps - time_start_ps))
    print("--- Construct BB Graph: %s seconds ---" % (time_end_bb - time_end_ps))
    print("--- Create Schedules: %s seconds ---" % (time_end_schedules - time_end_bb))
    print("--- Check for Data Races: %s seconds ---" % (time_end_data_races - time_end_schedules))


if __name__ == "__main__":
    main()