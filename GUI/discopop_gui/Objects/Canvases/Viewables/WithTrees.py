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

    def get_visual_node(self, id : int) -> VisualTreeNode:
        return self._visual_nodes[id]
    
    def create_visual_node(self, id: int, state : str = "normal") -> bool:
        if id in self._visual_nodes:
            return False

        node = self._nodes[id]

        x = node.metadata["x"]
        y = node.metadata["y"]
        label = node.metadata["label"]
        fill_color = node.metadata.get("fill", "cyan")
        node_radius = 40

        oval_id = self.create_oval(
            x - node_radius,
            y - node_radius,
            x + node_radius,
            y + node_radius,
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
            self._popup,
            oval_id,
            text_id,
        )

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

        dependency_edges : List[Tuple[Any, Any, Any]] = []
        edges_to_remove : List[Tuple[Any, Any, Any]] = []
        
        for src, dst, key, data in graph.edges(keys=True, data=True):
            if data.get("edge_type") == EdgeType.DEPENDENCY:
                dependency_edges.append((src, dst, data))
                edges_to_remove.append((src, dst, key))
                
        for src, dst, key in edges_to_remove:
            graph.remove_edge(src, dst, key=key)

        positions = nx.nx_pydot.pydot_layout(graph, prog="dot")

        if not positions:
            return

        self.update_idletasks()

        canvas_width = self.winfo_width()
        canvas_height = self.winfo_height()

        if canvas_width <= 1:
            canvas_width = int(self.cget("width"))

        if canvas_height <= 1:
            canvas_height = int(self.cget("height"))

        padding = 40

        xs = [pos[0] for pos in positions.values()]
        ys = [pos[1] for pos in positions.values()]

        min_x, max_x = min(xs), max(xs)
        min_y, max_y = min(ys), max(ys)

        x_span = max(max_x - min_x, 1)
        y_span = max(max_y - min_y, 1)

        scaled_positions: Dict[Any, Tuple[float, float]] = {}

        for node, (x, y) in positions.items():
            sx = padding + ((x - min_x) / x_span) * (canvas_width - (2 * padding))
            sy = padding + (1 - ((y - min_y) / y_span)) * (canvas_height - (2 * padding))
            scaled_positions[node] = (sx, sy)

        nodes_to_ids : Dict[Any, int] = {}

        for node in graph.nodes:
            node_id = len(self._nodes)
            nodes_to_ids[node] = node_id
            self._nodes[node_id] = TreeNode(node_id)
            x, y = scaled_positions[node]

            self._nodes[node_id].metadata.update(
                {
                    "x": x,
                    "y": y,
                    "label": node.get_label(),
                    "fill": "cyan",
                }
            )

        all_edges : List[Tuple[Any, Any, Any]] = list(graph.edges(data = True)) + dependency_edges
        seen_edges : Set[Tuple[int, int]] = set()

        for source, destination, data in all_edges:
            source_id = nodes_to_ids[source]
            destination_id = nodes_to_ids[destination]

            if ((source_id, destination_id) in seen_edges):
                continue

            edge_type = data.get("edge_type")
            self._nodes[source_id].lower_order_connections.append((self._nodes[destination_id], edge_type))
            self._nodes[destination_id].higher_order_connections.append((self._nodes[source_id], edge_type))
            self._nodes[source_id].metadata["fill"] = "orange"
            seen_edges.add((source_id, destination_id))
            seen_edges.add((destination_id, source_id))

        for node_id, node in self._nodes.items():
            if node.higher_order_connections:
                continue

            self.create_visual_node(node_id)