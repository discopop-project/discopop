from typing import Tuple

from discopop_validation.memory_access_graph.ParallelUnit import ParallelUnit


class AccessMetaData(object):
    access_mode: str
    operation_idx: Tuple[int, int, int, int]
    parallel_unit: ParallelUnit

    def __init__(self, access_mode: str, operation_idx: Tuple[int, int, int, int], parallel_unit: ParallelUnit):
        self.access_mode = access_mode
        self.operation_idx = operation_idx
        self.parallel_unit = parallel_unit

    def get_edge_label(self) -> str:
        return "" + str(self.operation_idx) + "\n" + str(self.parallel_unit)
