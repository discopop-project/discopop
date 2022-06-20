from typing import Tuple, List, Optional

from discopop_validation.memory_access_graph.ParallelUnit import ParallelUnit


class AccessMetaData(object):
    access_mode: str
    operation_path_id: List[int]
    parallel_unit: ParallelUnit

    def __init__(self, access_mode: str, operation_path_id: List[int], parallel_unit: ParallelUnit):
        self.access_mode = access_mode
        self.operation_path_id = operation_path_id
        self.parallel_unit = parallel_unit

    def get_edge_label(self) -> str:
        return "" + str(self.operation_path_id) + "\n" + str(self.parallel_unit)
