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
from discopop_gui.Enums.EdgeTypes import EdgeTypes
from discopop_gui.utils.TreeNode import TreeNode as BaseTreeNode
from discopop_gui.Objects.CanvasItems.Popup import Popup

if TYPE_CHECKING:
    from discopop_gui.Objects.Canvases.Viewables.WithTrees import WithTrees as ViewableCanvasWithTrees

class TreeNode:
    def __init__(self, canvas : "ViewableCanvasWithTrees", base_node : BaseTreeNode, popup : Popup, oval_id : int, text_id : int):
        self._base_node = base_node
        self._canvas = canvas
        self._popup = popup
        self._oval_id : int = oval_id
        self._text_id : int = text_id
        self._higher_order_connections : Dict[int, int] = {}
        self._lower_order_connections : Dict[int, int] = {}
        self._higher_order_connections_shown : bool = False
        self._lower_order_connections_shown : bool = False
        self._higher_order_hide_requests : Set[int] = set()
        self._lower_order_hide_requests : Set[int] = set()

        self._canvas.addtag_withtag("tree_node", self._oval_id)
        self._canvas.addtag_withtag("tree_node", self._text_id)
        self._canvas.tag_bind(self._oval_id, "<Button-1>", self._on_left_press)
        self._canvas.tag_bind(self._oval_id, "<Button-3>", self._on_right_press)

    def _on_show_or_hide_higher_order(self, _ : tk.Event) -> str | None:
        if len(self._higher_order_connections) < len(self._base_node.higher_order_connections):
            for base_node_connection in self._base_node.higher_order_connections:
                if base_node_connection.id in self._higher_order_connections:
                    continue

                self._canvas.create_visual_node(base_node_connection.id, state = "hidden")

                if (self._base_node.id == base_node_connection_dependency for base_node_connection_dependency in base_node_connection.dependency_connections):
                    edge_id = self._canvas.create_visual_edge(base_node_connection.id, self._base_node.id, EdgeTypes.DEPENDENCY)
                else:
                    edge_id = self._canvas.create_visual_edge(base_node_connection.id, self._base_node.id, EdgeTypes.MAIN)

                connection = self._canvas.get_visual_node(base_node_connection.id)
                connection.add_lower_order_connection(self._base_node.id, edge_id)
                self._higher_order_connections[base_node_connection.id] = edge_id
                self._higher_order_hide_requests.add(base_node_connection.id)

            self._canvas.tag_lower("tree_edge", "tree_node")

        if len(self._higher_order_hide_requests) > 0:
            for connection_id in self._higher_order_hide_requests:
                self._canvas.get_visual_node(connection_id).set_lower_order_connections_shown(True)

            self.visualize_higher_order_connections()
            self._higher_order_connections_shown = True
        else:
            self.hide_higher_order_connections()
            self._higher_order_connections_shown = False

            for connection_id, edge_id in self._higher_order_connections.items():
                self._canvas.get_visual_node(connection_id).set_lower_order_connections_shown(False)

        return None

    def _on_left_press(self, _ : tk.Event) -> str | None:
        if not (self._canvas.get_viewer_mode() == ViewerMode.MAIN):
            return None
        
        if len(self._lower_order_connections) < (len(self._base_node.dependency_connections) + len(self._base_node.lower_order_connections)):
            for base_node_connection in self._base_node.lower_order_connections:
                if base_node_connection.id in self._lower_order_connections:
                    continue

                self._canvas.create_visual_node(base_node_connection.id, state = "hidden")
                edge_id = self._canvas.create_visual_edge(self._base_node.id, base_node_connection.id, EdgeTypes.MAIN)
                connection = self._canvas.get_visual_node(base_node_connection.id)
                connection.add_higher_order_connection(self._base_node.id, edge_id)
                self._lower_order_connections[base_node_connection.id] = edge_id
                self._lower_order_hide_requests.add(base_node_connection.id)

            for base_node_connection in self._base_node.dependency_connections:
                if base_node_connection.id in self._lower_order_connections:
                    continue
                
                self._canvas.create_visual_node(base_node_connection.id, state = "hidden")
                edge_id = self._canvas.create_visual_edge(self._base_node.id, base_node_connection.id, EdgeTypes.DEPENDENCY)
                connection = self._canvas.get_visual_node(base_node_connection.id)
                connection.add_higher_order_connection(self._base_node.id, edge_id)
                self._lower_order_connections[base_node_connection.id] = edge_id
                self._lower_order_hide_requests.add(base_node_connection.id)

            self._canvas.tag_lower("tree_edge", "tree_node")
        
        if len(self._lower_order_hide_requests) > 0:
            for connection_id in self._lower_order_hide_requests:
                    self._canvas.get_visual_node(connection_id).set_higher_order_connections_shown(True)

            self.visualize_lower_order_connections()
            self._lower_order_connections_shown = True
        else:
            self.hide_lower_order_connections()
            self._lower_order_connections_shown = False

            for connection_id, edge_id in self._lower_order_connections.items():
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
            if len(self._higher_order_hide_requests) > 0 or len(self._higher_order_connections) < len(self._base_node.higher_order_connections):
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
    
    def set_higher_order_connections_shown(self, shown : bool) -> None:
        if (shown == False) and (len(self._higher_order_hide_requests) < len(self._higher_order_connections)):
            return
        
        self._higher_order_connections_shown = shown

    def set_lower_order_connections_shown(self, shown : bool) -> None:
        if (shown == False) and (len(self._lower_order_hide_requests) < len(self._lower_order_connections)):
            return
        
        self._lower_order_connections_shown = shown
    
    def add_higher_order_connection(self, connection_id : int, edge_id : int) -> None:
        self._higher_order_connections[connection_id] = edge_id
        self._higher_order_hide_requests.add(connection_id)

    def add_lower_order_connection(self, connection_id : int, edge_id : int) -> None:
        self._lower_order_connections[connection_id] = edge_id
        self._lower_order_hide_requests.add(connection_id)

    def visualize_by_higher_order(self, higher_order_id : int) -> None:
        self._higher_order_hide_requests.remove(higher_order_id)
        self._canvas.itemconfigure(self._oval_id, state = "normal")
        self._canvas.itemconfigure(self._text_id, state = "normal")
        self._higher_order_connections_shown = True

        if (self._lower_order_connections_shown == True):
            self.visualize_lower_order_connections()

    def visualize_by_lower_order(self, lower_order_id : int) -> None:
        self._lower_order_hide_requests.remove(lower_order_id)
        self._canvas.itemconfigure(self._oval_id, state = "normal")
        self._canvas.itemconfigure(self._text_id, state = "normal")
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
            
            if (self._higher_order_connections_shown == True):
                self.hide_higher_order_connections()

    def visualize_higher_order_connections(self) -> None:
        for connection_id in self._higher_order_hide_requests:
            self._canvas.itemconfigure(self._higher_order_connections[connection_id], state = "normal")
            self._canvas.get_visual_node(connection_id).visualize_by_lower_order(self._base_node.id)
            
        self._higher_order_hide_requests = set()

    def visualize_lower_order_connections(self) -> None:
        for connection_id in self._lower_order_hide_requests:
            self._canvas.itemconfigure(self._lower_order_connections[connection_id], state = "normal")
            self._canvas.get_visual_node(connection_id).visualize_by_higher_order(self._base_node.id)
            
        self._lower_order_hide_requests = set()

    def hide_higher_order_connections(self) -> None:
        for connection_id, edge_id in self._higher_order_connections.items():
            if not (connection_id in self._higher_order_hide_requests):
                self._canvas.itemconfigure(edge_id, state = "hidden")
                self._canvas.get_visual_node(connection_id).hide_by_lower_order(self._base_node.id)
                self._higher_order_hide_requests.add(connection_id)

    def hide_lower_order_connections(self) -> None:
        for connection_id, edge_id in self._lower_order_connections.items():
            if not (connection_id in self._lower_order_hide_requests):
                self._canvas.itemconfigure(edge_id, state = "hidden")
                self._canvas.get_visual_node(connection_id).hide_by_higher_order(self._base_node.id)
                self._lower_order_hide_requests.add(connection_id)

    def recursive_copy_to_canvas(
        self,
        canvas : "ViewableCanvasWithTrees",
        higher_order_connection_id : int| None = None,
        higher_order_edge_id : int | None = None
    ) -> None:
        state = "normal"

        if (
            higher_order_connection_id and
            higher_order_edge_id and
            len(self._higher_order_hide_requests) == len(self._higher_order_connections) and
            len(self._lower_order_hide_requests) == len(self._lower_order_connections)
        ):
            state = "hidden"

        created = canvas.create_visual_node(self._base_node.id, state)
        cloned_node = canvas.get_visual_node(self._base_node.id)

        if higher_order_connection_id and higher_order_edge_id:
            canvas.tag_lower("tree_edge", "tree_node")

            if created:
                cloned_node._higher_order_connections_shown = self._higher_order_connections_shown

            cloned_node._higher_order_connections[higher_order_connection_id] = higher_order_edge_id

            if (higher_order_connection_id in self._higher_order_hide_requests):
                cloned_node._higher_order_hide_requests.add(higher_order_connection_id)

        if created:
            cloned_node._lower_order_connections = self._lower_order_connections.copy()
            cloned_node._lower_order_connections_shown = self._lower_order_connections_shown
            cloned_node._lower_order_hide_requests = self._lower_order_hide_requests.copy()

            for connection_id, edge_id in self._lower_order_connections.items():
                cloned_edge_id = self._canvas.clone_item_to_canvas(canvas, edge_id)
                cloned_node._lower_order_connections[connection_id] = cloned_edge_id
                self._canvas.get_visual_node(connection_id).recursive_copy_to_canvas(canvas, self._base_node.id, cloned_edge_id)