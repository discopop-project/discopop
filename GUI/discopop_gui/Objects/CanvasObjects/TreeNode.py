# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

from typing import List, Dict, TYPE_CHECKING
import tkinter as tk

from discopop_gui.Enums.ViewerMode import ViewerMode

if TYPE_CHECKING:
    from discopop_gui.utils.TreeNode import TreeNode as BaseTreeNode
    from discopop_gui.Objects.Canvases.Viewables.WithTrees import WithTrees as ViewableCanvasWithTrees

class TreeNode:
    def __init__(self, canvas : "ViewableCanvasWithTrees", base_node : "BaseTreeNode", oval_id : int, text_id : int):
        self._base_node = base_node
        self._canvas = canvas
        self._oval_id : int = oval_id
        self._text_id : int = text_id
        self._total_higher_order_connections = 0
        self._lower_order_connections : List["TreeNode"] = []
        self._connection_edges : List[int] = []
        self._connections_shown : List[int] = []
        self._total_hide_requests : int = 0

        self._canvas.addtag_withtag("tree_node", self._oval_id)
        self._canvas.addtag_withtag("tree_node", self._text_id)
        self._canvas.tag_bind(self._oval_id, "<Button-1>", self._on_left_press)

    def _on_left_press(self, _ : tk.Event) -> None:
        if not (self._canvas.get_viewer_mode() == ViewerMode.MAIN):
            return
        
        if (len(self._base_node.dependency_connections) + len(self._base_node.lower_order_connections)) > len(self._lower_order_connections):
            existing_connection_ids = {node._base_node.id for node in self._lower_order_connections}

            for base_node_connection in self._base_node.lower_order_connections:
                if base_node_connection.id in existing_connection_ids:
                    continue

                self._canvas.create_visual_node(base_node_connection.id)

                edge_id = self._canvas.create_line(
                    self._base_node.metadata.get("x"),
                    self._base_node.metadata.get("y"),
                    base_node_connection.metadata.get("x"),
                    base_node_connection.metadata.get("y"),
                    fill="black",
                    width=1
                )

                self.add_lower_order_connection(base_node_connection.id, edge_id)

            for base_node_connection in self._base_node.dependency_connections:
                if base_node_connection.id in existing_connection_ids:
                    continue
                
                self._canvas.create_visual_node(base_node_connection.id)

                edge_id = self._canvas.create_line(
                    self._base_node.metadata.get("x"),
                    self._base_node.metadata.get("y"),
                    base_node_connection.metadata.get("x"),
                    base_node_connection.metadata.get("y"),
                    fill="red",
                    width=2,
                    arrow="last"
                )

                self.add_lower_order_connection(base_node_connection.id, edge_id)
        
        if len(self._connections_shown) < len(self._lower_order_connections):
            self._connections_shown = [i for i in range(len(self._lower_order_connections))]
            self.visualize_shown_connections()
        else:
            self.hide_connections()
            self._connections_shown = []
    
    def increment_higher_order_connections(self):
        self._total_higher_order_connections += 1

    def add_lower_order_connection(self, connection_id : int, edge_id : int) -> None:
        connection = self._canvas.get_visual_node(connection_id)
        self._lower_order_connections.append(connection)
        self._connection_edges.append(edge_id)
        self._canvas.addtag_withtag("tree_edge", edge_id)
        self._canvas.tag_lower("tree_edge", "tree_node")
        connection.increment_higher_order_connections()

    def visualize(self) -> None:
        self._canvas.itemconfigure(self._oval_id, state = "normal")
        self._canvas.itemconfigure(self._text_id, state = "normal")
        self._total_hide_requests = max(self._total_hide_requests - 1, 0)
        self.visualize_shown_connections()

    def visualize_shown_connections(self) -> None:
        for connection_id in self._connections_shown:
            self._canvas.itemconfigure(self._connection_edges[connection_id], state = "normal")
            self._lower_order_connections[connection_id].visualize()

    def hide(self) -> None:
        if self._total_hide_requests == self._total_higher_order_connections:
            return
        
        self._total_hide_requests += 1
        
        if self._total_hide_requests == self._total_higher_order_connections:
            self._canvas.itemconfigure(self._oval_id, state = "hidden")
            self._canvas.itemconfigure(self._text_id, state = "hidden")
            self.hide_connections()

    def hide_connections(self) -> None:
        for connection_id in self._connections_shown:
            self._canvas.itemconfigure(self._connection_edges[connection_id], state = "hidden")
            self._lower_order_connections[connection_id].hide()