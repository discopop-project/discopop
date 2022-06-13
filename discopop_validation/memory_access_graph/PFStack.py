from typing import List


class PFStack(object):
    """This stack is used to store information on the currently known parallel frames during the creation of the
    MemoryAccessGraph."""
    contents: List[int]

    def __init__(self):
        self.contents = []

    def push(self, parallel_frame_id: int):
        self.contents.append(parallel_frame_id)

    def pop(self) -> int | None:
        """removes and returns the last element of the stack.
        Returns None if the stack is empty"""
        if len(self.contents) == 0:
            return None
        buffer = self.contents[-1]
        del self.contents[-1]
        return buffer

    def peek(self) -> int | None:
        """returns the last element of the stack.
        Returns None if the stack is empty"""
        if len(self.contents) == 0:
            return None
        return self.contents[-1]

    def __str__(self) -> str:
        return str(self.contents)