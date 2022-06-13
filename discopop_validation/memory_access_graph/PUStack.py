from typing import List

from discopop_validation.data_race_prediction.parallel_construct_graph.classes.PCGraphNode import PCGraphNode
from discopop_validation.memory_access_graph.ParallelUnit import ParallelUnit


class PUStack(object):
    """This stack is used to store information on the currently known parallel units during the creation of the
    MemoryAccessGraph."""
    contents: List[ParallelUnit]

    def __init__(self):
        self.contents = []

    def push(self, parallel_frame_id: int, origin_pc_graph_node: PCGraphNode):
        parallel_frame = ParallelUnit(parallel_frame_id, origin_pc_graph_node)
        self.contents.append(parallel_frame)

    def pop(self) -> ParallelUnit | None:
        """removes and returns the last element of the stack.
        Returns None if the stack is empty"""
        if len(self.contents) == 0:
            return None
        buffer = self.contents[-1]
        del self.contents[-1]
        return buffer

    def peek(self) -> ParallelUnit | None:
        """returns the last element of the stack.
        Returns None if the stack is empty"""
        if len(self.contents) == 0:
            return None
        return self.contents[-1]

    def __str__(self) -> str:
        result = "["
        for element in self.contents:
            result += str(element) + ", "
        result += "]"
        return result
