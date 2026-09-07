from typing import Generic

from discopop_gui.Types.T import T
from discopop_gui.Objects.CanvasItems.TreeEdges.Base import Base

class Main(Base[T], Generic[T]):
    def __init__(self, canvas_edge_id: int, source_node_id: T, target_node_id: T):
        super().__init__(source_node_id, target_node_id)
        self._canvas_edge_id = canvas_edge_id

    def get_canvas_edge_id(self) -> int:
        return self._canvas_edge_id