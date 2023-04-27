from typing import Optional

from discopop_explorer.PETGraphX import NodeID
from discopop_library.OptimizationGraph.classes.nodes.ContextNode import ContextNode


class ContextSave(ContextNode):

    def __init__(self, node_id: int):
        super().__init__(node_id)

    def get_plot_label(self) -> str:
        return str(self.node_id) + "\nCTX\nsave"