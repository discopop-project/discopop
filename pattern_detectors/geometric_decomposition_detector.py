import math
from typing import Dict, List

from graph_tool import Vertex
from graph_tool.util import find_vertex

import PETGraph
from pattern_detectors.PatternInfo import PatternInfo
from pattern_detectors.do_all_detector import do_all_threshold
from utils import find_subnodes, get_subtree_of_type, get_loop_iterations, classify_loop_variables

# cache
__loop_iterations: Dict[str, int] = {}


class GDInfo(PatternInfo):
    """Class, that contains geometric decomposition detection result
    """

    def __init__(self, pet: PETGraph, node: Vertex):
        """
        :param pet: PET graph
        :param node: node, where geometric decomposition was detected
        """
        PatternInfo.__init__(self, pet, node)
        self.pet = pet

        child_loops = [sn for sn in find_subnodes(pet, node, 'child') if pet.graph.vp.type[sn] == 'loop']
        for sn in find_subnodes(pet, node, 'child'):
            if pet.graph.vp.type[sn] == 'func':
                child_loops.extend([n for n in find_subnodes(pet, sn, 'child') if pet.graph.vp.type[n] == 'loop'])

        self.do_all_children = [n for n in child_loops if pet.graph.vp.doAll[n] >= do_all_threshold]
        self.reduction_children = [n for n in child_loops if pet.graph.vp.reduction[n]]
        # TODO task var classification

    def __str__(self):
        return f'Geometric decomposition at: {self.node_id}\n' \
               f'Start line: {self.start_line}\n' \
               f'End line: {self.end_line}\n' \
               f'Do-All loops: {[self.pet.graph.vp.id[n] for n in self.do_all_children]}\n' \
               f'Reduction loops: {[self.pet.graph.vp.id[n] for n in self.reduction_children]}\n'


def run_detection(pet: PETGraph) -> List[GDInfo]:
    """Detects geometric decomposition

    :param pet: PET graph
    :return: List of detected pattern info
    """
    result = []
    for node in find_vertex(pet.graph, pet.graph.vp.type, 'func'):
        val = __detect_geometric_decomposition(pet, node)
        if val:
            pet.graph.vp.geomDecomp[node] = val
            if __test_chunk_limit(pet, node):
                result.append(GDInfo(pet, node))

    return result


def __test_chunk_limit(pet: PETGraph, node: Vertex) -> bool:
    """Tests, whether or not the node has inner loops with and none of them have 0 iterations

    :param pet: PET graph
    :param node: the node
    :return: true if node satisfies condition
    """
    min_iterations_count = math.inf
    inner_loop_iter = {}

    children = [e.target() for e in node.out_edges() if pet.graph.ep.type[e] == 'child'
                and pet.graph.vp.type[e.target()] == 'loop']

    for func_child in [e.target()
                       for e in node.out_edges()
                       if pet.graph.ep.type[e] == 'child' and pet.graph.vp.type[e.target()] == 'func']:
        children.extend([e.target()
                         for e in func_child.out_edges()
                         if pet.graph.ep.type[e] == 'child' and pet.graph.vp.type[e.target()] == 'loop'])

    for child in children:
        inner_loop_iter[pet.graph.vp.startsAtLine[child]] = __iterations_count(pet, child)

    for k, v in inner_loop_iter.items():
        min_iterations_count = min(min_iterations_count, v)

    return inner_loop_iter and min_iterations_count > 0


def __iterations_count(pet: PETGraph, node: Vertex) -> int:
    """Counts the iterations in the specified node

    :param pet: PET graph
    :param node: the loop node
    :return: number of iterations
    """
    if not (node in __loop_iterations):
        loop_iter = get_loop_iterations(pet.graph.vp.startsAtLine[node])
        parent_iter = __get_parent_iterations(pet, node)

        if loop_iter < parent_iter:
            __loop_iterations[node] = loop_iter
        elif loop_iter == 0 or parent_iter == 0:
            __loop_iterations[node] = 0
        else:
            __loop_iterations[node] = loop_iter // parent_iter

    return __loop_iterations[node]


def __get_parent_iterations(pet: PETGraph, node: Vertex) -> int:
    """Calculates the number of iterations in parent of loop

    :param pet: PET graph
    :param node: current node
    :return: number of iterations
    """
    parent = [e.source() for e in node.in_edges() if pet.graph.ep.type[e] == 'child']

    max_iter = 1
    while parent:
        node = parent[0]
        if pet.graph.vp.type[node] == 'loop':
            max_iter = max(1, get_loop_iterations(pet.graph.vp.startsAtLine[node]))
            break
        parent = [e.source() for e in node.in_edges() if pet.graph.ep.type[e] == 'child']

    return max_iter


def __detect_geometric_decomposition(pet: PETGraph, root: Vertex) -> bool:
    """Detects geometric decomposition pattern

    :param pet: PET graph
    :param root: root node
    :return: true if GD pattern was discovered
    """
    for child in get_subtree_of_type(pet, root, 'loop'):
        if (pet.graph.vp.doAll[child] < do_all_threshold
                and not pet.graph.vp.reduction[child]):
            return False

    for child in find_subnodes(pet, root, 'func'):
        for child2 in find_subnodes(pet, child, 'loop'):
            if (pet.graph.vp.doAll[child2] < do_all_threshold
                    and not pet.graph.vp.reduction[child2]):
                return False

    return True
