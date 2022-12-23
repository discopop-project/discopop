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
from discopop_explorer.pattern_detectors.gpu_patterns.GPURegions import GPURegionInfo


def find_all_pairwise_gpu_region_combinations(
    gpu_regions: List[GPURegionInfo], pet: PETGraphX
) -> List[Tuple[GPURegionInfo, GPURegionInfo, List[str]]]:
    combinable_pairs: List[
        Tuple[GPURegionInfo, GPURegionInfo, List[str]]
    ] = []  # [(region1, region2, [common data])
    # check pairwise if gpu regions can be combined
    for gpu_region_1 in gpu_regions:
        for gpu_region_2 in gpu_regions:
            if gpu_region_1 == gpu_region_2:
                continue
            # check if same data is accessed
            if __common_data_accessed(gpu_region_1, gpu_region_2, pet):
                common_data = [
                    var
                    for var in gpu_region_1.consumed_vars + gpu_region_1.produced_vars
                    if var in gpu_region_2.produced_vars + gpu_region_2.consumed_vars
                ]
                combinable_pairs.append((gpu_region_1, gpu_region_2, common_data))

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
