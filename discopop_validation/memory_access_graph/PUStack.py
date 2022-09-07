from typing import List

from discopop_validation.data_race_prediction.parallel_construct_graph.classes.PCGraphNode import PCGraphNode
from discopop_validation.memory_access_graph.ParallelUnit import ParallelUnit


class PUStack(object):
    """This stack is used to store information on the currently known parallel units during the creation of the
    MemoryAccessGraph.
    The stack has to consist of at least one element at all times"""
    contents: List[ParallelUnit]

    def __init__(self, parallel_frame_id: int, root_pc_graph_node: PCGraphNode):
        self.contents = []
        self.push(parallel_frame_id, root_pc_graph_node)

    def push(self, parallel_frame_id: int, origin_pc_graph_node: PCGraphNode):
        parallel_frame = ParallelUnit(parallel_frame_id, origin_pc_graph_node)
        self.contents.append(parallel_frame)

    def push_pu(self, parallel_unit: ParallelUnit):
        self.contents.append(parallel_unit)

    def pop(self) -> ParallelUnit:
        """removes and returns the last element of the stack.
        """
        if len(self.contents) == 0:
            raise ValueError("PU Stack must not be empty!")
        buffer = self.contents[-1]
        del self.contents[-1]
        return buffer

    def peek(self) -> ParallelUnit:
        """returns the last element of the stack.
        """
        if len(self.contents) == 0:
            raise ValueError("PU Stack must not be empty!")
        return self.contents[-1]

    def __str__(self) -> str:
        result = "["
        for element in self.contents:
            result += str(element) + ", "
        result += "]"
        return result
