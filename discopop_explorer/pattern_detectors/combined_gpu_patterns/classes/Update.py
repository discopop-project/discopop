from typing import Set

from discopop_explorer.PETGraphX import PETGraphX
from discopop_explorer.pattern_detectors.combined_gpu_patterns.classes.Aliases import (
    CUID,
    MemoryRegion,
)
from discopop_explorer.pattern_detectors.combined_gpu_patterns.classes.Enums import UpdateType


class Update(object):
    source_cu_id: CUID
    sink_cu_id: CUID
    memory_regions: Set[MemoryRegion]
    update_type: UpdateType

    def __init__(
        self,
        cu_id: CUID,
        sink_cu_id: CUID,
        memory_regions: Set[MemoryRegion],
        update_type: UpdateType,
    ):
        self.source_cu_id = cu_id
        self.sink_cu_id = sink_cu_id
        self.memory_regions = memory_regions
        self.update_type = update_type

    def __str__(self):
        result_str = ""
        result_str += (
            str(self.update_type)
            + " @ "
            + self.source_cu_id
            + " -> "
            + self.sink_cu_id
            + " : "
            + str(self.memory_regions)
        )
        return result_str

    def get_as_metadata(self, pet: PETGraphX):
        return [
            self.source_cu_id,
            self.sink_cu_id,
            self.update_type,
            str(self.memory_regions) + " @ " + self.source_cu_id + " -> " + self.sink_cu_id,
            pet.node_at(self.source_cu_id).end_position(),
        ]
