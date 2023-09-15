# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
from typing import Optional, cast

from sympy import Symbol, Integer, Expr  # type: ignore

from discopop_explorer.PETGraphX import NodeID
from discopop_library.discopop_optimizer.CostModels.CostModel import CostModel
from discopop_library.discopop_optimizer.Variables.Experiment import Experiment
from discopop_library.discopop_optimizer.classes.nodes.Workload import Workload


class Loop(Workload):
    iterations: int
    position: str
    iterations_symbol: Symbol
    experiment: Experiment

    def __init__(
        self,
        node_id: int,
        experiment: Experiment,
        cu_id: Optional[NodeID],
        parallelizable_workload: int,
        iterations: int,
        position: str,
        iterations_symbol: Optional[Symbol] = None,
    ):
        self.experiment = experiment
        self.position = position
        self.iterations = max(
            iterations, 1
        )  # to prevent dividing by 0 in case the loop has not been executed

        if iterations_symbol is None:
            self.iterations_symbol = Symbol(
                "loop_" + str(node_id) + "_pos_" + str(self.position) + "_iterations"
            )
        else:
            self.iterations_symbol = iterations_symbol

        # calculate workload per iteration
        per_iteration_parallelizable_workload = parallelizable_workload / iterations
        super().__init__(
            node_id,
            experiment,
            cu_id,
            sequential_workload=0,
            parallelizable_workload=int(per_iteration_parallelizable_workload),
        )

        # register iteration symbol in environment
        experiment.register_free_symbol(
            self.iterations_symbol, value_suggestion=Integer(self.iterations)
        )

    # todo: note: it might be more beneficial to use the iterations "per entry" instead of the total amount of iterations
    # example:
    # for(100)      --> use 100
    #   for(100)    --> use 100 instead of 10000

    def get_hover_text(self) -> str:
        return (
            "WL: " + str(self.sequential_workload) + "\n" + "IT: " + str(self.iterations) + "\n"
            "Read: " + str([str(e) for e in self.read_memory_regions]) + "\n"
            "Write: " + str([str(e) for e in self.written_memory_regions])
        )

    def get_cost_model(self, experiment, all_function_nodes) -> CostModel:
        """Performance model of a workload consists of the workload itself.
        Individual Workloads are assumed to be not parallelizable.
        Workloads of Loop etc. are parallelizable."""

        result_model: Optional[CostModel] = None
        if self.sequential_workload is None:
            result_model = (
                CostModel(Integer(1), Integer(0))
                .parallelizable_multiply_combine(self.cost_multiplier)
                .parallelizable_plus_combine(self.overhead)
                .parallelizable_multiply_combine(
                    CostModel(self.iterations_symbol, self.iterations_symbol)
                )
            )
        else:
            result_model = (
                CostModel(Integer(self.parallelizable_workload), Integer(self.sequential_workload))
                .parallelizable_multiply_combine(self.cost_multiplier)
                .parallelizable_plus_combine(self.overhead)
                .parallelizable_multiply_combine(
                    CostModel(self.iterations_symbol, self.iterations_symbol)
                )
            )

        cast(CostModel, result_model).symbol_value_suggestions[self.iterations_symbol] = Integer(
            self.iterations
        )

        cm = cast(CostModel, result_model)
        # substitute Expr(0) with Integer(0)
        cm.parallelizable_costs = cm.parallelizable_costs.subs({Expr(Integer(0)): Integer(0)})
        cm.sequential_costs = cm.sequential_costs.subs({Expr(Integer(0)): Integer(0)})

        if cm.raw_sequential_costs is not None:
            cm.raw_sequential_costs = cm.raw_sequential_costs.subs({Expr(Integer(0)): Integer(0)})
        if cm.raw_parallelizable_costs is not None:
            cm.raw_parallelizable_costs = cm.raw_parallelizable_costs.subs(
                {Expr(Integer(0)): Integer(0)}
            )

        return cm

    def register_child(self, other, experiment, all_function_nodes):
        """Registers a child node for the given model.
        Does not modify the stored model in self or other."""
        # The workload of the added child needs to be multiplied with the iteration count before adding it.
        return self.get_cost_model(experiment, all_function_nodes).parallelizable_multiply_combine(
            self.performance_model.parallelizable_plus_combine(
                other.parallelizable_multiply_combine(
                    CostModel(self.iterations_symbol, self.iterations_symbol)
                )
            )
        )

    def register_successor(self, other):
        """Registers a successor node for the given model.
        Does not modify the stored model in self or other."""
        # sequential composition is depicted by simply adding the performance models
        return self.performance_model.parallelizable_plus_combine(other)
