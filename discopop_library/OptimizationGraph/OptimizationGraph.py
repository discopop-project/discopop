import networkx as nx  # type: ignore


from discopop_explorer.PETGraphX import PETGraphX
from discopop_library.OptimizationGraph.PETParser.PETParser import PETParser
from discopop_library.OptimizationGraph.utilities.MOGUtilities import show


class OptimizationGraph(object):
    graph: nx.DiGraph

    def __init__(self, pet: PETGraphX):
        self.graph = PETParser(pet).parse()
        print("FINAL")
        show(self.graph)
