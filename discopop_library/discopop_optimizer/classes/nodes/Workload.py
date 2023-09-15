# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
from typing import Optional, Set, List, cast

from sympy import Integer, Expr  # type: ignore

from discopop_explorer.PETGraphX import NodeID, PETGraphX, EdgeType
from discopop_library.discopop_optimizer.CostModels.CostModel import CostModel
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
        experiment,
        cu_id: Optional[NodeID],
        sequential_workload: Optional[int],
        parallelizable_workload: Optional[int],
        written_memory_regions: Optional[Set[WriteDataAccess]] = None,
        read_memory_regions: Optional[Set[ReadDataAccess]] = None,
    ):
        super().__init__(
            node_id,
            experiment,
            cu_id,
            written_memory_regions=written_memory_regions,
            read_memory_regions=read_memory_regions,
        )
        self.sequential_workload = sequential_workload
        self.parallelizable_workload = parallelizable_workload
        self.performance_model = CostModel(
            Integer(0 if self.parallelizable_workload is None else self.parallelizable_workload),
            Integer(0 if self.sequential_workload is None else self.sequential_workload),
        )
        self.cost_multiplier = CostModel(Integer(1), Integer(1))
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

    def get_cost_model(self, experiment, all_function_nodes) -> CostModel:
        """Performance model of a workload consists of the workload itself + the workload of called functions.
        Individual Workloads are assumed to be not parallelizable.
        Workloads of called functions are added as encountered.
        Workloads of Loop etc. are parallelizable."""

        cm: CostModel

        if self.sequential_workload is None:
            cm = (
                CostModel(Integer(1), Integer(0))
                .parallelizable_multiply_combine(self.cost_multiplier)
                .parallelizable_plus_combine(self.overhead)
                .parallelizable_plus_combine(
                    self.__get_costs_of_function_call(experiment, all_function_nodes)
                )
            )
        else:
            cm = (
                CostModel(Integer(self.parallelizable_workload), Integer(self.sequential_workload))
                .parallelizable_multiply_combine(self.cost_multiplier)
                .parallelizable_plus_combine(self.overhead)
                .parallelizable_plus_combine(
                    self.__get_costs_of_function_call(experiment, all_function_nodes)
                )
            )

        # substitute Expr(0) with Integer(0)
        cm.parallelizable_costs = cm.parallelizable_costs.subs({Expr(Integer(0)): Integer(0)})
        cm.sequential_costs = cm.sequential_costs.subs({Expr(Integer(0)): Integer(0)})

        print("CM: ")
        print(cm)

        return cm

    def __get_costs_of_function_call(self, experiment, all_function_nodes) -> CostModel:
        """Check if the node performs a function call and returns the total costs for these."""
        total_costs = CostModel(Integer(0), Integer(0))
        # get CUIDs of called functions
        if self.original_cu_id is not None:
            called_cu_ids: List[str] = [
                str(t)
                for s, t, d in cast(PETGraphX, experiment.detection_result.pet).out_edges(
                    self.original_cu_id, EdgeType.CALLSNODE
                )
            ]
            # filter for called FunctionRoots
            called_function_nodes = [
                fr for fr in all_function_nodes if str(fr.original_cu_id) in called_cu_ids
            ]
            # remove duplicates
            called_function_nodes = list(set(called_function_nodes))
            # add costs of called function nodes to total costs
            for called_function_root in called_function_nodes:
                total_costs = total_costs.parallelizable_plus_combine(
                    called_function_root.get_cost_model(experiment, all_function_nodes)
                )

        return total_costs

    def register_child(self, other, experiment, all_function_nodes):
        """Registers a child node for the given model.
        Does not modify the stored model in self or other."""
        # since workloads do not modify their children, the performance model of other is simply added to self.
        return self.performance_model.parallelizable_plus_combine(other)

    def register_successor(self, other):
        """Registers a successor node for the given model.
        Does not modify the stored model in self or other."""
        # sequential composition is depicted by simply adding the performance models
        return self.performance_model.parallelizable_plus_combine(other)
