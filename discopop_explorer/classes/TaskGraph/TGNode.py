# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
from __future__ import annotations

from typing import Dict, Optional, TYPE_CHECKING

if TYPE_CHECKING:
    from discopop_explorer.classes.TaskGraph.Contexts.Context import Context

from discopop_explorer.classes.TaskGraph.Aliases import LevelIndex, PETNodeID, TGNodeID, PositionIndex


class TGNode(object):
    pet_node_id: PETNodeID
    level: LevelIndex  # for plotting and predecessor / successor detection
    position: PositionIndex  # for plotting
    parent_context: Optional[Context] = None

    def __init__(self, pet_node_id: PETNodeID, level: LevelIndex, position: PositionIndex):
        self.pet_node_id = pet_node_id
        self.level = level
        self.position = position

    def get_label(self) -> str:
        return str(self.pet_node_id)

    def set_parent_context(self, parent_context: Context) -> None:
        self.parent_context = parent_context
