from graph_tool import Graph, Vertex
from graph_tool.util import find_vertex

from utils import get_subtree_of_type

__reduction_vars = []


def __is_reduction_var(line: str, name: str) -> bool:
    """
    determines, whether or not the given variable is reduction variable
    :param line: loop line number
    :param name: variable name
    :return: true if is reduction variable
    """
    return any(rv for rv in __reduction_vars if rv['loop_line'] == line and rv['name'] == name)


def run_detection(graph: Graph):
    """Search for reduction pattern
    """

    # parse reduction variables
    with open('./data/reduction.txt') as f:
        content = f.readlines()

    __reduction_vars.clear()
    for line in content:
        s = line.split(' ')
        # line = FileId + LineNr
        var = {'loop_line': s[3] + ':' + s[8], 'name': s[17]}
        __reduction_vars.append(var)

    for node in find_vertex(graph, graph.vp.type, '2'):
        if __detect_reduction(graph, node):
            graph.vp.reduction[node] = True
            print('Reduction at', graph.vp.id[node])


def __detect_reduction(graph: Graph, root: Vertex) -> bool:
    """
    Detects reduction pattern in loop
    :param graph: cu graph
    :param root: the loop node
    :return: true if is reduction loop
    """
    if graph.vp.type[root] != '2':
        return False

    all_vars = set()
    for node in get_subtree_of_type(graph, root, '0'):
        for v in graph.vp.localVars[node]:
            all_vars.add(v)
        for v in graph.vp.globalVars[node]:
            all_vars.add(v)

    return bool([v for v in all_vars if __is_reduction_var(graph.vp.startsAtLine[root], v)])
