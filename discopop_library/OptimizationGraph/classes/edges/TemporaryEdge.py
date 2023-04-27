from discopop_library.OptimizationGraph.classes.edges.GenericEdge import GenericEdge
from discopop_library.OptimizationGraph.classes.edges.SuccessorEdge import SuccessorEdge


class TemporaryEdge(GenericEdge):
    pass

    def convert_to_successor_edge(self) -> SuccessorEdge:
        return SuccessorEdge()