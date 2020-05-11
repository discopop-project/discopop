# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.


from typing import List

from graph_tool import Vertex
from graph_tool.util import find_vertex

import PETGraph
from pattern_detectors.PatternInfo import PatternInfo
from utils import find_subnodes, depends_ignore_readonly, correlation_coefficient, get_subtree_of_type, \
    classify_task_vars

__pipeline_threshold = 0.9


class PipelineStage(object):
    def __init__(self, pet, node, in_dep, out_dep):
        self.node = pet.graph.vp.id[node]
        self.startsAtLine = pet.graph.vp.startsAtLine[node]
        self.endsAtLine = pet.graph.vp.endsAtLine[node]

        fp, p, s, in_deps, out_deps, in_out_deps, r = classify_task_vars(pet, node, "PipeLine", in_dep, out_dep)

        self.first_private = fp
        self.private = p
        self.shared = s
        self.reduction = r
        self.in_deps = in_deps
        self.out_deps = out_deps
        self.in_out_deps = in_out_deps

    def __str__(self):
        return f'\tNode: {self.node}\n' \
               f'\tStart line: {self.startsAtLine}\n' \
               f'\tEnd line: {self.endsAtLine}\n' \
               f'\tpragma: "#pragma omp task"\n' \
               f'\tfirst private: {[v.name for v in self.first_private]}\n' \
               f'\tprivate: {[v.name for v in self.private]}\n' \
               f'\tshared: {[v.name for v in self.shared]}\n' \
               f'\treduction: {[v for v in self.reduction]}\n' \
               f'\tInDeps: {[v.name for v in self.in_deps]}\n' \
               f'\tOutDeps: {[v.name for v in self.out_deps]}\n' \
               f'\tInOutDeps: {[v.name for v in self.in_out_deps]}'


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
        self._pet = pet
        self.coefficient = round(coefficient, 3)

        children_start_lines = [pet.graph.vp.startsAtLine[v]
                                for v in find_subnodes(pet, node, 'child')
                                if pet.graph.vp.type[v] == 'loop']

        self._stages = [v for v in find_subnodes(pet, node, 'child')
                        if is_pipeline_subnode(pet, node, v, children_start_lines)]

        self.stages = [self.__output_stage(s) for s in self._stages]

    def __in_dep(self, node: Vertex):
        raw = []
        for n in get_subtree_of_type(self._pet, node, 'cu'):
            raw.extend(e for e in n.out_edges() if self._pet.graph.ep.dtype[e] == 'RAW')

        nodes_before = [node]
        for i in range(self._stages.index(node)):
            nodes_before.extend(get_subtree_of_type(self._pet, self._stages[i], 'cu'))

        return [dep for dep in raw if dep.target() in nodes_before]

    def __out_dep(self, node: Vertex):
        raw = []
        for n in get_subtree_of_type(self._pet, node, 'cu'):
            raw.extend(e for e in n.in_edges() if self._pet.graph.ep.dtype[e] == 'RAW')

        nodes_after = [node]
        for i in range(self._stages.index(node) + 1, len(self._stages)):
            nodes_after.extend(get_subtree_of_type(self._pet, self._stages[i], 'cu'))

        return [dep for dep in raw if dep.source() in nodes_after]

    def __output_stage(self, node: Vertex) -> PipelineStage:

        in_d = self.__in_dep(node)
        out_d = self.__out_dep(node)

        return PipelineStage(self._pet, node, in_d, out_d)

    def __str__(self):
        s = "\n\n".join([str(s) for s in self.stages])
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
    #print(pet.graph.vp.id[root] + " " + str(graph_vector) + " : " + str(pipeline_vector))
    #print( correlation_coefficient(graph_vector, pipeline_vector))
    return correlation_coefficient(graph_vector, pipeline_vector)
