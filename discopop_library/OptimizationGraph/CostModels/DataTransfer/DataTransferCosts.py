from typing import Dict, List, Tuple, Set

import networkx as nx  # type: ignore

from discopop_library.OptimizationGraph.CostModels.CostModel import CostModel
from discopop_library.OptimizationGraph.classes.context.Update import Update
from discopop_library.OptimizationGraph.classes.nodes.FunctionRoot import FunctionRoot


def add_data_transfer_costs(
    graph: nx.DiGraph,
    function_performance_models: Dict[FunctionRoot, List[Tuple[CostModel, Set[Update]]]],
):
    """Calculates the data transfer costs for each of the given performance models and adds them to the respective model."""
    raise NotImplementedError("TODO")
