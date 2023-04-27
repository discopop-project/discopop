# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
from typing import Optional

from sympy import Function, Symbol, Integer  # type: ignore

from discopop_explorer.PETGraphX import NodeID
from discopop_library.OptimizationGraph.CostModels.CostModel import CostModel
from discopop_library.OptimizationGraph.classes.nodes.Workload import Workload


class FunctionRoot(Workload):
    name: str

    def __init__(self, node_id: int, cu_id: Optional[NodeID], name: str):
        super().__init__(node_id, cu_id)
        self.name = name

    def get_plot_label(self) -> str:
        return self.name

    def get_cost_model(self) -> CostModel:
        """Model:
            Spawn overhead + children"""
        # todo this is only a dummy, not a finished model!
        function_name = "function" + "_" + str(self.node_id) + "_" + self.name
        # spawn_overhead = Symbol(function_name + "_spawn_overhead")
        # self.introduced_symbols.append(spawn_overhead)
        # model = Function(function_name)
        # model = spawn_overhead

        model = Integer(1)  # dummy for a unknown, but constant overhead for function spawning
        self.performance_model = CostModel(model, identifier=function_name)

        return CostModel(model, identifier=function_name)
