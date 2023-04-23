import networkx as nx  # type: ignore


from discopop_explorer.PETGraphX import PETGraphX
from discopop_library.OptimizationGraph.PETParser.PETParser import PETParser
from discopop_library.OptimizationGraph.CostModels.utilities import get_performance_models_for_functions, \
    print_introduced_symbols_per_node
from discopop_library.OptimizationGraph.utilities.MOGUtilities import show


class OptimizationGraph(object):
    graph: nx.DiGraph

    def __init__(self, pet: PETGraphX):
        self.graph = PETParser(pet).parse()
        print("FINAL")
        show(self.graph)
        function_performance_models = get_performance_models_for_functions(self.graph)
        print_introduced_symbols_per_node(self.graph)

        print("FUNCTION PERFORMANCE MODELS: ")
        for idx, function in enumerate(function_performance_models):
            print(str(idx) + ": \t", end="")
            function_performance_models[function].print()

        print("COMPARE: ")
        for idx_1, function_1 in enumerate(function_performance_models):
            for idx_2, function_2 in enumerate(function_performance_models):
                print(idx_1, idx_2, " ==> ", function_performance_models[function_1].model.compare(function_performance_models[function_2].model))

        # import parallelization suggestions
        

