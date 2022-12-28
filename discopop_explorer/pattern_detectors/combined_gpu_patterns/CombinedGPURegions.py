# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

from typing import List, Tuple, cast

from discopop_explorer.PETGraphX import EdgeType, CUNode, Dependency, PETGraphX
from discopop_explorer.pattern_detectors.PatternInfo import PatternInfo
from discopop_explorer.pattern_detectors.simple_gpu_patterns.GPURegions import GPURegionInfo


class CombinedGPURegion(PatternInfo):
    contained_regions: List[GPURegionInfo]
    device_cu_ids: List[str]
    host_cu_ids: List[str]
    # meta information, mainly for display and overview purposes
    meta_device_lines: List[str]
    meta_host_lines: List[str]

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
        self.host_cu_ids = self.__get_host_cu_ids(pet)
        self.meta_device_lines = []
        self.meta_host_lines = []
        self.__get_metadata(pet)

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
            f"Host CUs: {self.host_cu_ids}\n"
            f"Device lines: {self.meta_device_lines}\n"
            f"Host lines: {self.meta_host_lines}\n"
            f"Contained regions: {contained_regions_str}\n"
        )

    def __get_metadata(self, pet: PETGraphX):
        """Create metadata and store it in the respective fields."""
        for device_cu_id in self.device_cu_ids:
            device_cu = pet.node_at(device_cu_id)
            self.meta_device_lines = list(
                set(
                    self.meta_device_lines
                    + self.__get_contained_lines(
                        device_cu.start_position(), device_cu.end_position()
                    )
                )
            )
        for host_cu_id in self.host_cu_ids:
            host_cu = pet.node_at(host_cu_id)
            self.meta_host_lines = list(
                set(
                    self.meta_host_lines
                    + self.__get_contained_lines(host_cu.start_position(), host_cu.end_position())
                )
            )

    def __get_contained_lines(self, start_line: str, end_line: str) -> List[str]:
        """Returns a list of line numbers inbetween start_line and end_line"""
        file_id = start_line.split(":")[0]
        if file_id != end_line.split(":")[0]:
            raise ValueError("File-ids not equal! ", start_line, end_line)
        line_numbers: List[int] = list(
            range(int(start_line.split(":")[1]), int(end_line.split(":")[1]) + 1)
        )
        result = [file_id + ":" + str(num) for num in line_numbers]
        return result

    def __get_host_cu_ids(self, pet: PETGraphX) -> List[str]:
        """identify CUs within the region which are not offloaded to a device."""
        host_cu_ids: List[str] = []
        for node_id_1 in self.device_cu_ids:
            for node_id_2 in self.device_cu_ids:
                if node_id_1 == node_id_2:
                    continue
                cu_ids_inbetween: List[str] = []
                # construct all paths from node_id_1 to node_id_2 and get all visited nodes
                queue: List[CUNode] = [pet.node_at(node_id_1)]
                while queue:
                    current = queue.pop()
                    if current.id == node_id_2:
                        # found target, stop searching on this branch
                        continue
                    else:
                        # add current to cu_ids_inbetween
                        cu_ids_inbetween.append(current.id)
                        # continue search for successors as long as line numbers potentially allow a match
                        queue += [
                            n
                            for n in pet.direct_successors(current)
                            if n.id not in cu_ids_inbetween
                            and n.id.split(":")[0] == node_id_2.split(":")[0]
                            and int(n.id.split(":")[1]) <= int(node_id_2.split(":")[1])
                        ]
                host_cu_ids += [
                    cu_id for cu_id in cu_ids_inbetween if cu_id not in self.device_cu_ids
                ]
        host_cu_ids = list(set(host_cu_ids))
        host_cu_ids = sorted(host_cu_ids)
        return host_cu_ids


def find_combined_gpu_regions(
    pet: PETGraphX, gpu_regions: List[GPURegionInfo]
) -> List[CombinedGPURegion]:
    # create combined gpu regions from original gpu regions
    combined_gpu_regions = []
    for gpu_region in gpu_regions:
        combined_gpu_regions.append(CombinedGPURegion(pet, [gpu_region]))

    # determine relations between single-element regions
    combinable_pairs: List[
        Tuple[CombinedGPURegion, CombinedGPURegion, List[str]]
    ] = __find_all_pairwise_gpu_region_combinations(combined_gpu_regions, pet)
    # print combinable gpu regions
    for combinable_1, combinable_2, common_data in combinable_pairs:
        print("Combinable: ")
        print(combinable_1.start_line, combinable_1.end_line)
        print("####")
        print(combinable_2.start_line, combinable_2.end_line)
        print("####")
        # preliminary calculation of common data. Calculation based on dependencies should be preferred!
        print("Common data: ", common_data)
        print()

    intra_function_combinations = __find_combinations_within_function_body(pet, combinable_pairs)
    for combinable_1, combinable_2 in intra_function_combinations:
        print("INTRA COMBINE: ")
        print(combinable_1.start_line, combinable_1.end_line)
        print("####")
        print(combinable_2.start_line, combinable_2.end_line)
        print("####")
        print()

    true_successor_combinations = __find_true_successor_combinations(
        pet, intra_function_combinations
    )
    for combinable_1, combinable_2 in true_successor_combinations:
        print("TRUE SUCCESSORS: ")
        print(combinable_1.start_line, combinable_1.end_line)
        print("####")
        print(combinable_2.start_line, combinable_2.end_line)
        print("####")
        print()

    # combine regions
    for combinable_1, combinable_2 in true_successor_combinations:
        combined_gpu_regions.remove(combinable_1)
        combined_gpu_regions.remove(combinable_2)
        combined_gpu_regions.append(__combine_regions(pet, combinable_1, combinable_2))

    # todo add update instructions
    # todo merge data regions
    
    return combined_gpu_regions


def __combine_regions(
    pet: PETGraphX, region_1: CombinedGPURegion, region_2: CombinedGPURegion
) -> CombinedGPURegion:
    """Combines regions. Individual contained regions are not yet merged!
    Analysis of Live-data and necessary update pragmas needs ti happen in a subsequent step."""
    print(region_1.to_string(pet))
    print(region_2.to_string(pet))
    combined_region = CombinedGPURegion(
        pet, region_1.contained_regions + region_2.contained_regions
    )
    print("COMBINED REGION: ")
    print(combined_region.to_string(pet))
    return combined_region


def __find_true_successor_combinations(
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


def __find_combinations_within_function_body(
    pet: PETGraphX, combinable_pairs: List[Tuple[CombinedGPURegion, CombinedGPURegion, List[str]]]
) -> List[Tuple[CombinedGPURegion, CombinedGPURegion]]:
    """Check regions pairwise for reachability via successor edges.
    Only combinations within a function's body are possible in this way since successor edges only exist
    for function body's."""
    result = []
    for region_1, region_2, _ in combinable_pairs:
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


def __find_all_pairwise_gpu_region_combinations(
    gpu_regions: List[CombinedGPURegion], pet: PETGraphX
) -> List[Tuple[CombinedGPURegion, CombinedGPURegion, List[str]]]:
    combinable_pairs: List[
        Tuple[CombinedGPURegion, CombinedGPURegion, List[str]]
    ] = []  # [(region1, region2, [common data])
    # check pairwise if gpu regions can be combined
    for gpu_region_1 in gpu_regions:
        for gpu_region_2 in gpu_regions:
            if gpu_region_1 == gpu_region_2:
                continue
            # check if same data is accessed
            if __common_data_accessed(
                gpu_region_1.contained_regions[0], gpu_region_2.contained_regions[0], pet
            ):
                common_data = [
                    var
                    for var in gpu_region_1.contained_regions[0].consumed_vars
                    + gpu_region_1.contained_regions[0].produced_vars
                    if var
                    in gpu_region_2.contained_regions[0].produced_vars
                    + gpu_region_2.contained_regions[0].consumed_vars
                ]
                combinable_pairs.append((gpu_region_1, gpu_region_2, common_data))
    return combinable_pairs


def __common_data_accessed(
    gpu_region_1: GPURegionInfo, gpu_region_2: GPURegionInfo, pet: PETGraphX
) -> bool:
    # common data is accessed, if a transitive RAW / WAR dependency from gpu_region_1 to gpu_region_2 or
    # from gpu_region_2 to gpu_region_1 exists
    for cu_id_1 in gpu_region_1.contained_cu_ids:
        for cu_id_2 in gpu_region_2.contained_cu_ids:
            if __check_reachability_via_transitive_dependency(pet, cu_id_1, cu_id_2):
                return True
    return False


def __check_reachability_via_transitive_dependency(
    pet: PETGraphX, source_id: str, target_id: str
) -> bool:
    # perform BFS from source to target, consider the name of the respective variable
    # add initial values for "previous" variable names
    queue: List[Tuple[str, str, Dependency, str]] = [
        (e[0], e[1], e[2], cast(str, e[2].var_name))
        for e in pet.out_edges(source_id, EdgeType.DATA)
        if e[2].var_name is not None
    ]
    visited: List[Tuple[str, str]] = []
    while queue:
        s_id, t_id, dep, prev_var_name = queue.pop(0)
        if (t_id, prev_var_name) not in visited:
            visited.append((t_id, prev_var_name))
        if t_id == target_id:
            # target reached
            return True
        # target not reached
        # add outgoing edges of t_id with variable prev_var_name to the queue
        queue += [
            (e[0], e[1], e[2], prev_var_name)
            for e in pet.out_edges(t_id, EdgeType.DATA)
            if e[2].var_name == prev_var_name and (e[1], prev_var_name) not in visited
        ]
        # remove duplicates
        queue = list(dict.fromkeys(queue))
    return False
