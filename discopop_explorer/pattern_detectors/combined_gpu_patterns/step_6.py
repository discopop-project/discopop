# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
import sys
from typing import Set, Tuple, Dict, List, cast

from discopop_explorer.PETGraphX import PETGraphX, EdgeType
from discopop_explorer.pattern_detectors.combined_gpu_patterns.classes.Aliases import (
    MemoryRegion,
    CUID,
    VarName,
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


def add_aliases(
    pet: PETGraphX,
    issued_updates: Set[Update],
    memory_regions_to_functions_and_variables: Dict[MemoryRegion, Dict[CUID, Set[VarName]]],
) -> Set[Update]:

    for update in issued_updates:
        source_parent_function_node = pet.get_parent_function(pet.node_at(update.source_cu_id))
        sink_parent_function_node = pet.get_parent_function(pet.node_at(update.sink_cu_id))
        if source_parent_function_node == sink_parent_function_node:
            # add alias information from function level
            modification_found = True
            while modification_found:
                modification_found = False
                # add missing variable names
                for mem_reg in update.memory_regions:
                    alias_var_names = memory_regions_to_functions_and_variables[mem_reg][
                        cast(CUID, source_parent_function_node.id)
                    ]
                    len_pre = len(update.variable_names)
                    update.variable_names.update(alias_var_names)
                    len_post = len(update.variable_names)
                    if len_pre != len_post:
                        modification_found = True

                # add missing memory regions
                for var_name in update.variable_names:
                    for mem_reg in memory_regions_to_functions_and_variables:
                        if (
                            cast(CUID, source_parent_function_node.id)
                            not in memory_regions_to_functions_and_variables[mem_reg]
                        ):
                            continue
                        potential_aliases = memory_regions_to_functions_and_variables[mem_reg][
                            cast(CUID, source_parent_function_node.id)
                        ]
                        if var_name in potential_aliases:
                            len_pre = len(update.memory_regions)
                            update.memory_regions.add(mem_reg)
                            len_post = len(update.memory_regions)
                            if len_pre != len_post:
                                modification_found = True

    return issued_updates


def identify_end_of_life_points(
    pet: PETGraphX,
    entry_points: Set[EntryPoint],
    exit_points: Set[ExitPoint],
    memory_region_liveness_by_device: Dict[int, Dict[MemoryRegion, List[CUID]]],
    memory_regions_to_functions_and_variables: Dict[MemoryRegion, Dict[CUID, Set[VarName]]],
) -> Set[ExitPoint]:
    eol_points: Set[Tuple[CUID, CUID, Tuple[MemoryRegion, ...]]] = set()

    print("Identifying end of live for variables...", file=sys.stderr)

    # get list of seen aliases:
    mem_reg_aliases: Dict[MemoryRegion, Set[MemoryRegion]] = dict()
    for entry_point in entry_points:
        for mem_reg in entry_point.memory_regions:
            if mem_reg not in mem_reg_aliases:
                mem_reg_aliases[mem_reg] = set()
            mem_reg_aliases[mem_reg].update(entry_point.memory_regions)
    for exit_point in exit_points:
        for mem_reg in exit_point.memory_regions:
            if mem_reg not in mem_reg_aliases:
                mem_reg_aliases[mem_reg] = set()
            mem_reg_aliases[mem_reg].update(exit_point.memory_regions)

    print("\tUsed Aliases: ", mem_reg_aliases, file=sys.stderr)

    # actual search for EOL
    for device_id in memory_region_liveness_by_device:
        if device_id == 0:
            # do not search for EOL on host
            continue
        for mem_reg in memory_region_liveness_by_device[device_id]:
            # check if mem_reg is live in all successors of all contained cu's
            for cu_id in memory_region_liveness_by_device[device_id][mem_reg]:
                for successor_node in pet.direct_successors(pet.node_at(cu_id)):
                    if (
                        successor_node.id
                        not in memory_region_liveness_by_device[device_id][mem_reg]
                    ):
                        # mem_reg is not live anymore. create an EOL point
                        if mem_reg in mem_reg_aliases:
                            eol_points.add(
                                (
                                    cu_id,
                                    cast(CUID, successor_node.id),
                                    tuple(mem_reg_aliases[mem_reg]),
                                )
                            )
                        else:
                            eol_points.add((cu_id, cast(CUID, successor_node.id), tuple([mem_reg])))

    # remove eols which are covered by known exit points
    for exit_point in exit_points:
        to_be_removed: Set[Tuple[CUID, CUID, Tuple[MemoryRegion, ...]]] = set()
        for eol in eol_points:
            # check if either exit_point is reachable from eol or vice versa.
            # in both cases, eol is covered by the exit_point and can be ignored
            if (
                (
                    pet.is_predecessor(exit_point.source_cu_id, eol[0])
                    and pet.is_predecessor(exit_point.sink_cu_id, eol[1])
                )
                or pet.is_predecessor(eol[0], exit_point.source_cu_id)
                and pet.is_predecessor(eol[1], exit_point.sink_cu_id)
            ):
                # check if memory regions overlap, i.e. if the exit_point covers eol
                if len([mem_reg for mem_reg in exit_point.memory_regions if mem_reg in eol[2]]) > 0:
                    # overlap exists, remove eol
                    to_be_removed.add(eol)

        for elem in to_be_removed:
            if elem in eol_points:
                eol_points.remove(elem)

    eol_exit_points: Set[ExitPoint] = set()
    for eol in eol_points:
        parent_function_node_id = cast(CUID, pet.get_parent_function(pet.node_at(eol[0])).id)
        var_names: Set[VarName] = set()
        for mem_reg in eol[2]:
            var_names.update(
                memory_regions_to_functions_and_variables[mem_reg][parent_function_node_id]
            )
        memory_regions = set(eol[2])
        eol_exit_points.add(
            ExitPoint(pet, var_names, memory_regions, eol[0], eol[1], ExitPointType.DELETE)
        )

    print("\tDone.", file=sys.stderr)
    print(file=sys.stderr)

    return eol_exit_points
