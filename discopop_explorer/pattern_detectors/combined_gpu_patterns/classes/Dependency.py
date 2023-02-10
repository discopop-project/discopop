from typing import Set

from discopop_explorer.pattern_detectors.combined_gpu_patterns.classes.Aliases import (
    VarName,
    CUID,
    MemoryRegion,
)


class Dependency(object):
    source: CUID
    sink: CUID
    var_names: Set[VarName]
    memory_regions: Set[MemoryRegion]

    def __init__(
        self, source: CUID, sink: CUID, var_names: Set[VarName], memory_regions: Set[MemoryRegion]
    ):
        self.source = source
        self.sink = sink
        self.var_names = var_names
        self.memory_regions = memory_regions

    def __str__(self):
        return (
            "Dependency("
            + self.source
            + " -> "
            + self.sink
            + " "
            + str(self.var_names)
            + " / "
            + str(self.memory_regions)
            + ")"
        )
