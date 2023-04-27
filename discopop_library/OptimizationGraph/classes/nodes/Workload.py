# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
from typing import Optional

from sympy import Integer, Expr  # type: ignore

from discopop_explorer.PETGraphX import NodeID
from discopop_library.OptimizationGraph.CostModels.CostModel import CostModel
from discopop_library.OptimizationGraph.classes.nodes.GenericNode import GenericNode


class Workload(GenericNode):
    """This class represents a generic node in the Optimization Graph"""
    workload: Optional[int]
    cost_multiplier: CostModel

    def __init__(self, node_id: int, cu_id: Optional[NodeID], workload: Optional[int] = None):
        super().__init__(node_id, cu_id)
        self.workload = workload
        self.cost_multiplier = CostModel(Integer(1))
        self.overhead = CostModel(Integer(0))

    def get_plot_label(self) -> str:
        if self.workload is not None:
            # return str(self.workload)
            return str(self.node_id)
        else:
            return "WL"

    def get_hover_text(self) -> str:
        return "WL: " + str(self.workload)

    def get_cost_model(self) -> CostModel:
        """Performance model of a workload consists of the workload itself"""
        if self.workload is None:
            return CostModel(Integer(0)).multiply_combine(self.cost_multiplier).plus_combine(self.overhead)
        else:
            return CostModel(Integer(self.workload)).multiply_combine(self.cost_multiplier).plus_combine(self.overhead)
