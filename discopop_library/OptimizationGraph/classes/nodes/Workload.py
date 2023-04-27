from typing import Optional

from discopop_library.OptimizationGraph.classes.nodes.GenericNode import GenericNode


class Workload(GenericNode):
    """This class represents a generic node in the Optimization Graph"""
    workload: Optional[int]

    def __init__(self, node_id: int, workload: Optional[int] = None):
        super().__init__(node_id)
        self.workload = workload

    def get_plot_label(self) -> str:
        if self.workload is not None:
            return str(self.workload)
        else:
            return "WL"
