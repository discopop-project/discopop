# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
from typing import Dict, Set, cast, List, Tuple

import networkx as nx  # type: ignore
import sympy  # type: ignore
from sympy import Integer, Expr, Symbol, lambdify, plot, Float, init_printing, simplify  # type: ignore
from sympy.plotting import plot3d  # type: ignore

from discopop_library.OptimizationGraph.CostModels.utilities import (
    get_performance_models_for_functions,
)
from discopop_library.OptimizationGraph.DataTransfers.DataTransfers import calculate_data_transfers
from discopop_library.OptimizationGraph.PETParser.PETParser import PETParser
from discopop_library.OptimizationGraph.Variables.Environment import Environment
from discopop_library.OptimizationGraph.suggestions.importers.base import import_suggestions
from discopop_library.OptimizationGraph.utilities.MOGUtilities import show


class OptimizationGraph(object):
    graph: nx.DiGraph
    next_free_node_id: int

    def __init__(self, detection_result):
        self.graph, self.next_free_node_id = PETParser(detection_result.pet).parse()
        # print("FINAL")
        # show(self.graph)

        # define Environment
        environment = Environment()

        # import parallelization suggestions
        self.graph = import_suggestions(
            detection_result, self.graph, self.get_next_free_node_id, environment
        )
        # show(self.graph)

        # calculate performance models without data transfers
        function_performance_models = get_performance_models_for_functions(self.graph)

        # calculate and append necessary data transfers to the models
        function_performance_models_with_transfers = calculate_data_transfers(self.graph, function_performance_models)

        # calculate and append costs of data transfers to the performance models
        # TODO
        #  complete_performance_models = add_data_transfer_costs(self.graph, function_performance_models)

        # print_introduced_symbols_per_node(self.graph)

        print("FUNCTION PERFORMANCE MODELS: ")
        for idx, function in enumerate(function_performance_models):
            for midx, model in enumerate(function_performance_models[function]):
                print(str(idx) + "-" + str(midx) + ": \t", end="")
                model.print()

        import sys
        sys.exit(0)

        # define variable substitutions
        substitutions: Dict[Symbol, Expr] = dict()
        # print_introduced_symbols_per_node(self.graph)
        # thread counts
        # substitutions[data_at(self.graph, 105).introduced_symbols[0]] = Integer(4)
        # substitutions[data_at(self.graph, 106).introduced_symbols[0]] = Integer(16)

        # function spawn overhead
        # substitutions[data_at(self.graph, 51).introduced_symbols[0]] = Integer(5)
        # substitutions[data_at(self.graph, 104).introduced_symbols[0]] = Integer(5)

        # collect free symbols
        free_symbols: Set[Symbol] = set()
        for function in function_performance_models:
            for model in function_performance_models[function]:
                free_symbols.update(cast(List[Symbol], model.model.free_symbols))
        sorted_free_symbols = sorted(list(free_symbols), key=lambda x: x.name)
        print("Free Symbols: ", sorted_free_symbols)
        # query user for values for free symbols
        for free_symbol in sorted_free_symbols:
            raw_symbol_value = input("Insert value for: " + free_symbol.name + ": ")
            if len(raw_symbol_value) == 0:
                continue
            substitutions[free_symbol] = Float(float(raw_symbol_value))

        print("subs: ", substitutions)

        # apply substitutions
        for idx, function in enumerate(function_performance_models):
            for midx, model in enumerate(function_performance_models[function]):
                model.model = model.model.subs(substitutions)

        if True:  # plot results
            print("FUNCTION PERFORMANCE MODELS AFTER SUBSTITUTION: ")
            for idx, function in enumerate(function_performance_models):
                print("Function: ", function.name)
                combined_plot = None
                shown_models: List[Tuple[List[int], Expr]] = []
                for midx, model in enumerate(function_performance_models[function]):
                    print(str(idx) + "-" + str(midx) + ": \t", end="")
                    model.print()
                    print("Path Decisions: ", model.path_decisions)
                    try:
                        if len(model.model.free_symbols) == 0:
                            continue
                        if len(model.model.free_symbols) <= 2:
                            if len(model.path_decisions) <= 1:
                                if combined_plot is None:
                                    combined_plot = plot3d(
                                        model.model,
                                        (sorted_free_symbols[0], 1, 128),
                                        (sorted_free_symbols[1], 1, 128),
                                        show=False,
                                    )
                                    combined_plot.title = function.name

                                    shown_models.append((model.path_decisions, model.model))
                                else:
                                    combined_plot.extend(
                                        plot3d(
                                            model.model,
                                            (sorted_free_symbols[0], 1, 128),
                                            (sorted_free_symbols[1], 1, 128),
                                            show=False,
                                        )
                                    )
                                    shown_models.append((model.path_decisions, model.model))
                    except ValueError:
                        pass
                if combined_plot is not None:
                    print("Combined_plot: ")
                    for entry in shown_models:
                        print("->", entry[0], end="\t")
                        print(entry[1])
                    combined_plot.show()

    def get_next_free_node_id(self):
        buffer = self.next_free_node_id
        self.next_free_node_id += 1
        return buffer
