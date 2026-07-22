# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

from typing import List, Tuple, Dict, Set, TYPE_CHECKING
import tkinter as tk

from discopop_gui.Constants import TREE_NODES_SPACING, TREE_NODE_RADIUS
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
        self._lower_order_x_offset_data : Dict[int, Tuple[int, int, int]] = {}
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

                self._canvas.create_visual_node(base_node_connection.id, self._highest, state = "hidden", x_offset = self._x_offset, y_offset = self._y_offset - 1)
                edge_id = self._canvas.create_visual_edge(base_node_connection.id, self._base_node.id, edge_type)
                connection = self._canvas.get_visual_node(base_node_connection.id)
                connection.add_lower_order_connection(self._base_node.id, edge_id, edge_type)
                self._higher_order_connections[base_node_connection.id] = (edge_id, edge_type)
                self._higher_order_hide_requests.add(base_node_connection.id)

            self._canvas.tag_lower("tree_edge", "tree_node")

        if len(self._higher_order_hide_requests) > 0:
            self.visualize_higher_order_connections()
            self._higher_order_connections_shown = True
            highest_visible_id = self.get_highest_visible()
            current_highest_id = self.get_current_highest()

            if highest_visible_id is None or current_highest_id is None:
                raise ValueError("No highest or visible nodes found when showing or hiding higher order connections.")
            
            if highest_visible_id != current_highest_id:
                index = self._canvas.remove_highest_visual_node_id(current_highest_id)
                self._canvas.get_visual_node(current_highest_id).set_highest(False)
                self._canvas.add_highest_visual_node_id(highest_visible_id, index)
                self._canvas.get_visual_node(highest_visible_id).set_highest(True)
        else:
            self.hide_higher_order_connections()
            self._higher_order_connections_shown = False

            for connection_id, __ in self._higher_order_connections.items():
                self._canvas.get_visual_node(connection_id).set_lower_order_connections_shown(False)

            if self._highest == True:
                self._canvas.update_highest_visual_nodes()
        
        return None

    def _on_left_press(self, _ : tk.Event) -> str | None:
        if not (self._canvas.get_viewer_mode() == ViewerMode.MAIN):
            return None
        
        if len(self._lower_order_connections) < len(self._base_node.lower_order_connections):
            old_main_connection_ids = [connection_id for connection_id, edge in self._lower_order_connections.items() if edge[1] == EdgeType.MAIN]
            new_main_connection_ids : List[int] = []

            for base_node_connection, edge_type in self._base_node.lower_order_connections:
                if base_node_connection.id in self._lower_order_connections:
                    continue

                highest = False

                if edge_type == EdgeType.MAIN:
                    new_main_connection_ids.append(base_node_connection.id)
                elif edge_type == EdgeType.DEPENDENCY and not self._canvas.check_visual_node(base_node_connection.id):
                    highest = True

                self._canvas.create_visual_node(base_node_connection.id, highest, state = "hidden", y_offset = self._y_offset + 1)
                edge_id = self._canvas.create_visual_edge(self._base_node.id, base_node_connection.id, edge_type)
                connection = self._canvas.get_visual_node(base_node_connection.id)
                connection.add_higher_order_connection(self._base_node.id, edge_id, edge_type)
                self._lower_order_connections[base_node_connection.id] = (edge_id, edge_type)
                self._lower_order_hide_requests.add(base_node_connection.id)

            self._canvas.tag_lower("tree_edge", "tree_node")
            left_offset = -((len(new_main_connection_ids) + len(old_main_connection_ids) - 1) // 2)

            for connection_id in old_main_connection_ids:
                self._lower_order_x_offset_data[connection_id] = (self._lower_order_x_offset_data[connection_id][0] + left_offset, self._lower_order_x_offset_data[connection_id][1], self._lower_order_x_offset_data[connection_id][2])
                left_offset += 1

            right_offset = left_offset if not old_main_connection_ids else self._lower_order_x_offset_data[old_main_connection_ids[-1]][0] + self._lower_order_x_offset_data[old_main_connection_ids[-1]][2] + 1

            for connection_id in new_main_connection_ids:
                self._lower_order_x_offset_data[connection_id] = (right_offset, 0, 0)
                right_offset += 1
            

        if len(self._lower_order_hide_requests) > 0:
            self.visualize_lower_order_connections()
            self._lower_order_connections_shown = True
        else:
            self.hide_lower_order_connections()
            self._lower_order_connections_shown = False

            for connection_id, __ in self._lower_order_connections.items():
                self._canvas.get_visual_node(connection_id).set_higher_order_connections_shown(False)

        self.set_offset_by_higher_order(self._x_offset, self._y_offset)

        if self._highest == False:
            for connection_id, edge in self._higher_order_connections.items():
                if not edge[1] == EdgeType.MAIN:
                    continue

                space_needed = self.get_x_space_needed()

                if space_needed is not None:
                    self._canvas.get_visual_node(connection_id).request_x_space_by_lower_order(self._base_node.id, space_needed)
        else:
            space_needed = self.get_x_space_needed()

            if space_needed is not None:
                self._canvas.request_x_space(self._base_node.id, space_needed)

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
    
    def get_visible(self) -> bool:
        return self._visible
    
    def get_location(self) -> Tuple[float, float]:
        return (self._x_offset * TREE_NODES_SPACING, self._y_offset * TREE_NODES_SPACING)
    
    def get_current_highest(self) -> int | None:
        if self._highest:
            return self._base_node.id
        
        for connection_id, edge in self._higher_order_connections.items():
            if not edge[1] == EdgeType.MAIN:
                continue

            connection = self._canvas.get_visual_node(connection_id)
            connection_value = connection.get_current_highest()

            if connection_value is not None:
                return connection_value
        
        return None

    def get_highest_visible(self) -> int | None:
        value = None

        if self._visible == True:
            value = self._base_node.id

        for connection_id, edge in self._higher_order_connections.items():
            if not edge[1] == EdgeType.MAIN:
                continue

            connection = self._canvas.get_visual_node(connection_id)
            connection_value = connection.get_highest_visible()

            if connection_value is not None:
                value = connection_value

        return value
    
    def get_x_space_needed(self) -> Tuple[int, int] | None:
        space_needed_left = 0
        space_needed_right = 0
        left_set = False

        for connection_id, x_offset_data in self._lower_order_x_offset_data.items():
            if not self._lower_order_connections[connection_id][1] == EdgeType.MAIN:
                continue
            
            connection = self._canvas.get_visual_node(connection_id)
            space_needed = connection.get_x_space_needed()

            if space_needed is None:
                continue
            
            if left_set == False:
                space_needed_left = space_needed[0] + abs(x_offset_data[0])
                left_set = True
            
            space_needed_right = space_needed[1] + abs(x_offset_data[0])

        if left_set == False and self._visible == False:
            return None
        
        return (space_needed_left, space_needed_right)
    
    def set_highest(self, value : bool) -> None:
        self._highest = value
    
    def update_highest_by_higher_order(self, index : int | None = None) -> None:
        if self._visible == True and self._highest == True:
            return
        elif self._visible == False and self._highest == True:
            self._highest = False
            index = self._canvas.remove_highest_visual_node_id(self._base_node.id)
        elif index is None:
            raise ValueError("Index must be provided when setting highest by higher order when node is not highest.")
        elif self._visible == True and self._highest == False:
            self._highest = True
            self._canvas.add_highest_visual_node_id(self._base_node.id, index)
            return
        
        for connection_id, edge in self._lower_order_connections.items():
            if not edge[1] == EdgeType.MAIN:
                continue
            
            self._canvas.get_visual_node(connection_id).update_highest_by_higher_order(index)

    def set_offset_by_higher_order(self, x_offset : int | None = None, y_offset : int | None = None, not_to_set : int | None = None) -> None:
        if x_offset is None:
            x_offset = self._x_offset

        if y_offset is None:
            y_offset = self._y_offset

        if self._visible == True:
            self._x_offset = x_offset
            self._y_offset = y_offset
            self._canvas.coords_unscaled(self._oval_id, x_offset * TREE_NODES_SPACING - TREE_NODE_RADIUS, y_offset * TREE_NODES_SPACING - TREE_NODE_RADIUS, x_offset * TREE_NODES_SPACING + TREE_NODE_RADIUS, y_offset * TREE_NODES_SPACING + TREE_NODE_RADIUS)
            self._canvas.coords_unscaled(self._text_id, x_offset * TREE_NODES_SPACING, y_offset * TREE_NODES_SPACING)

        for connection_id, x_offset_data in self._lower_order_x_offset_data.items():
            if connection_id == not_to_set:
                continue

            edge = self._lower_order_connections[connection_id]
            y_offset_increase = 1 if self._visible == True else 0
            self._canvas.get_visual_node(connection_id).set_offset_by_higher_order(x_offset + x_offset_data[0], y_offset + y_offset_increase)

            if self._visible == True:
                self._canvas.coords_unscaled(edge[0], x_offset * TREE_NODES_SPACING, y_offset * TREE_NODES_SPACING, (x_offset + x_offset_data[0]) * TREE_NODES_SPACING, (y_offset + y_offset_increase) * TREE_NODES_SPACING)

        for connection_id, edge in self._higher_order_connections.items():
            if edge[1] == EdgeType.DEPENDENCY and self._visible == True:
                self._canvas.coords_unscaled(edge[0], self._canvas.get_visual_node(connection_id).get_location()[0], self._canvas.get_visual_node(connection_id).get_location()[1], x_offset * TREE_NODES_SPACING, y_offset * TREE_NODES_SPACING)

        for connection_id, edge in self._lower_order_connections.items():
            if edge[1] == EdgeType.DEPENDENCY and self._visible == True:
                self._canvas.coords_unscaled(edge[0], x_offset * TREE_NODES_SPACING, y_offset * TREE_NODES_SPACING, self._canvas.get_visual_node(connection_id).get_location()[0], self._canvas.get_visual_node(connection_id).get_location()[1])
    
    def request_x_space_by_lower_order(self, lower_order_id : int, space_needed : Tuple[int, int]) -> None:
        _ = self._lower_order_connections[lower_order_id]
        
        left_offset = self._lower_order_x_offset_data[lower_order_id][1] - space_needed[0]
        right_offset = space_needed[1] - self._lower_order_x_offset_data[lower_order_id][2]
        space_needed_from_higher_order_left = 0
        space_needed_from_higher_order_right = 0
        flip = False

        for i, (connection_id, __) in enumerate(self._lower_order_x_offset_data.items()):
            if connection_id == lower_order_id:
                self._lower_order_x_offset_data[connection_id] = (self._lower_order_x_offset_data[connection_id][0], space_needed[0], space_needed[1])
                flip = True
            elif flip == False:
                self._lower_order_x_offset_data[connection_id] = (self._lower_order_x_offset_data[connection_id][0] + left_offset, self._lower_order_x_offset_data[connection_id][1], self._lower_order_x_offset_data[connection_id][2])
            else:
                self._lower_order_x_offset_data[connection_id] = (self._lower_order_x_offset_data[connection_id][0] + right_offset, self._lower_order_x_offset_data[connection_id][1], self._lower_order_x_offset_data[connection_id][2])

            if i == 0:
                space_needed_from_higher_order_left = abs(self._lower_order_x_offset_data[connection_id][0]) + self._lower_order_x_offset_data[connection_id][1]
            if i == len(self._lower_order_x_offset_data) - 1:
                space_needed_from_higher_order_right = abs(self._lower_order_x_offset_data[connection_id][0]) + self._lower_order_x_offset_data[connection_id][2]

        self.set_offset_by_higher_order(self._x_offset, self._y_offset, lower_order_id)

        if (self._highest == True):
            self._canvas.request_x_space(self._base_node.id, (space_needed_from_higher_order_left, space_needed_from_higher_order_right))
            return

        for connection_id, edge in self._higher_order_connections.items():
            if not edge[1] == EdgeType.MAIN:
                continue

            self._canvas.get_visual_node(connection_id).request_x_space_by_lower_order(self._base_node.id, (space_needed_from_higher_order_left, space_needed_from_higher_order_right))

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

        if (self._highest == True and self._higher_order_connections[higher_order_id][1] == EdgeType.MAIN):
            self._highest = False
            self._canvas.remove_highest_visual_node_id(self._base_node.id)

        if (self._lower_order_connections_shown == True):
            self.visualize_lower_order_connections()

        if not (self._higher_order_connections[higher_order_id][1] == EdgeType.MAIN):
            current_highest_id = self.get_current_highest()

            if current_highest_id is not None:
                return
            
            highest_visible_id = self.get_highest_visible()

            if highest_visible_id is None:
                raise ValueError("No highest nodes found after dependency is shown.")
            
            self._canvas.add_highest_visual_node_id(highest_visible_id)
            self._canvas.get_visual_node(highest_visible_id).set_highest(True)

    def visualize_by_lower_order(self, lower_order_id : int) -> None:
        self._lower_order_hide_requests.remove(lower_order_id)
        self._canvas.itemconfigure(self._oval_id, state = "normal")
        self._canvas.itemconfigure(self._text_id, state = "normal")
        self._visible = True
        self._lower_order_connections_shown = True

        if (self._higher_order_connections_shown == True):
            self.visualize_higher_order_connections()

        if not (self._lower_order_connections[lower_order_id][1] == EdgeType.MAIN):
            current_highest_id = self.get_current_highest()

            if current_highest_id is not None:
                return
            
            highest_visible_id = self.get_highest_visible()

            if highest_visible_id is None:
                raise ValueError("No highest nodes found after dependency is shown.")
            
            self._canvas.add_highest_visual_node_id(highest_visible_id)
            self._canvas.get_visual_node(highest_visible_id).set_highest(True)

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
            cloned_node._lower_order_x_offset_data = self._lower_order_x_offset_data.copy()

            for connection_id, edge in self._lower_order_connections.items():
                cloned_edge_id = self._canvas.clone_item_to_canvas(canvas, edge[0])
                cloned_edge = (cloned_edge_id, edge[1])
                cloned_node._lower_order_connections[connection_id] = cloned_edge
                self._canvas.get_visual_node(connection_id).recursive_copy_to_canvas(canvas, self._base_node.id, cloned_edge)

        if higher_order_connection_id is not None and higher_order_edge is not None:
            cloned_node.set_offset_by_higher_order(0, 0)
            space_needed = cloned_node.get_x_space_needed()

            if space_needed is not None:
                canvas.request_x_space(higher_order_connection_id, space_needed)