# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import tkinter as tk
import networkx as nx
from typing import Any, Dict, Tuple, List, Set, TYPE_CHECKING

from discopop_gui.Constants import TREE_NODES_SPACING, TREE_NODE_RADIUS
from discopop_gui.Enums.ViewerMode import ViewerMode
from discopop_gui.Enums.EdgeType import EdgeType
from discopop_gui.Objects.Canvases.Viewables.Viewable import Viewable as ViewableCanvas
from discopop_gui.utils.TreeNode import TreeNode
from discopop_gui.Objects.CanvasItems.TreeNode import TreeNode as VisualTreeNode

if TYPE_CHECKING:
    from discopop_gui.Objects.Frames.CanvasViewer import CanvasViewer

class WithTrees(ViewableCanvas):
    def __init__(
        self,
        parent : tk.Frame,
        canvas_viewer : "CanvasViewer[WithTrees]",
        viewer_mode : ViewerMode,
        trees : Dict[int, TreeNode] = {},
        *args : Any,
        **kwargs : Any,
    ) -> None:
        super().__init__(parent, viewer_mode, *args, **kwargs)
        self._canvas_viewer = canvas_viewer
        self._nodes : Dict[int, TreeNode] = trees
        self._visual_nodes : Dict[int, VisualTreeNode] = {}
        self._highest_visual_node_ids : List[int] = []
        self._highest_visual_nodes_x_offset_data : Dict[int, Tuple[int, int, int]] = {}

    def get_visual_node(self, id : int) -> VisualTreeNode:
        return self._visual_nodes[id]
    
    def check_visual_node(self, id : int) -> bool:
        return id in self._visual_nodes
    
    def add_highest_visual_node_id(self, visual_node_id : int, at_index : int | None = None) -> None:
        self._highest_visual_nodes_x_offset_data[visual_node_id] = (0, 0, 0)

        if at_index is not None:
            self._highest_visual_node_ids.insert(at_index, visual_node_id)

            for node_id in self._highest_visual_node_ids[at_index + 1:]:
                self._highest_visual_nodes_x_offset_data[node_id] = (self._highest_visual_nodes_x_offset_data[node_id][0] + 1, self._highest_visual_nodes_x_offset_data[node_id][1], self._highest_visual_nodes_x_offset_data[node_id][2])
            
            return
        elif len(self._highest_visual_node_ids) > 0:
            self._highest_visual_nodes_x_offset_data[visual_node_id] = (self._highest_visual_nodes_x_offset_data[self._highest_visual_node_ids[-1]][0] + 1, 0, 0)
        
        self._highest_visual_node_ids.append(visual_node_id)

    def update_highest_visual_nodes(self) -> None:
        temp = self._highest_visual_node_ids.copy()

        for node_id in temp:
            self.get_visual_node(node_id).set_highest_by_higher_order()

    def remove_highest_visual_node_id(self, visual_node_id : int) -> int:
        left_offset = self._highest_visual_nodes_x_offset_data[visual_node_id][1]
        right_offset = self._highest_visual_nodes_x_offset_data[visual_node_id][2]
        flip = False

        for node_id in self._highest_visual_node_ids:
            if node_id == visual_node_id:
                flip = True
            elif flip == False:
                self._highest_visual_nodes_x_offset_data[node_id] = (self._highest_visual_nodes_x_offset_data[node_id][0] + left_offset, self._highest_visual_nodes_x_offset_data[node_id][1], self._highest_visual_nodes_x_offset_data[node_id][2])
            else:
                self._highest_visual_nodes_x_offset_data[node_id] = (self._highest_visual_nodes_x_offset_data[node_id][0] - right_offset - 1, self._highest_visual_nodes_x_offset_data[node_id][1], self._highest_visual_nodes_x_offset_data[node_id][2])

        value = self._highest_visual_node_ids.index(visual_node_id)
        self._highest_visual_node_ids.remove(visual_node_id)
        self._highest_visual_nodes_x_offset_data.pop(visual_node_id, None)
        return value

    def request_x_space(self, highest_order_id : int, space_needed : Tuple[int, int]) -> None:
        if highest_order_id not in self._highest_visual_nodes_x_offset_data:
            return
        
        left_offset = self._highest_visual_nodes_x_offset_data[highest_order_id][1] - space_needed[0]
        right_offset = space_needed[1] - self._highest_visual_nodes_x_offset_data[highest_order_id][2]
        flip = False

        for node_id in self._highest_visual_node_ids:
            if node_id == highest_order_id:
                self._highest_visual_nodes_x_offset_data[node_id] = (self._highest_visual_nodes_x_offset_data[node_id][0], space_needed[0], space_needed[1])
                flip = True
            elif flip == False:
                self._highest_visual_nodes_x_offset_data[node_id] = (self._highest_visual_nodes_x_offset_data[node_id][0] + left_offset, self._highest_visual_nodes_x_offset_data[node_id][1], self._highest_visual_nodes_x_offset_data[node_id][2])
            else:
                self._highest_visual_nodes_x_offset_data[node_id] = (self._highest_visual_nodes_x_offset_data[node_id][0] + right_offset, self._highest_visual_nodes_x_offset_data[node_id][1], self._highest_visual_nodes_x_offset_data[node_id][2])

            if not node_id == highest_order_id:
                self._visual_nodes[node_id].set_offset(self._highest_visual_nodes_x_offset_data[node_id][0])

    def create_visual_node(self, id: int, highest : bool = False, state : str = "normal", x_offset : int = 0, y_offset : int = 0) -> bool:
        if id in self._visual_nodes:
            return False

        node = self._nodes[id]
        x = x_offset * TREE_NODES_SPACING
        y = y_offset * TREE_NODES_SPACING
        label = node.metadata["label"]
        fill_color = node.metadata.get("fill", "cyan")

        oval_id = self.create_oval(
            x - TREE_NODE_RADIUS,
            y - TREE_NODE_RADIUS,
            x + TREE_NODE_RADIUS,
            y + TREE_NODE_RADIUS,
            fill=fill_color,
            outline="black",
            state = state
        )

        text_id = self.create_text(
            x,
            y,
            text=label,
            font=("Arial", 7),
            anchor="center",
            state = state
        )

        self._visual_nodes[id] = VisualTreeNode(
            self,
            self._nodes[id],
            highest,
            True if state == "normal" else False,
            self._popup,
            oval_id,
            text_id,
            x_offset,
            y_offset
        )

        if highest:
            self.add_highest_visual_node_id(id)

        return True
    
    def create_visual_edge(self, from_id : int, to_id : int, edge_type : EdgeType, state : str = "hidden") -> int:
        from_node = self.get_visual_node(from_id)
        to_node = self.get_visual_node(to_id)
        (x1, y1) = from_node.get_location()
        (x2, y2) = to_node.get_location()

        return self.create_line(
            x1,
            y1,
            x2,
            y2,
            fill = "black" if edge_type == EdgeType.MAIN else "red",
            width = 1,
            state = state,
            tags = "tree_edge"
        )

    
    def add_clone_to_canvas_viewer(self, starting_tree_node_id : int) -> None:
        starting_tree_node = self.get_visual_node(starting_tree_node_id)

        def canvas_builder(parent : tk.Frame, canvas_viewer : "CanvasViewer[WithTrees]", canvas_viewer_mode : ViewerMode) -> "WithTrees":
            return WithTrees(parent, canvas_viewer, canvas_viewer_mode, self._nodes, bg = self["bg"])

        cloned_canvas = self._canvas_viewer.get_canvas(self._canvas_viewer.add_canvas(canvas_builder))
        starting_tree_node.recursive_copy_to_canvas(cloned_canvas)

    def build_trees(self, graph: nx.MultiDiGraph) -> None:
        self.delete("all")
        self._visual_nodes.clear()
        self._nodes.clear()
        self._transform_scale = 1
        self._transform_x = 0.0
        self._transform_y = 0.0
        self._highest_visual_node_ids.clear()
        self._highest_visual_nodes_x_offset_data.clear()

        nodes_to_ids : Dict[Any, int] = {}

        for node in graph.nodes:
            node_id = len(self._nodes)
            nodes_to_ids[node] = node_id
            self._nodes[node_id] = TreeNode(node_id)

            self._nodes[node_id].metadata.update(
                {
                    "label": node.get_label(),
                    "fill": "cyan"
                }
            )

        seen_edges : Set[Tuple[int, int]] = set()
        
        for source, destination, data in graph.edges(data = True):
            source_node_id = nodes_to_ids[source]
            destination_node_id = nodes_to_ids[destination]

            if (source_node_id, destination_node_id) in seen_edges:
                continue
            
            if data.get("edge_type") == EdgeType.DEPENDENCY:
                self._nodes[source_node_id].lower_order_connections.append((self._nodes[destination_node_id], EdgeType.DEPENDENCY))
                self._nodes[destination_node_id].higher_order_connections.append((self._nodes[source_node_id], EdgeType.DEPENDENCY))
            elif data.get("edge_type") == EdgeType.MAIN:
                self._nodes[source_node_id].lower_order_connections.append((self._nodes[destination_node_id], EdgeType.MAIN))
                self._nodes[destination_node_id].higher_order_connections.append((self._nodes[source_node_id], EdgeType.MAIN))

            self._nodes[source_node_id].metadata["fill"] = "orange"
            seen_edges.add((source_node_id, destination_node_id))
            seen_edges.add((destination_node_id, source_node_id))

        for node_id, node in self._nodes.items():
            if node.higher_order_connections:
                continue

            self.create_visual_node(node_id, highest = True)
            self.get_visual_node(node_id).set_offset(self._highest_visual_nodes_x_offset_data[node_id][0])