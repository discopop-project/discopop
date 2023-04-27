from typing import Dict

import networkx as nx  # type: ignore
from sympy import Integer, Expr, Symbol  # type: ignore

from discopop_explorer.PETGraphX import PETGraphX
from discopop_library.OptimizationGraph.PETParser.PETParser import PETParser
from discopop_library.OptimizationGraph.CostModels.utilities import get_performance_models_for_functions, \
    print_introduced_symbols_per_node
from discopop_library.OptimizationGraph.suggestions.importers.base import import_suggestions
from discopop_library.OptimizationGraph.utilities.MOGUtilities import show, data_at


class OptimizationGraph(object):
    graph: nx.DiGraph
    next_free_node_id: int

    def __init__(self, detection_result):
        self.graph, self.next_free_node_id = PETParser(detection_result.pet).parse()
        #print("FINAL")
        #show(self.graph)

        # import parallelization suggestions
        self.graph = import_suggestions(detection_result, self.graph, self.get_next_free_node_id)
        show(self.graph)

        function_performance_models = get_performance_models_for_functions(self.graph)

        print_introduced_symbols_per_node(self.graph)

        print("FUNCTION PERFORMANCE MODELS: ")
        for idx, function in enumerate(function_performance_models):
            for midx, model in enumerate(function_performance_models[function]):
                print(str(idx)+"-"+str(midx) + ": \t", end="")
                model.print()

        print("COMPARE: ")
        for idx_1, function_1 in enumerate(function_performance_models):
            for midx_1, model_1 in enumerate(function_performance_models[function_1]):
                for idx_2, function_2 in enumerate(function_performance_models):
                    for midx_2, model_2 in enumerate(function_performance_models[function_2]):
                        print(str(idx_1)+"-"+str(midx_1), str(idx_2)+"-"+str(midx_2), " ==> ", model_1.model.compare(model_2.model))

        # define variable substitutions
        substitutions: Dict[Symbol, Expr] = dict()
        substitutions[data_at(self.graph, 105).introduced_symbols[0]] = Integer(42)
        print("subs: ", substitutions)

        # apply substitutions
        print_introduced_symbols_per_node(self.graph)
        print("FUNCTION PERFORMANCE MODELS AFTER SUBSTITUTION: ")
        for idx, function in enumerate(function_performance_models):
            for midx, model in enumerate(function_performance_models[function]):
                print(str(idx) + "-" + str(midx) + ": \t", end="")
                model.model = model.model.subs(substitutions)
                model.print()




    def get_next_free_node_id(self):
        buffer = self.next_free_node_id
        self.next_free_node_id += 1
        return buffer

