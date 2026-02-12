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
from discopop_explorer.functions.PEGraph.traversal.called_functions import get_called_nodes


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

    def get_contained_calls(self, pet: PEGraphX) -> List[Tuple[PETNodeID, LineID]]:
        """returns a list of calls contained in the context. Each call is represented as a tuple of the called function's PETNodeID and the lineID of the call."""
        calls = []
        for node in self.contained_nodes:
            pet_node = node.get_pet_node(pet)
            if pet_node is None:
                continue

            # print("CALLS: ", str([e.name for e in get_called_nodes(pet, pet_node)]))
            for called_function in list(set([e for e in get_called_nodes(pet, pet_node)])):
                for i in range(pet_node.start_line, pet_node.end_line + 1):
                    calls.append((called_function.id, LineID(str(pet_node.file_id) + ":" + str(i))))
        return list(set(calls))
