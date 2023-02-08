# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import copy
from typing import Dict, Set, Tuple, Optional, List, cast

from discopop_explorer.PETGraphX import PETGraphX, EdgeType, NodeType
from discopop_explorer.pattern_detectors.combined_gpu_patterns.classes.Aliases import (
    MemoryRegion,
    CUID,
)
import sys

from discopop_explorer.pattern_detectors.combined_gpu_patterns.classes.Enums import UpdateType
from discopop_explorer.pattern_detectors.combined_gpu_patterns.classes.Update import Update


class Context(object):
    cu_id: CUID
    device_id: int
    seen_writes_by_device: Dict[int, Dict[MemoryRegion, Set[Optional[int]]]]

    def __init__(self, cu_id: CUID, device_id: int):
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
        self, device_id_to_update: int, writes: Dict[MemoryRegion, Set[Optional[int]]]
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
                if ident not in self.seen_writes_by_device[device_id_to_update][mem_reg]:
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
                self.seen_writes_by_device[device_id_to_update][mem_reg].add(ident)
        return updated_memory_regions

    def find_required_updates(self, new_device_id: int) -> Set[Tuple[MemoryRegion, int, int]]:
        # update required, if seen writes of new device is not a superset of old device id
        required_updates: Set[Tuple[MemoryRegion, int, int]] = set()

        #        # check if new key needs to be added
        #        required_mem_regs = [
        #            mem_reg
        #            for mem_reg in self.seen_writes_by_device[self.device_id]
        #            if mem_reg not in self.seen_writes_by_device[new_device_id]
        #        ]
        #        for mem_reg in required_mem_regs:
        #            required_updates.add((mem_reg, False))

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
                wid
                for wid in self.seen_writes_by_device[device_id_1][mem_reg]
                if wid not in self.seen_writes_by_device[device_id_2][mem_reg] and wid is not None
            ]
            if len(missing_write_identifiers) > 0:
                required_updates.add((mem_reg, device_id_1, device_id_2))

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
                for write_identifier in self.seen_writes_by_device[self.device_id][mem_reg]:
                    if write_identifier not in self.seen_writes_by_device[new_device_id][mem_reg]:
                        print("SYNCHRONIZED: ", mem_reg, write_identifier, file=sys.stderr)
                    self.seen_writes_by_device[new_device_id][mem_reg].add(write_identifier)

    def request_updates_from_other_devices(
        self, new_device_id: int
    ) -> Set[Tuple[MemoryRegion, int, int]]:
        required_updates: Set[Tuple[MemoryRegion, int, int]] = set()
        to_be_removed = set()
        for mem_reg in self.seen_writes_by_device[new_device_id]:
            for write_identifier in self.seen_writes_by_device[new_device_id][mem_reg]:
                if write_identifier is None:
                    # check if updates on other devices exist
                    for other_device_id in self.seen_writes_by_device:
                        if other_device_id == new_device_id:
                            continue
                        if mem_reg not in self.seen_writes_by_device[other_device_id]:
                            continue
                        # update exist, if entries for new_device_id are not a superset of other_device_id
                        missing_identifiers = [
                            wid
                            for wid in self.seen_writes_by_device[other_device_id][mem_reg]
                            if wid not in self.seen_writes_by_device[new_device_id][mem_reg]
                        ]
                        if len(missing_identifiers) > 0:
                            required_updates.add((mem_reg, other_device_id, new_device_id))
                    # remove none identifier
                    to_be_removed.add((new_device_id, mem_reg, write_identifier))

        for entry in to_be_removed:
            if entry[2] in self.seen_writes_by_device[entry[0]][entry[1]]:
                self.seen_writes_by_device[entry[0]][entry[1]].remove(entry[2])
        return required_updates

    def update_to(
        self,
        next_cu_id: CUID,
        comb_gpu_reg,
        writes_by_device: Dict[int, Dict[CUID, Dict[MemoryRegion, Set[Optional[int]]]]],
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
        self_updated_memory_regions = self.update_writes(new_device_id, writes_for_update)
        print("UPDATED MEMORY REGIONS: ", self_updated_memory_regions, file=sys.stderr)

        # identify required updates
        updated_memory_regions = self.find_required_updates(new_device_id)

        # synchronize states between old and new device
        self.synchronize_states(new_device_id)

        # check if update has to be requested from other device due to a read (identifier: None)
        requested_updates = self.request_updates_from_other_devices(new_device_id)

        # remove None-identifier entries from lists of seen writes -> done in request_updates_from_other_devices
        # self.remove_none_identifiers()

        #        if not device_switch_occurred:
        #            # do not report the updated memory regions, as no update instructions need to be issued
        #            pass
        #        else:

        # report the identifed updates as a device switch has been performed

        # report data movement
        for mem_reg, from_device, to_device in updated_memory_regions:
            update_direction = get_update_type(from_device, to_device)
            print(
                "REPORTED! ",
                update_direction,
                " -> ",
                str(mem_reg),
                from_device,
                "->",
                to_device,
                file=sys.stderr,
            )
            required_updates.add(Update(self.cu_id, next_cu_id, {mem_reg}, update_direction))

        # report data movement
        for mem_reg, from_device, to_device in requested_updates:
            update_direction = get_update_type(from_device, to_device)
            print(
                "REQUESTED! ",
                update_direction,
                " -> ",
                str(mem_reg),
                from_device,
                "->",
                to_device,
                file=sys.stderr,
            )
            required_updates.add(Update(self.cu_id, next_cu_id, {mem_reg}, update_direction))

        # update the context
        self.cu_id = next_cu_id
        self.device_id = new_device_id

        print("DONE: \n", file=sys.stderr)

        return required_updates


def get_device_id(comb_gpu_reg, cu_id: CUID) -> int:
    if cu_id in comb_gpu_reg.device_cu_ids:
        return 1
    return 0


def __identify_merge_node(pet, successors: List[CUID]) -> Optional[CUID]:
    paths: List[List[CUID]] = []

    def construct_paths(current_node, current_path, visited):
        visited.append(current_node)
        # allow visiting a node twice to properly consider loops
        succs = [cast(CUID, t) for s, t, d in pet.out_edges(current_node, EdgeType.SUCCESSOR)]

        if len(succs) == 0:
            return [current_path]
        if len(succs) == 1:
            current_path.append(succs[0])
            if visited.count(succs[0]) < 2:
                return construct_paths(
                    succs[0], copy.deepcopy(current_path), copy.deepcopy(visited)
                )
            else:
                # loop has not been exited. Discard the path
                return []
        result_paths = []
        for succ in succs:
            if visited.count(succ) < 2:
                tmp_path = copy.deepcopy(current_path)
                tmp_path.append(succ)
                result_paths += construct_paths(succ, tmp_path, copy.deepcopy(visited))
            else:
                # loop has not been exited. Discard the path
                pass
        return result_paths

    for successor_id in successors:
        paths += construct_paths(successor_id, [successor_id], [])

    # identify first common node if existing
    # identify the shortest path
    shortest_path_id = 0
    for idx, path in enumerate(paths):
        if len(path) < len(paths[shortest_path_id]):
            shortest_path_id = idx
    # check elements of the shortest path
    for element in paths[shortest_path_id]:
        contained_in_all_paths = True
        for path in paths:
            if element not in path:
                contained_in_all_paths = False
                break
        if contained_in_all_paths:
            return element
    return None


def identify_updates(
    comb_gpu_reg,
    pet: PETGraphX,
    writes_by_device: Dict[int, Dict[CUID, Dict[MemoryRegion, Set[Optional[int]]]]],
) -> Set[Update]:
    identified_updates: Set[Update] = set()
    # get parent functions
    parent_functions: Set[CUID] = set()
    for region in comb_gpu_reg.contained_regions:
        parent_functions.add(cast(CUID, pet.get_parent_function(pet.node_at(region.node_id)).id))

    for parent_function_id in parent_functions:

        print("IDENTIFY UPDATES FOR: ", pet.node_at(parent_function_id).name, file=sys.stderr)
        # determine entry points
        entry_points: List[CUID] = []
        for function_child_id in [
            t for s, t, d in pet.out_edges(parent_function_id, EdgeType.CHILD)
        ]:
            in_successor_edges = pet.in_edges(function_child_id, EdgeType.SUCCESSOR)
            if len(in_successor_edges) == 0 and pet.node_at(function_child_id).type == NodeType.CU:
                entry_points.append(cast(CUID, function_child_id))

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

            context.update_writes(device_id, entry_point_writes)

            # start calculation of updates for entry_point
            identified_updates.update(
                __calculate_updates(pet, comb_gpu_reg, context, entry_point, writes_by_device)
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
    cur_node_id: CUID,
    writes_by_device: Dict[int, Dict[CUID, Dict[MemoryRegion, Set[Optional[int]]]]],
) -> Set[Update]:
    # calculate and return updates between ctx.cu_id and its immediate successor cur_node
    identified_updates: Set[Update] = set()

    # pass on calculation
    end_reached = False
    while not end_reached:
        context.print()

        # todo: update context to current node and save required updates
        required_updates = context.update_to(cur_node_id, comb_gpu_reg, writes_by_device)
        identified_updates.update(required_updates)

        # calculate successors of current node
        successors = [cast(CUID, t) for s, t, d in pet.out_edges(cur_node_id, EdgeType.SUCCESSOR)]

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
            merge_node = __identify_merge_node(pet, successors)

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
                    # enter recursion
                    print("ENTER RECURSION FOR: ", successor, file=sys.stderr)
                    identified_updates.update(
                        __calculate_updates(
                            pet, comb_gpu_reg, copy.deepcopy(context), successor, writes_by_device
                        )
                    )
                return identified_updates

    return identified_updates


#    else:
#        # identify merge node
#    print("SPAWN FOR: ", succs, file=sys.stderr)
#        merge_node = __identify_merge_node(pet, succs)
#        if merge_node is None:
#            # no merge node exists (e.g. caused by a return in a branch)
#            # todo implement
#            raise NotImplementedError(
#                "Currently unsupported program structure encountered. No merge node found in paths at CUID: " +
#                str(context.cu_id)
#            )
#        else:
#            # merge node exists
#
#            # follow successor paths until merge node has been encountered
#            # gather updates for branched section
#            gathered_updates = []
#            for succ_id in succs:
#                # if no context switch happens, do nothing
#                succ_device_id = get_device_id(comb_gpu_reg, succ_id)
#                if succ_device_id == context.device_id:
#                    continue
#
#            # apply updates to context
#
#            end_reached = True
#
#        # todo replace with more diversified approach
#        # treat each branch of a branched sections without merge node individually
#
#    return identified_updates
