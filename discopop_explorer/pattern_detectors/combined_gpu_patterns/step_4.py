# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import copy
from typing import Dict, Set, Tuple, Optional, List, cast

import networkx as nx  # type: ignore

from discopop_explorer.PETGraphX import (
    PETGraphX,
    EdgeType,
    NodeType,
    NodeID,
    MemoryRegion,
    CUNode,
    Dependency,
    FunctionNode,
)
import sys

from discopop_explorer.pattern_detectors.combined_gpu_patterns.classes.Enums import UpdateType
from discopop_explorer.pattern_detectors.combined_gpu_patterns.classes.Update import Update


class Context(object):
    cu_id: NodeID
    device_id: int
    seen_writes_by_device: Dict[
        int, Dict[MemoryRegion, Set[Tuple[Optional[int], Optional[NodeID]]]]
    ]

    def __init__(self, cu_id: NodeID, device_id: int):
        self.cu_id = cu_id
        self.device_id = device_id
        self.seen_writes_by_device = dict()
        self.print()

    def __str__(self):
        result_str = ""
        result_str += "Context:\n"
        result_str += "\tcu_id: " + str(self.cu_id) + "\n"
        result_str += "\tdevice: " + str(self.device_id) + "\n"
        result_str += "\twrites:\n"
        for device_id in self.seen_writes_by_device:
            result_str += "\t\tDEVICE: " + str(device_id) + "\n"
            for mem_reg in self.seen_writes_by_device[device_id]:
                result_str += "\t\t\t" + mem_reg + ": "
                for ident in self.seen_writes_by_device[device_id][mem_reg]:
                    result_str += str(ident) + ", "
                result_str += "\n"
            result_str += "\n"
        return result_str

    def print(self):
        print(self, file=sys.stderr)

    def update_writes(
        self,
        device_id_to_update: int,
        writes: Dict[MemoryRegion, Set[Optional[int]]],
        origin_cu_id: NodeID,
    ) -> Set[Tuple[MemoryRegion, bool]]:
        """Returns the updated memory regions"""
        updated_memory_regions: Set[Tuple[MemoryRegion, bool]] = set()

        if device_id_to_update not in self.seen_writes_by_device:
            self.seen_writes_by_device[device_id_to_update] = dict()
        for mem_reg in writes:
            is_initialization = (
                True
                if (mem_reg not in self.seen_writes_by_device[device_id_to_update])
                and (mem_reg not in self.seen_writes_by_device[self.device_id])
                else False
            )
            if mem_reg not in self.seen_writes_by_device[device_id_to_update]:
                self.seen_writes_by_device[device_id_to_update][mem_reg] = set()
                print("==> added ", mem_reg, " to device: ", device_id_to_update, file=sys.stderr)
            for ident in writes[mem_reg]:
                if ident not in [
                    t[0] for t in self.seen_writes_by_device[device_id_to_update][mem_reg]
                ]:
                    # list of seen writes will be updated
                    updated_memory_regions.add((mem_reg, is_initialization))
                    print(
                        "--> adding memreg: ",
                        mem_reg,
                        " ident: ",
                        ident,
                        " initialization? ",
                        is_initialization,
                        file=sys.stderr,
                    )
                print("ADD : ", (ident, origin_cu_id), file=sys.stderr)
                # todo: do not simply add, but replace current entry with origin_cu_id if it is a successor of the current entry
                #  necessary, since relying on set behavior is not sufficient anymore
                if ident not in [
                    t[0] for t in self.seen_writes_by_device[device_id_to_update][mem_reg]
                ]:
                    self.seen_writes_by_device[device_id_to_update][mem_reg].add(
                        (ident, origin_cu_id)
                    )
        return updated_memory_regions

    def find_required_updates(
        self, pet: PETGraphX, new_device_id: int
    ) -> Set[Tuple[MemoryRegion, int, int, NodeID]]:
        # update required, if seen writes of new device is not a superset of old device id
        required_updates: Set[Tuple[MemoryRegion, int, int, NodeID]] = set()

        # check if unsynchronized changes exist
        device_id_1 = self.device_id
        device_id_2 = new_device_id

        overlapping_mem_reg = [
            mem_reg
            for mem_reg in self.seen_writes_by_device[device_id_1]
            if mem_reg in self.seen_writes_by_device[device_id_2]
        ]
        for mem_reg in overlapping_mem_reg:
            # issue update, if writes of new device is not a superset of old device
            missing_write_identifiers = [
                (ident, origin)
                for (ident, origin) in self.seen_writes_by_device[device_id_1][mem_reg]
                if ident not in [t[0] for t in self.seen_writes_by_device[device_id_2][mem_reg]]
                and ident is not None
            ]
            if len(missing_write_identifiers) > 0:
                # get position of the last write
                last_write_location: Optional[NodeID] = None
                for ident, origin in missing_write_identifiers:
                    if last_write_location is None:
                        last_write_location = origin
                    if pet.is_predecessor(cast(NodeID, last_write_location), cast(NodeID, origin)):
                        last_write_location = origin

                required_updates.add(
                    (mem_reg, device_id_1, device_id_2, cast(NodeID, last_write_location))
                )

        return required_updates

    def synchronize_states(self, new_device_id: int):
        overlapping_mem_reg = [
            mem_reg
            for mem_reg in self.seen_writes_by_device[self.device_id]
            if mem_reg in self.seen_writes_by_device[new_device_id]
        ]
        for mem_reg in overlapping_mem_reg:
            # synchronize from old to new device
            for mem_reg in overlapping_mem_reg:
                # issue update, if writes of new device is not a superset of old device
                for ident, origin in self.seen_writes_by_device[self.device_id][mem_reg]:
                    if ident not in [
                        t[0] for t in self.seen_writes_by_device[new_device_id][mem_reg]
                    ]:
                        print("SYNCHRONIZED: ", mem_reg, (ident, origin), file=sys.stderr)
                    self.seen_writes_by_device[new_device_id][mem_reg].add((ident, origin))

    def request_updates_from_other_devices(
        self, pet, new_device_id: int
    ) -> Set[Tuple[MemoryRegion, int, int, NodeID]]:
        required_updates: Set[Tuple[MemoryRegion, int, int, NodeID]] = set()
        to_be_removed = set()
        for mem_reg in self.seen_writes_by_device[new_device_id]:
            # check if updates on other devices exist
            for other_device_id in self.seen_writes_by_device:
                if other_device_id == new_device_id:
                    continue
                if mem_reg not in self.seen_writes_by_device[other_device_id]:
                    continue
                # update exist, if entries for new_device_id are not a superset of other_device_id
                missing_identifiers = [
                    (ident, origin)
                    for (ident, origin) in self.seen_writes_by_device[other_device_id][mem_reg]
                    if ident
                    not in [t[0] for t in self.seen_writes_by_device[new_device_id][mem_reg]]
                ]
                if len(missing_identifiers) > 0:
                    # get position of the last write
                    last_write_location: Optional[NodeID] = None
                    for ident, origin in missing_identifiers:
                        if last_write_location is None:
                            last_write_location = origin
                        if pet.is_predecessor(
                            cast(NodeID, last_write_location), cast(NodeID, origin)
                        ):
                            last_write_location = origin

                    required_updates.add(
                        (mem_reg, other_device_id, new_device_id, cast(NodeID, last_write_location))
                    )

                # remove none identifier
                for ident, origin in self.seen_writes_by_device[new_device_id][mem_reg]:
                    if ident is None:
                        to_be_removed.add((new_device_id, mem_reg, (ident, origin)))

        # update seen writes according to required updates
        for mem_reg, other_device_id, new_device_id, last_write_location in required_updates:
            missing_identifiers = [
                (ident, origin)
                for (ident, origin) in self.seen_writes_by_device[other_device_id][mem_reg]
                if ident not in [t[0] for t in self.seen_writes_by_device[new_device_id][mem_reg]]
            ]

            print("ADDING: ", missing_identifiers, " TO ", mem_reg, file=sys.stderr)

            self.seen_writes_by_device[new_device_id][mem_reg].update(missing_identifiers)

        for entry in to_be_removed:
            if entry[2] in self.seen_writes_by_device[entry[0]][entry[1]]:
                self.seen_writes_by_device[entry[0]][entry[1]].remove(entry[2])
        return required_updates

    def update_to(
        self,
        pet: PETGraphX,
        next_cu_id: NodeID,
        comb_gpu_reg,
        writes_by_device: Dict[int, Dict[NodeID, Dict[MemoryRegion, Set[Optional[int]]]]],
    ) -> Set[Update]:
        print("UPDATE TO: ", next_cu_id, file=sys.stderr)

        required_updates: Set[Update] = set()
        # cuid is always the CUID currently saved in the context

        # calculate device id of new cu
        new_device_id = get_device_id(comb_gpu_reg, next_cu_id)

        # check for device switch
        device_switch_occurred = True if new_device_id != self.device_id else False

        # apply updates to written memory regions
        writes_for_update = dict()
        if next_cu_id in writes_by_device[new_device_id]:
            writes_for_update = writes_by_device[new_device_id][next_cu_id]
        self_updated_memory_regions = self.update_writes(
            new_device_id, writes_for_update, next_cu_id
        )
        print("UPDATED MEMORY REGIONS: ", self_updated_memory_regions, file=sys.stderr)

        # identify required updates
        updated_memory_regions = self.find_required_updates(pet, new_device_id)

        # synchronize states between old and new device
        self.synchronize_states(new_device_id)

        # check if update has to be requested from other device due to a read (identifier: None)
        requested_updates = self.request_updates_from_other_devices(pet, new_device_id)

        # report data movement
        for mem_reg, from_device, to_device, last_write_to_mem_reg in updated_memory_regions:
            update_direction = get_update_type(from_device, to_device)
            print(
                "REPORTED! ",
                update_direction,
                " -> ",
                str(mem_reg),
                from_device,
                "->",
                to_device,
                " last_write@",
                last_write_to_mem_reg,
                file=sys.stderr,
            )
            required_updates.add(
                Update(
                    self.cu_id,
                    next_cu_id,
                    {mem_reg},
                    update_direction,
                    {mem_reg: last_write_to_mem_reg},
                )
            )

        # report data movement
        for mem_reg, from_device, to_device, last_write_to_mem_reg in requested_updates:
            update_direction = get_update_type(from_device, to_device)
            print(
                "REQUESTED! ",
                update_direction,
                " -> ",
                str(mem_reg),
                from_device,
                "->",
                to_device,
                " last_write@",
                last_write_to_mem_reg,
                file=sys.stderr,
            )
            required_updates.add(
                Update(
                    self.cu_id,
                    next_cu_id,
                    {mem_reg},
                    update_direction,
                    {mem_reg: last_write_to_mem_reg},
                )
            )

        # update the context
        self.cu_id = next_cu_id
        self.device_id = new_device_id

        print("DONE: \n", file=sys.stderr)

        return required_updates


def get_device_id(comb_gpu_reg, cu_id: NodeID) -> int:
    if cu_id in comb_gpu_reg.device_cu_ids:
        return 1
    return 0


def __identify_merge_node(pet, successors: List[NodeID]) -> Optional[NodeID]:
    def check_validity_of_potential_merge_node(node_id: NodeID):
        # return True if the given node is a valid merge node.
        # return False otherwise.
        # do not allow return BB's as merge nodes, since this would be trivially true for every path split
        potential_merge_node = pet.node_at(node_id)
        if (
            "return" in str(potential_merge_node.basic_block_id)
            and potential_merge_node.end_position()
            == pet.get_parent_function(potential_merge_node).end_position()
        ):
            # do not consider return BB as merge node
            return False
        return True

    if len(successors) == 0:
        raise ValueError("Empty list of successors!")

    parent_function = pet.get_parent_function(pet.node_at(successors[0]))

    # copy graph since edges need to be removed
    copied_graph = pet.g.copy()

    exit_cu_ids = parent_function.get_exit_cu_ids(pet)

    # remove all but successor edges
    to_be_removed = set()
    for edge in copied_graph.edges:
        edge_data = cast(Dependency, copied_graph.edges[edge]["data"])
        if edge_data.etype != EdgeType.SUCCESSOR:
            to_be_removed.add(edge)
    for edge in to_be_removed:
        copied_graph.remove_edge(edge[0], edge[1])

    # reverse edges
    immediate_post_dominators: Set[Tuple[NodeID, NodeID]] = set()
    for exit_cu_id in exit_cu_ids:
        immediate_post_dominators.update(
            nx.immediate_dominators(copied_graph.reverse(), exit_cu_id).items()
        )

    immediate_post_dominators_dict = dict(immediate_post_dominators)

    # find post dominator outside parent, if type(parent) != function
    post_dominators = dict()
    for node_id in parent_function.children_cu_ids:
        if type(pet.node_at(node_id)) != CUNode:
            continue
        # initialize search with immediate post dominator
        if node_id not in immediate_post_dominators_dict:
            immediate_post_dominators_dict[node_id] = node_id
        post_dom_id = immediate_post_dominators_dict[node_id]
        while (
            pet.node_at(node_id).get_parent_id(pet) == pet.node_at(post_dom_id).get_parent_id(pet)
            and type(pet.node_at(pet.node_at(post_dom_id).get_parent_id(pet))) != FunctionNode
        ):
            new_post_dom_id = immediate_post_dominators_dict[post_dom_id]
            if post_dom_id == new_post_dom_id:
                break
            post_dom_id = new_post_dom_id
        # found post dom
        post_dominators[node_id] = post_dom_id

    # initialize lists of current post dominators
    current_post_dominators: List[NodeID] = [post_dominators[node_id] for node_id in successors]
    # initialize lists of visited post dominators for each node in "successors"
    visited_post_dominators: List[Set[NodeID]] = []
    for idx, cpd in enumerate(current_post_dominators):
        # add the node itself as well as it's first post dominator to visited nodes for the initialization
        visited_post_dominators.append({cpd, successors[idx]})

    if len(visited_post_dominators) == 0 and len(current_post_dominators) == 0:
        raise ValueError("No post dominators found!")

    # check for common post dominators
    while True:
        # check if a common post dominator exists
        common_post_dominators = visited_post_dominators[0]
        for idx, vpd_set in enumerate(visited_post_dominators):
            common_post_dominators.intersection_update(vpd_set)
            if len(common_post_dominators) == 0:
                break

        if len(common_post_dominators) > 0:
            # return identified merge node
            for potential_merge_node_id in common_post_dominators:
                if check_validity_of_potential_merge_node(potential_merge_node_id):
                    return potential_merge_node_id

        if len(current_post_dominators) == 0:
            # No merge node found and no node to be checked anymore. Exit the loop.
            break

        # if not, add current post dominators to the visited list and resolve each post dominator by one step
        # break if new post dominator is equal to the old (end of path reached)
        for idx, cpd in enumerate(current_post_dominators):
            visited_post_dominators[idx].add(cpd)
        new_post_dominators = []
        for cpd in current_post_dominators:
            tmp = post_dominators[cpd]
            if tmp == cpd:
                # end of path reached, do not add tmp to list of new post dominators
                continue
            # get the next post dominator
            new_post_dominators.append(tmp)
        # replace the list of current post dominators (~ frontier)
        current_post_dominators = new_post_dominators
    # no merge node found
    return None


def identify_updates(
    comb_gpu_reg,
    pet: PETGraphX,
    writes_by_device: Dict[int, Dict[NodeID, Dict[MemoryRegion, Set[Optional[int]]]]],
) -> Set[Update]:
    identified_updates: Set[Update] = set()
    # get parent functions
    parent_functions: Set[NodeID] = set()
    for region in comb_gpu_reg.contained_regions:
        parent_functions.add(cast(NodeID, pet.get_parent_function(pet.node_at(region.node_id)).id))

    for parent_function_id in parent_functions:

        print("IDENTIFY UPDATES FOR: ", pet.node_at(parent_function_id).name, file=sys.stderr)
        # determine entry points
        entry_points: List[NodeID] = []
        for function_child_id in [
            t for s, t, d in pet.out_edges(parent_function_id, EdgeType.CHILD)
        ]:
            in_successor_edges = pet.in_edges(function_child_id, EdgeType.SUCCESSOR)
            if len(in_successor_edges) == 0 and pet.node_at(function_child_id).type == NodeType.CU:
                entry_points.append(cast(NodeID, function_child_id))

        for entry_point in entry_points:
            print(
                "\tEntry point: ",
                entry_point,
                "@L.",
                pet.node_at(entry_point).start_line,
                file=sys.stderr,
            )

            # create a new context
            # todo add contexts support for multiple devices
            device_id = get_device_id(comb_gpu_reg, entry_point)
            context = Context(entry_point, device_id)

            try:
                entry_point_writes = writes_by_device[device_id][entry_point]
            except KeyError:
                entry_point_writes = dict()

            context.update_writes(device_id, entry_point_writes, entry_point)

            # start calculation of updates for entry_point
            identified_updates.update(
                __calculate_updates(
                    pet, comb_gpu_reg, context, entry_point, writes_by_device, set()
                )
            )

    return identified_updates


def get_update_type(from_device_id: int, to_device_id: int) -> UpdateType:
    if from_device_id == 0 and to_device_id != 0:
        return UpdateType.TO_DEVICE
    elif from_device_id != 0 and to_device_id == 0:
        return UpdateType.FROM_DEVICE
    raise ValueError(
        "Unsupported update type requested for device IDS: "
        + str(from_device_id)
        + " -> "
        + str(to_device_id)
    )


def __calculate_updates(
    pet: PETGraphX,
    comb_gpu_reg,
    context: Context,
    cur_node_id: NodeID,
    writes_by_device: Dict[int, Dict[NodeID, Dict[MemoryRegion, Set[Optional[int]]]]],
    visited_nodes: Set[NodeID],
) -> Set[Update]:
    # calculate and return updates between ctx.cu_id and its immediate successor cur_node
    identified_updates: Set[Update] = set()

    # pass on calculation
    end_reached = False
    while not end_reached:
        context.print()

        # todo: update context to current node and save required updates
        required_updates = context.update_to(pet, cur_node_id, comb_gpu_reg, writes_by_device)
        identified_updates.update(required_updates)

        # calculate successors of current node
        successors = [cast(NodeID, t) for s, t, d in pet.out_edges(cur_node_id, EdgeType.SUCCESSOR)]

        if len(successors) == 0:
            end_reached = True
            continue
        elif len(successors) == 1:
            # start calculation for successor of current node
            cur_node_id = successors[0]
            print("PROCEED TO ", cur_node_id, file=sys.stderr)
            continue
        else:
            # multiple successors exist

            # determine merge node if existing
            print("SUCCESSORS: ", successors)
            merge_node = __identify_merge_node(pet, successors)
            print("MERGE NODE: ", merge_node)

            # if merge node exists, skip branched section and treat it as a single node
            if merge_node is not None:
                cur_node_id = merge_node
                print("PROCEED TO MERGE NODE ", cur_node_id, file=sys.stderr)
                continue

            # if no merge node exists, start recursion calculation of updates for each branch
            if merge_node is None:
                # recursive calculation will stop at the end of the funciton body, thus return identified updates
                # without executing a new loop iteration
                for successor in successors:
                    if successor in visited_nodes:
                        # prevent endless cycles
                        continue
                    # enter recursion
                    print("ENTER RECURSION FOR: ", successor, file=sys.stderr)
                    tmp_visited_set = copy.deepcopy(visited_nodes)
                    tmp_visited_set.add(successor)

                    identified_updates.update(
                        __calculate_updates(
                            pet,
                            comb_gpu_reg,
                            copy.deepcopy(context),
                            successor,
                            writes_by_device,
                            tmp_visited_set,
                        )
                    )
                return identified_updates

    return identified_updates
