# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
from typing import List
from sympy import Function, Symbol, init_printing, Expr  # type: ignore


class CostModel(object):
    path_decisions: List[int]
    identifier: str
    model: Expr

    def __init__(self, performance_model: Expr, identifier: str = "None", path_decisions=None):
        if path_decisions is None:
            self.path_decisions = []
        else:
            # used for the construction of combined models
            self.path_decisions = path_decisions
        self.identifier = identifier
        self.model = performance_model

    def __str__(self):
        return str(self.model)

    def print(self):
        init_printing()
        print(self.model)

    def plus_combine(self, other):
        """Combines both models in the following fashion:
        f(x,y) = x + y"""
        if other is None:
            return self
        combined_model = self.model + other.model
        path_decisions = self.path_decisions + other.path_decisions
        return CostModel(combined_model, path_decisions=path_decisions)

    def divide_combine(self, other):
        """Combines both models in the following fashion:
        f(x,y) = x / y"""
        if other is None:
            return self
        combined_model = self.model / other.model
        path_decisions = self.path_decisions + other.path_decisions
        return CostModel(combined_model, path_decisions=path_decisions)

    def multiply_combine(self, other):
        """Combines both models in the following fashion:
                f(x,y) = x * y"""
        if other is None:
            return self
        combined_model = self.model * other.model
        path_decisions = self.path_decisions + other.path_decisions
        return CostModel(combined_model, path_decisions=path_decisions)