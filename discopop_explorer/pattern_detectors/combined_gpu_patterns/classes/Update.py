# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
import sys
from typing import Set, Dict, cast, Optional

from discopop_explorer.PETGraphX import PETGraphX
from discopop_explorer.pattern_detectors.combined_gpu_patterns.classes.Aliases import (
    CUID,
    MemoryRegion,
    VarName,
)
from discopop_explorer.pattern_detectors.combined_gpu_patterns.classes.Dependency import Dependency
from discopop_explorer.pattern_detectors.combined_gpu_patterns.classes.Enums import UpdateType


class Update(object):
    synchronous_source_cu_id: CUID
    asynchronous_source_cu_id: Optional[CUID]
    sink_cu_id: CUID
    memory_regions: Set[MemoryRegion]
    variable_names: Set[VarName]
    update_type: UpdateType
    last_write_locations: Dict[MemoryRegion, CUID]
    asynchronous_possible: bool
    dependencies: Set[Dependency]

    def __init__(
        self,
        cu_id: CUID,
        sink_cu_id: CUID,
        memory_regions: Set[MemoryRegion],
        update_type: UpdateType,
        last_write_locations: Dict[MemoryRegion, CUID],
    ):
        self.synchronous_source_cu_id = cu_id
        self.asynchronous_source_cu_id = None
        self.sink_cu_id = sink_cu_id
        self.memory_regions = memory_regions
        self.variable_names = set()
        self.update_type = update_type
        self.last_write_locations = last_write_locations
        self.dependencies = set()

        # check if an asynchronous update is possible
        import sys

        print("ORIGINAL SOURCE: ", self.synchronous_source_cu_id, file=sys.stderr)
        self.asynchronous_possible = True
        asynchronous_source: Optional[CUID] = None
        for mem_reg in self.memory_regions:
            if self.last_write_locations[mem_reg] == self.synchronous_source_cu_id:
                self.asynchronous_possible = False
                break
            if asynchronous_source is None:
                asynchronous_source = self.last_write_locations[mem_reg]
            if asynchronous_source != self.last_write_locations[mem_reg]:
                self.asynchronous_possible = False
                break

        if self.asynchronous_possible:
            # update the asynchronous source cu
            self.asynchronous_source_cu_id = cast(CUID, asynchronous_source)
            print("UPDATED SOURCE: ", self.synchronous_source_cu_id, file=sys.stderr)
            # create a dependency to ensure correctness
            self.dependencies.add(
                Dependency(
                    self.asynchronous_source_cu_id,
                    self.sink_cu_id,
                    self.variable_names,
                    self.memory_regions,
                )
            )

    def __str__(self):
        result_str = ""
        result_str += (
            str(self.update_type)
            + " @ "
            + self.synchronous_source_cu_id
            + " -> "
            + self.sink_cu_id
            + " : "
            + str(self.variable_names)
            + "/"
            + str(self.memory_regions)
            + " last_writes@ "
            + str(self.last_write_locations)
            + " async "
            if self.asynchronous_possible
            else ""
        )
        return result_str

    def get_as_metadata_using_memory_regions(self, pet: PETGraphX):
        return [
            self.synchronous_source_cu_id,
            self.sink_cu_id,
            self.update_type,
            str(self.memory_regions),
            pet.node_at(self.synchronous_source_cu_id).end_position(),
        ]

    def get_as_metadata_using_variable_names(self, pet: PETGraphX):
        return [
            self.synchronous_source_cu_id,
            self.sink_cu_id,
            self.update_type,
            str(self.variable_names),
            pet.node_at(self.synchronous_source_cu_id).end_position(),
        ]

    def get_as_metadata_using_variable_names_and_memory_regions(self, pet: PETGraphX):
        return [
            self.synchronous_source_cu_id,
            self.sink_cu_id,
            self.update_type,
            str(self.variable_names) + "/" + str(self.memory_regions),
            pet.node_at(self.synchronous_source_cu_id).end_position(),
        ]

    def convert_memory_regions_to_variable_names(
        self,
        pet: PETGraphX,
        memory_regions_to_functions_and_variables: Dict[MemoryRegion, Dict[CUID, Set[VarName]]],
    ):
        self.variable_names = set()
        parent_function_id = cast(
            CUID, pet.get_parent_function(pet.node_at(self.synchronous_source_cu_id)).id
        )
        for mem_reg in self.memory_regions:
            if parent_function_id in memory_regions_to_functions_and_variables[mem_reg]:
                self.variable_names.update(
                    memory_regions_to_functions_and_variables[mem_reg][parent_function_id]
                )
            elif (
                self.synchronous_source_cu_id in memory_regions_to_functions_and_variables[mem_reg]
            ):
                self.variable_names.update(
                    memory_regions_to_functions_and_variables[mem_reg][
                        self.synchronous_source_cu_id
                    ]
                )
            elif self.sink_cu_id in memory_regions_to_functions_and_variables[mem_reg]:
                self.variable_names.update(
                    memory_regions_to_functions_and_variables[mem_reg][self.sink_cu_id]
                )
            else:
                self.variable_names.add(VarName("UNDETERMINED(" + mem_reg + ")"))
