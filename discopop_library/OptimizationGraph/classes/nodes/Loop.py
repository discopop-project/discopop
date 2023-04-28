# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
from typing import Optional

from sympy import Symbol  # type: ignore

from discopop_explorer.PETGraphX import NodeID
from discopop_library.OptimizationGraph.classes.nodes.Workload import Workload


class Loop(Workload):
    iterations: int

    def __init__(self, node_id: int, cu_id: Optional[NodeID], workload: int, iterations: int):
        super().__init__(node_id, cu_id, workload=workload)
        self.iterations = max(iterations, 1)  # to prevent dividing by 0 in case the loop has not been executed

    # todo: note: it might be more beneficial to use the iterations "per entry" instead of the total amount of iterations
    # example:
    # for(100)      --> use 100
    #   for(100)    --> use 100 instead of 10000

    def get_hover_text(self) -> str:
        return "WL: " + str(self.workload) + "\n" + \
               "IT: " + str(self.iterations)
