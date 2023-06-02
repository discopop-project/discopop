import copy
import random
from random import shuffle
from typing import List, Dict, Tuple

import networkx as nx  # type: ignore
from spb import plot3d, MB, plot  # type: ignore
from sympy import Symbol, Expr

from discopop_library.discopop_optimizer.CostModels.CostModel import CostModel
from discopop_library.discopop_optimizer.CostModels.utilities import get_random_path
from discopop_library.discopop_optimizer.classes.enums.Distributions import FreeSymbolDistribution
from discopop_library.discopop_optimizer.classes.nodes.FunctionRoot import FunctionRoot
from discopop_library.discopop_optimizer.gui.plotting.CostModels import plot_CostModels


def find_quasi_optimal_using_random_samples(
    graph: nx.DiGraph,
    function_root: FunctionRoot,
    random_path_count: int,
    substitutions: Dict[Symbol, Expr],
    sorted_free_symbols: List[Symbol],
    free_symbol_ranges: Dict[Symbol, Tuple[float, float]],
    free_symbol_distributions: Dict[Symbol, FreeSymbolDistribution],
    verbose: bool = False,
):
    """Returns the identified minimum, maximum, median, 25% quartile and 75% quartile of the random_path_count samples.
    NOTE: The decisions should be treated as suggestions, not mathematically accurate decisions
    due to the used comparison method!"""
    random_paths: List[CostModel] = []
    if verbose:
        print("Generating ", random_path_count, "random paths")
    for i in range(0, random_path_count):
        random_paths.append(get_random_path(graph, function_root.node_id, must_contain=None))

    # apply substitutions and set free symbol ranges and distributions
    if verbose:
        print("\tApplying substitutions...")
    for model in random_paths:
        model.parallelizable_costs = model.parallelizable_costs.subs(substitutions)
        model.sequential_costs = model.sequential_costs.subs(substitutions)
        model.free_symbol_ranges = free_symbol_ranges
        model.free_symbol_distributions = free_symbol_distributions

    if verbose:
        print("\tSorting...")
    sorted_list = sorted(random_paths)  # BOTTLENECK!
    if verbose:
        print("\tDone.")
    minimum = sorted_list[0]
    maximum = sorted_list[-1]
    median = sorted_list[int(len(sorted_list) / 2)]
    upper_quartile = sorted_list[int(len(sorted_list) / 4 * 3)]
    lower_quartile = sorted_list[int(len(sorted_list) / 4 * 1)]

    return minimum, maximum, median, lower_quartile, upper_quartile
