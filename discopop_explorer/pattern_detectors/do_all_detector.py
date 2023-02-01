# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
from typing import List, Dict, Set, Tuple

from .PatternInfo import PatternInfo
from ..PETGraphX import PETGraphX, CUNode, NodeType, EdgeType
from ..utils import classify_loop_variables, contains
import time


class DoAllInfo(PatternInfo):
    """Class, that contains do-all detection result"""

    def __init__(self, pet: PETGraphX, node: CUNode):
        """
        :param pet: PET graph
        :param node: node, where do-all was detected
        """
        PatternInfo.__init__(self, node)
        fp, p, lp, s, r = classify_loop_variables(pet, node)
        self.first_private = fp
        self.private = p
        self.last_private = lp
        self.shared = s
        self.reduction = r

    def __str__(self):
        return (
            f"Do-all at: {self.node_id}\n"
            f"Start line: {self.start_line}\n"
            f"End line: {self.end_line}\n"
            # f"iterations: {self.iterations_count}\n"
            # f"instructions: {self.instructions_count}\n"
            # f"workload: {self.workload}\n"
            f'pragma: "#pragma omp parallel for"\n'
            f"private: {[v.name for v in self.private]}\n"
            f"shared: {[v.name for v in self.shared]}\n"
            f"first private: {[v.name for v in self.first_private]}\n"
            f"reduction: {[v.name for v in self.reduction]}\n"
            f"last private: {[v.name for v in self.last_private]}"
        )


def run_detection(pet: PETGraphX) -> List[DoAllInfo]:
    """Search for do-all loop pattern

    :param pet: PET graph
    :return: List of detected pattern info
    """
    result: List[DoAllInfo] = []
    nodes = pet.all_nodes(NodeType.LOOP)
    for idx, node in enumerate(nodes):
        # print("Do-all:", idx, "/", len(nodes))
        if not contains(result, lambda x: x.node_id == node.id) and __detect_do_all(pet, node):
            node.do_all = True
            if not node.reduction and node.loop_iterations >= 0:
                result.append(DoAllInfo(pet, node))

    return result


def __detect_do_all(pet: PETGraphX, root_loop: CUNode) -> bool:
    """Calculate do-all value for node

    :param pet: PET graph
    :param root: root node
    :return: true if do-all
    """
    subnodes = [
        pet.node_at(t)
        for s, t, d in pet.out_edges(root_loop.id, [EdgeType.CHILD, EdgeType.CALLSNODE])
    ]

    for i in range(0, len(subnodes)):
        children_cache: Dict[CUNode, List[CUNode]] = dict()
        dependency_cache: Dict[Tuple[CUNode, CUNode], Set[CUNode]] = dict()
        for j in range(i, len(subnodes)):
            if pet.depends_ignore_readonly(subnodes[i], subnodes[j], root_loop):
                return False

    return True
