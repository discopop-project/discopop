from typing import List

from graph_tool import Vertex, Graph
from graph_tool.util import find_vertex

from utils import find_subnodes, is_depending, correlation_coefficient


def __is_pipeline_subnode(graph: Graph, root: Vertex, current: Vertex, children_start_lines: List[str]) -> bool:
    """Checks if node is a valid subnode for pipeline
    """
    r_start = graph.vp.startsAtLine[root]
    r_end = graph.vp.endsAtLine[root]
    c_start = graph.vp.startsAtLine[current]
    c_end = graph.vp.endsAtLine[current]
    return not (c_start == r_start and c_end == r_start
                or c_start == r_end and c_end == r_end
                or c_start == c_end and c_start in children_start_lines)


def run_detection(graph: Graph):
    """Search pipeline pattern on all the loops within the application
    """
    for node in find_vertex(graph, graph.vp.type, '2'):
        graph.vp.pipeline[node] = detect_pipeline(graph, node)
        if graph.vp.pipeline[node] > 0:
            print('Pipeline at', graph.vp.id[node])
            print('start:', graph.vp.startsAtLine[node])
            print('end:', graph.vp.endsAtLine[node])


def detect_pipeline(graph: Graph, root: Vertex) -> float:
    """Calculate pipeline value for node. Returns pipeline scalar value
    """

    # TODO how deep
    children_start_lines = [graph.vp.startsAtLine[v]
                            for v in find_subnodes(graph, root, 'child')
                            if graph.vp.type[v] == '2']

    loop_subnodes = [v for v in find_subnodes(graph, root, 'child')
                     if __is_pipeline_subnode(graph, root, v, children_start_lines)]

    # No chain of stages found
    if len(loop_subnodes) < 2:
        graph.vp.pipeline[root] = -1
        return 0

    graph_vector = []
    for i in range(0, len(loop_subnodes) - 1):
        graph_vector.append(1 if is_depending(graph, loop_subnodes[i + 1], loop_subnodes[i], root) else 0)

    pipeline_vector = []
    for i in range(0, len(loop_subnodes) - 1):
        pipeline_vector.append(1)

    min_weight = 1
    for i in range(0, len(loop_subnodes) - 1):
        for j in range(i + 1, len(loop_subnodes)):
            if is_depending(graph, loop_subnodes[i], loop_subnodes[j], root):
                # TODO whose corresponding entry in the graph matrix is nonzero?
                node_weight = 1 - (j - i) / (len(loop_subnodes) - 1)
                if min_weight > node_weight > 0:
                    min_weight = node_weight

    if min_weight == 1:
        graph_vector.append(0)
        pipeline_vector.append(0)
    else:
        graph_vector.append(1)
        pipeline_vector.append(min_weight)
    return correlation_coefficient(graph_vector, pipeline_vector)
