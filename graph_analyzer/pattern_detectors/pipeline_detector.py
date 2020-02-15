from typing import List

from graph_tool import Vertex
from graph_tool.util import find_vertex

import PETGraph
from pattern_detectors.PatternInfo import PatternInfo
from utils import find_subnodes, depends_ignore_readonly, correlation_coefficient, get_subtree_of_type, \
    classify_loop_variables

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
        self.pet = pet
        children_start_lines = [pet.graph.vp.startsAtLine[v]
                                for v in find_subnodes(pet, node, 'child')
                                if pet.graph.vp.type[v] == 'loop']

        self.stages = [v for v in find_subnodes(pet, node, 'child')
                       if is_pipeline_subnode(pet, node, v, children_start_lines)]

    def __in_dep(self, node: Vertex):
        raw = []
        for n in get_subtree_of_type(self.pet, node, 'cu'):
            raw.extend(e for e in n.out_edges() if self.pet.graph.ep.dtype[e] == 'RAW')

        nodes_before = []
        for i in range(self.stages.index(node)):
            nodes_before.extend(get_subtree_of_type(self.pet, self.stages[i], 'cu'))

        return set([self.pet.graph.ep.var[dep] for dep in raw if dep.target() in nodes_before])

    def __out_dep(self, node: Vertex):
        raw = []
        for n in get_subtree_of_type(self.pet, node, 'cu'):
            raw.extend(e for e in n.in_edges() if self.pet.graph.ep.dtype[e] == 'RAW')

        nodes_after = []
        for i in range(self.stages.index(node)+1, len(self.stages)):
            nodes_after.extend(get_subtree_of_type(self.pet, self.stages[i], 'cu'))

        return set([self.pet.graph.ep.var[dep] for dep in raw if dep.source() in nodes_after])

    def __output_stage(self, node: Vertex) -> str:
        fp, p, lp, s, r = classify_loop_variables(self.pet, node)
        in_dep = self.__in_dep(node)
        out_dep = self.__out_dep(node)
        in_out_dep = [d for d in in_dep if d in out_dep]
        in_dep = [d for d in in_dep if d not in in_out_dep]
        out_dep = [d for d in out_dep if d not in in_out_dep]

        return f'\tNode: {self.pet.graph.vp.id[node]}\n' \
               f'\tStart line: {self.pet.graph.vp.startsAtLine[node]}\n' \
               f'\tEnd line: {self.pet.graph.vp.endsAtLine[node]}\n' \
               f'\tpragma: "#pragma omp task"\n' \
               f'\tfirst private: {[v.name for v in fp]}\n' \
               f'\tprivate: {[v.name for v in p]}\n' \
               f'\tshared: {[v.name for v in s]}\n' \
               f'\treduction: {[v.name for v in r]}\n' \
               f'\tInDeps: {in_dep}\n' \
               f'\tOutDeps: {out_dep}\n' \
               f'\tInOutDeps: {in_out_dep}'

    def __str__(self):
        s = "\n\n".join([self.__output_stage(s) for s in self.stages])
        return f'Pipeline at: {self.node_id}\n' \
               f'Coefficient: {round(self.coefficient, 3)}\n' \
               f'Start line: {self.start_line}\n' \
               f'End line: {self.end_line}\n' \
               f'Stages:\n{s}'


def is_pipeline_subnode(pet: PETGraph, root: Vertex, current: Vertex, children_start_lines: List[str]) -> bool:
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
                     if is_pipeline_subnode(pet, root, v, children_start_lines)]

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
