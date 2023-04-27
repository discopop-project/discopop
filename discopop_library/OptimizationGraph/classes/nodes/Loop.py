from typing import Optional

from sympy import Symbol  # type: ignore

from discopop_explorer.PETGraphX import NodeID
from discopop_library.OptimizationGraph.CostModels.CostModel import CostModel
from discopop_library.OptimizationGraph.classes.nodes.Workload import Workload


class Loop(Workload):
    iterations: int

    def __init__(self, node_id: int, cu_id: Optional[NodeID], workload: int, iterations: int):
        super().__init__(node_id, cu_id, workload=workload)
        self.iterations = iterations

    # todo: note: it might be more beneficial to use the iterations "per entry" instead of the total amount of iterations
    # example:
    # for(100)      --> use 100
    #   for(100)    --> use 100 instead of 10000

    def get_hover_text(self) -> str:
        return "WL: " + str(self.workload) + "\n" + \
            "IT: " + str(self.iterations)
