# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

from discopop_explorer.classes.TaskGraph.Aliases import PETNodeID
from discopop_explorer.classes.TaskGraph.Contexts.Context import Context


class LoopParentContext(Context):
    parent_loop: PETNodeID
    pass

    def __init__(self, parent_loop: PETNodeID):
        self.parent_loop = parent_loop
        super().__init__()

    def get_plot_border_color(self) -> str:
        return "b"

    def get_plot_face_color(self) -> str:
        return "cyan"

    def get_label(self) -> str:
        return "LoopParent " + str(self.parent_loop)
