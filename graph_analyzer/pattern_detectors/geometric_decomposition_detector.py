# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.


import math
from typing import Dict, List, Tuple, Optional

from .PatternInfo import PatternInfo
from ..PETGraphX import PETGraphX, NodeType, CUNode, EdgeType
from ..utils import classify_task_vars, get_child_loops
from ..variable import Variable

__loop_iterations: Dict[str, int] = {}


class GDInfo(PatternInfo):
    """Class, that contains geometric decomposition detection result
    """

    def __init__(self, pet: PETGraphX, node: CUNode, min_iter: int):
        """
        :param pet: PET graph
        :param node: node, where geometric decomposition was detected
        """
        PatternInfo.__init__(self, node)

        self.do_all_children, self.reduction_children = get_child_loops(pet, node)

        self.min_iter_number = min_iter
        mi_sqrt = math.sqrt(min_iter)
        wl = math.sqrt(self.workload)
        nt = 1.1 * mi_sqrt + 0.0002 * wl - 0.0000002 * mi_sqrt * wl - 10

        if nt >= 1000:
            self.num_tasks = math.floor(nt / 100) * 100
        elif nt >= 100:
            self.num_tasks = math.floor(nt / 10) * 10
        elif nt < 0:
            self.num_tasks = 2
        else:
            self.num_tasks = math.floor(nt)

        self.pragma = "for (i = 0; i < num-tasks; i++) #pragma omp task"
        lp: List = []
        fp, p, s, in_dep, out_dep, in_out_dep, r = classify_task_vars(pet, node, "GeometricDecomposition", [], [])
        fp.append(Variable('int', 'i'))

        self.first_private = fp
        self.private = p
        self.last_private = lp
        self.shared = s
        self.reduction = r

    def __str__(self):
        return f'Geometric decomposition at: {self.node_id}\n' \
               f'Start line: {self.start_line}\n' \
               f'End line: {self.end_line}\n' \
               f'Type: Geometric Decomposition Pattern\n' \
               f'Do-All loops: {[n.id for n in self.do_all_children]}\n' \
               f'Reduction loops: {[n.id for n in self.reduction_children]}\n' \
               f'\tNumber of tasks: {self.num_tasks}\n' \
               f'\tChunk limits: {self.min_iter_number}\n' \
               f'\tpragma: {self.pragma}]\n' \
               f'\tprivate: {[v.name for v in self.private]}\n' \
               f'\tshared: {[v.name for v in self.shared]}\n' \
               f'\tfirst private: {[v.name for v in self.first_private]}\n' \
               f'\treduction: {[v for v in self.reduction]}\n' \
               f'\tlast private: {[v.name for v in self.last_private]}'


def run_detection(pet: PETGraphX) -> List[GDInfo]:
    """Detects geometric decomposition

    :param pet: PET graph
    :return: List of detected pattern info
    """
    result = []
    global __loop_iterations
    __loop_iterations = {}
    for node in pet.all_nodes(NodeType.FUNC):
        if __detect_geometric_decomposition(pet, node):
            node.geometric_decomposition = True
            test, min_iter = __test_chunk_limit(pet, node)
            if test and min_iter is not None:
                result.append(GDInfo(pet, node, min_iter))
                # result.append(node.id)

    return result


def __test_chunk_limit(pet: PETGraphX, node: CUNode) -> Tuple[bool, Optional[int]]:
    """Tests, whether or not the node has inner loops with and none of them have 0 iterations

    :param pet: PET graph
    :param node: the node
    :return: true if node satisfies condition, min iteration number
    """
    min_iterations_count = None
    inner_loop_iter = {}

    children = pet.direct_children_of_type(node, NodeType.LOOP)

    for func_child in pet.direct_children_of_type(node, NodeType.FUNC):
        children.extend(pet.direct_children_of_type(func_child, NodeType.LOOP))

    for child in children:
        inner_loop_iter[child.start_position()] = __iterations_count(pet, child)

    for k, v in inner_loop_iter.items():
        if min_iterations_count is None or v < min_iterations_count:
            min_iterations_count = v
    return bool(inner_loop_iter) and (min_iterations_count is None or min_iterations_count > 0), min_iterations_count


def __iterations_count(pet: PETGraphX, node: CUNode) -> int:
    """Counts the iterations in the specified node

    :param pet: PET graph
    :param node: the loop node
    :return: number of iterations
    """
    if not (node in __loop_iterations):
        loop_iter = node.loop_iterations
        parent_iter = __get_parent_iterations(pet, node)

        if loop_iter < parent_iter:
            __loop_iterations[node.id] = loop_iter
        elif loop_iter <= 0 or parent_iter <= 0:
            __loop_iterations[node.id] = 0
        else:
            __loop_iterations[node.id] = loop_iter // parent_iter

    return __loop_iterations[node.id]


def __get_parent_iterations(pet: PETGraphX, node: CUNode) -> int:
    """Calculates the number of iterations in parent of loop

    :param pet: PET graph
    :param node: current node
    :return: number of iterations
    """
    parent = pet.in_edges(node.id, EdgeType.CHILD)

    max_iter = 1
    while parent:
        node = pet.node_at(parent[0][0])
        if node.type == NodeType.LOOP:
            max_iter = max(1, node.loop_iterations)
            break
        parent = pet.in_edges(node.id, EdgeType.CHILD)

    return max_iter


def __detect_geometric_decomposition(pet: PETGraphX, root: CUNode) -> bool:
    """Detects geometric decomposition pattern

    :param pet: PET graph
    :param root: root node
    :return: true if GD pattern was discovered
    """
    for child in pet.subtree_of_type(root, NodeType.LOOP):
        if not (child.reduction or child.do_all):
            return False

    for child in pet.direct_children_of_type(root, NodeType.FUNC):
        for child2 in pet.direct_children_of_type(child, NodeType.LOOP):
            if not (child2.reduction or child2.do_all):
                return False

    return True
