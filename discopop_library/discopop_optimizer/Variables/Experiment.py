import os
from typing import Dict, Tuple, Set, cast, Optional

from sympy import Integer, Symbol, Expr, Float  # type: ignore

from discopop_explorer.PETGraphX import MemoryRegion
from discopop_library.MemoryRegions.utils import get_sizes_of_memory_regions
from discopop_library.discopop_optimizer.classes.system.System import System
from discopop_library.discopop_optimizer.classes.system.devices.Device import Device


class Experiment(object):
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

    ## END OF SETTINGS

    __system: System

    # all free symbols will be added to this list for simple retrieval and user query
    free_symbols: Set[Symbol] = set()
    # value suggestions for all free symbols will be stored in this dictionary
    suggested_values: Dict[Symbol, Expr] = dict()

    __memory_region_sizes: Dict[MemoryRegion, int]  # sizes in Bytes

    def __init__(self, project_folder_path, system: System):
        self.__system = system

        self.__memory_region_sizes = get_sizes_of_memory_regions(
            set(),
            os.path.join(project_folder_path, "memory_regions.txt"),
            return_all_memory_regions=True,
        )

        # collect free symbols from system
        for free_symbol, value_suggestion in system.get_free_symbols():
            self.register_free_symbol(free_symbol, value_suggestion)

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

    def get_system(self) -> System:
        return self.__system
