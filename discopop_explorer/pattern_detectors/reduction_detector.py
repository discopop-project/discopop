# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.


from typing import List

from .PatternInfo import PatternInfo
from ..PETGraphX import PETGraphX, NodeType, CUNode
from ..utils import is_reduction_var, classify_loop_variables


class ReductionInfo(PatternInfo):
    """Class, that contains reduction detection result
    """

    def __init__(self, pet: PETGraphX, node: CUNode):
        """
        :param pet: PET graph
        :param node: node, where reduction was detected
        """
        PatternInfo.__init__(self, node)
        self.pragma = "#pragma omp parallel for"

        fp, p, lp, s, r = classify_loop_variables(pet, node)
        self.first_private = fp
        self.private = p
        self.last_private = lp
        self.shared = s
        self.reduction = r

    def __str__(self):
        return f'Reduction at: {self.node_id}\n' \
               f'Start line: {self.start_line}\n' \
               f'End line: {self.end_line}\n' \
               f'pragma: {self.pragma}\n' \
               f'private: {[v.name for v in self.private]}\n' \
               f'shared: {[v.name for v in self.shared]}\n' \
               f'first private: {[v.name for v in self.first_private]}\n' \
               f'reduction: {[v.operation + ":" + v.name for v in self.reduction]}\n' \
               f'last private: {[v.name for v in self.last_private]}'


def run_detection(pet: PETGraphX) -> List[ReductionInfo]:
    """Search for reduction pattern

    :param pet: PET graph
    :return: List of detected pattern info
    """
    result = []

    for node in pet.all_nodes(NodeType.LOOP):
        if __detect_reduction(pet, node):
            node.reduction = True
            if node.loop_iterations > 0:
                result.append(ReductionInfo(pet, node))

    return result


def __detect_reduction(pet: PETGraphX, root: CUNode) -> bool:
    """Detects reduction pattern in loop

    :param pet: PET graph
    :param root: the loop node
    :return: true if is reduction loop
    """
    all_vars = []
    for node in pet.subtree_of_type(root, NodeType.CU):
        all_vars.extend(node.local_vars)
        all_vars.extend(node.global_vars)

    return bool([v for v in all_vars if is_reduction_var(root.start_position(), v.name, pet.reduction_vars)])
