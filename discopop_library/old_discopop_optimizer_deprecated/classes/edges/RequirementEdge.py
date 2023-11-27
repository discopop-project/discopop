# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
from sympy import Symbol  # type: ignore

from discopop_library.discopop_optimizer.CostModels.CostModel import CostModel
from discopop_library.discopop_optimizer.classes.edges.GenericEdge import GenericEdge


class RequirementEdge(GenericEdge):
    """Used to represent dependencies between path selections in the form of:
    if A is selected, it is required that B is selected as well."""

    pass

    def get_cost_model(self) -> CostModel:
        raise ValueError("The cost of a RequirementEdge is not defined and may never be used!")
