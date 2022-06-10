from typing import List

from discopop_validation.memory_access_graph.MemoryAccessGraph import MemoryAccessGraph


class ParallelFrame(object):
    identifier: int
    children_frame_identifiers: List[int]

    def __init__(self, memory_access_graph: MemoryAccessGraph):
        identifier = memory_access_graph.next_free_parallel_frame_id

