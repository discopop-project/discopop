from typing import List

from discopop_validation.data_race_prediction.task_graph.classes.TaskGraphNode import TaskGraphNode
from discopop_validation.memory_access_graph.ParallelUnit import ParallelUnit


class PUStack(object):
    """This stack is used to store information on the currently known parallel units during the creation of the
    MemoryAccessGraph."""
    contents: List[ParallelUnit]

    def __init__(self):
        self.contents = []

    def push(self, parallel_frame_id: int, origin_task_graph_node: TaskGraphNode):
        parallel_frame = ParallelUnit(parallel_frame_id, origin_task_graph_node)
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