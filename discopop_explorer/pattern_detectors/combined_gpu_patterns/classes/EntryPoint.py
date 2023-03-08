# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
import sys
from typing import Set, Tuple, List

from discopop_explorer.PETGraphX import PETGraphX, NodeID
from discopop_explorer.pattern_detectors.combined_gpu_patterns.classes.Aliases import (
    VarName,
    MemoryRegion,
)
from discopop_explorer.pattern_detectors.combined_gpu_patterns.classes.Dependency import Dependency
from discopop_explorer.pattern_detectors.combined_gpu_patterns.classes.Enums import (
    EntryPointType,
    EntryPointPositioning,
)


class EntryPoint(object):
    var_names: Set[VarName]
    memory_regions: Set[MemoryRegion]
    source_cu_id: NodeID
    sink_cu_id: NodeID
    entry_point_type: EntryPointType
    pragma_line: str
    entry_point_positioning: EntryPointPositioning
    dependencies: Set[Dependency]

    def __init__(
        self,
        pet: PETGraphX,
        var_names: Set[VarName],
        memory_regions: Set[MemoryRegion],
        source_cu_id: NodeID,
        sink_cu_id: NodeID,
        entry_point_type: EntryPointType,
    ):
        self.var_names = var_names
        self.memory_regions = memory_regions
        self.source_cu_id = source_cu_id
        self.sink_cu_id = sink_cu_id

        # todo handle async
        self.entry_point_type = entry_point_type
        self.pragma_line = pet.node_at(sink_cu_id).start_position()
        self.entry_point_positioning = EntryPointPositioning.BEFORE_CU
        self.dependencies = set()

    def __str__(self):
        return (
            "EntryPoint("
            + str(self.var_names)
            + ", "
            + str(self.memory_regions)
            + ", @ "
            + self.source_cu_id
            + " -> "
            + self.sink_cu_id
            + " : "
            + str(self.entry_point_type)
            + ")"
        )

    def get_as_metadata(self, pet: PETGraphX):
        # get type of mapped variables
        var_names_and_types: List[Tuple[VarName, str]] = []
        for var_name in self.var_names:
            var_type = pet.get_variable_type(self.sink_cu_id, var_name)
            if var_type == "":
                var_type = pet.get_variable_type(self.source_cu_id, var_name)
            var_names_and_types.append((var_name, var_type))
        # add [..] to variable name if required (type contains "**")
        modified_var_names = [(vn + "[..]" if "**" in t else vn) for vn, t in var_names_and_types]

        return [
            ",".join(modified_var_names),
            self.source_cu_id,
            self.sink_cu_id,
            self.entry_point_type,
            self.pragma_line,
            self.entry_point_positioning,
        ]
