# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
from typing import Optional

from sympy import Function, Symbol, Integer, Expr  # type: ignore

from discopop_explorer.PETGraphX import NodeID
from discopop_library.discopop_optimizer.CostModels.CostModel import CostModel
from discopop_library.discopop_optimizer.classes.nodes.Workload import Workload


class FunctionRoot(Workload):
    name: str

    def __init__(self, node_id: int, experiment, cu_id: Optional[NodeID], name: str):
        super().__init__(
            node_id, experiment, cu_id, sequential_workload=0, parallelizable_workload=0
        )
        self.name = name
        self.device_id = 0
        function_name = "function" + "_" + str(self.node_id) + "_" + self.name

    def get_plot_label(self) -> str:
        return self.name
