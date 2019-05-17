"""Discopop analyzer.

Usage:
    main.py --cu-xml <cuxml> --dep-file <depfile>

Options:
    --cu-xml=<cuxml>        CU node xml file [default: Data.xml].
    --dep-file=<depfile>    Dependences text file
    -h --help               Show this screen.
    --version               Show version.
"""

import os
import time
from docopt import docopt
from schema import Schema, Use, SchemaError


from parser import parse_inputs
from PETGraph import PETGraph
from pattern_detection import PatternDetector
from graph_tool.search import dfs_iterator

docopt_schema = Schema({
        '--cu-xml': Use(open, error='XML should be readable'),
        '--dep-file': Use(open, error='Dependence file should be readable')
    })

if __name__ == "__main__":
    arguments = docopt(__doc__, version='DiscoPoP analyzer 0.1')

    try:
        arguments = docopt_schema.validate(arguments)
    except SchemaError as e:
        exit(e)

    cu_dict, dependences = parse_inputs(arguments['--cu-xml'], arguments['--dep-file'])
    graph = PETGraph(cu_dict, dependences)

    gv = graph.filter_view(graph.graph.vertices(), 'child')

    graph.infer_level_dependences()

    graph.visualize(gv)



    start = time.time()

    pattern_detector = PatternDetector(graph)
    pattern_detector.detect_patterns()

    end = time.time()

    print("Time taken for pattern detection: {0}".format(end - start))





