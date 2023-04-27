from typing import Optional

from discopop_explorer.PETGraphX import NodeID
from discopop_library.OptimizationGraph.classes.nodes.Workload import Workload


class FunctionRoot(Workload):
    name: str

    def __init__(self, node_id: int, cu_id: Optional[NodeID], name: str):
        super().__init__(node_id, cu_id)
        self.name = name

    def get_plot_label(self) -> str:
        return self.name