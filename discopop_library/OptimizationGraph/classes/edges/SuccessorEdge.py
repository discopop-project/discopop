# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
from sympy import Symbol  # type: ignore

from discopop_library.OptimizationGraph.CostModels.CostModel import CostModel
from discopop_library.OptimizationGraph.classes.edges.GenericEdge import GenericEdge


class SuccessorEdge(GenericEdge):
    pass

    def get_cost_model(self) -> CostModel:
        # todo this is only a dummy, not a finished model!
        transfer_cost = Symbol("transfer_cost")
        return CostModel(transfer_cost)
