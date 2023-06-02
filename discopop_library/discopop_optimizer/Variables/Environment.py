import os
from typing import Dict, Tuple, Set, cast, Optional

from sympy import Integer, Symbol, Expr, Float  # type: ignore

from discopop_explorer.PETGraphX import MemoryRegion
from discopop_library.MemoryRegions.utils import get_sizes_of_memory_regions


class Environment(object):
    ## SETTINGS
    # todo: convert Costs into estimated runtime, removes need for high overhead weight
    workload_overhead_weight = Integer(1500)
    do_all_overhead_weight_by_device: Dict[int, Expr] = {
        0: Integer(300),
        1: Integer(300),
    }
    reduction_overhead_weight_by_device: Dict[int, Expr] = {
        0: Integer(300),
        1: Integer(300),
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

    # all free symbols will be added to this list for simple retrieval and user query
    free_symbols: Set[Symbol] = set()
    # value suggestions for all free symbols will be stored in this dictionary
    suggested_values: Dict[Symbol, Expr] = dict()

    __memory_region_sizes: Dict[MemoryRegion, int]  # sizes in Bytes

    def __init__(self, project_folder_path):
        self.__memory_region_sizes = get_sizes_of_memory_regions(
            set(),
            os.path.join(project_folder_path, "memory_regions.txt"),
            return_all_memory_regions=True,
        )

        # add thread counts to free_symbols
        for key in self.thread_counts_by_device:
            self.register_free_symbol(cast(Symbol, self.thread_counts_by_device[key]))

    def get_memory_region_size(
        self, memory_region: MemoryRegion, use_symbolic_value: bool = False
    ) -> Tuple[Expr, Expr]:
        if memory_region not in self.__memory_region_sizes:
            self.__memory_region_sizes[memory_region] = 8  # assume 8 Bytes for unknown sizes

        if use_symbolic_value:
            symbolic_memory_region_size = Symbol("mem_reg_size_" + str(memory_region))
            # register the symbolic value in the environment
            self.register_free_symbol(
                symbolic_memory_region_size,
                value_suggestion=Integer(self.__memory_region_sizes[memory_region]),
            )
            return symbolic_memory_region_size, Integer(self.__memory_region_sizes[memory_region])
        else:
            return Integer(self.__memory_region_sizes[memory_region]), Integer(0)

    def register_free_symbol(self, symbol: Symbol, value_suggestion: Optional[Expr] = None):
        self.free_symbols.add(symbol)
        if value_suggestion is not None:
            self.suggested_values[symbol] = value_suggestion
