from typing import Dict, Set, Tuple, Optional, List, cast

from discopop_explorer.PETGraphX import PETGraphX, EdgeType, NodeType
from discopop_explorer.pattern_detectors.combined_gpu_patterns.classes.Aliases import (
    MemoryRegion,
    CUID,
)
import sys


class Context(object):
    device_id: int
    seen_writes: Dict[MemoryRegion, Set[Optional[int]]]

    def __init__(self, device_id: int):
        self.device_id = device_id
        self.seen_writes = dict()
        self.print()

    def __str__(self):
        result_str = ""
        result_str += "Context:\n"
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
            device_id = 1 if entry_point in comb_gpu_reg.device_cu_ids else 0
            context = Context(device_id)

            try:
                entry_point_writes = (device_writes if device_id == 1 else host_writes)[entry_point]
            except KeyError:
                entry_point_writes = dict()

            context.update_writes(entry_point_writes)
            context.print()

            # follow successor path

            # identify context switches

            # determine update points using lookahead at path splits
