# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
import sys
from typing import Dict, List, Set, Tuple, cast

import networkx as nx  # type: ignore

from discopop_explorer.PETGraphX import (
    PETGraphX,
    NodeType,
    EdgeType,
    CUNode,
    NodeID,
    Node,
    MemoryRegion,
    Dependency,
)
from discopop_explorer.pattern_detectors.combined_gpu_patterns.classes.Aliases import (
    VarName,
)
from discopop_explorer.pattern_detectors.combined_gpu_patterns.classes.Enums import UpdateType
from discopop_explorer.pattern_detectors.combined_gpu_patterns.utilities import (
    get_function_body_cus_without_called_functions,
)


def populate_live_data(
    comb_gpu_reg, pet: PETGraphX, ignore_update_instructions=False
) -> Dict[VarName, List[NodeID]]:
    """calculate List of cu-id's in the combined region for each variable in which the respective data is live.
    The gathered information is used for the optimization / creation of data mapping instructions afterwards."""
    liveness: Dict[VarName, List[NodeID]] = dict()

    # populate liveness sets based on gpu loops
    for region in comb_gpu_reg.contained_regions:
        for gpu_loop in region.contained_loops:
            live_in_loop = (
                [v.name for v in gpu_loop.map_type_to]
                + [v.name for v in gpu_loop.map_type_tofrom]
                + [v.name for v in gpu_loop.map_type_from]
                + [v.name for v in gpu_loop.map_type_alloc]
                + [v.name for v in gpu_loop.reduction_vars_ids]
            )
            # set liveness within loop
            subtree = pet.subtree_of_type(pet.node_at(gpu_loop.node_id), CUNode)
            for var in live_in_loop:
                if var not in liveness:
                    liveness[var] = []
                for cu in subtree:
                    liveness[var].append(cu.id)

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
    device_liveness: Dict[VarName, List[NodeID]],
    cu_and_variable_to_memory_regions: Dict[NodeID, Dict[VarName, Set[MemoryRegion]]],
) -> Dict[VarName, List[Tuple[NodeID, Set[MemoryRegion]]]]:
    extended_device_liveness: Dict[VarName, List[Tuple[NodeID, Set[MemoryRegion]]]] = dict()

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
    device_liveness_plus_memory_regions: Dict[VarName, List[Tuple[NodeID, Set[MemoryRegion]]]]
) -> Dict[VarName, List[Tuple[NodeID, Set[MemoryRegion]]]]:
    """Propagate memory regions for variables"""
    result_dict: Dict[VarName, List[Tuple[NodeID, Set[MemoryRegion]]]] = dict()
    for var_name in device_liveness_plus_memory_regions:
        cu_ids: List[NodeID] = []
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
    device_liveness_plus_memory_regions: Dict[VarName, List[Tuple[NodeID, Set[MemoryRegion]]]]
) -> Dict[MemoryRegion, List[NodeID]]:
    result_dict: Dict[MemoryRegion, List[NodeID]] = dict()

    for var_name in device_liveness_plus_memory_regions:
        for cu_id, mem_regions in device_liveness_plus_memory_regions[var_name]:
            for mem_reg in mem_regions:
                if mem_reg not in result_dict:
                    result_dict[mem_reg] = []
                result_dict[mem_reg].append(cu_id)
    return result_dict


def extend_data_lifespan(
    pet: PETGraphX, live_data: Dict[MemoryRegion, List[NodeID]]
) -> Dict[MemoryRegion, List[NodeID]]:
    """Extends the lifespan of the data on the device to allow as little data movement as possible."""
    print("Extending data lifespan...", file=sys.stderr)
    # create graph copy and remove all but successor edges
    copied_graph = pet.g.copy()

    # remove all but successor edges
    to_be_removed = set()
    for edge in copied_graph.edges:
        edge_data = cast(Dependency, copied_graph.edges[edge]["data"])
        if edge_data.etype != EdgeType.SUCCESSOR:
            to_be_removed.add(edge)
    for edge in to_be_removed:
        copied_graph.remove_edge(edge[0], edge[1])

    for idx, mem_reg in enumerate(live_data):
        print("EXTENDING mem_reg ", idx, "/", len(live_data), file=sys.stderr)
        modification_found = True
        cycles = 0
        while modification_found:
            print("\t", "len: ", len(live_data[mem_reg]), file=sys.stderr)
            cycles += 1
            modification_found = False
            new_entries: List[Tuple[MemoryRegion, NodeID]] = []

            path_node_ids: Set[NodeID] = set()
            path_nodes: Set[CUNode] = set()

            for cu_id in live_data[mem_reg]:
                parent_function = pet.get_parent_function(pet.node_at(cu_id))
                # check if data is live in any successor
                # If so, set mem_reg to live in each of the encountered CUs.

                for potential_successor_cu_id in live_data[mem_reg]:
                    if cu_id == potential_successor_cu_id:
                        continue

                    if cu_id in parent_function.reachability_pairs:

                        reachable = (
                            potential_successor_cu_id in parent_function.reachability_pairs[cu_id]
                        )
                    else:
                        reachable = False

                    if reachable:
                        # get nodes of path from source to target
                        for path in nx.all_simple_paths(
                            copied_graph, source=cu_id, target=potential_successor_cu_id
                        ):
                            path_node_ids.update(path)

                # set mem_reg to live in every child of CU
                for _, child_id, _ in pet.out_edges(cu_id, EdgeType.CHILD):
                    if child_id not in live_data[mem_reg]:
                        new_entries.append((mem_reg, child_id))

                # set mem_reg to live in every called function of CU
                for _, called_node, _ in pet.out_edges(cu_id, EdgeType.CALLSNODE):
                    if called_node not in live_data[mem_reg]:
                        new_entries.append((mem_reg, called_node))

            path_nodes.update([cast(CUNode, pet.node_at(nid)) for nid in path_node_ids])

            # if path_node is located within a loop, add the other loop cus to the path as well
            to_be_added: List[CUNode] = []
            for path_node in path_nodes:
                parent_node = [
                    pet.node_at(s) for s, t, d in pet.in_edges(path_node.id, EdgeType.CHILD)
                ][0]
                if parent_node.type == NodeType.LOOP:
                    for _, loop_cu_id, _ in pet.out_edges(parent_node.id, EdgeType.CHILD):
                        loop_cu = cast(CUNode, pet.node_at(loop_cu_id))
                        if loop_cu not in path_nodes and loop_cu not in to_be_added:
                            to_be_added.append(loop_cu)
            for loop_cu in to_be_added:
                path_nodes.add(loop_cu)

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
                    if subtree_node.id not in [cu_id for cu_id in live_data[mem_reg]]:
                        new_entries.append((mem_reg, subtree_node.id))

            new_entries = list(set(new_entries))
            if len(new_entries) > 0:
                modification_found = True
            for mem_reg, new_cu_id in new_entries:
                live_data[mem_reg].append(new_cu_id)

        print("\tCycles: ", cycles, file=sys.stderr)

    # remove duplicates
    for mem_reg in live_data:
        live_data[mem_reg] = list(set(live_data[mem_reg]))

    print("\tDone.", file=sys.stderr)
    return live_data


def calculate_host_liveness(
    comb_gpu_reg,
    pet: PETGraphX,
) -> Dict[VarName, List[Tuple[NodeID, Set[MemoryRegion]]]]:

    """
    Variable is live on host, if a dependency between the host cu or any of its children and any device cu for a given variable exists

    """

    host_liveness_lists: Dict[VarName, List[Tuple[NodeID, Set[MemoryRegion]]]] = dict()

    all_function_cu_ids: Set[NodeID] = set()
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
        subtree = pet.subtree_of_type(pet.node_at(cu_id), CUNode)
        for subtree_node_id in [n.id for n in subtree]:
            out_data_edges = pet.out_edges(subtree_node_id, EdgeType.DATA)
            in_data_edges = pet.in_edges(subtree_node_id, EdgeType.DATA)
            for _, target, dep in out_data_edges:
                if target in comb_gpu_reg.device_cu_ids:
                    if dep.var_name is not None:
                        shared_variables.add(VarName(cast(str, dep.var_name)))
                    if dep.memory_region is not None:
                        shared_memory_regions.add(MemoryRegion(cast(str, dep.memory_region)))

            for source, _, dep in in_data_edges:
                if source in comb_gpu_reg.device_cu_ids:
                    if dep.var_name is not None:
                        shared_variables.add(VarName(cast(str, dep.var_name)))
                    if dep.memory_region is not None:
                        shared_memory_regions.add(MemoryRegion(cast(str, dep.memory_region)))
        for var_name in shared_variables:
            if var_name not in host_liveness_lists:
                host_liveness_lists[var_name] = []
            host_liveness_lists[var_name].append((cu_id, shared_memory_regions))

    # convert sets to lists
    host_liveness: Dict[VarName, List[Tuple[NodeID, Set[MemoryRegion]]]] = dict()
    for key in host_liveness_lists:
        host_liveness[key] = host_liveness_lists[key]
    return host_liveness
