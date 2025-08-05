# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

from typing import List, Tuple

from discopop_explorer.classes.TaskGraph.Aliases import LevelIndex, PositionIndex
from discopop_explorer.classes.TaskGraph.TGNode import TGNode


class Context(object):
    contained_nodes: List[TGNode]

    def __init__(self) -> None:
        self.contained_nodes = []

    def add_node(self, node: TGNode) -> None:
        self.contained_nodes.append(node)

    def get_plot_bounding_box(self) -> Tuple[int, LevelIndex, LevelIndex, PositionIndex, PositionIndex]:
        if len(self.contained_nodes) == 0:
            return 0, 0, 0, 0, 0
        levels = [n.level for n in self.contained_nodes]
        positions = [n.position for n in self.contained_nodes]
        print("CTX, levels: ", levels)
        print("CTX, positions: ", positions)
        return len(self.contained_nodes), min(levels), max(levels), min(positions), max(positions)

    def get_plot_border_color(self) -> str:
        return "b"

    def get_plot_face_color(self) -> str:
        return "red"
