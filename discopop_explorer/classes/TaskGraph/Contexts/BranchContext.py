# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

from typing import List, Set
from discopop_explorer.classes.TaskGraph.Aliases import PETNode, PETNodeID
from discopop_explorer.classes.TaskGraph.Contexts.Context import Context


class BranchContext(Context):
    parent_context: Context
    contained_pet_nodes: Set[PETNode]

    def __init__(self, parent_context: Context):
        self.parent_context = parent_context
        self.contained_pet_nodes = set()
        super().__init__()

    def add_pet_node(self, pet_node: PETNode) -> None:
        self.contained_pet_nodes.add(pet_node)

    def get_plot_border_color(self) -> str:
        return "b"

    def get_plot_face_color(self) -> str:
        return "orange"
