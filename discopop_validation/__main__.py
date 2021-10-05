"""Discopop validation

Usage:
    discopop_validation [--path <path>] [--cu-xml <cuxml>] [--dep-file <depfile>] [--plugins <plugs>] \
[--loop-counter <loopcount>] [--reduction <reduction>] [--fmap <fmap>] [--ll-file <llfile>] [--profiling <value>]

Options:
    --path=<path>               Directory with input data [default: ./]
    --cu-xml=<cuxml>            CU node xml file [default: Data.xml]
    --dep-file=<depfile>        Dependencies text file [default: dp_run_dep.txt]
    --loop-counter=<loopcount>  Loop counter data [default: loop_counter_output.txt]
    --reduction=<reduction>     Reduction variables file [default: reduction.txt]
    --ll-file=<llfile>          Path to .ll file to be analyzed
    --fmap=<fmap>               File mapping [default: FileMapping.txt]
    --plugins=<plugs>           Plugins to execute
    --profiling=<value>         Enable profiling mode. Values: true / false [default: false]
    -h --help                   Show this screen
"""
import os
import sys
import cProfile
import time

from docopt import docopt
from schema import SchemaError, Schema, Use

from .interfaces.behavior_extraction import get_relevant_sections_from_suggestions, \
    execute_bb_graph_extraction
from .vc_data_race_detector.data_race_detector import check_sections, get_filtered_data_race_strings
from .vc_data_race_detector.scheduler import create_schedules_for_sections
from .interfaces.discopop_explorer import get_parallelization_suggestions

docopt_schema = Schema({
    '--path': Use(str),
    '--cu-xml': Use(str),
    '--dep-file': Use(str),
    '--loop-counter': Use(str),
    '--reduction': Use(str),
    '--ll-file': Use(str),
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
    file_mapping = get_path(path, 'FileMapping.txt')
    for file in [cu_xml, dep_file, loop_counter_file, reduction_file, ll_file]:
        if not os.path.isfile(file):
            print(f"File not found: \"{file}\"")
            sys.exit()
    plugins = [] if arguments['--plugins'] == 'None' else arguments['--plugins'].split(' ')
    time_start_ps = time.time()
    parallelization_suggestions = get_parallelization_suggestions(cu_xml, dep_file, loop_counter_file, reduction_file,
                                                                  plugins, file_mapping=file_mapping)
    time_end_ps = time.time()
    bb_graph = execute_bb_graph_extraction(parallelization_suggestions, file_mapping, ll_file)
    time_end_bb = time.time()
    sections_to_schedules_dict = create_schedules_for_sections(bb_graph,
                                                               bb_graph.get_possible_path_combinations_for_sections())
    time_end_schedules = time.time()
    unfiltered_data_races = check_sections(sections_to_schedules_dict)
    filtered_data_race_strings = get_filtered_data_race_strings(unfiltered_data_races)
    time_end_data_races = time.time()
    # print found data races
    for dr_str in filtered_data_race_strings:
        print(dr_str)

    print("\n###########################################")
    print("######### AUXILIARY INFORMATION ###########")
    print("###########################################\n")

    if arguments["--profiling"] == "true":
        profile.disable()
        profile.print_stats()

    print("### DiscoPoP Suggestions: ###")
    print("-------------------------------------------")
    print(parallelization_suggestions)

    print("\n### Measured Times: ###")
    print("-------------------------------------------")
    print("--- Get Parallelization Suggestions: %s seconds ---" % (time_end_ps - time_start_ps))
    print("--- Construct BB Graph: %s seconds ---" % (time_end_bb - time_end_ps))
    print("--- Create Schedules: %s seconds ---" % (time_end_schedules - time_end_bb))
    print("--- Check for Data Races: %s seconds ---" % (time_end_data_races - time_end_schedules))


if __name__ == "__main__":
    main()