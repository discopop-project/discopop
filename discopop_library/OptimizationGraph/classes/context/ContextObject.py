from typing import Dict, Set

from discopop_library.OptimizationGraph.CostModels.CostModel import CostModel
from discopop_library.OptimizationGraph.classes.context.Update import Update
from discopop_library.OptimizationGraph.classes.types.Aliases import DeviceID
from discopop_library.OptimizationGraph.classes.types.DataAccessType import (
    WriteDataAccess,
    ReadDataAccess,
)


class ContextObject(object):
    seen_writes_by_device: Dict[DeviceID, WriteDataAccess]
    necessary_updates: Set[Update]

    def __init__(self):
        self.seen_writes_by_device = dict()
        self.necessary_updates = set()

    def merge(self, other):
        raise NotImplementedError("TODO")

    def calculate_necessary_updates(self, node_reads: Set[ReadDataAccess]):
        raise NotImplementedError("TODO")

    def get_transfer_costs(self) -> CostModel:
        """Replaces the planned storage of update information for individual graph edges.
        Sums and returns the transfert costs represented by the current ContextObject."""
        raise NotImplementedError("TODO")
