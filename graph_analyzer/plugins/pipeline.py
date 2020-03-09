from graph_tool import Vertex
from graph_tool.util import find_vertex

import PETGraph
from typing import List

from utils import find_subnodes, correlation_coefficient, depends_ignore_readonly


def run(pet):
    for node in find_vertex(pet.graph, pet.graph.vp.type, 'loop'):
        check_pipeline(pet, node)
    return pet


def check_pipeline(pet: PETGraph, root: Vertex):
    """TODO

    :param pet: PET graph
    :param root: current node
    :return: Pipeline scalar value
    """

    children_start_lines = [pet.graph.vp.startsAtLine[v]
                            for v in find_subnodes(pet, root, 'child')
                            if pet.graph.vp.type[v] == 'loop']

    loop_subnodes = [v for v in find_subnodes(pet, root, 'child')
                     if is_pipeline_subnode(pet, root, v, children_start_lines)]

    if len(loop_subnodes) < 2:
        pet.graph.vp.pipeline[root] = -1
        return

    reverse = depends_ignore_readonly(pet, loop_subnodes[0], loop_subnodes[-1], root)

    isolated = True

    for i in range(0, len(loop_subnodes)-2):
        if depends_ignore_readonly(pet, loop_subnodes[-1], loop_subnodes[i], root):
            isolated = False

    if reverse and isolated:
        print('pipeline can be restructured at ' + pet.graph.vp.id[root])


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
