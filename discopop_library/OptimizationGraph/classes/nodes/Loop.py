# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
from typing import Optional, cast

from sympy import Symbol, Integer  # type: ignore

from discopop_explorer.PETGraphX import NodeID
from discopop_library.OptimizationGraph.CostModels.CostModel import CostModel
from discopop_library.OptimizationGraph.classes.nodes.Workload import Workload


class Loop(Workload):
    iterations: int
    position: str

    def __init__(self, node_id: int, cu_id: Optional[NodeID], parallelizable_workload: int, iterations: int, position: str):
        self.position = position
        self.iterations = max(
            iterations, 1
        )  # to prevent dividing by 0 in case the loop has not been executed

        # calculate workload per iteration
        per_iteration_parallelizable_workload = parallelizable_workload / iterations
        super().__init__(node_id, cu_id, sequential_workload=0,
                         parallelizable_workload=int(per_iteration_parallelizable_workload))

    # todo: note: it might be more beneficial to use the iterations "per entry" instead of the total amount of iterations
    # example:
    # for(100)      --> use 100
    #   for(100)    --> use 100 instead of 10000

    def get_hover_text(self) -> str:
        return "WL: " + str(self.sequential_workload) + "\n" + "IT: " + str(self.iterations)

    def get_cost_model(self) -> CostModel:
        """Performance model of a workload consists of the workload itself.
        Individual Workloads are assumed to be not parallelizable.
        Workloads of Loop etc. are parallelizable."""
        iterations_symbol = Symbol("loop_" + str(self.node_id)+"_pos_" + str(self.position) + "_iterations")
        result_model: Optional[CostModel] = None
        if self.sequential_workload is None:
            result_model = CostModel(Integer(1), Integer(0)).parallelizable_multiply_combine(
                self.cost_multiplier).parallelizable_plus_combine(self.overhead).parallelizable_multiply_combine(
                CostModel(iterations_symbol, iterations_symbol))
        else:
            result_model = CostModel(Integer(self.parallelizable_workload),
                                     Integer(self.sequential_workload)).parallelizable_multiply_combine(
                self.cost_multiplier).parallelizable_plus_combine(self.overhead).parallelizable_multiply_combine(
                CostModel(iterations_symbol, iterations_symbol))

        cast(CostModel, result_model).symbol_value_suggestions[iterations_symbol] = Integer(self.iterations)
        return cast(CostModel, result_model)
