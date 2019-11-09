import math

from graph_tool import Graph, Vertex
from graph_tool.util import find_vertex

from utils import find_subnodes, get_subtree_of_type
from pattern_detectors.do_all_detector import do_all_threshold

__loop_iterations = {}
__loop_data = {}


def __init_data():
    __loop_iterations.clear()
    __loop_data.clear()

    with open('./data/loop_counter_output.txt') as f:
        content = f.readlines()
    for line in content:
        s = line.split(' ')
        # line = FileId + LineNr
        __loop_data[s[0] + ':' + s[1]] = int(s[2])


def run_detection(graph: Graph):
    """
    Detects geometric decomposition
    :return:
    """
    __init_data()

    for node in find_vertex(graph, graph.vp.type, '1'):
        val = __detect_geometric_decomposition(graph, node)
        if val:
            graph.vp.geomDecomp[node] = val
            if __test_chunk_limit(graph, node):
                print('Geometric decomposition at', graph.vp.id[node])


def __test_chunk_limit(graph: Graph, node: Vertex) -> bool:
    """
    Tests, whether or not the node has inner loops with and none of them have 0 iterations
    :param graph: cu graph
    :param node: the node
    :return:
    """
    min_iterations_count = math.inf
    inner_loop_iter = {}

    children = [e.target() for e in node.out_edges() if graph.ep.type[e] == 'child'
                and graph.vp.type[e.target()] == '2']

    for func_child in [e.target()
                       for e in node.out_edges()
                       if graph.ep.type[e] == 'child' and graph.vp.type[e.target()] == '1']:
        children.extend([e.target()
                         for e in func_child.out_edges()
                         if graph.ep.type[e] == 'child' and graph.vp.type[e.target()] == '2'])

    for child in children:
        inner_loop_iter[graph.vp.startsAtLine[child]] = __iterations_count(graph, child)

    for k, v in inner_loop_iter.items():
        min_iterations_count = min(min_iterations_count, v)

    return inner_loop_iter and min_iterations_count > 0


def __iterations_count(graph: Graph, node: Vertex) -> int:
    """
    Counts the iterations in the specified node
    :param graph: cu graph
    :param node: the loop node
    :return: number of iterations
    """
    if not (node in __loop_iterations):
        loop_iter = __get_loop_iterations(graph.vp.startsAtLine[node])
        parent_iter = __get_parent_iterations(graph, node)

        if loop_iter < parent_iter:
            __loop_iterations[node] = loop_iter
        elif loop_iter == 0 or parent_iter == 0:
            __loop_iterations[node] = 0
        else:
            __loop_iterations[node] = loop_iter // parent_iter

    return __loop_iterations[node]


def __get_loop_iterations(line: str) -> int:
    """
    Calculates the number of iterations in specified loop
    :param line: start line of the loop
    :return: number of iterations
    """
    return __loop_data.get(line, 0)


def __get_parent_iterations(graph: Graph, node: Vertex) -> int:
    """
     Calculates the number of iterations in parent of loop
    :param graph: cu graph
    :param node: current node
    :return:
    """
    parent = [e.source() for e in node.in_edges() if graph.ep.type[e] == 'child']

    max_iter = 1
    while parent:
        node = parent[0]
        if graph.vp.type[node] == '2':
            max_iter = max(1, __get_loop_iterations(graph.vp.startsAtLine[node]))
            break
        parent = [e.source() for e in node.in_edges() if graph.ep.type[e] == 'child']

    return max_iter


def __detect_geometric_decomposition(graph: Graph, root: Vertex) -> bool:
    """
    Detects geometric decomposition pattern
    :param graph: cu graph
    :param root: root node
    :return: true if GD pattern was discovered
    """
    for child in get_subtree_of_type(graph, root, '2'):
        if (graph.vp.doAll[child] < do_all_threshold
                and not graph.vp.reduction[child]):
            return False

    for child in find_subnodes(graph, root, '1'):
        for child2 in find_subnodes(graph, child, '2'):
            if (graph.vp.doAll[child2] < do_all_threshold
                    and not graph.vp.reduction[child2]):
                return False

    return True
