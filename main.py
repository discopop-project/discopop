"""Discopop analyzer.

Usage:
    main.py --cu-xml <cuxml> --dep-file <depfile> [--plugins <plugs>]

Options:
    --cu-xml=<cuxml>        CU node xml file [default: Data.xml].
    --dep-file=<depfile>    Dependencies text file
    --plugins=<plugs>       Plugins to execute
    -h --help               Show this screen.
    --version               Show version.
"""

import os
import time
from docopt import docopt
from schema import Schema, Use, SchemaError
from pluginbase import PluginBase

from parser import parse_inputs
from PETGraph import PETGraph
from pattern_detection import PatternDetector
from graph_tool.search import dfs_iterator

docopt_schema = Schema({
    '--cu-xml': Use(open, error='XML should be readable'),
    '--dep-file': Use(open, error='Dependence file should be readable'),
    '--plugins': Use(str)
})


if __name__ == "__main__":
    arguments = docopt(__doc__, version='DiscoPoP analyzer 0.1')

    try:
        arguments = docopt_schema.validate(arguments)
    except SchemaError as e:
        exit(e)

    cu_dict, dependencies = parse_inputs(arguments['--cu-xml'], arguments['--dep-file'])

    plugins = [] if arguments['--plugins'] == 'None' else arguments['--plugins'].split(' ')

    graph = PETGraph(cu_dict, dependencies)

    # graph.infer_level_dependences()

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

    # graph.visualize(graph.graph)
    pattern_detector = PatternDetector(graph)
    pattern_detector.detect_patterns()

    end = time.time()

    print("Time taken for pattern detection: {0}".format(end - start))
