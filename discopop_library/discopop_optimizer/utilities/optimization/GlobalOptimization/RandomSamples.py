# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
import copy
import random
from random import shuffle
from typing import List, Dict, Tuple

import networkx as nx  # type: ignore
from spb import plot3d, MB, plot  # type: ignore
from sympy import Symbol, Expr

from discopop_library.discopop_optimizer.CostModels.CostModel import CostModel
from discopop_library.discopop_optimizer.CostModels.utilities import get_random_path
from discopop_library.discopop_optimizer.DataTransfers.DataTransfers import calculate_data_transfers
from discopop_library.discopop_optimizer.Variables.Experiment import Experiment
from discopop_library.discopop_optimizer.classes.context.ContextObject import ContextObject
from discopop_library.discopop_optimizer.classes.enums.Distributions import FreeSymbolDistribution
from discopop_library.discopop_optimizer.classes.nodes.FunctionRoot import FunctionRoot
from discopop_library.discopop_optimizer.gui.plotting.CostModels import plot_CostModels


def find_quasi_optimal_using_random_samples(
    experiment: Experiment,
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
    random_paths: List[Tuple[CostModel, ContextObject]] = []
    if verbose:
        print("Generating ", random_path_count, "random paths")
    i = 0
    while i < random_path_count:
        tmp_dict = dict()
        tmp_dict[function_root] = [
            get_random_path(experiment, graph, function_root.node_id, must_contain=None)
        ]
        try:
            random_paths.append(calculate_data_transfers(graph, tmp_dict)[function_root][0])
            i += 1
        except ValueError:
            # might occur as a result of invalid paths due to restrictions
            pass

    # apply substitutions and set free symbol ranges and distributions
    if verbose:
        print("\tApplying substitutions...")
        print("\t" + str(substitutions))
    for model, context in random_paths:
        # save raw cost models
        if model.raw_sequential_costs is None:
            model.raw_sequential_costs = model.sequential_costs
        if model.raw_parallelizable_costs is None:
            model.raw_parallelizable_costs = model.parallelizable_costs
        # apply substitutions iteratively
        modification_found = True
        while modification_found:
            modification_found = False
            # apply substitutions to parallelizable costs
            tmp_model = model.parallelizable_costs.subs(substitutions)
            if tmp_model != model.parallelizable_costs:
                modification_found = True
            model.parallelizable_costs = tmp_model

            # apply substitutions to sequential costs
            tmp_model = model.sequential_costs.subs(substitutions)
            if tmp_model != model.sequential_costs:
                modification_found = True
            model.sequential_costs = tmp_model
        model.free_symbol_ranges = free_symbol_ranges
        model.free_symbol_distributions = free_symbol_distributions

    if verbose:
        print("\tSorting...")
    sorted_list = sorted(random_paths, key=lambda x: x[0])  # BOTTLENECK!
    if verbose:
        print("\tDone.")
    minimum = sorted_list[0]
    maximum = sorted_list[-1]
    median = sorted_list[int(len(sorted_list) / 2)]
    upper_quartile = sorted_list[int(len(sorted_list) / 4 * 3)]
    lower_quartile = sorted_list[int(len(sorted_list) / 4 * 1)]

    return minimum, maximum, median, lower_quartile, upper_quartile
