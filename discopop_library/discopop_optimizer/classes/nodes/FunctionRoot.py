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
    parallelizable_costs: Expr
    sequential_costs: Expr
    performance_model: CostModel

    def __init__(self, node_id: int, experiment, cu_id: Optional[NodeID], name: str):
        super().__init__(
            node_id, experiment, cu_id, sequential_workload=0, parallelizable_workload=0
        )
        self.name = name
        self.device_id = 0
        function_name = "function" + "_" + str(self.node_id) + "_" + self.name
        self.parallelizable_costs = Symbol(function_name + "-parallelizable")
        self.sequential_costs = Symbol(function_name + "-sequential")
        self.performance_model = CostModel(
            self.parallelizable_costs,
            self.sequential_costs,
            identifier=function_name,
        )

    def get_plot_label(self) -> str:
        return self.name

    def get_cost_model(self, experiment, all_function_nodes) -> CostModel:
        """Model:
        Spawn overhead + children"""
        # todo this is only a dummy, not a finished model!
        function_name = "function" + "_" + str(self.node_id) + "_" + self.name
        # spawn_overhead = Symbol(function_name + "_spawn_overhead")
        # self.introduced_symbols.append(spawn_overhead)
        # model = Function(function_name)
        # model = spawn_overhead

        # todo: check if the costs of calling functions should be included into the models
        # self.performance_model = CostModel(Integer(0), Integer(0), identifier=function_name)

        # return CostModel(Integer(0), Integer(0), identifier=function_name)
        # instead of returning an empty model, return symbols for sequential and parallel workload.
        # These symbols can be substituted in order to evaluate for different versions of other functions

        return self.performance_model
