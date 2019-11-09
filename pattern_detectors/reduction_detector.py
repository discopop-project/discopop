from typing import List, Dict

from graph_tool import Graph, Vertex
from graph_tool.util import find_vertex

from utils import get_subtree_of_type


def __is_reduction_var(line: str, name: str, reduction_vars: List[Dict[str, str]]) -> bool:
    """Determines, whether or not the given variable is reduction variable

    :param line: loop line number
    :param name: variable name
    :param reduction_vars: List of reduction variables
    :return: true if is reduction variable
    """
    return any(rv for rv in reduction_vars if rv['loop_line'] == line and rv['name'] == name)


def run_detection(graph: Graph, reduction_vars: List[Dict[str, str]]):
    """Search for reduction pattern

    :param graph: CU graph
    :param reduction_vars: List of reduction variables
    """
    for node in find_vertex(graph, graph.vp.type, 'loop'):
        if __detect_reduction(graph, node, reduction_vars):
            graph.vp.reduction[node] = True
            print('Reduction at', graph.vp.id[node])


def __detect_reduction(graph: Graph, root: Vertex, reduction_vars: List[Dict[str, str]]) -> bool:
    """Detects reduction pattern in loop

    :param graph: cu graph
    :param root: the loop node
    :param reduction_vars: List of reduction variables
    :return: true if is reduction loop
    """
    if graph.vp.type[root] != 'loop':
        return False

    all_vars = set()
    for node in get_subtree_of_type(graph, root, 'cu'):
        for v in graph.vp.localVars[node]:
            all_vars.add(v)
        for v in graph.vp.globalVars[node]:
            all_vars.add(v)

    return bool([v for v in all_vars if __is_reduction_var(graph.vp.startsAtLine[root], v, reduction_vars)])
