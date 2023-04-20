from typing import Optional, List

from sympy import Symbol, Function  # type: ignore

from discopop_explorer.PETGraphX import NodeID
from discopop_library.OptimizationGraph.PerformanceModels.CostModel import CostModel


class GenericNode(object):
    node_id: int  # id of the node in the nx.DiGraph which stores this object
    ## Performance modelling
    introduced_symbols: List[Symbol]
    performance_model: CostModel

    def __init__(self, node_id: int, cu_id: Optional[NodeID] = None):
        self.node_id = node_id
        self.cu_id = cu_id
        self.introduced_symbols = []
        self.performance_model = CostModel("dummy", Function("dummy"))

    def get_plot_label(self) -> str:
        return ""

    def get_hover_text(self) -> str:
        return ""

    def get_cost_model(self) -> CostModel:
        raise NotImplementedError("Implementation needs to be provided by derived class: !", type(self))
