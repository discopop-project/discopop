# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

from typing import Dict, List, Set, Tuple, cast

from discopop_explorer.PETGraphX import PETGraphX, NodeType, EdgeType, CUNode
from discopop_explorer.pattern_detectors.combined_gpu_patterns.classes.Aliases import (
    CUID,
    VarName,
    MemoryRegion,
)
from discopop_explorer.pattern_detectors.combined_gpu_patterns.classes.Enums import UpdateType
from discopop_explorer.pattern_detectors.combined_gpu_patterns.utilities import (
    get_function_body_cus_without_called_functions,
)


def populate_live_data(
    comb_gpu_reg, pet: PETGraphX, ignore_update_instructions=False
) -> Dict[VarName, List[CUID]]:
    """calculate List of cu-id's in the combined region for each variable in which the respective data is live.
    The gathered information is used for the optimization / creation of data mapping instructions afterwards."""
    liveness: Dict[VarName, List[CUID]] = dict()

    # populate liveness sets based on gpu loops
    for region in comb_gpu_reg.contained_regions:
        for gpu_loop in region.contained_loops:
            live_in_loop = (
                gpu_loop.map_type_to
                + gpu_loop.map_type_tofrom
                + gpu_loop.map_type_alloc
                + [v.name for v in gpu_loop.reduction_vars_ids]
            )
            # set liveness within loop
            subtree = pet.subtree_of_type(pet.node_at(gpu_loop.node_id), NodeType.CU)
            for var in live_in_loop:
                if var not in liveness:
                    liveness[var] = []
                for cu in subtree:
                    liveness[var].append(CUID(cu.id))

    if not ignore_update_instructions:
        # populate liveness sets based on update instructions
        for source_id, sink_id, update_type, var, meta_line_num in comb_gpu_reg.update_instructions:
            if var not in liveness:
                liveness[var] = []
            if update_type == UpdateType.TO_DEVICE:
                liveness[var].append(sink_id)
            elif update_type == UpdateType.FROM_DEVICE:
                liveness[var].append(source_id)
            else:
                raise ValueError("Unsupported Update type: ", update_type)

    return liveness


def add_memory_regions_to_device_liveness(
    device_liveness: Dict[VarName, List[CUID]],
    cu_and_variable_to_memory_regions: Dict[CUID, Dict[VarName, Set[MemoryRegion]]],
) -> Dict[VarName, List[Tuple[CUID, Set[MemoryRegion]]]]:
    extended_device_liveness: Dict[VarName, List[Tuple[CUID, Set[MemoryRegion]]]] = dict()

    for var_name in device_liveness:
        if var_name not in extended_device_liveness:
            extended_device_liveness[var_name] = []
        for cu_id in device_liveness[var_name]:
            memory_regions: Set[MemoryRegion] = set()
            if cu_id in cu_and_variable_to_memory_regions:
                if var_name in cu_and_variable_to_memory_regions[cu_id]:
                    memory_regions.update(cu_and_variable_to_memory_regions[cu_id][var_name])
            extended_device_liveness[var_name].append((cu_id, memory_regions))

    return extended_device_liveness


def propagate_memory_regions(
    device_liveness_plus_memory_regions: Dict[VarName, List[Tuple[CUID, Set[MemoryRegion]]]]
) -> Dict[VarName, List[Tuple[CUID, Set[MemoryRegion]]]]:
    """Propagate memory regions for variables"""
    result_dict: Dict[VarName, List[Tuple[CUID, Set[MemoryRegion]]]] = dict()
    for var_name in device_liveness_plus_memory_regions:
        cu_ids: List[CUID] = []
        memory_regions: Set[MemoryRegion] = set()
        for cu_id, mem_regs in device_liveness_plus_memory_regions[var_name]:
            cu_ids.append(cu_id)
            memory_regions.update(mem_regs)

        if var_name not in result_dict:
            result_dict[var_name] = []
        for cu_id in cu_ids:
            result_dict[var_name].append((cu_id, memory_regions))

    return result_dict


def convert_liveness(
    device_liveness_plus_memory_regions: Dict[VarName, List[Tuple[CUID, Set[MemoryRegion]]]]
) -> Dict[MemoryRegion, List[CUID]]:
    result_dict: Dict[MemoryRegion, List[CUID]] = dict()

    for var_name in device_liveness_plus_memory_regions:
        for cu_id, mem_regions in device_liveness_plus_memory_regions[var_name]:
            for mem_reg in mem_regions:
                if mem_reg not in result_dict:
                    result_dict[mem_reg] = []
                result_dict[mem_reg].append(cu_id)
    return result_dict


def extend_data_lifespan(
    pet: PETGraphX, live_data: Dict[MemoryRegion, List[CUID]]
) -> Dict[MemoryRegion, List[CUID]]:
    """Extends the lifespan of the data on the device to allow as little data movement as possible."""
    modification_found = True
    while modification_found:
        modification_found = False
        new_entries: List[Tuple[MemoryRegion, CUID]] = []

        for mem_reg in live_data:
            for cu_id in live_data[mem_reg]:
                # check if data is live in any successor
                # If so, set mem_reg to live in each of the encountered CUs.
                for potential_successor_cu_id in live_data[mem_reg]:
                    if cu_id == potential_successor_cu_id:
                        continue
                    reachable, path_nodes = pet.check_reachability_and_get_path_nodes(
                        pet.node_at(potential_successor_cu_id),
                        pet.node_at(cu_id),
                        [EdgeType.SUCCESSOR, EdgeType.CHILD],
                    )
                    if reachable:
                        # if path_node is located within a loop, add the other loop cus to the path as well
                        to_be_added: List[CUNode] = []
                        for path_node in path_nodes:
                            parent_node = [
                                pet.node_at(s)
                                for s, t, d in pet.in_edges(path_node.id, EdgeType.CHILD)
                            ][0]
                            if parent_node.type == NodeType.LOOP:
                                for _, loop_cu_id, _ in pet.out_edges(
                                    parent_node.id, EdgeType.CHILD
                                ):
                                    loop_cu = pet.node_at(loop_cu_id)
                                    if loop_cu not in path_nodes and loop_cu not in to_be_added:
                                        to_be_added.append(loop_cu)
                        for loop_cu in to_be_added:
                            path_nodes.append(loop_cu)

                        # mark mem_reg live in all path_nodes and their children
                        for path_node in path_nodes:
                            # todo replace with subtree calculation after merging with refactoring changes
                            # calculate subtree without including called functions
                            subtree_without_called_functions = [
                                cu
                                for cu in pet.direct_children(path_node)
                                if cu
                                not in [
                                    pet.node_at(t)
                                    for s, t, d in pet.out_edges(path_node.id, EdgeType.CALLSNODE)
                                ]
                            ]
                            # add path_node itself to the subtree
                            subtree_without_called_functions.append(path_node)
                            # todo end of section to be replaced
                            #  subtree = pet.subtree_of_type(path_node, NodeType.CU)  # subtree contains path_node
                            for subtree_node in subtree_without_called_functions:
                                if CUID(subtree_node.id) not in [
                                    cu_id for cu_id in live_data[mem_reg]
                                ]:
                                    new_entries.append((mem_reg, cast(CUID, subtree_node.id)))

                # set mem_reg to live in every child of CU
                for _, child_id, _ in pet.out_edges(cu_id, EdgeType.CHILD):
                    if CUID(child_id) not in live_data[mem_reg]:
                        new_entries.append((mem_reg, cast(CUID, child_id)))

                # set mem_reg to live in every called function of CU
                for _, called_node, _ in pet.out_edges(cu_id, EdgeType.CALLSNODE):
                    if CUID(called_node) not in live_data[mem_reg]:
                        new_entries.append((mem_reg, cast(CUID, called_node)))

        new_entries = list(set(new_entries))
        if len(new_entries) > 0:
            modification_found = True
        for mem_reg, new_cu_id in new_entries:
            live_data[mem_reg].append(new_cu_id)

    # remove duplicates
    for mem_reg in live_data:
        live_data[mem_reg] = list(set(live_data[mem_reg]))

    return live_data


def calculate_host_liveness(
    comb_gpu_reg,
    pet: PETGraphX,
) -> Dict[VarName, List[Tuple[CUID, Set[MemoryRegion]]]]:

    """
    Variable is live on host, if a dependency between the host cu or any of its children and any device cu for a given variable exists

    """

    host_liveness_lists: Dict[VarName, List[Tuple[CUID, Set[MemoryRegion]]]] = dict()

    all_function_cu_ids: Set[CUID] = set()
    for region in comb_gpu_reg.contained_regions:
        parent_function = pet.get_parent_function(pet.node_at(region.node_id))
        all_function_cu_ids.update(
            get_function_body_cus_without_called_functions(pet, parent_function)
        )

    all_function_host_cu_ids = [
        cu_id for cu_id in all_function_cu_ids if cu_id not in comb_gpu_reg.device_cu_ids
    ]

    for cu_id in all_function_host_cu_ids:
        shared_variables: Set[VarName] = set()
        shared_memory_regions: Set[MemoryRegion] = set()
        # get all data which is accessed by the cu_id and it's children and any device cu
        subtree = pet.subtree_of_type(pet.node_at(cu_id), NodeType.CU)
        for subtree_node_id in [n.id for n in subtree]:
            out_data_edges = pet.out_edges(subtree_node_id, EdgeType.DATA)
            in_data_edges = pet.in_edges(subtree_node_id, EdgeType.DATA)
            for _, target, dep in out_data_edges:
                if target in comb_gpu_reg.device_cu_ids:
                    if dep.var_name is not None:
                        shared_variables.add(VarName(cast(str, dep.var_name)))
                    if dep.aa_var_name is not None:
                        shared_memory_regions.add(MemoryRegion(cast(str, dep.aa_var_name)))

            for source, _, dep in in_data_edges:
                if source in comb_gpu_reg.device_cu_ids:
                    if dep.var_name is not None:
                        shared_variables.add(VarName(cast(str, dep.var_name)))
                    if dep.aa_var_name is not None:
                        shared_memory_regions.add(MemoryRegion(cast(str, dep.aa_var_name)))
        for var_name in shared_variables:
            if var_name not in host_liveness_lists:
                host_liveness_lists[var_name] = []
            host_liveness_lists[var_name].append((cu_id, shared_memory_regions))

    # convert sets to lists
    host_liveness: Dict[VarName, List[Tuple[CUID, Set[MemoryRegion]]]] = dict()
    for key in host_liveness_lists:
        host_liveness[key] = host_liveness_lists[key]
    return host_liveness
