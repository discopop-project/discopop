from sympy import Integer  # type: ignore

from discopop_library.OptimizationGraph.CostModels.CostModel import CostModel


class GenericEdge(object):
    pass

    def get_cost_model(self) -> CostModel:
        return CostModel(Integer(0))
