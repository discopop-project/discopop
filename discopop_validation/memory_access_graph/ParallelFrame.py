from typing import List


class ParallelFrame(object):
    identifier: int
    children_frame_identifiers: List[int]

    def __init__(self, memory_access_graph):
        identifier = memory_access_graph.next_free_parallel_frame_id
