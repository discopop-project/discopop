from typing import Set

from discopop_explorer.PETGraphX import PETGraphX
from discopop_explorer.pattern_detectors.combined_gpu_patterns.classes.Aliases import (
    VarName,
    CUID,
    MemoryRegion,
)
from discopop_explorer.pattern_detectors.combined_gpu_patterns.classes.Enums import (
    ExitPointPositioning,
    ExitPointType,
)


class ExitPoint(object):
    var_names: Set[VarName]
    memory_regions: Set[MemoryRegion]
    source_cu_id: CUID
    sink_cu_id: CUID
    exit_point_type: ExitPointType
    pragma_line: str
    exit_point_positioning: ExitPointPositioning

    def __init__(
        self,
        pet: PETGraphX,
        var_names: Set[VarName],
        memory_regions: Set[MemoryRegion],
        source_cu_id: CUID,
        sink_cu_id: CUID,
        exit_point_type: ExitPointType,
    ):
        self.var_names = var_names
        self.memory_regions = memory_regions
        self.source_cu_id = source_cu_id
        self.sink_cu_id = sink_cu_id
        self.exit_point_type = exit_point_type
        self.pragma_line = pet.node_at(source_cu_id).end_position()
        self.exit_point_positioning = ExitPointPositioning.BEFORE_CU

    def get_as_metadata(self):
        return [
            str(self.var_names),
            self.source_cu_id,
            self.sink_cu_id,
            self.exit_point_type,
            self.pragma_line,
            self.exit_point_positioning,
        ]
