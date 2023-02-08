# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

from typing import Set, Dict, cast

from discopop_explorer.PETGraphX import PETGraphX
from discopop_explorer.pattern_detectors.combined_gpu_patterns.classes.Aliases import (
    CUID,
    MemoryRegion,
    VarName,
)
from discopop_explorer.pattern_detectors.combined_gpu_patterns.classes.Enums import UpdateType


class Update(object):
    source_cu_id: CUID
    sink_cu_id: CUID
    memory_regions: Set[MemoryRegion]
    variable_names: Set[VarName]
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

    def get_as_metadata_using_memory_regions(self, pet: PETGraphX):
        return [
            self.source_cu_id,
            self.sink_cu_id,
            self.update_type,
            str(self.memory_regions),
            pet.node_at(self.source_cu_id).end_position(),
        ]

    def get_as_metadata_using_variable_names(self, pet: PETGraphX):
        return [
            self.source_cu_id,
            self.sink_cu_id,
            self.update_type,
            str(self.variable_names),
            pet.node_at(self.source_cu_id).end_position(),
        ]

    def get_as_metadata_using_variable_names_and_memory_regions(self, pet: PETGraphX):
        return [
            self.source_cu_id,
            self.sink_cu_id,
            self.update_type,
            str(self.variable_names) + "/" + str(self.memory_regions),
            pet.node_at(self.source_cu_id).end_position(),
        ]

    def convert_memory_regions_to_variable_names(
        self,
        pet: PETGraphX,
        memory_regions_to_functions_and_variables: Dict[MemoryRegion, Dict[CUID, Set[VarName]]],
    ):
        self.variable_names = set()
        parent_function_id = cast(CUID, pet.get_parent_function(pet.node_at(self.source_cu_id)).id)
        for mem_reg in self.memory_regions:
            if parent_function_id in memory_regions_to_functions_and_variables[mem_reg]:
                self.variable_names.update(
                    memory_regions_to_functions_and_variables[mem_reg][parent_function_id]
                )
            elif self.source_cu_id in memory_regions_to_functions_and_variables[mem_reg]:
                self.variable_names.update(
                    memory_regions_to_functions_and_variables[mem_reg][self.source_cu_id]
                )
            elif self.sink_cu_id in memory_regions_to_functions_and_variables[mem_reg]:
                self.variable_names.update(
                    memory_regions_to_functions_and_variables[mem_reg][self.sink_cu_id]
                )
            else:
                self.variable_names.add(VarName("UNDETERMINED(" + mem_reg + ")"))
