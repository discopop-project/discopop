from typing import List

from graph_tool import Vertex, Graph
from graph_tool.util import find_vertex

from utils import find_subnodes, depends_ignore_readonly, correlation_coefficient


class PipelineInfo(object):
    """Class, that contains pipeline detection result
    """
    node: Vertex
    node_id: str
    coefficient: float
    start_line: str
    end_line: str

    def __init__(self, graph: Graph, node: Vertex, coefficient: float):
        """
        :param graph: CU graph
        :param node: node, where pipeline was detected
        :param coefficient: correlation coefficient
        """
        self.node = node
        self.node_id = graph.vp.id[node]
        self.coefficient = coefficient
        self.start_line = graph.vp.startsAtLine[node]
        self.end_line = graph.vp.endsAtLine[node]

    def __str__(self):
        return f'Pipeline at: {self.node_id}\n' \
               f'Coefficient: {self.coefficient}\n' \
               f'Start line: {self.start_line}\n' \
               f'End line: {self.end_line}'


def __is_pipeline_subnode(graph: Graph, root: Vertex, current: Vertex, children_start_lines: List[str]) -> bool:
    """Checks if node is a valid subnode for pipeline

    :param graph: CU graph
    :param root: root node
    :param current: current node
    :param children_start_lines: start lines of children loops
    :return: true if valid
    """
    r_start = graph.vp.startsAtLine[root]
    r_end = graph.vp.endsAtLine[root]
    c_start = graph.vp.startsAtLine[current]
    c_end = graph.vp.endsAtLine[current]
    return not (c_start == r_start and c_end == r_start
                or c_start == r_end and c_end == r_end
                or c_start == c_end and c_start in children_start_lines)


def run_detection(graph: Graph) -> List[PipelineInfo]:
    """Search for pipeline pattern on all the loops in the graph

    :param graph: CU graph
    :return: List of detected pattern info
    """
    result = []
    for node in find_vertex(graph, graph.vp.type, 'loop'):
        graph.vp.pipeline[node] = __detect_pipeline(graph, node)
        if graph.vp.pipeline[node] > 0:
            result.append(PipelineInfo(graph, node, graph.vp.pipeline[node]))

    return result


def __detect_pipeline(graph: Graph, root: Vertex) -> float:
    """Calculate pipeline value for node

    :param graph: CU graph
    :param root: current node
    :return: Pipeline scalar value
    """

    # TODO how deep
    children_start_lines = [graph.vp.startsAtLine[v]
                            for v in find_subnodes(graph, root, 'child')
                            if graph.vp.type[v] == 'loop']

    loop_subnodes = [v for v in find_subnodes(graph, root, 'child')
                     if __is_pipeline_subnode(graph, root, v, children_start_lines)]

    # No chain of stages found
    if len(loop_subnodes) < 2:
        graph.vp.pipeline[root] = -1
        return 0

    graph_vector = []
    for i in range(0, len(loop_subnodes) - 1):
        graph_vector.append(1 if depends_ignore_readonly(graph, loop_subnodes[i + 1], loop_subnodes[i], root) else 0)

    pipeline_vector = []
    for i in range(0, len(loop_subnodes) - 1):
        pipeline_vector.append(1)

    min_weight = 1
    for i in range(0, len(loop_subnodes) - 1):
        for j in range(i + 1, len(loop_subnodes)):
            if depends_ignore_readonly(graph, loop_subnodes[i], loop_subnodes[j], root):
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
