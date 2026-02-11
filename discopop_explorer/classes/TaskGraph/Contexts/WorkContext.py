# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

from typing import List, Tuple
from discopop_explorer.aliases.LineID import LineID
from discopop_explorer.classes.PEGraph.PEGraphX import PEGraphX
from discopop_explorer.classes.TaskGraph.Aliases import PETNodeID
from discopop_explorer.classes.TaskGraph.Contexts.Context import Context


class WorkContext(Context):

    def get_plot_border_color(self) -> str:
        return "b"

    def get_plot_face_color(self) -> str:
        return "red"

    def get_label(self) -> str:
        label = "Work"
        return label

    def get_label_with_defined_vars(self, pet: PEGraphX) -> str:
        label = "Work"
        defines_vars: List[Tuple[str, LineID]] = self.get_defined_variables(pet)

        for tpl in defines_vars:
            label += " " + str(tpl[0]) + "@" + str(tpl[1])
        return label
