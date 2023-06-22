from typing import Tuple, List, Optional, cast

from sympy import Expr, Symbol

from discopop_explorer.pattern_detectors.PatternInfo import PatternInfo


class Device(object):
    __compute_capability: Expr
    __thread_count: Expr
    openmp_device_id: int

    def __init__(
        self,
        compute_capability: Expr,
        thread_count: Expr,
        openmp_device_id: int,
        device_specific_compiler_flags: str,
    ):
        self.__compute_capability = compute_capability
        self.__thread_count = thread_count
        self.openmp_device_id = openmp_device_id
        self.device_specific_compiler_flags: str = device_specific_compiler_flags

    def get_device_specific_pattern_info(
        self, suggestion: PatternInfo, suggestion_type: str
    ) -> Tuple[PatternInfo, str]:
        return suggestion, suggestion_type

    def get_compute_capability(self) -> Expr:
        return self.__compute_capability

    def get_thread_count(self) -> Expr:
        return self.__thread_count

    def get_free_symbols(self) -> List[Tuple[Symbol, Optional[Expr]]]:
        result_list: List[Tuple[Symbol, Optional[Expr]]] = []
        result_list += [(cast(Symbol, s), None) for s in self.__compute_capability.free_symbols]
        result_list += [(cast(Symbol, s), None) for s in self.__thread_count.free_symbols]
        return result_list
