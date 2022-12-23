# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

from typing import List, Tuple

from discopop_explorer import PETGraphX
from discopop_explorer.PETGraphX import EdgeType
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

    return [combinable_pairs]


def __common_data_accessed(
    gpu_region_1: GPURegionInfo, gpu_region_2: GPURegionInfo, pet: PETGraphX
) -> bool:
    # common data is accessed, if a transitive RAW / WAR dependency from gpu_region_1 to gpu_region_2 or
    # from gpu_region_2 to gpu_region_1 exists
    for cu_id_1 in gpu_region_1.contained_cu_ids:
        for cu_id_2 in gpu_region_2.contained_cu_ids:
            if pet.check_reachability(pet.node_at(cu_id_1), pet.node_at(cu_id_2), [EdgeType.DATA]):
                return True
    return False
