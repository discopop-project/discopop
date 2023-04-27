# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
from typing import Dict

import networkx as nx  # type: ignore
from sympy import Integer, Expr, Symbol, lambdify, plot  # type: ignore
from sympy.plotting import plot3d  # type: ignore

from discopop_explorer.PETGraphX import PETGraphX
from discopop_library.OptimizationGraph.PETParser.PETParser import PETParser
from discopop_library.OptimizationGraph.CostModels.utilities import get_performance_models_for_functions, \
    print_introduced_symbols_per_node
from discopop_library.OptimizationGraph.Variables.Environment import Environment
from discopop_library.OptimizationGraph.suggestions.importers.base import import_suggestions
from discopop_library.OptimizationGraph.utilities.MOGUtilities import show, data_at


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
        self.graph = import_suggestions(detection_result, self.graph, self.get_next_free_node_id, environment)
        # show(self.graph)

        function_performance_models = get_performance_models_for_functions(self.graph)

        # print_introduced_symbols_per_node(self.graph)

        print("FUNCTION PERFORMANCE MODELS: ")
        for idx, function in enumerate(function_performance_models):
            for midx, model in enumerate(function_performance_models[function]):
                print(str(idx) + "-" + str(midx) + ": \t", end="")
                model.print()

        # define variable substitutions
        substitutions: Dict[Symbol, Expr] = dict()
        # print_introduced_symbols_per_node(self.graph)
        # thread counts
        #substitutions[data_at(self.graph, 105).introduced_symbols[0]] = Integer(4)
        #substitutions[data_at(self.graph, 106).introduced_symbols[0]] = Integer(16)

        # function spawn overhead
        #substitutions[data_at(self.graph, 51).introduced_symbols[0]] = Integer(5)
        #substitutions[data_at(self.graph, 104).introduced_symbols[0]] = Integer(5)

        print("subs: ", substitutions)

        # apply substitutions
        for idx, function in enumerate(function_performance_models):
            for midx, model in enumerate(function_performance_models[function]):
                model.model = model.model.subs(substitutions)

        print("FUNCTION PERFORMANCE MODELS AFTER SUBSTITUTION: ")
        for idx, function in enumerate(function_performance_models):
            for midx, model in enumerate(function_performance_models[function]):
                print(str(idx) + "-" + str(midx) + ": \t", end="")
                model.print()
                print(model.model.free_symbols)
                try:
                    if len(model.model.free_symbols) == 2:
                        plot3d(model.model, (Symbol("transfer_cost"), 0, 500), (Symbol("thread_num"), 1, 128))
                    elif len(model.model.free_symbols) == 1:
                        plot(model, (Symbol("transfer_cost"), 0, 500))
                except ValueError:
                    pass



        print("COMPARE: ")
        for idx_1, function_1 in enumerate(function_performance_models):
            for midx_1, model_1 in enumerate(function_performance_models[function_1]):
                for idx_2, function_2 in enumerate(function_performance_models):
                    for midx_2, model_2 in enumerate(function_performance_models[function_2]):
                        cmp = model_1.model.compare(model_2.model)
                        print(str(idx_1) + "-" + str(midx_1), str(idx_2) + "-" + str(midx_2), " ==> ",
                              "<" if cmp == -1 else "="
                              if cmp == 0 else ">")

    def get_next_free_node_id(self):
        buffer = self.next_free_node_id
        self.next_free_node_id += 1
        return buffer
