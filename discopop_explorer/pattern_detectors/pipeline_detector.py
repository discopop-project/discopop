# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.


from typing import List, Tuple

from .PatternInfo import PatternInfo
from ..PETGraphX import PETGraphX, NodeType, CUNode, EdgeType, DepType, Dependency
from ..utils import correlation_coefficient, classify_task_vars

__pipeline_threshold = 0.9


class PipelineStage(object):
    def __init__(self, pet: PETGraphX, node: CUNode, in_dep, out_dep):
        self.node = node.id
        self.startsAtLine = node.start_position()
        self.endsAtLine = node.end_position()

        fp, p, s, in_deps, out_deps, in_out_deps, r = classify_task_vars(pet, node, "Pipeline", in_dep, out_dep)

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

    def __init__(self, pet: PETGraphX, node: CUNode):
        """
        :param pet: PET graph
        :param node: node, where pipeline was detected
        """
        PatternInfo.__init__(self, node)
        self._pet = pet
        self.coefficient = round(node.pipeline, 3)

        children_start_lines = [v.start_position() for v in pet.subtree_of_type(node, NodeType.LOOP)]

        self._stages = [pet.node_at(t) for s, t, d in pet.out_edges(node.id, EdgeType.CHILD)
                        if is_pipeline_subnode(node, pet.node_at(t), children_start_lines)]

        self.stages = [self.__output_stage(s) for s in self._stages]

    def __in_dep(self, node: CUNode):
        raw: List[Tuple[str, str, Dependency]] = []
        for n in self._pet.subtree_of_type(node, NodeType.CU):
            raw.extend((s, t, d) for s, t, d in self._pet.out_edges(n.id, EdgeType.DATA) if d.dtype == DepType.RAW)

        nodes_before = [node]
        for i in range(self._stages.index(node)):
            nodes_before.extend(self._pet.subtree_of_type(self._stages[i], NodeType.CU))

        return [dep for dep in raw if dep[1] in [n.id for n in nodes_before]]

    def __out_dep(self, node: CUNode):
        raw: List[Tuple[str, str, Dependency]] = []
        for n in self._pet.subtree_of_type(node, NodeType.CU):
            raw.extend((s, t, d) for s, t, d in self._pet.in_edges(n.id, EdgeType.DATA) if d.dtype == DepType.RAW)

        nodes_after = [node]
        for i in range(self._stages.index(node) + 1, len(self._stages)):
            nodes_after.extend(self._pet.subtree_of_type(self._stages[i], NodeType.CU))

        return [dep for dep in raw if dep[0] in [n.id for n in nodes_after]]

    def __output_stage(self, node: CUNode) -> PipelineStage:
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


def is_pipeline_subnode(root: CUNode, current: CUNode, children_start_lines: List[str]) -> bool:
    """Checks if node is a valid subnode for pipeline

    :param root: root node
    :param current: current node
    :param children_start_lines: start lines of children loops
    :return: true if valid
    """
    r_start = root.start_position()
    r_end = root.end_position()
    c_start = current.start_position()
    c_end = current.end_position()
    return not (c_start == r_start and c_end == r_start
                or c_start == r_end and c_end == r_end
                or c_start == c_end and c_start in children_start_lines)


def run_detection(pet: PETGraphX) -> List[PipelineInfo]:
    """Search for pipeline pattern on all the loops in the graph

    :param pet: PET graph
    :return: List of detected pattern info
    """
    result = []
    for node in pet.all_nodes(NodeType.LOOP):
        node.pipeline = __detect_pipeline(pet, node)
        if node.pipeline > __pipeline_threshold:
            result.append(PipelineInfo(pet, node))

    return result


def __detect_pipeline(pet: PETGraphX, root: CUNode) -> float:
    """Calculate pipeline value for node

    :param pet: PET graph
    :param root: current node
    :return: Pipeline scalar value
    """

    children_start_lines = [v.start_position() for v in pet.subtree_of_type(root, NodeType.LOOP)]

    loop_subnodes = [pet.node_at(t) for s, t, d in pet.out_edges(root.id, EdgeType.CHILD)
                     if is_pipeline_subnode(root, pet.node_at(t), children_start_lines)]

    # No chain of stages found
    if len(loop_subnodes) < 2:
        return 0

    graph_vector = []
    for i in range(0, len(loop_subnodes) - 1):
        graph_vector.append(1.0 if pet.depends_ignore_readonly(loop_subnodes[i + 1], loop_subnodes[i], root) else 0.0)

    pipeline_vector = []
    for i in range(0, len(loop_subnodes) - 1):
        pipeline_vector.append(1.0)

    min_weight = 1.0
    for i in range(0, len(loop_subnodes) - 1):
        for j in range(i + 1, len(loop_subnodes)):
            if pet.depends_ignore_readonly(loop_subnodes[i], loop_subnodes[j], root):
                # TODO whose corresponding entry in the graph matrix is nonzero?
                node_weight = 1 - (j - i) / (len(loop_subnodes) - 1)
                if min_weight > node_weight > 0:
                    min_weight = node_weight

    if min_weight == 1.0:
        graph_vector.append(0.0)
        pipeline_vector.append(0)
    else:
        graph_vector.append(1.0)
        pipeline_vector.append(min_weight)

    return correlation_coefficient(graph_vector, pipeline_vector)
