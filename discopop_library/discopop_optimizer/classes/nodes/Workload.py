# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
from typing import Optional, Set

from sympy import Integer, Expr  # type: ignore

from discopop_explorer.PETGraphX import NodeID
from discopop_library.discopop_optimizer.CostModels.CostModel import CostModel
from discopop_library.discopop_optimizer.Variables.Experiment import Experiment
from discopop_library.discopop_optimizer.classes.nodes.GenericNode import GenericNode
from discopop_library.discopop_optimizer.classes.types.DataAccessType import (
    WriteDataAccess,
    ReadDataAccess,
)


class Workload(GenericNode):
    """This class represents a generic node in the Optimization Graph"""

    sequential_workload: Optional[int]
    parallelizable_workload: Optional[int]
    cost_multiplier: CostModel

    def __init__(
        self,
        node_id: int,
        environment: Experiment,
        cu_id: Optional[NodeID],
        sequential_workload: Optional[int],
        parallelizable_workload: Optional[int],
        written_memory_regions: Optional[Set[WriteDataAccess]] = None,
        read_memory_regions: Optional[Set[ReadDataAccess]] = None,
    ):
        super().__init__(
            node_id,
            environment,
            cu_id,
            written_memory_regions=written_memory_regions,
            read_memory_regions=read_memory_regions,
        )
        self.sequential_workload = sequential_workload
        self.parallelizable_workload = parallelizable_workload
        self.cost_multiplier = CostModel(Integer(1), Integer(0))
        self.overhead = CostModel(Integer(0), Integer(0))

    def get_plot_label(self) -> str:
        if self.sequential_workload is not None:
            # return str(self.workload)
            return str(self.node_id)
        else:
            return "WL"

    def get_hover_text(self) -> str:
        return (
            "WL: " + str(self.sequential_workload) + "\n"
            "Read: " + str([str(e) for e in self.read_memory_regions]) + "\n"
            "Write: " + str([str(e) for e in self.written_memory_regions]) + "\n"
            "Branch: " + str(self.branch_affiliation)
        )

    def get_cost_model(self) -> CostModel:
        """Performance model of a workload consists of the workload itself.
        Individual Workloads are assumed to be not parallelizable.
        Workloads of Loop etc. are parallelizable."""
        if self.sequential_workload is None:
            return (
                CostModel(Integer(1), Integer(0))
                .parallelizable_multiply_combine(self.cost_multiplier)
                .parallelizable_plus_combine(self.overhead)
            )
        else:
            return (
                CostModel(Integer(self.parallelizable_workload), Integer(self.sequential_workload))
                .parallelizable_multiply_combine(self.cost_multiplier)
                .parallelizable_plus_combine(self.overhead)
            )
