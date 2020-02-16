"""Discopop analyzer.

Usage:
    main.py [--path <path>] [--cu-xml <cuxml>] [--dep-file <depfile>] [--plugins <plugs>] \
[--loop-counter <loopcount>] [--reduction <reduction>]

Options:
    --path=<path>               Directory with input data [default: ./]
    --cu-xml=<cuxml>            CU node xml file [default: Data.xml].
    --dep-file=<depfile>        Dependencies text file [default: dep.txt].
    --loop-counter=<loopcount>  Loop counter data [default: loop_counter_output.txt].
    --reduction=<reduction>     Reduction variables file [default: reduction.txt].
    --plugins=<plugs>           Plugins to execute
    -h --help                   Show this screen.
    --version                   Show version.
"""
import os
import time

from docopt import docopt
from pluginbase import PluginBase
from schema import Schema, Use, SchemaError

from PETGraph import PETGraph
from parser import parse_inputs
from pattern_detection import PatternDetector

docopt_schema = Schema({
    '--path': Use(str),
    '--cu-xml': Use(str),
    '--dep-file': Use(str),
    '--loop-counter': Use(str),
    '--reduction': Use(str),
    '--plugins': Use(str)
})


def get_path(base_path: str, file: str) -> str:
    """Combines path and filename if it is not absolute

    :param base_path: path
    :param file: file name
    :return: path to file
    """
    return file if os.path.isabs(file) else os.path.join(base_path, file)


if __name__ == "__main__":
    arguments = docopt(__doc__, version='DiscoPoP analyzer 0.1')

    try:
        arguments = docopt_schema.validate(arguments)
    except SchemaError as e:
        exit(e)

    path = arguments['--path']

    cu_xml = get_path(path, arguments['--cu-xml'])
    dep_file = get_path(path, arguments['--dep-file'])
    loop_counter_file = get_path(path, arguments['--loop-counter'])
    reduction_file = get_path(path, arguments['--reduction'])

    cu_dict, dependencies, loop_data, reduction_vars = parse_inputs(open(cu_xml), open(dep_file),
                                                                    loop_counter_file, reduction_file)

    plugins = [] if arguments['--plugins'] == 'None' else arguments['--plugins'].split(' ')

    graph = PETGraph(cu_dict, dependencies, loop_data, reduction_vars)

    # visualize subgraphs
    # graph.interactive_visualize(graph.graph)

    # graph.visualize(graph.graph)
    # graph.visualize(graph.filter_view(graph.graph.vertices(), 'child'), "child.svg")
    # graph.visualize(graph.filter_view(graph.graph.vertices(), 'dependence'), "dep.svg")
    # graph.visualize(graph.filter_view(graph.graph.vertices(), 'successor'), "suc.svg")

    start = time.time()

    plugin_base = PluginBase(package='plugins')

    plugin_source = plugin_base.make_plugin_source(
        searchpath=['./plugins'])

    for plugin_name in plugins:
        p = plugin_source.load_plugin(plugin_name)
        print("executing plugin: " + plugin_name)
        graph = p.run(graph)

    pattern_detector = PatternDetector(graph)
    pattern_detector.detect_patterns()

    end = time.time()

    print("Time taken for pattern detection: {0}".format(end - start))
