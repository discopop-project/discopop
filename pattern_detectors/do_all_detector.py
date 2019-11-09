import numpy as np
from graph_tool import Vertex, Graph
from graph_tool.util import find_vertex

from utils import find_subnodes, is_depending, correlation_coefficient

do_all_threshold = 0.9


def run_detection(graph: Graph):
    """Search for do-all loop pattern
    """
    for node in find_vertex(graph, graph.vp.type, '2'):
        val = detect_do_all(graph, node)
        if val > do_all_threshold:
            graph.vp.doAll[node] = val
            if not graph.vp.reduction[node]:
                print('Do All at', graph.vp.id[node])
                print('Coefficient', val)


def detect_do_all(graph: Graph, root: Vertex):
    """Calculate do-all value for node. Returns dü-all scalar value
    """
    graph_vector = []

    subnodes = find_subnodes(graph, root, 'child')

    for i in range(0, len(subnodes)):
        for j in range(i, len(subnodes)):
            if is_depending(graph, subnodes[i], subnodes[j], root):
                graph_vector.append(0)
            else:
                graph_vector.append(1)

    pattern_vector = [1 for _ in graph_vector]

    if np.linalg.norm(graph_vector) == 0:
        return 0

    return correlation_coefficient(graph_vector, pattern_vector)
