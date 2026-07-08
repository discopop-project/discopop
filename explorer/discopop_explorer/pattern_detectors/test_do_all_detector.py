# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
from __future__ import annotations

import sys
from typing import Callable, cast

from discopop_explorer.classes.PEGraph.Dependency import Dependency
from discopop_explorer.classes.PEGraph.FunctionNode import FunctionNode
from discopop_explorer.classes.PEGraph.LoopNode import LoopNode
from discopop_explorer.classes.PEGraph.Node import Node
from discopop_explorer.classes.PEGraph.PEGraphX import PEGraphX
from discopop_explorer.classes.variable import Variable
from discopop_explorer.enums.EdgeType import EdgeType
from discopop_explorer.enums.NodeType import NodeType
from discopop_explorer.pattern_detectors.combined_gpu_patterns.classes.Aliases import VarName
from discopop_explorer.pattern_detectors.do_all_detector import (
    __calculate_nesting_level,
    __check_for_problematic_function_argument_access,
    __get_called_functions,
    __get_parent_loops,
)

MakeNode = Callable[..., Node]
BuildPetGraph = Callable[..., PEGraphX]


def _loop(node: Node) -> LoopNode:
    return cast(LoopNode, node)


# --- __calculate_nesting_level -------------------------------------------------


def test_calculate_nesting_level_zero_for_direct_child(make_node: MakeNode, build_pet_graph: BuildPetGraph) -> None:
    loop = make_node("1:1", NodeType.LOOP, name="loop")
    cu = make_node("1:2", NodeType.CU, name="cu")
    pet = build_pet_graph([loop, cu], [(loop.id, cu.id, EdgeType.CHILD)])
    assert __calculate_nesting_level(pet, _loop(loop), cu.id) == 0


def test_calculate_nesting_level_counts_intermediate_ancestors(
    make_node: MakeNode, build_pet_graph: BuildPetGraph
) -> None:
    outer = make_node("1:1", NodeType.LOOP, name="outer")
    inner = make_node("1:2", NodeType.LOOP, name="inner")
    cu = make_node("1:3", NodeType.CU, name="cu")
    pet = build_pet_graph(
        [outer, inner, cu],
        [(outer.id, inner.id, EdgeType.CHILD), (inner.id, cu.id, EdgeType.CHILD)],
    )
    assert __calculate_nesting_level(pet, _loop(outer), cu.id) == 1


def test_calculate_nesting_level_returns_maxsize_when_unrelated(
    make_node: MakeNode, build_pet_graph: BuildPetGraph
) -> None:
    loop = make_node("1:1", NodeType.LOOP, name="loop")
    cu = make_node("1:2", NodeType.CU, name="cu")
    pet = build_pet_graph([loop, cu])
    assert __calculate_nesting_level(pet, _loop(loop), cu.id) == sys.maxsize


# --- __get_parent_loops ---------------------------------------------------------


def test_get_parent_loops_returns_ancestor_loops_excluding_self(
    make_node: MakeNode, build_pet_graph: BuildPetGraph
) -> None:
    outer = make_node("1:1", NodeType.LOOP, name="outer", start_line=1)
    inner = make_node("1:2", NodeType.LOOP, name="inner", start_line=2)
    pet = build_pet_graph([outer, inner], [(outer.id, inner.id, EdgeType.CHILD)])
    assert __get_parent_loops(pet, _loop(inner)) == [outer.start_position()]


def test_get_parent_loops_empty_for_top_level_loop(make_node: MakeNode, build_pet_graph: BuildPetGraph) -> None:
    main = make_node("1:1", NodeType.FUNC, name="main")
    loop = make_node("1:2", NodeType.LOOP, name="loop")
    pet = build_pet_graph([main, loop], [(main.id, loop.id, EdgeType.CHILD)])
    assert __get_parent_loops(pet, _loop(loop)) == []


def test_get_parent_loops_follows_calls_node_edges(make_node: MakeNode, build_pet_graph: BuildPetGraph) -> None:
    outer = make_node("1:1", NodeType.LOOP, name="outer", start_line=1)
    caller_cu = make_node("1:2", NodeType.CU, name="caller_cu")
    helper = make_node("2:1", NodeType.FUNC, name="helper")
    inner = make_node("2:2", NodeType.LOOP, name="inner", start_line=2)
    pet = build_pet_graph(
        [outer, caller_cu, helper, inner],
        [
            (outer.id, caller_cu.id, EdgeType.CHILD),
            (caller_cu.id, helper.id, EdgeType.CALLSNODE),
            (helper.id, inner.id, EdgeType.CHILD),
        ],
    )
    assert __get_parent_loops(pet, _loop(inner)) == [outer.start_position()]


# --- __get_called_functions -----------------------------------------------------


def test_get_called_functions_collects_direct_call(make_node: MakeNode, build_pet_graph: BuildPetGraph) -> None:
    loop = make_node("1:1", NodeType.LOOP, name="loop")
    cu = make_node("1:2", NodeType.CU, name="cu")
    helper = make_node("2:1", NodeType.FUNC, name="helper")
    pet = build_pet_graph(
        [loop, cu, helper],
        [(loop.id, cu.id, EdgeType.CHILD), (cu.id, helper.id, EdgeType.CALLSNODE)],
    )
    assert __get_called_functions(pet, _loop(loop)) == [helper.start_position()]


def test_get_called_functions_empty_when_nothing_called(make_node: MakeNode, build_pet_graph: BuildPetGraph) -> None:
    loop = make_node("1:1", NodeType.LOOP, name="loop")
    cu = make_node("1:2", NodeType.CU, name="cu")
    pet = build_pet_graph([loop, cu], [(loop.id, cu.id, EdgeType.CHILD)])
    assert __get_called_functions(pet, _loop(loop)) == []


# --- __check_for_problematic_function_argument_access ---------------------------


def test_problematic_function_argument_access_true_for_shared_pointer_arg(
    make_node: MakeNode, build_pet_graph: BuildPetGraph
) -> None:
    func = make_node("1:1", NodeType.FUNC, name="f", args=[Variable("int*", VarName("p"), "1:1")])
    cu1 = make_node("1:2", NodeType.CU, name="cu1")
    cu2 = make_node("1:3", NodeType.CU, name="cu2")
    pet = build_pet_graph([func, cu1, cu2], [(func.id, cu1.id, EdgeType.CHILD), (func.id, cu2.id, EdgeType.CHILD)])
    dep = Dependency(EdgeType.DATA)
    dep.var_name = "p"
    assert __check_for_problematic_function_argument_access(pet, cu1.id, cu2.id, dep) is True


def test_problematic_function_argument_access_false_for_non_pointer_arg(
    make_node: MakeNode, build_pet_graph: BuildPetGraph
) -> None:
    func = make_node("1:1", NodeType.FUNC, name="f", args=[Variable("int", VarName("x"), "1:1")])
    cu1 = make_node("1:2", NodeType.CU, name="cu1")
    cu2 = make_node("1:3", NodeType.CU, name="cu2")
    pet = build_pet_graph([func, cu1, cu2], [(func.id, cu1.id, EdgeType.CHILD), (func.id, cu2.id, EdgeType.CHILD)])
    dep = Dependency(EdgeType.DATA)
    dep.var_name = "x"
    assert __check_for_problematic_function_argument_access(pet, cu1.id, cu2.id, dep) is False


def test_problematic_function_argument_access_false_when_var_is_not_an_argument(
    make_node: MakeNode, build_pet_graph: BuildPetGraph
) -> None:
    func = make_node("1:1", NodeType.FUNC, name="f", args=[])
    cu1 = make_node("1:2", NodeType.CU, name="cu1")
    cu2 = make_node("1:3", NodeType.CU, name="cu2")
    pet = build_pet_graph([func, cu1, cu2], [(func.id, cu1.id, EdgeType.CHILD), (func.id, cu2.id, EdgeType.CHILD)])
    dep = Dependency(EdgeType.DATA)
    dep.var_name = "not_an_arg"
    assert __check_for_problematic_function_argument_access(pet, cu1.id, cu2.id, dep) is False
