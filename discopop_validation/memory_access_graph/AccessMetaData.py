from typing import Tuple, List, Optional

from discopop_validation.data_race_prediction.behavior_modeller.classes.Operation import Operation
from discopop_validation.data_race_prediction.parallel_construct_graph.classes.BehaviorModelNode import \
    BehaviorModelNode
from discopop_validation.memory_access_graph.ParallelUnit import ParallelUnit


class AccessMetaData(object):
    operation: Operation
    access_mode: str
    operation_path_id: List[int]
    origin_bhv_node: BehaviorModelNode
    parallel_unit: ParallelUnit

    def __init__(self, operation: Operation, access_mode: str, operation_path_id: List[int], bhv_node: BehaviorModelNode, parallel_unit: ParallelUnit):
        self.operation = operation
        self.access_mode = access_mode
        self.operation_path_id = operation_path_id
        self.origin_bhv_node = bhv_node
        self.parallel_unit = parallel_unit

    def get_edge_label(self) -> str:
        return "" + str(self.operation_path_id) + "\n" + str(self.parallel_unit)
