# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
from random import randint, shuffle
from time import sleep
from typing import Dict, Set, cast, List, Tuple

import networkx as nx  # type: ignore
import sympy  # type: ignore
from sympy import Integer, Expr, Symbol, lambdify, plot, Float, init_printing, simplify, diff  # type: ignore

from spb import plot3d, MB  # type: ignore

from discopop_library.OptimizationGraph.CostModels.CostModel import CostModel
from discopop_library.OptimizationGraph.CostModels.DataTransfer.DataTransferCosts import (
    add_data_transfer_costs,
)
from discopop_library.OptimizationGraph.CostModels.utilities import (
    get_performance_models_for_functions,
)
from discopop_library.OptimizationGraph.DataTransfers.DataTransfers import calculate_data_transfers
from discopop_library.OptimizationGraph.PETParser.PETParser import PETParser
from discopop_library.OptimizationGraph.Variables.Environment import Environment
from discopop_library.OptimizationGraph.classes.enums.Distributions import FreeSymbolDistribution
from discopop_library.OptimizationGraph.gui.presentation.OptionTable import show_options
from discopop_library.OptimizationGraph.gui.queries.ValueTableQuery import (
    query_user_for_symbol_values,
)
from discopop_library.OptimizationGraph.suggestions.importers.base import import_suggestions
from discopop_library.OptimizationGraph.utilities.MOGUtilities import show
from discopop_library.OptimizationGraph.utilities.optimization.GlobalOptimization.RandomSamples import (
    find_quasi_optimal_using_random_samples,
)


class OptimizationGraph(object):
    graph: nx.DiGraph
    next_free_node_id: int

    def __init__(self, detection_result, project_folder_path):
        self.graph, self.next_free_node_id = PETParser(detection_result.pet).parse()

        # print("FINAL")
        # show(self.graph)

        # define Environment
        environment = Environment(project_folder_path)

        # get performance models for sequential execution
        sequential_function_performance_models = get_performance_models_for_functions(self.graph)
        sequential_function_performance_models_with_transfers = calculate_data_transfers(
            self.graph, sequential_function_performance_models
        )
        sequential_complete_performance_models = add_data_transfer_costs(
            self.graph, sequential_function_performance_models_with_transfers, environment
        )


        # import parallelization suggestions
        self.graph = import_suggestions(
            detection_result, self.graph, self.get_next_free_node_id, environment
        )
        # show(self.graph)

        # calculate performance models without data transfers
        function_performance_models = get_performance_models_for_functions(self.graph)

        # calculate and append necessary data transfers to the models
        function_performance_models_with_transfers = calculate_data_transfers(
            self.graph, function_performance_models
        )

        # calculate and append costs of data transfers to the performance models
        complete_performance_models = add_data_transfer_costs(
            self.graph, function_performance_models_with_transfers, environment
        )

        # print_introduced_symbols_per_node(self.graph)

        print("FUNCTION PERFORMANCE MODELS: ")
        for idx, function in enumerate(complete_performance_models):
            for midx, pair in enumerate(complete_performance_models[function]):
                model, context = pair
                print(str(idx) + "-" + str(midx) + ": \t", end="")
                model.print()

        # import sys
        # sys.exit(0)

        # define variable substitutions
        substitutions: Dict[Symbol, Expr] = dict()
        # print_introduced_symbols_per_node(self.graph)

        # collect free symbols
        free_symbols: Set[Symbol] = set()
        free_symbol_ranges: Dict[Symbol, Tuple[float, float]] = dict()
        free_symbol_distributions: Dict[Symbol, FreeSymbolDistribution] = dict()

        suggested_values: Dict[Symbol, Expr] = dict()
        for function in complete_performance_models:
            for pair in complete_performance_models[function]:
                model, context = pair
                free_symbols.update(cast(List[Symbol], model.model.free_symbols))
                suggested_values = suggested_values | model.symbol_value_suggestions
        sorted_free_symbols = sorted(list(free_symbols), key=lambda x: x.name)
        print("Free Symbols: ", sorted_free_symbols)

        # query user for values for free symbols
        query_results = query_user_for_symbol_values(sorted_free_symbols, suggested_values)
        for symbol, value, start_value, end_value, symbol_distribution in query_results:
            if value is not None:
                substitutions[symbol] = Float(value)
            else:
                free_symbol_ranges[symbol] = (start_value, end_value)
                free_symbol_distributions[symbol] = symbol_distribution
        print("subs: ", substitutions)

        # apply substitutions and un-mark substituted free symbols
        for idx, function in enumerate(function_performance_models):
            for midx, model in enumerate(function_performance_models[function]):
                model.model = model.model.subs(substitutions)
        for symbol in substitutions:
            if symbol in free_symbols:
                free_symbols.remove(symbol)
            if symbol in free_symbol_ranges:
                del free_symbol_ranges[symbol]
            if symbol in sorted_free_symbols:
                sorted_free_symbols.remove(symbol)

        # set free symbol ranges and distributions for comparisons
        for idx, function in enumerate(function_performance_models):
            for model in function_performance_models[function]:
                model.free_symbol_ranges = free_symbol_ranges
                model.free_symbol_distributions = free_symbol_distributions

        # find quasi-optimal results by checking random subsets
        random_paths = 50
        for function in function_performance_models:
            print("Function: ", function.name)
            minimum, maximum, median, lower_quartile, upper_quartile = find_quasi_optimal_using_random_samples(
                function_performance_models[function],
                random_paths,
                sorted_free_symbols,
                free_symbol_ranges,
                plot=False
            )
            # show table of options
            options: List[Tuple[CostModel, str]] = []
            options.append((minimum, "Minimum"))
            options.append((maximum, "Maximum"))
            options.append((median, "Median"))
            options.append((lower_quartile, "25% Quartile"))
            options.append((upper_quartile, "75% Quartile"))
            options.append((complete_performance_models[function][0][0], "Sequential"))
            show_options(options, sorted_free_symbols,
                free_symbol_ranges, window_title="Function: " + function.name)


    def get_next_free_node_id(self):
        buffer = self.next_free_node_id
        self.next_free_node_id += 1
        return buffer
