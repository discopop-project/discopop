# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
from __future__ import annotations

from typing import Dict, List, Tuple, TYPE_CHECKING

if TYPE_CHECKING:
    from discopop_explorer.classes.TaskGraph.TGNode import TGNode

from discopop_explorer.classes.TaskGraph.Aliases import LevelIndex, PositionIndex


class Context(object):
    contained_nodes: List[TGNode]
    contained_contexts: List[Context]

    def __init__(self) -> None:
        self.contained_nodes = []
        self.contained_contexts = []

    def get_contained_nodes(self, inclusive: bool = False) -> List[TGNode]:
        """
        Returns the nodes contained in the current context.
        inclusive: If False, does not consider contexts contained in the current context. If true, included contexts are traversed recursively.
        """
        if not inclusive:
            return self.contained_nodes
        nodes: List[TGNode] = []
        nodes += self.contained_nodes
        for ctx in self.contained_contexts:
            nodes += ctx.get_contained_nodes()
        return nodes

    def add_node(self, node: TGNode) -> None:
        self.contained_nodes.append(node)

    def add_contained_context(self, context: Context) -> None:
        self.contained_contexts.append(context)

    def get_plot_bounding_box(self) -> Tuple[int, LevelIndex, LevelIndex, PositionIndex, PositionIndex]:
        if len(self.contained_nodes) == 0:
            return 0, 0, 0, 0, 0
        levels = [n.level for n in self.contained_nodes]
        positions = [n.position for n in self.contained_nodes]
        return len(self.contained_nodes), min(levels), max(levels), min(positions), max(positions)

    def get_plot_border_color(self) -> str:
        return "b"

    def get_plot_face_color(self) -> str:
        return "red"

    def get_plot_face_alpha(self) -> float:
        return 0.2
