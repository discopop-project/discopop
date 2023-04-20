from sympy import Symbol  # type: ignore

from discopop_library.OptimizationGraph.PerformanceModels.CostModel import CostModel
from discopop_library.OptimizationGraph.classes.edges.GenericEdge import GenericEdge


class SuccessorEdge(GenericEdge):
    pass

    def get_cost_model(self) -> CostModel:
        # todo this is only a dummy, not a finished model!
        transfer_cost = Symbol("transfer_cost")
        return CostModel(transfer_cost)
