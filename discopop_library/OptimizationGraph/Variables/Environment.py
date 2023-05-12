import os
from typing import Dict, Tuple, Union

from sympy import Integer, Symbol, Expr, Float  # type: ignore

from discopop_explorer.PETGraphX import MemoryRegion
from discopop_library.MemoryRegions.utils import get_sizes_of_memory_regions


class Environment(object):
    ## SETTINGS
    # todo: convert Costs into estimated runtime, removes need for high overhead weight
    workload_overhead_weight = Integer(1500)
    do_all_overhead_weight_by_device: Dict[int, Expr] = {
        0: Integer(5),
        1: Integer(1),
    }

    # transfer_speeds: {source_device: {target_device: transfer speed}} (MB/s)
    same_device_transfer_speed: Expr = Integer(100000)
    transfer_speeds: Dict[int, Dict[int, Expr]] = {
        0: {0: same_device_transfer_speed, 1: Integer(10)},
        1: {0: Integer(10), 2: same_device_transfer_speed},
    }
    # transfer initialization cost (static costs to start a transfer between the specified devices)
    transfer_initialization_costs: Dict[int, Dict[int, Expr]] = {
        0: {0: Integer(0), 1: Integer(1000000)},
        1: {0: Integer(1000000), 1: Integer(0)},
    }

    # thread number spawned by openmp parallel for and reduction pragmas
    thread_counts_by_device: Dict[int, Expr] = {
        0: Symbol("CPU_thread_num"),
        1: Symbol("GPU_thread_num"),
    }

    ## END OF SETTINGS

    __memory_region_sizes: Dict[MemoryRegion, int]  # sizes in Bytes

    def __init__(self, project_folder_path):
        self.__memory_region_sizes = get_sizes_of_memory_regions(
            set(),
            os.path.join(project_folder_path, "memory_regions.txt"),
            return_all_memory_regions=True,
        )

    def get_memory_region_size(
        self, memory_region: MemoryRegion, use_symbolic_value: bool = False
    ) -> Tuple[Expr, Expr]:
        if memory_region not in self.__memory_region_sizes:
            self.__memory_region_sizes[memory_region] = 8  # assume 8 Bytes for unknown sizes

        if use_symbolic_value:
            return Symbol("mem_reg_size_" + str(memory_region)), Integer(
                self.__memory_region_sizes[memory_region]
            )
        else:
            return Integer(self.__memory_region_sizes[memory_region]), Integer(0)
