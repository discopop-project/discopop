# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
import copy
from random import randint, shuffle
from time import sleep
from typing import Dict, Set, cast, List, Tuple

import networkx as nx  # type: ignore
import sympy  # type: ignore
from sympy import Integer, Expr, Symbol, lambdify, plot, Float, init_printing, simplify, diff  # type: ignore

from spb import plot3d, MB  # type: ignore

from discopop_library.discopop_optimizer.CostModels.CostModel import CostModel
from discopop_library.discopop_optimizer.CostModels.DataTransfer.DataTransferCosts import (
    add_data_transfer_costs,
)
from discopop_library.discopop_optimizer.CostModels.utilities import (
    get_performance_models_for_functions,
)
from discopop_library.discopop_optimizer.DataTransfers.DataTransfers import calculate_data_transfers
from discopop_library.discopop_optimizer.PETParser.PETParser import PETParser
from discopop_library.discopop_optimizer.Variables.Experiment import Experiment
from discopop_library.discopop_optimizer.classes.context.ContextObject import ContextObject
from discopop_library.discopop_optimizer.classes.enums.Distributions import FreeSymbolDistribution
from discopop_library.discopop_optimizer.classes.nodes.FunctionRoot import FunctionRoot
from discopop_library.discopop_optimizer.gui.presentation.OptionTable import show_options
from discopop_library.discopop_optimizer.gui.queries.ValueTableQuery import (
    query_user_for_symbol_values,
)
from discopop_library.discopop_optimizer.suggestions.importers.base import import_suggestions
from discopop_library.discopop_optimizer.utilities.MOGUtilities import show
from discopop_library.discopop_optimizer.utilities.optimization.GlobalOptimization.RandomSamples import (
    find_quasi_optimal_using_random_samples,
)
from discopop_library.discopop_optimizer.utilities.optimization.LocalOptimization.TopDown import (
    get_locally_optimized_models,
)


class OptimizationGraph(object):
    graph: nx.DiGraph
    next_free_node_id: int

    def __init__(self, detection_result, project_folder_path, experiment: Experiment):
        # construct optimization graph from PET Graph
        self.graph, self.next_free_node_id = PETParser(detection_result.pet, experiment).parse()

        # get performance models for sequential execution
        sequential_function_performance_models = get_performance_models_for_functions(self.graph)
        sequential_function_performance_models_with_transfers = calculate_data_transfers(
            self.graph, sequential_function_performance_models
        )
        sequential_complete_performance_models = add_data_transfer_costs(
            self.graph, sequential_function_performance_models_with_transfers, experiment
        )

        # import parallelization suggestions
        self.graph = import_suggestions(
            detection_result, self.graph, self.get_next_free_node_id, experiment
        )

        #        # calculate performance models without data transfers
        #        function_performance_models = get_performance_models_for_functions(self.graph)

        #        # calculate and append necessary data transfers to the models
        #        function_performance_models_with_transfers = calculate_data_transfers(
        #            self.graph, function_performance_models
        #       )

        #        # calculate and append costs of data transfers to the performance models
        #        complete_performance_models = add_data_transfer_costs(
        #            self.graph, function_performance_models_with_transfers, environment
        #        )

        # define variable substitutions
        substitutions: Dict[Symbol, Expr] = dict()

        # collect free symbols
        #        free_symbols: Set[Symbol] = set()
        free_symbol_ranges: Dict[Symbol, Tuple[float, float]] = dict()
        free_symbol_distributions: Dict[Symbol, FreeSymbolDistribution] = dict()

        #        for function in complete_performance_models:
        #            for pair in complete_performance_models[function]:
        #                model, context = pair
        #                free_symbols.update(cast(List[Symbol], model.parallelizable_costs.free_symbols))
        #                free_symbols.update(cast(List[Symbol], model.sequential_costs.free_symbols))
        #                suggested_values = suggested_values | model.symbol_value_suggestions
        sorted_free_symbols = sorted(list(experiment.free_symbols), key=lambda x: x.name)

        # query user for values for free symbols
        query_results = query_user_for_symbol_values(
            sorted_free_symbols, experiment.suggested_values
        )
        for symbol, value, start_value, end_value, symbol_distribution in query_results:
            if value is not None:
                substitutions[symbol] = Float(value)
            else:
                free_symbol_ranges[symbol] = (cast(float, start_value), cast(float, end_value))
                free_symbol_distributions[symbol] = cast(
                    FreeSymbolDistribution, symbol_distribution
                )

        # apply substitutions and un-mark substituted free symbols
        #        for idx, function in enumerate(complete_performance_models):
        #            for midx, pair in enumerate(complete_performance_models[function]):
        #                model, context = pair
        #                model.parallelizable_costs = model.parallelizable_costs.subs(substitutions)
        #                model.sequential_costs = model.sequential_costs.subs(substitutions)
        for idx, function in enumerate(sequential_complete_performance_models):
            for midx, pair in enumerate(sequential_complete_performance_models[function]):
                model, context = pair
                model.parallelizable_costs = model.parallelizable_costs.subs(substitutions)
                model.sequential_costs = model.sequential_costs.subs(substitutions)
        for symbol in substitutions:
            if symbol in experiment.free_symbols:
                experiment.free_symbols.remove(symbol)
            if symbol in free_symbol_ranges:
                del free_symbol_ranges[symbol]
            if symbol in sorted_free_symbols:
                sorted_free_symbols.remove(symbol)

        # set free symbol ranges and distributions for comparisons
        #        for idx, function in enumerate(complete_performance_models):
        #            for pair in complete_performance_models[function]:
        #                model, context = pair
        #                model.free_symbol_ranges = free_symbol_ranges
        #                model.free_symbol_distributions = free_symbol_distributions

        # create locally optimized model
        locally_optimized_models = get_locally_optimized_models(
            self.graph, substitutions, experiment, free_symbol_ranges, free_symbol_distributions
        )
        # apply substitutions and un-mark substituted free symbols
        for idx, function in enumerate(locally_optimized_models):
            for midx, pair in enumerate(locally_optimized_models[function]):
                model, context = pair
                model.parallelizable_costs = model.parallelizable_costs.subs(substitutions)
                model.sequential_costs = model.sequential_costs.subs(substitutions)
        # set free symbol ranges and distributions for comparisons
        for idx, function in enumerate(locally_optimized_models):
            for pair in locally_optimized_models[function]:
                model, context = pair
                model.free_symbol_ranges = free_symbol_ranges
                model.free_symbol_distributions = free_symbol_distributions

        # find quasi-optimal results by checking random subsets
        random_paths = 50
        #        for function in complete_performance_models:
        for function in locally_optimized_models:
            # show table of options
            options: List[Tuple[CostModel, ContextObject, str]] = []
            #            options.append((minimum, "Minimum"))
            #            options.append((maximum, "Maximum"))
            #            options.append((median, "Median"))
            #            options.append((lower_quartile, "25% Quartile"))
            #            options.append((upper_quartile, "75% Quartile"))
            options.append(
                (
                    sequential_complete_performance_models[function][0][0],
                    sequential_complete_performance_models[function][0][1],
                    "Sequential",
                )
            )
            options.append(
                (
                    locally_optimized_models[function][0][0],
                    locally_optimized_models[function][0][1],
                    "Locally Optimized",
                )
            )
            show_options(
                self.graph,
                experiment,
                options,
                substitutions,
                sorted_free_symbols,
                free_symbol_ranges,
                free_symbol_distributions,
                function,
                window_title="Function: " + function.name,
            )

    def get_next_free_node_id(self):
        buffer = self.next_free_node_id
        self.next_free_node_id += 1
        return buffer
