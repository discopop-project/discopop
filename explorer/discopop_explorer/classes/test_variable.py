# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
"""Tests for Variable, which the pattern detectors collect into sets and sorted lists and
serialize into the suggestions' variable classifications."""

from __future__ import annotations

from discopop_explorer.classes.variable import Variable
from discopop_explorer.pattern_detectors.combined_gpu_patterns.classes.Aliases import VarName


def test_variables_are_identified_by_name() -> None:
    """The same variable is found in several CUs, with differing access modes."""
    first = Variable("int", VarName("x"), "1:3", accessMode="R")
    second = Variable("float", VarName("x"), "1:9", accessMode="W")

    assert first == second and hash(first) == hash(second)
    assert len({first, second, Variable("int", VarName("y"), "1:3")}) == 2
    assert first != "x"


def test_variables_sort_by_name() -> None:
    names = [
        str(v)
        for v in sorted(
            [Variable("int", VarName("c"), ""), Variable("int", VarName("a"), ""), Variable("int", VarName("b"), "")]
        )
    ]

    assert names == ["a", "b", "c"]


def test_unknown_size_defaults_to_the_size_of_a_pointer() -> None:
    """A size of 0 is reported for pointers, and would otherwise be divided by."""
    assert Variable("int*", VarName("p"), "1:1").sizeInByte == 8
    assert Variable("double", VarName("d"), "1:1", sizeInByte=16).sizeInByte == 16


def test_json_representation_carries_the_reduction_operation() -> None:
    variable = Variable("int", VarName("sum"), "1:1")
    assert variable.toJSON() == "sum"

    variable.operation = "+"

    assert variable.toJSON() == "+:sum"
