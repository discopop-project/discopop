# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2019, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# a BSD-style license.  See the LICENSE file in the package base
# directory for details.
from typing import List

import numpy as np
from graph_tool import Vertex
from graph_tool.util import find_vertex

import PETGraph
from pattern_detectors.PatternInfo import PatternInfo
from utils import find_subnodes, depends_ignore_readonly, \
    correlation_coefficient, get_loop_iterations, classify_loop_variables

do_all_threshold = 0.95


class DoAllInfo(PatternInfo):
    """Class, that contains do-all detection result
    """
    coefficient: float

    def __init__(self, pet: PETGraph, node: Vertex, coefficient: float):
        """
        :param pet: PET graph
        :param node: node, where do-all was detected
        :param coefficient: correlation coefficient
        """
        PatternInfo.__init__(self, pet, node)
        self.coefficient = round(coefficient, 3)
        fp, p, lp, s, r = classify_loop_variables(pet, node)
        self.first_private = fp
        self.private = p
        self.last_private = lp
        self.shared = s
        self.reduction = r

    def __str__(self):
        return f'Do-all at: {self.node_id}\n' \
               f'Coefficient: {round(self.coefficient, 3)}\n' \
               f'Start line: {self.start_line}\n' \
               f'End line: {self.end_line}\n' \
               f'iterations: {self.iterations_count}\n' \
               f'instructions: {self.instruction_count}\n' \
               f'workload: {self.workload}\n' \
               f'pragma: "#pragma omp parallel for"\n' \
               f'private: {[v.name for v in self.private]}\n' \
               f'shared: {[v.name for v in self.shared]}\n' \
               f'first private: {[v.name for v in self.first_private]}\n' \
               f'reduction: {[v.name for v in self.reduction]}\n' \
               f'last private: {[v.name for v in self.last_private]}'


def run_detection(pet: PETGraph) -> List[DoAllInfo]:
    """Search for do-all loop pattern

    :param pet: PET graph
    :return: List of detected pattern info
    """
    result = []
    for node in find_vertex(pet.graph, pet.graph.vp.type, 'loop'):
        val = __detect_do_all(pet, node)
        if val > do_all_threshold:
            pet.graph.vp.doAll[node] = val
            if not pet.graph.vp.reduction[node] and get_loop_iterations(pet.graph.vp.startsAtLine[node]) > 0:
                result.append(DoAllInfo(pet, node, pet.graph.vp.doAll[node]))

    return result


def __detect_do_all(pet: PETGraph, root: Vertex):
    """Calculate do-all value for node

    :param pet: PET graph
    :param root: root node
    :return: do-all scalar value
    """
    graph_vector = []

    subnodes = find_subnodes(pet, root, 'child')

    for i in range(0, len(subnodes)):
        for j in range(i, len(subnodes)):
            if depends_ignore_readonly(pet, subnodes[i], subnodes[j], root):
                graph_vector.append(0)
            else:
                graph_vector.append(1)

    pattern_vector = [1 for _ in graph_vector]

    if np.linalg.norm(graph_vector) == 0:
        return 0

    return correlation_coefficient(graph_vector, pattern_vector)
