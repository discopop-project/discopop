# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
from __future__ import annotations

from typing import Callable, List, Tuple, cast

from discopop_explorer.aliases.LineID import LineID
from discopop_explorer.aliases.MemoryRegion import MemoryRegion
from discopop_explorer.aliases.NodeID import NodeID
from discopop_explorer.classes.PEGraph.CUNode import CUNode
from discopop_explorer.classes.PEGraph.Dependency import Dependency
from discopop_explorer.classes.PEGraph.LoopNode import LoopNode
from discopop_explorer.classes.PEGraph.Node import Node
from discopop_explorer.classes.PEGraph.PEGraphX import PEGraphX
from discopop_explorer.classes.variable import Variable
from discopop_explorer.enums.EdgeType import EdgeType
from discopop_explorer.enums.NodeType import NodeType
from discopop_explorer.pattern_detectors.combined_gpu_patterns.classes.Aliases import VarName
from discopop_explorer.utils import (
    is_first_written,
    is_func_arg,
    is_global,
    is_readonly,
    is_read_in_subtree,
    is_reduction_any,
    is_reduction_var,
    is_scalar_val,
    is_written_in_subtree,
    no_inter_iteration_dependency_exists,
    var_declared_in_subtree,
    __merge_classifications,
)

MakeNode = Callable[..., Node]
BuildPetGraph = Callable[..., PEGraphX]

Edge = Tuple[NodeID, NodeID, Dependency]


def _cu(node: Node) -> CUNode:
    return cast(CUNode, node)


def _loop(node: Node) -> LoopNode:
    return cast(LoopNode, node)


def _dep(memory_region: str, **attrs: object) -> Dependency:
    d = Dependency(EdgeType.DATA)
    d.memory_region = MemoryRegion(memory_region)
    for key, value in attrs.items():
        setattr(d, key, value)
    return d


def _edge(source: str, target: str, dep: Dependency) -> Edge:
    return (NodeID(source), NodeID(target), dep)


# --- is_scalar_val -------------------------------------------------------------


def test_is_scalar_val_true_for_plain_and_single_pointer_types() -> None:
    assert is_scalar_val(Variable("int", VarName("x"), "1:1")) is True
    assert is_scalar_val(Variable("int*", VarName("x"), "1:1")) is True


def test_is_scalar_val_false_for_double_pointer_and_array_types() -> None:
    assert is_scalar_val(Variable("int**", VarName("x"), "1:1")) is False
    assert is_scalar_val(Variable("ARRAY_5_int", VarName("x"), "1:1")) is False
    assert is_scalar_val(Variable("[5]", VarName("x"), "1:1")) is False


# --- is_global -------------------------------------------------------------------


def test_is_global_true_when_variable_is_a_global_var_of_a_cu(make_node: MakeNode) -> None:
    cu = make_node("1:1", NodeType.CU, name="cu", global_vars=[Variable("int", VarName("g"), "1:1")])
    assert is_global("g", [cu]) is True


def test_is_global_false_for_unrelated_or_local_variable(make_node: MakeNode) -> None:
    cu = make_node(
        "1:1",
        NodeType.CU,
        name="cu",
        global_vars=[Variable("int", VarName("g"), "1:1")],
        local_vars=[Variable("int", VarName("local"), "1:2")],
    )
    assert is_global("local", [cu]) is False
    assert is_global("missing", [cu]) is False


def test_is_global_ignores_non_cu_nodes(make_node: MakeNode) -> None:
    loop = make_node("1:1", NodeType.LOOP, name="loop")
    assert is_global("g", [loop]) is False


# --- is_readonly -----------------------------------------------------------------


def test_is_readonly_true_without_matching_dependencies() -> None:
    assert is_readonly({MemoryRegion("M1")}, set(), set(), set()) is True


def test_is_readonly_false_when_war_dependency_matches() -> None:
    war = {_edge("1:1", "1:2", _dep("M1"))}
    assert is_readonly({MemoryRegion("M1")}, war, set(), set()) is False


def test_is_readonly_false_when_waw_dependency_matches() -> None:
    waw = {_edge("1:1", "1:2", _dep("M1"))}
    assert is_readonly({MemoryRegion("M1")}, set(), waw, set()) is False


def test_is_readonly_true_when_dependency_targets_different_memory_region() -> None:
    war = {_edge("1:1", "1:2", _dep("M2"))}
    assert is_readonly({MemoryRegion("M1")}, war, set(), set()) is True


# --- is_written_in_subtree --------------------------------------------------------


def test_is_written_in_subtree_true_when_raw_target_in_tree(make_node: MakeNode) -> None:
    target = make_node("1:2", NodeType.CU, name="target")
    raw = {_edge("1:1", "1:2", _dep("M1"))}
    assert is_written_in_subtree({MemoryRegion("M1")}, raw, set(), [target]) is True


def test_is_written_in_subtree_false_when_target_outside_tree(make_node: MakeNode) -> None:
    other = make_node("1:3", NodeType.CU, name="other")
    raw = {_edge("1:1", "1:2", _dep("M1"))}
    assert is_written_in_subtree({MemoryRegion("M1")}, raw, set(), [other]) is False


def test_is_written_in_subtree_false_for_unrelated_memory_region(make_node: MakeNode) -> None:
    target = make_node("1:2", NodeType.CU, name="target")
    raw = {_edge("1:1", "1:2", _dep("M2"))}
    assert is_written_in_subtree({MemoryRegion("M1")}, raw, set(), [target]) is False


# --- is_first_written --------------------------------------------------------------


def test_is_first_written_true_without_any_dependencies() -> None:
    assert is_first_written({MemoryRegion("M1")}, set(), set(), []) is True


def test_is_first_written_false_when_raw_target_lies_outside_subtree(make_node: MakeNode) -> None:
    sub = [_cu(make_node("1:2", NodeType.CU, name="inside"))]
    raw = {_edge("1:1", "1:3", _dep("M1"))}  # target "1:3" is outside `sub`
    assert is_first_written({MemoryRegion("M1")}, raw, set(), sub) is False


def test_is_first_written_true_when_raw_target_lies_inside_subtree(make_node: MakeNode) -> None:
    sub = [_cu(make_node("1:2", NodeType.CU, name="inside"))]
    raw = {_edge("1:1", "1:2", _dep("M1"))}
    assert is_first_written({MemoryRegion("M1")}, raw, set(), sub) is True


def test_is_first_written_false_when_war_write_has_no_matching_raw(make_node: MakeNode) -> None:
    sub = [_cu(make_node("1:2", NodeType.CU, name="inside"))]
    war = {_edge("1:1", "1:2", _dep("M1"))}
    assert is_first_written({MemoryRegion("M1")}, set(), war, sub) is False


def test_is_first_written_true_when_war_write_has_matching_raw_at_same_line(make_node: MakeNode) -> None:
    sub = [_cu(make_node("1:2", NodeType.CU, name="inside"))]
    war_dep = _dep("M1", source_line=LineID("1:5"))
    raw_dep = _dep("M1", sink_line=LineID("1:5"))
    war = {_edge("1:1", "1:2", war_dep)}
    raw = {_edge("1:1", "1:2", raw_dep)}
    assert is_first_written({MemoryRegion("M1")}, raw, war, sub) is True


# --- is_read_in_subtree ------------------------------------------------------------


def test_is_read_in_subtree_true_when_source_of_reverse_raw_is_in_tree(make_node: MakeNode) -> None:
    tree = [make_node("1:1", NodeType.CU, name="reader")]
    rev_raw = {_edge("1:1", "1:2", _dep("M1"))}
    assert is_read_in_subtree({MemoryRegion("M1")}, rev_raw, tree) is True


def test_is_read_in_subtree_false_when_source_outside_tree(make_node: MakeNode) -> None:
    tree = [make_node("1:9", NodeType.CU, name="unrelated")]
    rev_raw = {_edge("1:1", "1:2", _dep("M1"))}
    assert is_read_in_subtree({MemoryRegion("M1")}, rev_raw, tree) is False


# --- is_func_arg -------------------------------------------------------------------


def test_is_func_arg_true_when_var_is_prefixed_by_argument_name(
    make_node: MakeNode, build_pet_graph: BuildPetGraph
) -> None:
    func = make_node("1:1", NodeType.FUNC, name="f", args=[Variable("int*", VarName("arr"), "1:1")])
    cu = make_node("1:2", NodeType.CU, name="cu")
    pet = build_pet_graph([func, cu], [(func.id, cu.id, EdgeType.CHILD)])
    assert is_func_arg(pet, "arr.addr", cu) is True


def test_is_func_arg_false_without_dot_in_var_name(make_node: MakeNode, build_pet_graph: BuildPetGraph) -> None:
    func = make_node("1:1", NodeType.FUNC, name="f", args=[Variable("int*", VarName("arr"), "1:1")])
    cu = make_node("1:2", NodeType.CU, name="cu")
    pet = build_pet_graph([func, cu], [(func.id, cu.id, EdgeType.CHILD)])
    assert is_func_arg(pet, "arr", cu) is False


def test_is_func_arg_false_for_none_var(make_node: MakeNode, build_pet_graph: BuildPetGraph) -> None:
    func = make_node("1:1", NodeType.FUNC, name="f", args=[])
    cu = make_node("1:2", NodeType.CU, name="cu")
    pet = build_pet_graph([func, cu], [(func.id, cu.id, EdgeType.CHILD)])
    assert is_func_arg(pet, cast(str, None), cu) is False


def test_is_func_arg_considers_the_function_node_itself(make_node: MakeNode, build_pet_graph: BuildPetGraph) -> None:
    func = make_node("1:1", NodeType.FUNC, name="f", args=[Variable("int*", VarName("arr"), "1:1")])
    pet = build_pet_graph([func])
    assert is_func_arg(pet, "arr.addr", func) is True


# --- var_declared_in_subtree --------------------------------------------------------


def test_var_declared_in_subtree_true_when_defline_within_a_nodes_range(make_node: MakeNode) -> None:
    var = Variable("int", VarName("x"), "1:5")
    node = make_node("1:1", NodeType.CU, name="cu", start_line=1, end_line=10)
    assert var_declared_in_subtree(var, [_cu(node)]) is True


def test_var_declared_in_subtree_false_when_outside_all_ranges(make_node: MakeNode) -> None:
    var = Variable("int", VarName("x"), "1:50")
    node = make_node("1:1", NodeType.CU, name="cu", start_line=1, end_line=10)
    assert var_declared_in_subtree(var, [_cu(node)]) is False


def test_var_declared_in_subtree_false_for_malformed_defline(make_node: MakeNode) -> None:
    var = Variable("int", VarName("x"), "GlobalVar")
    node = make_node("1:1", NodeType.CU, name="cu", start_line=1, end_line=10)
    assert var_declared_in_subtree(var, [_cu(node)]) is False


# --- no_inter_iteration_dependency_exists --------------------------------------------


def test_no_inter_iteration_dependency_exists_true_by_default(make_node: MakeNode) -> None:
    loop = _loop(make_node("1:1", NodeType.LOOP, name="loop", start_line=5))
    sub = [_cu(make_node("1:2", NodeType.CU, name="a")), _cu(make_node("1:3", NodeType.CU, name="b"))]
    dep = _dep("M1")  # metadata_inter_iteration_dep defaults to []
    raw = {_edge("1:2", "1:3", dep)}
    assert no_inter_iteration_dependency_exists({MemoryRegion("M1")}, raw, set(), sub, loop) is True


def test_no_inter_iteration_dependency_exists_false_when_flagged_for_this_loop(make_node: MakeNode) -> None:
    loop = _loop(make_node("1:1", NodeType.LOOP, name="loop", start_line=5))
    sub = [_cu(make_node("1:2", NodeType.CU, name="a")), _cu(make_node("1:3", NodeType.CU, name="b"))]
    dep = _dep("M1", metadata_inter_iteration_dep=[loop.start_position()])
    raw = {_edge("1:2", "1:3", dep)}
    assert no_inter_iteration_dependency_exists({MemoryRegion("M1")}, raw, set(), sub, loop) is False


def test_no_inter_iteration_dependency_exists_ignores_deps_outside_subtree(make_node: MakeNode) -> None:
    loop = _loop(make_node("1:1", NodeType.LOOP, name="loop", start_line=5))
    sub = [_cu(make_node("1:2", NodeType.CU, name="a"))]
    dep = _dep("M1", metadata_inter_iteration_dep=[loop.start_position()])
    raw = {_edge("1:2", "1:9", dep)}  # "1:9" is not part of `sub`
    assert no_inter_iteration_dependency_exists({MemoryRegion("M1")}, raw, set(), sub, loop) is True


# --- __merge_classifications (utils.py) ----------------------------------------------


def test_merge_classifications_firstprivate_takes_precedence_over_private() -> None:
    fp = [Variable("int", VarName("x"), "1:1")]
    p = [Variable("int", VarName("x"), "1:1")]
    new_fp, new_p, new_lp, new_shared, new_red = __merge_classifications(fp, p, [], [], [])
    assert new_fp == fp
    assert new_p == []


def test_merge_classifications_lastprivate_takes_precedence_over_private() -> None:
    lp = [Variable("int", VarName("x"), "1:1")]
    p = [Variable("int", VarName("x"), "1:1")]
    new_fp, new_p, new_lp, new_shared, new_red = __merge_classifications([], p, lp, [], [])
    assert new_lp == lp
    assert new_p == []


def test_merge_classifications_shared_takes_precedence_over_private() -> None:
    shared = [Variable("int", VarName("x"), "1:1")]
    p = [Variable("int", VarName("x"), "1:1")]
    new_fp, new_p, new_lp, new_shared, new_red = __merge_classifications([], p, [], shared, [])
    assert new_shared == shared
    assert new_p == []


def test_merge_classifications_firstprivate_takes_precedence_over_shared() -> None:
    fp = [Variable("int", VarName("x"), "1:1")]
    shared = [Variable("int", VarName("x"), "1:1")]
    new_fp, new_p, new_lp, new_shared, new_red = __merge_classifications(fp, [], [], shared, [])
    assert new_fp == fp
    assert new_shared == []


def test_merge_classifications_reduction_passes_through_unchanged() -> None:
    reduction = [Variable("int", VarName("x"), "1:1")]
    new_fp, new_p, new_lp, new_shared, new_red = __merge_classifications([], [], [], [], reduction)
    assert new_red == reduction


def test_merge_classifications_disjoint_sets_pass_through_unchanged() -> None:
    fp = [Variable("int", VarName("a"), "1:1")]
    p = [Variable("int", VarName("b"), "1:2")]
    lp = [Variable("int", VarName("c"), "1:3")]
    shared = [Variable("int", VarName("d"), "1:4")]
    new_fp, new_p, new_lp, new_shared, new_red = __merge_classifications(fp, p, lp, shared, [])
    assert (new_fp, new_p, new_lp, new_shared) == (fp, p, lp, shared)


# --- is_reduction_var / is_reduction_any ----------------------------------------------


def test_is_reduction_var_true_for_matching_line_and_name() -> None:
    reduction_vars = [{"loop_line": "1:5", "name": "sum"}]
    assert is_reduction_var(LineID("1:5"), "sum", reduction_vars) is True


def test_is_reduction_var_false_for_mismatched_line_or_name() -> None:
    reduction_vars = [{"loop_line": "1:5", "name": "sum"}]
    assert is_reduction_var(LineID("1:6"), "sum", reduction_vars) is False
    assert is_reduction_var(LineID("1:5"), "other", reduction_vars) is False


def test_is_reduction_any_true_if_any_candidate_line_matches() -> None:
    reduction_vars = [{"loop_line": "1:5", "name": "sum"}]
    assert is_reduction_any([LineID("1:1"), LineID("1:5")], "sum", reduction_vars) is True


def test_is_reduction_any_false_when_no_line_matches() -> None:
    reduction_vars = [{"loop_line": "1:5", "name": "sum"}]
    assert is_reduction_any([LineID("1:1"), LineID("1:2")], "sum", reduction_vars) is False
