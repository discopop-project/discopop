# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import tkinter as tk
from typing import Any, List

from discopop_gui.Enums.ViewerMode import ViewerMode
from discopop_gui.Objects.Canvases.Viewables.Viewable import Viewable as ViewableCanvas
from discopop_gui.Objects.CanvasObjects.TreeNode import TreeNode

class WithTrees(ViewableCanvas):
    def __init__(self, parent: tk.Misc, viewer_mode: ViewerMode, *args: Any, **kwargs: Any) -> None:
        super().__init__(parent, viewer_mode, *args, **kwargs)
        self._nodes : List[TreeNode] = []

    def get_tree_node(self, id : int) -> TreeNode:
        return self._nodes[id]
    
    def create_node(self, x : float, y : float, label : str, fill_color: str) -> int:
        node_radius = 40

        oval_id = self.create_oval(
            x - node_radius,
            y - node_radius,
            x + node_radius,
            y + node_radius,
            fill = fill_color,
            outline = "black",
        )

        text_id = self.create_text(
            x,
            y,
            text = label,
            font = ("Arial", 7),
            anchor = "center",
        )

        self._nodes.append(TreeNode(self, oval_id, text_id))
        return len(self._nodes) - 1
    
    def add_dependency(self, source_node_id : int, destination_node_id : int, *args: Any, **kwargs: Any) -> None:
        edge_id = self.create_line(*args, **kwargs)
        self._nodes[source_node_id].add_child(self._nodes[destination_node_id], edge_id)
        self._nodes[destination_node_id].add_child(self._nodes[source_node_id], edge_id)