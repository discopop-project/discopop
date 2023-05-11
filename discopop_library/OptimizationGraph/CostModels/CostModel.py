# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
import random
from functools import cmp_to_key
from typing import List, Dict, Tuple

import sympy
from sympy import Function, Symbol, init_printing, Expr  # type: ignore


class CostModel(object):
    path_decisions: List[int]
    identifier: str
    model: Expr
    free_symbol_ranges: Dict[Symbol, Tuple[float, float]]
    symbol_value_suggestions: Dict[Symbol, Expr]

    def __init__(
        self,
        performance_model: Expr,
        identifier: str = "None",
        path_decisions=None,
        symbol_value_suggestions: Dict[Symbol, Expr] = None,
    ):
        if path_decisions is None:
            self.path_decisions = []
        else:
            # used for the construction of combined models
            self.path_decisions = path_decisions
        if symbol_value_suggestions is None:
            self.symbol_value_suggestions = dict()
        else:
            self.symbol_value_suggestions = symbol_value_suggestions
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
        value_suggestions = self.symbol_value_suggestions | other.symbol_value_suggestions
        return CostModel(
            combined_model,
            path_decisions=path_decisions,
            symbol_value_suggestions=value_suggestions,
        )

    def divide_combine(self, other):
        """Combines both models in the following fashion:
        f(x,y) = x / y"""
        if other is None:
            return self
        combined_model = self.model / other.model
        path_decisions = self.path_decisions + other.path_decisions
        value_suggestions = self.symbol_value_suggestions | other.symbol_value_suggestions
        return CostModel(
            combined_model,
            path_decisions=path_decisions,
            symbol_value_suggestions=value_suggestions,
        )

    def multiply_combine(self, other):
        """Combines both models in the following fashion:
        f(x,y) = x * y"""
        if other is None:
            return self
        combined_model = self.model * other.model
        path_decisions = self.path_decisions + other.path_decisions
        value_suggestions = self.symbol_value_suggestions | other.symbol_value_suggestions
        return CostModel(
            combined_model,
            path_decisions=path_decisions,
            symbol_value_suggestions=value_suggestions,
        )

    def __lt__(self, other):
        """Compare both models.
        The comparison is based on random sampling and may not be correct in all cases!
        """
        decision_tendency = (
            0  # positive -> self was evaluated to be smaller more often than the other way around
        )
        decided = False
        counter = 0
        min_count = 50
        max_count = 300
        decision_threshold = 0.85

        # draw and evaluate random samples until either the max_count has been reached, or a decision has been made
        while not (decided or counter > max_count) or counter < min_count:
            counter += 1
            # determine random sampling point
            sampling_point = dict()
            for symbol in self.free_symbol_ranges:
                range_min, range_max = self.free_symbol_ranges[symbol]
                sampling_point[symbol] = random.uniform(range_min, range_max)
            # evaluate both functions at the sampling point
            substituted_model_1 = self.model.xreplace(sampling_point)
            numerical_result_1 = substituted_model_1.evalf()
            substituted_model_2 = other.model.xreplace(sampling_point)
            numerical_result_2 = substituted_model_2.evalf()

            # determine relation between the numerical results
            if numerical_result_1 < numerical_result_2:
                decision_tendency += 1
            else:
                decision_tendency -= 1

            if counter > min_count:
                # check if a decision in either direction can be made
                if decision_threshold < (abs(decision_tendency) / counter):
                    decided = True

        # check if a decision has been made
        if decided:
            # print("DECIDED: ", decision_tendency, " -> ", decision_tendency / counter, " @ ", counter, "samples")
            if decision_tendency > 0:
                return True
            else:
                return False
        else:
            # print("UNDECIDED: ", decision_tendency, " -> ", decision_tendency / counter, " @ ", counter, "samples")
            return False
