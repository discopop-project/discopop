# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
import copy
from enum import IntEnum
from typing import List, Tuple, cast, Dict, Optional, Set, Any

from discopop_explorer.PETGraphX import EdgeType, CUNode, Dependency, PETGraphX, DepType, NodeType
from discopop_explorer.pattern_detectors.PatternInfo import PatternInfo

from discopop_explorer.pattern_detectors.simple_gpu_patterns.GPULoop import GPULoopPattern
from discopop_explorer.pattern_detectors.simple_gpu_patterns.GPURegions import GPURegionInfo

import sys


class UpdateType(IntEnum):
    TO_DEVICE = 0
    FROM_DEVICE = 1
    # TO_FROM should not occur ideally, since data should only be modified either on the host or the device for now
    TO_FROM_DEVICE = 2


class EntryPointType(IntEnum):
    TO_DEVICE = 0
    ALLOCATE = 1
    ASYNC_TO_DEVICE = 2
    ASYNC_ALLOCATE = 3


class ExitPointType(IntEnum):
    FROM_DEVICE = 0
    DELETE = 1
    ASYNC_FROM_DEVICE = 2


class ExitPointPositioning(IntEnum):
    BEFORE_CU = 0
    AFTER_CU = 1


class EntryPointPositioning(IntEnum):
    BEFORE_CU = 0
    AFTER_CU = 1

# Type alias definitions
MemoryRegion = str


class CombinedGPURegion(PatternInfo):
    contained_regions: List[GPURegionInfo]
    update_instructions: List[
        Tuple[str, str, UpdateType, str, str]
    ]  # (source_cu_id, sink_cu_id, UpdateType, target_vars, meta_line_num)
    target_data_regions: Dict[str, List[Tuple[List[str], str, str, str, str]]]
    # {var: ([contained cu_s], entry_cu, exit_after_cu, meta_entry_line_num, meta_exit_line_num)
    data_region_entry_points: List[
        Tuple[str, str, EntryPointType, str, EntryPointPositioning]
    ]  # [(var, cu_id, entry_point_type, meta_line_num)]
    data_region_exit_points: List[
        Tuple[str, str, ExitPointType, str, ExitPointPositioning]
    ]  # [(var, cu_id, exit_point_type, meta_line_num)]
    data_region_depend_in: List[
        Tuple[str, str, str, EntryPointPositioning]
    ]  # [(var, cu_id, meta_line_num)]
    data_region_depend_out: List[
        Tuple[str, str, str, ExitPointPositioning]
    ]  # [(var, cu_id, meta_line_num)]
    device_cu_ids: List[str]
    # meta information, mainly for display and overview purposes
    meta_device_lines: List[str]
    meta_host_lines: List[str]
    meta_device_liveness: Dict[str, List[str]]
    meta_host_liveness: Dict[str, List[str]]

    def __init__(self, pet: PETGraphX, contained_regions: List[GPURegionInfo]):
        node_id = sorted([region.node_id for region in contained_regions])[0]
        device_cu_ids = []
        for region in contained_regions:
            device_cu_ids += region.contained_cu_ids
            device_cu_ids = list(set(device_cu_ids))
        PatternInfo.__init__(self, pet.node_at(node_id))
        self.contained_regions = contained_regions
        self.device_cu_ids = device_cu_ids
        self.start_line = min([l.start_line for l in contained_regions])
        self.end_line = max([l.end_line for l in contained_regions])
        print("\n\n", file=sys.stderr)
        print("DEVICE CU IDS: ", file=sys.stderr)
        print(self.device_cu_ids, file=sys.stderr)
        entry_points: List[Tuple[str, str, EntryPointType, str, EntryPointPositioning]] = []
        exit_points: List[Tuple[str, str, ExitPointType, str, ExitPointPositioning]] = []

        # ### STEP 1: INITIALIZATION
        # get written and read memory regions by CU
        written_memory_regions_by_cu: Dict[str, Set[MemoryRegion]] = dict()
        read_memory_regions_by_cu: Dict[str, Set[MemoryRegion]] = dict()
        (
            written_memory_regions_by_cu,
            read_memory_regions_by_cu,
        ) = self.__get_written_and_read_memory_regions_by_cu(pet)
        print("Written memory regions:", file=sys.stderr)
        print(written_memory_regions_by_cu, file=sys.stderr)
        print(file=sys.stderr)
        print("Read memory regions:", file=sys.stderr)
        print(read_memory_regions_by_cu, file=sys.stderr)
        print(file=sys.stderr)

        # get memory region and variable associations for each CU
        cu_and_variable_to_memory_regions: Dict[
            str, Dict[str, Set[MemoryRegion]]
        ] = self.__get_memory_region_and_variable_associations(pet, written_memory_regions_by_cu)

        print("CU AND VARIABLE TO MEMORY REGIONS", file=sys.stderr)
        print(
            [
                (str(key), str(cu_and_variable_to_memory_regions[key]))
                for key in cu_and_variable_to_memory_regions
            ],
            file=sys.stderr,
        )
        print(file=sys.stderr)

        # get memory regions to cus and variables names
        memory_regions_to_cus_and_variables: Dict[
            MemoryRegion, Dict[str, Set[str]]
        ] = self.__get_memory_region_to_cu_and_variables_dict(cu_and_variable_to_memory_regions)

        print("MEMORY REGIONS TO CU AND VARIABLES", file=sys.stderr)
        print(memory_regions_to_cus_and_variables, file=sys.stderr)
        print(file=sys.stderr)

        print("STEP ONE FINISHED", file=sys.stderr)

        # ### STEP 2: INITIALIZE LIVE DATA USING MAPPING CLAUSES AND CONVERSION TO MEMORY REGIONS

        # ### STEP 3: CALCULATE LIVE DATA BY PROPAGATING MEMORY REGIONS AND EXTENDING LIFESPAN

        # ### STEP 4: IDENTIFY SYNCHRONOUS UPDATE POINTS

        # ### STEP 5: CONVERT MEMORY REGIONS IN UPDATES TO VARIABLE NAMES

    def __str__(self):
        raise NotImplementedError()  # used to identify necessity to call to_string() instead

    def to_string(self, pet: PETGraphX):
        contained_regions_str = "\n" if len(self.contained_regions) > 0 else ""
        for region in self.contained_regions:
            region_str = region.to_string(pet)
            # pretty printing
            region_str = "".join(["\t" + s + "\n" for s in region_str.split("\n")])
            contained_regions_str += region_str

        return (
            f"COMBINED GPU Region at: {self.node_id}\n"
            f"Start line: {self.start_line}\n"
            f"End line: {self.end_line}\n"
            f"Device CUs: {self.device_cu_ids}\n"
            f"Device lines: {self.meta_device_lines}\n"
            f"Host lines: {self.meta_host_lines}\n"
            f"Contained regions: {contained_regions_str}\n"
        )

    def __get_written_and_read_memory_regions_by_cu(
        self, pet: PETGraphX
    ) -> Tuple[Dict[str, Set[MemoryRegion]], Dict[str, Set[MemoryRegion]]]:
        all_function_cu_ids: Set[str] = set()
        for region in self.contained_regions:
            parent_function = pet.get_parent_function(pet.node_at(region.node_id))

            subtree = pet.subtree_of_type(parent_function, NodeType.CU)
            all_function_cu_ids.update([n.id for n in subtree])

        written_memory_regions_by_cu_id: Dict[str, Set[MemoryRegion]] = dict()
        read_memory_regions_by_cu_id: Dict[str, Set[MemoryRegion]] = dict()
        for cu_id in all_function_cu_ids:
            in_dep_edges = pet.in_edges(cu_id, EdgeType.DATA)
            out_dep_edges = pet.out_edges(cu_id, EdgeType.DATA)

            written_memory_regions = [
                MemoryRegion(cast(str, d.aa_var_name))
                for s, t, d in in_dep_edges
                if (d.dtype == DepType.RAW or d.dtype == DepType.WAW) and d.aa_var_name is not None
            ]
            written_memory_regions += [
                MemoryRegion(cast(str, d.aa_var_name))
                for s, t, d in out_dep_edges
                if (d.dtype == DepType.WAR or d.dtype == DepType.WAW) and d.aa_var_name is not None
            ]

            read_memory_regions = [
                MemoryRegion(cast(str, d.aa_var_name))
                for s, t, d in in_dep_edges
                if (d.dtype == DepType.WAR) and d.aa_var_name is not None
            ]
            read_memory_regions += [
                MemoryRegion(cast(str, d.aa_var_name))
                for s, t, d in out_dep_edges
                if (d.dtype == DepType.RAW) and d.aa_var_name is not None
            ]

            if cu_id not in written_memory_regions_by_cu_id:
                written_memory_regions_by_cu_id[cu_id] = set()
            written_memory_regions_by_cu_id[cu_id] = set(written_memory_regions)

            if cu_id not in read_memory_regions_by_cu_id:
                read_memory_regions_by_cu_id[cu_id] = set()
            read_memory_regions_by_cu_id[cu_id] = set(read_memory_regions)
        return written_memory_regions_by_cu_id, read_memory_regions_by_cu_id

    def __get_memory_region_and_variable_associations(
        self, pet: PETGraphX, written_memory_regions_by_cu: Dict[str, Set[MemoryRegion]]
    ) -> Dict[str, Dict[str, Set[MemoryRegion]]]:
        # dict -> {Cu_ID: {var_name: [memory regions]}}
        result_dict: Dict[str, Dict[str, Set[MemoryRegion]]] = dict()

        all_function_cu_ids: Set[str] = set()
        for region in self.contained_regions:
            parent_function = pet.get_parent_function(pet.node_at(region.node_id))

            subtree = pet.subtree_of_type(parent_function, NodeType.CU)
            all_function_cu_ids.update([n.id for n in subtree])

        for cu_id in all_function_cu_ids:
            if cu_id not in result_dict:
                result_dict[cu_id] = dict()

            # only out_deps considered, as in_deps might use variable names
            # which originate from different source code scopes
            out_dep_edges = pet.out_edges(cu_id, EdgeType.DATA)
            for _, _, dep in out_dep_edges:
                if dep.var_name is None or dep.aa_var_name is None:
                    continue
                if dep.var_name not in result_dict[cu_id]:
                    result_dict[cu_id][cast(str, dep.var_name)] = set()
                result_dict[cu_id][cast(str, dep.var_name)].add(
                    MemoryRegion(cast(str, dep.aa_var_name))
                )

        return result_dict

    def __get_memory_region_to_cu_and_variables_dict(
        self, cu_and_variable_to_memory_regions: Dict[str, Dict[str, Set[MemoryRegion]]]
    ) -> Dict[MemoryRegion, Dict[str, Set[str]]]:
        # inverts the given cu_and_variable_to_memory_regions dictionary
        result_dict: Dict[MemoryRegion, Dict[str, Set[str]]] = dict()

        for cu_id in cu_and_variable_to_memory_regions:
            for var_name in cu_and_variable_to_memory_regions[cu_id]:
                for mem_reg in cu_and_variable_to_memory_regions[cu_id][var_name]:
                    if mem_reg not in result_dict:
                        result_dict[mem_reg] = dict()
                    if cu_id not in result_dict[mem_reg]:
                        result_dict[mem_reg][cu_id] = set()
                    result_dict[mem_reg][cu_id].add(var_name)
        return result_dict


def find_combined_gpu_regions(
    pet: PETGraphX, gpu_regions: List[GPURegionInfo]
) -> List[CombinedGPURegion]:
    # create combined gpu regions from original gpu regions
    combined_gpu_regions = []
    for gpu_region in gpu_regions:
        combined_gpu_regions.append(CombinedGPURegion(pet, [gpu_region]))

    # determine relations between single-element regions
    combinable_pairs: List[
        Tuple[CombinedGPURegion, CombinedGPURegion]
    ] = find_all_pairwise_gpu_region_combinations(combined_gpu_regions, pet)

    intra_function_combinations = find_combinations_within_function_body(pet, combinable_pairs)

    true_successor_combinations = find_true_successor_combinations(pet, intra_function_combinations)

    # combine regions
    for combinable_1, combinable_2 in true_successor_combinations:
        combined_gpu_regions.remove(combinable_1)
        combined_gpu_regions.remove(combinable_2)
        combined_gpu_regions.append(combine_regions(pet, combinable_1, combinable_2))

    # todo add update instructions
    # todo merge data regions

    return combined_gpu_regions


def find_all_pairwise_gpu_region_combinations(
    gpu_regions: List[CombinedGPURegion], pet: PETGraphX
) -> List[Tuple[CombinedGPURegion, CombinedGPURegion]]:
    combinable_pairs: List[Tuple[CombinedGPURegion, CombinedGPURegion]] = []  # [(region1, region2)
    # get all pairwise combinations of gpu regions
    for gpu_region_1 in gpu_regions:
        for gpu_region_2 in gpu_regions:
            if gpu_region_1 == gpu_region_2:
                continue
            combinable_pairs.append((gpu_region_1, gpu_region_2))
    return combinable_pairs


def find_combinations_within_function_body(
    pet: PETGraphX, combinable_pairs: List[Tuple[CombinedGPURegion, CombinedGPURegion]]
) -> List[Tuple[CombinedGPURegion, CombinedGPURegion]]:
    """Check regions pairwise for reachability via successor edges.
    Only combinations within a function's body are possible in this way since successor edges only exist
    for function body's."""
    result = []
    for region_1, region_2 in combinable_pairs:
        if region_1 == region_2:
            continue
        # check reachability in both directions via successor edges
        # consider children, as loop nodes do not have successors on their own
        for region_1_child in pet.direct_children(
            pet.node_at(region_1.contained_regions[0].node_id)
        ):
            for region_2_child in pet.direct_children(
                pet.node_at(region_2.contained_regions[0].node_id)
            ):
                if region_1_child == region_2_child:
                    continue
                if pet.check_reachability(region_2_child, region_1_child, [EdgeType.SUCCESSOR]):
                    result.append((region_1, region_2))
                elif pet.check_reachability(region_1_child, region_2_child, [EdgeType.SUCCESSOR]):
                    result.append((region_2, region_1))
    # remove duplicates (deterministic ordering not relevant, hence list(set(..)) is fine)
    result = list(set(result))
    return result


def find_true_successor_combinations(
    pet, intra_function_combinations: List[Tuple[CombinedGPURegion, CombinedGPURegion]]
) -> List[Tuple[CombinedGPURegion, CombinedGPURegion]]:
    """Check for combinations options without branching inbetween.
    As a result, both regions will always be executed in succession."""
    result = []
    # a successor path between region_1 and region_2 must exist.
    # a true successor relation exists, if every successor path outgoing from any child of region_1 arrives at region_2
    for region_1, region_2 in intra_function_combinations:
        true_successors = True
        queue: List[CUNode] = pet.direct_children(
            pet.node_at(region_1.contained_regions[0].node_id)
        )
        visited: List[CUNode] = []
        while queue:
            current_node: CUNode = queue.pop()
            visited.append(current_node)
            if current_node in pet.direct_children(
                pet.node_at(region_2.contained_regions[0].node_id)
            ):
                # reached region_2
                continue
            # region_2 not reached
            successors = pet.direct_successors(current_node)
            if len(successors) == 0:
                # end of the function body reached, region_2 not reached
                true_successors = False
                break
            else:
                # end of the function's body not yet reached, continue searching
                # add successors to queue
                queue += [succ for succ in successors if succ not in visited]
        if true_successors:
            result.append((region_1, region_2))
    return result


def combine_regions(
    pet: PETGraphX, region_1: CombinedGPURegion, region_2: CombinedGPURegion
) -> CombinedGPURegion:
    """Combines regions. Individual contained regions are not yet merged!
    Analysis of Live-data and necessary update pragmas needs ti happen in a subsequent step."""
    combined_region = CombinedGPURegion(
        pet, region_1.contained_regions + region_2.contained_regions
    )
    return combined_region
