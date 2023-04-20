import networkx as nx  # type: ignore


from discopop_explorer.PETGraphX import PETGraphX
from discopop_library.OptimizationGraph.PETParser.PETParser import PETParser
from discopop_library.OptimizationGraph.PerformanceModels.utilities import get_performance_models_for_functions, \
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
        for function in function_performance_models:
            function_performance_models[function].print()

