# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
from random import randint
from time import sleep
from typing import Dict, Set, cast, List, Tuple

import networkx as nx  # type: ignore
import sympy  # type: ignore
from sympy import Integer, Expr, Symbol, lambdify, plot, Float, init_printing, simplify, diff  # type: ignore

# from sympy.plotting import plot3d  # type: ignore
from spb import plot3d, MB  # type: ignore

from discopop_library.OptimizationGraph.CostModels.DataTransfer.DataTransferCosts import (
    add_data_transfer_costs,
)
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

    def __init__(self, detection_result, project_folder_path):
        self.graph, self.next_free_node_id = PETParser(detection_result.pet).parse()
        # print("FINAL")
        # show(self.graph)

        # define Environment
        environment = Environment(project_folder_path)

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
        for function in function_performance_models:
            for model in function_performance_models[function]:
                free_symbols.update(cast(List[Symbol], model.model.free_symbols))
        sorted_free_symbols = sorted(list(free_symbols), key=lambda x: x.name)
        print("Free Symbols: ", sorted_free_symbols)
        # query user for values for free symbols
        for free_symbol in sorted_free_symbols:
            raw_symbol_value = input(
                "Insert value for: "
                + free_symbol.name
                + ":\nLeave empty to treat as a variable. \n\t"
            )
            if len(raw_symbol_value) == 0:
                start_value = input("Start value?: [1]")
                end_value = input("End value? : [128]")
                if len(start_value) != 0:
                    num_start_value = float(start_value)
                else:
                    num_start_value = float(1)
                if len(end_value) != 0:
                    num_end_value = float(end_value)
                else:
                    num_end_value = float(128)
                free_symbol_ranges[free_symbol] = (num_start_value, num_end_value)

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
                        if len(model.model.free_symbols) <= 2:
                            if combined_plot is None:
                                combined_plot = plot3d(
                                    model.model,
                                    (
                                        sorted_free_symbols[0],
                                        free_symbol_ranges[sorted_free_symbols[0]][0],
                                        free_symbol_ranges[sorted_free_symbols[0]][1],
                                    ),
                                    (
                                        sorted_free_symbols[1],
                                        free_symbol_ranges[sorted_free_symbols[1]][0],
                                        free_symbol_ranges[sorted_free_symbols[1]][1],
                                    ),
                                    show=False,
                                    backend=MB,
                                    label=str(model.path_decisions),
                                    zlabel="Costs",
                                )
                                combined_plot.title = function.name

                                shown_models.append((model.path_decisions, model.model))

                            else:
                                if randint(0, 1000) < 2:
                                    combined_plot.extend(
                                        plot3d(
                                            model.model,
                                            (
                                                sorted_free_symbols[0],
                                                free_symbol_ranges[sorted_free_symbols[0]][0],
                                                free_symbol_ranges[sorted_free_symbols[0]][1],
                                            ),
                                            (
                                                sorted_free_symbols[1],
                                                free_symbol_ranges[sorted_free_symbols[1]][0],
                                                free_symbol_ranges[sorted_free_symbols[1]][1],
                                            ),
                                            show=False,
                                            backend=MB,
                                            label=str(model.path_decisions),
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
