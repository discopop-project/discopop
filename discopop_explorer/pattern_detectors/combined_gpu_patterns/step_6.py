# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

from typing import Set, Tuple, Dict, List

from discopop_explorer.PETGraphX import PETGraphX
from discopop_explorer.pattern_detectors.combined_gpu_patterns.classes.Aliases import (
    MemoryRegion,
    CUID,
)
from discopop_explorer.pattern_detectors.combined_gpu_patterns.classes.EntryPoint import EntryPoint
from discopop_explorer.pattern_detectors.combined_gpu_patterns.classes.Enums import (
    UpdateType,
    EntryPointType,
    ExitPointType,
)
from discopop_explorer.pattern_detectors.combined_gpu_patterns.classes.ExitPoint import ExitPoint
from discopop_explorer.pattern_detectors.combined_gpu_patterns.classes.Update import Update


def convert_updates_to_entry_and_exit_points(
    pet: PETGraphX,
    issued_updates: Set[Update],
    memory_region_liveness_by_device: Dict[int, Dict[MemoryRegion, List[CUID]]],
) -> Tuple[Set[EntryPoint], Set[ExitPoint], Set[Update]]:
    entry_points: Set[EntryPoint] = set()
    exit_points: Set[ExitPoint] = set()
    updates: Set[Update] = set()

    for issued_update in issued_updates:
        if (
            issued_update.update_type == UpdateType.TO_DEVICE
            or issued_update.update_type == UpdateType.ALLOCATE
        ):
            # check if the memory region was live on the device before the update
            qualifies_as_entry = True
            for mem_reg in issued_update.memory_regions:
                if issued_update.source_cu_id in memory_region_liveness_by_device[1][mem_reg]:
                    qualifies_as_entry = False
                    break
            if qualifies_as_entry:
                if issued_update.update_type == UpdateType.TO_DEVICE:
                    entry_points.add(
                        EntryPoint(
                            pet,
                            issued_update.variable_names,
                            issued_update.memory_regions,
                            issued_update.source_cu_id,
                            issued_update.sink_cu_id,
                            EntryPointType.TO_DEVICE,
                        )
                    )
                else:
                    entry_points.add(
                        EntryPoint(
                            pet,
                            issued_update.variable_names,
                            issued_update.memory_regions,
                            issued_update.source_cu_id,
                            issued_update.sink_cu_id,
                            EntryPointType.ALLOCATE,
                        )
                    )
            else:
                updates.add(issued_update)

        elif issued_update.update_type == UpdateType.FROM_DEVICE:
            # check if the memory region is live on the device after the update
            qualifies_as_exit = True
            for mem_reg in issued_update.memory_regions:
                if issued_update.sink_cu_id in memory_region_liveness_by_device[1][mem_reg]:
                    qualifies_as_exit = False
                    break
            if qualifies_as_exit:
                exit_points.add(
                    ExitPoint(
                        pet,
                        issued_update.variable_names,
                        issued_update.memory_regions,
                        issued_update.source_cu_id,
                        issued_update.sink_cu_id,
                        ExitPointType.FROM_DEVICE,
                    )
                )
            else:
                updates.add(issued_update)

        else:
            raise ValueError("Unsupported update type: ", issued_update.update_type)

    return entry_points, exit_points, updates
