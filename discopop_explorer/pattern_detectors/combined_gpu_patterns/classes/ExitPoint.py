# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
import os
from typing import Set, List, Tuple

from discopop_explorer.PETGraphX import PETGraphX, NodeID, MemoryRegion
from discopop_explorer.pattern_detectors.combined_gpu_patterns.classes.Aliases import (
    VarName,
)
from discopop_explorer.pattern_detectors.combined_gpu_patterns.classes.Dependency import Dependency
from discopop_explorer.pattern_detectors.combined_gpu_patterns.classes.Enums import (
    ExitPointPositioning,
    ExitPointType,
)
from discopop_library.MemoryRegions.utils import get_sizes_of_memory_regions


class ExitPoint(object):
    var_names: Set[VarName]
    memory_regions: Set[MemoryRegion]
    source_cu_id: NodeID
    sink_cu_id: NodeID
    exit_point_type: ExitPointType
    pragma_line: str
    exit_point_positioning: ExitPointPositioning
    dependencies: Set[Dependency]

    def __init__(
        self,
        pet: PETGraphX,
        var_names: Set[VarName],
        memory_regions: Set[MemoryRegion],
        source_cu_id: NodeID,
        sink_cu_id: NodeID,
        exit_point_type: ExitPointType,
    ):
        self.var_names = var_names
        self.memory_regions = memory_regions
        self.source_cu_id = source_cu_id
        self.sink_cu_id = sink_cu_id

        # todo handle async
        self.exit_point_type = exit_point_type
        self.pragma_line = pet.node_at(sink_cu_id).start_position()
        self.exit_point_positioning = ExitPointPositioning.BEFORE_CU
        self.dependencies = set()

    def __str__(self):
        return (
            "ExitPoint("
            + str(self.var_names)
            + ", "
            + str(self.memory_regions)
            + ", @ "
            + self.source_cu_id
            + " -> "
            + self.sink_cu_id
            + " : "
            + str(self.exit_point_type)
            + ")"
        )

    def __eq__(self, other):
        if (
            tuple(self.var_names),
            #            tuple(self.memory_regions),  # leads to duplicated outputs
            self.source_cu_id,
            self.sink_cu_id,
            self.exit_point_type,
            self.pragma_line,
            self.exit_point_positioning,
            tuple(self.dependencies),
        ) == (
            tuple(other.var_names),
            #            tuple(other.memory_regions),  # leads to duplicated outputs
            other.source_cu_id,
            other.sink_cu_id,
            other.exit_point_type,
            other.pragma_line,
            other.exit_point_positioning,
            tuple(other.dependencies),
        ):
            return True
        return False

    def __hash__(self):
        return hash(
            (
                tuple(self.var_names),
                tuple(self.memory_regions),
                self.source_cu_id,
                self.sink_cu_id,
                self.exit_point_type,
                self.pragma_line,
                self.exit_point_positioning,
                tuple(self.dependencies),
            )
        )

    def get_position_identifier(self):
        # used to join multiple elements
        return (
            self.sink_cu_id,
            self.source_cu_id,
            self.exit_point_type,
            self.exit_point_positioning,
        )

    def join(self, other):
        self.var_names.update(other.var_names)
        self.memory_regions.update(other.memory_regions)
        self.dependencies.update(other.dependencies)

    def get_as_metadata(self, pet: PETGraphX, project_folder_path: str):
        # get type of mapped variables
        var_names_types_and_sizes: List[Tuple[VarName, str, int]] = []
        for var_name in self.var_names:
            var_obj = pet.get_variable(self.sink_cu_id, var_name)
            if var_obj is None:
                var_obj = pet.get_variable(self.source_cu_id, var_name)
            if var_obj is None:
                var_names_types_and_sizes.append((var_name, "", 1))
            else:
                var_names_types_and_sizes.append((var_name, var_obj.type, var_obj.sizeInByte))
        # add [..] to variable name if required (type contains "**")

        # get size of memory region
        memory_region_sizes = get_sizes_of_memory_regions(
            self.memory_regions, os.path.join(project_folder_path, "memory_regions.txt")
        )
        if len(memory_region_sizes) > 0:
            max_mem_reg_size = max(memory_region_sizes.values())
            # divide memory region size by size of variable
            # construct new list of modified var names
            modified_var_names = [
                (
                    vn + "[:]" if "**" in t else vn
                )  # (vn + "[:" + str(int(max_mem_reg_size / s)) + "]" if "**" in t else vn)
                for vn, t, s in var_names_types_and_sizes
            ]
        else:
            modified_var_names = [(vn + "[:]" if "**" in t else vn) for vn, t, s in var_names_types_and_sizes]

        return [
            ",".join(modified_var_names),
            self.source_cu_id,
            self.sink_cu_id,
            self.exit_point_type,
            self.pragma_line,
            self.exit_point_positioning,
        ]
