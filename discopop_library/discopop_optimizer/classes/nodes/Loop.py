# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
import sys
from typing import Optional, cast

from sympy import Symbol, Integer  # type: ignore

from discopop_explorer.PETGraphX import NodeID
from discopop_library.discopop_optimizer.Variables.Experiment import Experiment
from discopop_library.discopop_optimizer.classes.nodes.Workload import Workload


class Loop(Workload):
    iterations: int
    position: str
    iterations_symbol: Symbol

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
        self.position = position
        self.iterations = max(
            iterations, 1
        )  # to prevent dividing by 0 in case the loop has not been executed

        if iterations_symbol is None:
            self.iterations_symbol = Symbol(
                "loop_" + str(node_id) + "_pos_" + str(self.position) + "_iterations"
            )
        else:
            self.iterations_symbol = cast(Symbol, iterations_symbol)

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
