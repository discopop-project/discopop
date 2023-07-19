import os
from pathlib import Path
from typing import Dict, Tuple, Set, Optional, List

import networkx as nx  # type: ignore
from sympy import Integer, Symbol, Expr, Float  # type: ignore

from discopop_library.result_classes.DetectionResult import DetectionResult
from discopop_library.FileMapping.FileMapping import load_file_mapping


class Experiment(object):
    ## SETTINGS
    # todo: convert Costs into estimated runtime, removes need for high overhead weight
    workload_overhead_weight = Integer(1500)
    do_all_overhead_weight_by_device: Dict[int, Expr] = {
        0: Integer(300),
        1: Integer(300),
        2: Integer(300),
    }
    reduction_overhead_weight_by_device: Dict[int, Expr] = {
        0: Integer(300),
        1: Integer(300),
        2: Integer(300),
    }

    ## END OF SETTINGS

    # all free symbols will be added to this list for simple retrieval and user query
    free_symbols: Set[Symbol] = set()
    # value suggestions for all free symbols will be stored in this dictionary
    suggested_values: Dict[Symbol, Expr] = dict()

    project_path: Path
    file_mapping: Dict[int, Path]  # file-mapping
    detection_result: DetectionResult
    optimization_graph: nx.DiGraph

    def __init__(
        self,
        project_path,
        detection_result: DetectionResult,
        file_mapping_path,
    ):
        self.detection_result = detection_result
        self.project_path = project_path
        self.file_mapping = load_file_mapping(file_mapping_path)

    def register_free_symbol(self, symbol: Symbol, value_suggestion: Optional[Expr] = None):
        self.free_symbols.add(symbol)
        if value_suggestion is not None:
            self.suggested_values[symbol] = value_suggestion
