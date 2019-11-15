from typing import List, Dict

from graph_tool import Vertex
from graph_tool.util import find_vertex

import PETGraph
from pattern_detectors.PatternInfo import PatternInfo
from utils import get_subtree_of_type


class ReductionInfo(PatternInfo):
    """Class, that contains reduction detection result
    """

    def __init__(self, pet: PETGraph, node: Vertex):
        """
        :param pet: PET graph
        :param node: node, where reduction was detected
        """
        PatternInfo.__init__(self, pet, node)

    def __str__(self):
        return f'Reduction at: {self.node_id}\n' \
               f'Start line: {self.start_line}\n' \
               f'End line: {self.end_line}'


def __is_reduction_var(line: str, name: str, reduction_vars: List[Dict[str, str]]) -> bool:
    """Determines, whether or not the given variable is reduction variable

    :param line: loop line number
    :param name: variable name
    :param reduction_vars: List of reduction variables
    :return: true if is reduction variable
    """
    return any(rv for rv in reduction_vars if rv['loop_line'] == line and rv['name'] == name)


def run_detection(pet: PETGraph) -> List[ReductionInfo]:
    """Search for reduction pattern

    :param pet: PET graph
    :return: List of detected pattern info
    """
    result = []

    for node in find_vertex(pet.graph, pet.graph.vp.type, 'loop'):
        if __detect_reduction(pet, node):
            pet.graph.vp.reduction[node] = True
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

    all_vars = set()
    for node in get_subtree_of_type(pet, root, 'cu'):
        for v in pet.graph.vp.localVars[node]:
            all_vars.add(v)
        for v in pet.graph.vp.globalVars[node]:
            all_vars.add(v)

    return bool([v for v in all_vars if __is_reduction_var(pet.graph.vp.startsAtLine[root], v, pet.reduction_vars)])
