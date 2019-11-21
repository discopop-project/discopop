from graph_tool import Vertex

import PETGraph
from utils import get_loop_iterations, total_instructions_count, calculate_workload


class PatternInfo(object):
    """Base class for pattern detection info
    """
    node: Vertex
    node_id: str
    start_line: str
    end_line: str
    iterations_count: int
    instructions_count: int
    workload: int

    def __init__(self, pet: PETGraph, node: Vertex):
        """
        :param pet: PET graph
        :param node: node, where pipeline was detected
        """
        self.node = node
        self.node_id = pet.graph.vp.id[node]
        self.start_line = pet.graph.vp.startsAtLine[node]
        self.end_line = pet.graph.vp.endsAtLine[node]
        self.iterations_count = get_loop_iterations(self.start_line)
        self.instruction_count = total_instructions_count(pet, node)
        self.workload = calculate_workload(pet, node)
