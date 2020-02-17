# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2019, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# a BSD-style license.  See the LICENSE file in the package base
# directory for details.


from typing import List

from graph_tool import Vertex
from graph_tool.util import find_vertex

import PETGraph
from pattern_detectors.PatternInfo import PatternInfo
from utils import get_subtree_of_type, is_reduction_var, classify_loop_variables, get_loop_iterations


class ReductionInfo(PatternInfo):
    """Class, that contains reduction detection result
    """

    def __init__(self, pet: PETGraph, node: Vertex):
        """
        :param pet: PET graph
        :param node: node, where reduction was detected
        """
        PatternInfo.__init__(self, pet, node)
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
               f'pragma: "#pragma omp parallel for"\n' \
               f'private: {[v.name for v in self.private]}\n' \
               f'shared: {[v.name for v in self.shared]}\n' \
               f'first private: {[v.name for v in self.first_private]}\n' \
               f'reduction: {[v.name for v in self.reduction]}\n' \
               f'last private: {[v.name for v in self.last_private]}'


def run_detection(pet: PETGraph) -> List[ReductionInfo]:
    """Search for reduction pattern

    :param pet: PET graph
    :return: List of detected pattern info
    """
    result = []

    for node in find_vertex(pet.graph, pet.graph.vp.type, 'loop'):
        if __detect_reduction(pet, node):
            pet.graph.vp.reduction[node] = True
            if get_loop_iterations(pet.graph.vp.startsAtLine[node]) != 0:
                result.append(ReductionInfo(pet, node))

    return result


def __detect_reduction(pet: PETGraph, root: Vertex) -> bool:
    """Detects reduction pattern in loop

    :param pet: PET graph
    :param root: the loop node
    :return: true if is reduction loop
    """
    if pet.graph.vp.type[root] != 'loop':
        return False

    all_vars = []
    for node in get_subtree_of_type(pet, root, 'cu'):
        for v in pet.graph.vp.localVars[node]:
            all_vars.append(v)
        for v in pet.graph.vp.globalVars[node]:
            all_vars.append(v)

    return bool([v for v in all_vars if is_reduction_var(pet.graph.vp.startsAtLine[root], v.name, pet.reduction_vars)])
