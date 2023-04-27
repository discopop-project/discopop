from typing import Optional

from discopop_explorer.PETGraphX import NodeID


class GenericNode(object):
    node_id: int  # id of the node in the nx.DiGraph which stores this object

    def __init__(self, node_id: int, cu_id: Optional[NodeID] = None):
        self.node_id = node_id
        self.cu_id = cu_id

    def get_plot_label(self) -> str:
        return ""

    def get_hover_text(self) -> str:
        return ""
