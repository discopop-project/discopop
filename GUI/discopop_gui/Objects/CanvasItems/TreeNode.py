# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

from typing import Tuple, Dict, Set, TYPE_CHECKING
import tkinter as tk

from discopop_gui.Enums.ViewerMode import ViewerMode
from discopop_gui.Enums.EdgeType import EdgeType
from discopop_gui.utils.TreeNode import TreeNode as BaseTreeNode
from discopop_gui.Objects.CanvasItems.Popup import Popup

if TYPE_CHECKING:
    from discopop_gui.Objects.Canvases.Viewables.WithTrees import WithTrees as ViewableCanvasWithTrees

class TreeNode:
    def __init__(self, canvas : "ViewableCanvasWithTrees", base_node : BaseTreeNode, highest : bool, visible : bool, popup : Popup, oval_id : int, text_id : int, x_offset : int, y_offset : int):
        self._base_node = base_node
        self._highest = highest
        self._visible = visible
        self._canvas = canvas
        self._popup = popup
        self._oval_id : int = oval_id
        self._text_id : int = text_id
        self._higher_order_connections : Dict[int, Tuple[int, EdgeType]] = {}
        self._lower_order_connections : Dict[int, Tuple[int, EdgeType]] = {}
        self._higher_order_connections_shown : bool = False
        self._lower_order_connections_shown : bool = False
        self._higher_order_hide_requests : Set[int] = set()
        self._lower_order_hide_requests : Set[int] = set()
        self._connection_offsets : Dict[int, int] = {}
        self._x_offset : int = x_offset
        self._y_offset : int = y_offset

        self._canvas.addtag_withtag("tree_node", self._oval_id)
        self._canvas.addtag_withtag("tree_node", self._text_id)
        self._canvas.tag_bind(self._oval_id, "<Button-1>", self._on_left_press)
        self._canvas.tag_bind(self._oval_id, "<Button-3>", self._on_right_press)

    def _on_show_or_hide_higher_order(self, _ : tk.Event) -> str | None:
        if len(self._higher_order_connections) < len(self._base_node.higher_order_connections):
            for base_node_connection, edge_type in self._base_node.higher_order_connections:
                if base_node_connection.id in self._higher_order_connections:
                    continue

                self._canvas.create_visual_node(base_node_connection.id, self._highest, state = "hidden")
                self._highest = False
                edge_id = self._canvas.create_visual_edge(base_node_connection.id, self._base_node.id, edge_type)
                connection = self._canvas.get_visual_node(base_node_connection.id)
                connection.add_lower_order_connection(self._base_node.id, edge_id, edge_type)
                self._higher_order_connections[base_node_connection.id] = (edge_id, edge_type)
                self._higher_order_hide_requests.add(base_node_connection.id)

            self._canvas.tag_lower("tree_edge", "tree_node")

        if len(self._higher_order_hide_requests) > 0:
            self.visualize_higher_order_connections()
            self._higher_order_connections_shown = True
        else:
            self.hide_higher_order_connections()
            self._higher_order_connections_shown = False

            for connection_id, __ in self._higher_order_connections.items():
                self._canvas.get_visual_node(connection_id).set_lower_order_connections_shown(False)

        return None

    def _on_left_press(self, _ : tk.Event) -> str | None:
        if not (self._canvas.get_viewer_mode() == ViewerMode.MAIN):
            return None
        
        if len(self._lower_order_connections) < len(self._base_node.lower_order_connections):
            for base_node_connection, edge_type in self._base_node.lower_order_connections:
                if base_node_connection.id in self._lower_order_connections:
                    continue

                self._canvas.create_visual_node(base_node_connection.id, False, state = "hidden")
                edge_id = self._canvas.create_visual_edge(self._base_node.id, base_node_connection.id, edge_type)
                connection = self._canvas.get_visual_node(base_node_connection.id)
                connection.add_higher_order_connection(self._base_node.id, edge_id, edge_type)
                self._lower_order_connections[base_node_connection.id] = (edge_id, edge_type)
                self._lower_order_hide_requests.add(base_node_connection.id)

            self._canvas.tag_lower("tree_edge", "tree_node")
        
        if len(self._lower_order_hide_requests) > 0:
            self.visualize_lower_order_connections()
            self._lower_order_connections_shown = True
        else:
            self.hide_lower_order_connections()
            self._lower_order_connections_shown = False

            for connection_id, __ in self._lower_order_connections.items():
                self._canvas.get_visual_node(connection_id).set_higher_order_connections_shown(False)

        return None

    def _on_new_canvas(self, _ : tk.Event) -> str | None:
        self._canvas.add_clone_to_canvas_viewer(self._base_node.id)
        return None

    def _on_right_press(self, event : tk.Event) -> str | None:
        if not (self._canvas.get_viewer_mode() == ViewerMode.MAIN):
            return None
        
        self._popup.clear_buttons()

        if len(self._base_node.higher_order_connections) > 0:
            if (len(self._higher_order_hide_requests) > 0) or (len(self._higher_order_connections) < len(self._base_node.higher_order_connections)):
                self._popup.add_button("Show higher order", self._on_show_or_hide_higher_order)
            else:
                self._popup.add_button("Hide higher order", self._on_show_or_hide_higher_order)
            
        self._popup.add_button("New canvas", self._on_new_canvas)
        x = self._canvas.canvasx(event.x)
        y = self._canvas.canvasy(event.y)
        self._popup.visualize(x, y)
        return None

    def get_id(self) -> int:
        return self._base_node.id
    
    def get_location(self) -> Tuple[float, float]:
        return (self._base_node.metadata["x"], self._base_node.metadata["y"])
    
    def set_highest(self, value : bool) -> None:
        self._highest = value
    
    def set_higher_order_connections_shown(self, shown : bool) -> None:
        if (shown == False) and (len(self._higher_order_hide_requests) < len(self._higher_order_connections)):
            return
        
        self._higher_order_connections_shown = shown

    def set_lower_order_connections_shown(self, shown : bool) -> None:
        if (shown == False) and (len(self._lower_order_hide_requests) < len(self._lower_order_connections)):
            return
        
        self._lower_order_connections_shown = shown
    
    def add_higher_order_connection(self, connection_id : int, edge_id : int, edge_type : EdgeType) -> None:
        self._higher_order_connections[connection_id] = (edge_id, edge_type)
        self._higher_order_hide_requests.add(connection_id)

    def add_lower_order_connection(self, connection_id : int, edge_id : int, edge_type : EdgeType) -> None:
        self._lower_order_connections[connection_id] = (edge_id, edge_type)
        self._lower_order_hide_requests.add(connection_id)

    def visualize_by_higher_order(self, higher_order_id : int) -> None:
        self._higher_order_hide_requests.remove(higher_order_id)
        self._canvas.itemconfigure(self._oval_id, state = "normal")
        self._canvas.itemconfigure(self._text_id, state = "normal")
        self._visible = True
        self._higher_order_connections_shown = True

        if (self._lower_order_connections_shown == True):
            self.visualize_lower_order_connections()

    def visualize_by_lower_order(self, lower_order_id : int) -> None:
        self._lower_order_hide_requests.remove(lower_order_id)
        self._canvas.itemconfigure(self._oval_id, state = "normal")
        self._canvas.itemconfigure(self._text_id, state = "normal")
        self._visible = True
        self._lower_order_connections_shown = True

        if (self._higher_order_connections_shown == True):
            self.visualize_higher_order_connections()

    def hide_by_higher_order(self, higher_order_id : int) -> None:
        _ = self._higher_order_connections[higher_order_id]

        if higher_order_id in self._higher_order_hide_requests:
            return
        
        self._higher_order_hide_requests.add(higher_order_id)
        
        if (
            len(self._higher_order_hide_requests) == len(self._higher_order_connections)
        ):
            self._canvas.itemconfigure(self._oval_id, state = "hidden")
            self._canvas.itemconfigure(self._text_id, state = "hidden")
            self._visible = False

            if (self._lower_order_connections_shown == True):
                self.hide_lower_order_connections()

    def hide_by_lower_order(self, lower_order_id : int) -> None:
        _ = self._lower_order_connections[lower_order_id]

        if lower_order_id in self._lower_order_hide_requests:
            return
        
        self._lower_order_hide_requests.add(lower_order_id)
        
        if (
            len(self._lower_order_hide_requests) == len(self._lower_order_connections)
        ):
            self._canvas.itemconfigure(self._oval_id, state = "hidden")
            self._canvas.itemconfigure(self._text_id, state = "hidden")
            self._visible = False
            
            if (self._higher_order_connections_shown == True):
                self.hide_higher_order_connections()

    def visualize_higher_order_connections(self) -> None:
        for connection_id in self._higher_order_hide_requests:
            self._canvas.itemconfigure(self._higher_order_connections[connection_id][0], state = "normal")
            self._canvas.get_visual_node(connection_id).visualize_by_lower_order(self._base_node.id)
            
        self._higher_order_hide_requests = set()

    def visualize_lower_order_connections(self) -> None:
        for connection_id in self._lower_order_hide_requests:
            self._canvas.itemconfigure(self._lower_order_connections[connection_id][0], state = "normal")
            self._canvas.get_visual_node(connection_id).visualize_by_higher_order(self._base_node.id)
            
        self._lower_order_hide_requests = set()

    def hide_higher_order_connections(self) -> None:
        for connection_id, edge in self._higher_order_connections.items():
            if not (connection_id in self._higher_order_hide_requests):
                self._canvas.itemconfigure(edge[0], state = "hidden")
                self._canvas.get_visual_node(connection_id).hide_by_lower_order(self._base_node.id)
                self._higher_order_hide_requests.add(connection_id)

    def hide_lower_order_connections(self) -> None:
        for connection_id, edge in self._lower_order_connections.items():
            if not (connection_id in self._lower_order_hide_requests):
                self._canvas.itemconfigure(edge[0], state = "hidden")
                self._canvas.get_visual_node(connection_id).hide_by_higher_order(self._base_node.id)
                self._lower_order_hide_requests.add(connection_id)

    def recursive_copy_to_canvas(
        self,
        canvas : "ViewableCanvasWithTrees",
        higher_order_connection_id : int| None = None,
        higher_order_edge : Tuple[int, EdgeType] | None = None
    ) -> None:
        state : str = "normal" if self._visible else "hidden"
        created = canvas.create_visual_node(self._base_node.id, True if higher_order_connection_id else False, state)
        cloned_node = canvas.get_visual_node(self._base_node.id)

        if higher_order_connection_id is not None and higher_order_edge is not None:
            canvas.tag_lower("tree_edge", "tree_node")

            if created:
                cloned_node._higher_order_connections_shown = self._higher_order_connections_shown

            cloned_node._higher_order_connections[higher_order_connection_id] = higher_order_edge

            if (higher_order_connection_id in self._higher_order_hide_requests):
                cloned_node._higher_order_hide_requests.add(higher_order_connection_id)

        if created:
            cloned_node._lower_order_connections = self._lower_order_connections.copy()
            cloned_node._lower_order_connections_shown = self._lower_order_connections_shown
            cloned_node._lower_order_hide_requests = self._lower_order_hide_requests.copy()

            for connection_id, edge in self._lower_order_connections.items():
                cloned_edge_id = self._canvas.clone_item_to_canvas(canvas, edge[0])
                cloned_edge = (cloned_edge_id, edge[1])
                cloned_node._lower_order_connections[connection_id] = cloned_edge
                self._canvas.get_visual_node(connection_id).recursive_copy_to_canvas(canvas, self._base_node.id, cloned_edge)