from typing import List

from graph_tool import Vertex
from graph_tool.util import find_vertex

import PETGraph
from pattern_detectors.PatternInfo import PatternInfo
from utils import find_subnodes, depends_ignore_readonly, correlation_coefficient


__pipeline_threshold = 0.9


class PipelineInfo(PatternInfo):
    """Class, that contains pipeline detection result
    """
    coefficient: float

    def __init__(self, pet: PETGraph, node: Vertex, coefficient: float):
        """
        :param pet: PET graph
        :param node: node, where pipeline was detected
        :param coefficient: correlation coefficient
        """
        PatternInfo.__init__(self, pet, node)
        self.coefficient = coefficient

    def __str__(self):
        return f'Pipeline at: {self.node_id}\n' \
               f'Coefficient: {self.coefficient}\n' \
               f'Start line: {self.start_line}\n' \
               f'End line: {self.end_line}'


def __is_pipeline_subnode(pet: PETGraph, root: Vertex, current: Vertex, children_start_lines: List[str]) -> bool:
    """Checks if node is a valid subnode for pipeline

    :param pet: PET graph
    :param root: root node
    :param current: current node
    :param children_start_lines: start lines of children loops
    :return: true if valid
    """
    r_start = pet.graph.vp.startsAtLine[root]
    r_end = pet.graph.vp.endsAtLine[root]
    c_start = pet.graph.vp.startsAtLine[current]
    c_end = pet.graph.vp.endsAtLine[current]
    return not (c_start == r_start and c_end == r_start
                or c_start == r_end and c_end == r_end
                or c_start == c_end and c_start in children_start_lines)


def run_detection(pet: PETGraph) -> List[PipelineInfo]:
    """Search for pipeline pattern on all the loops in the graph

    :param pet: PET graph
    :return: List of detected pattern info
    """
    result = []
    for node in find_vertex(pet.graph, pet.graph.vp.type, 'loop'):
        pet.graph.vp.pipeline[node] = __detect_pipeline(pet, node)
        if pet.graph.vp.pipeline[node] > __pipeline_threshold:
            result.append(PipelineInfo(pet, node, pet.graph.vp.pipeline[node]))

    return result


def __detect_pipeline(pet: PETGraph, root: Vertex) -> float:
    """Calculate pipeline value for node

    :param pet: PET graph
    :param root: current node
    :return: Pipeline scalar value
    """

    # TODO how deep
    children_start_lines = [pet.graph.vp.startsAtLine[v]
                            for v in find_subnodes(pet, root, 'child')
                            if pet.graph.vp.type[v] == 'loop']

    loop_subnodes = [v for v in find_subnodes(pet, root, 'child')
                     if __is_pipeline_subnode(pet, root, v, children_start_lines)]

    # No chain of stages found
    if len(loop_subnodes) < 2:
        pet.graph.vp.pipeline[root] = -1
        return 0

    graph_vector = []
    for i in range(0, len(loop_subnodes) - 1):
        graph_vector.append(1 if depends_ignore_readonly(pet, loop_subnodes[i + 1], loop_subnodes[i], root) else 0)

    pipeline_vector = []
    for i in range(0, len(loop_subnodes) - 1):
        pipeline_vector.append(1)

    min_weight = 1
    for i in range(0, len(loop_subnodes) - 1):
        for j in range(i + 1, len(loop_subnodes)):
            if depends_ignore_readonly(pet, loop_subnodes[i], loop_subnodes[j], root):
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
