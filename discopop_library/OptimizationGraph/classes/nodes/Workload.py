from typing import Optional

from sympy import Integer  # type: ignore

from discopop_explorer.PETGraphX import NodeID
from discopop_library.OptimizationGraph.CostModels.CostModel import CostModel
from discopop_library.OptimizationGraph.classes.nodes.GenericNode import GenericNode


class Workload(GenericNode):
    """This class represents a generic node in the Optimization Graph"""
    workload: Optional[int]

    def __init__(self, node_id: int, cu_id: Optional[NodeID], workload: Optional[int] = None):
        super().__init__(node_id, cu_id)
        self.workload = workload

    def get_plot_label(self) -> str:
        if self.workload is not None:
            #return str(self.workload)
            return str(self.node_id)
        else:
            return "WL"

    def get_hover_text(self) -> str:
        return "WL: " + str(self.workload)

    def get_cost_model(self) -> CostModel:
        """Performance model of a workload consists of the workload itself"""
        if self.workload is None:
            return CostModel(Integer(0))
        else:
            return CostModel(Integer(self.workload))