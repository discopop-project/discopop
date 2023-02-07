import copy
from typing import Dict, Set, Tuple, Optional, List, cast

from discopop_explorer.PETGraphX import PETGraphX, EdgeType, NodeType
from discopop_explorer.pattern_detectors.combined_gpu_patterns.classes.Aliases import (
    MemoryRegion,
    CUID,
)
import sys


class Context(object):
    cu_id: CUID
    device_id: int
    seen_writes: Dict[MemoryRegion, Set[Optional[int]]]

    def __init__(self, cu_id: CUID, device_id: int):
        self.cu_id = cu_id
        self.device_id = device_id
        self.seen_writes = dict()
        self.print()

    def __str__(self):
        result_str = ""
        result_str += "Context:\n"
        result_str += "\tcu_id: " + str(self.cu_id) + "\n"
        result_str += "\tdevice: " + str(self.device_id) + "\n"
        result_str += "\twrites:"
        for mem_reg in self.seen_writes:
            result_str += "\t\t" + mem_reg + ": "
            for ident in self.seen_writes[mem_reg]:
                result_str += str(ident) + ", "
            result_str += "\n"
        result_str += "\n"
        return result_str

    def print(self):
        print(file=sys.stderr)
        print(self, file=sys.stderr)
        print(file=sys.stderr)

    def update_writes(self, writes: Dict[MemoryRegion, Set[Optional[int]]]):
        for mem_reg in writes:
            if mem_reg not in self.seen_writes:
                self.seen_writes[mem_reg] = set()
            for ident in writes[mem_reg]:
                self.seen_writes[mem_reg].add(ident)


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
    device_writes: Dict[CUID, Dict[MemoryRegion, Set[Optional[int]]]],
    host_writes: Dict[CUID, Dict[MemoryRegion, Set[Optional[int]]]],
):
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
            # todo add multiple contexts for multiple devices
            device_id = get_device_id(comb_gpu_reg, entry_point)
            context = Context(entry_point, device_id)

            try:
                entry_point_writes = (device_writes if device_id == 1 else host_writes)[entry_point]
            except KeyError:
                entry_point_writes = dict()

            context.update_writes(entry_point_writes)

            # follow successor path
            end_reached = False
            successors = [
                cast(CUID, t) for s, t, d in pet.out_edges(context.cu_id, EdgeType.SUCCESSOR)
            ]
            visited: Set[CUID] = set()
            visited.add(context.cu_id)

            while not end_reached:
                context.print()

                if len(successors) == 0:
                    end_reached = True
                elif len(successors) == 1:
                    # todo: check for context switch
                    # todo: update context
                    # update successors
                    successors = [
                        cast(CUID, t)
                        for s, t, d in pet.out_edges(successors[0], EdgeType.SUCCESSOR)
                    ]
                else:
                    # multiple successors exist

                    # identify merge node
                    print("SPAWN FOR: ", successors, file=sys.stderr)
                    merge_node = __identify_merge_node(pet, successors)

                    # follow successor paths until merge node has been encountered

                    for successor_id in successors:
                        # if no context switch happens, do nothing
                        succ_device_id = get_device_id(comb_gpu_reg, successor_id)
                        if succ_device_id == context.device_id:
                            continue

                    end_reached = True

                # todo replace with more diversified approach
                # treat branched sections as a single element

            # identify context switches

            # determine update points using lookahead at path splits
