# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
"""Tests for the PET node classes: the id and line handling every Node shares, and the structural
queries of FunctionNode and LoopNode."""

from __future__ import annotations

from typing import Any

import pytest

from discopop_explorer.aliases.NodeID import NodeID
from discopop_explorer.classes.PEGraph.CUNode import CUNode
from discopop_explorer.classes.PEGraph.DummyNode import DummyNode
from discopop_explorer.classes.PEGraph.FunctionNode import FunctionNode
from discopop_explorer.classes.PEGraph.FunctionReturnNode import FunctionReturnNode
from discopop_explorer.classes.PEGraph.LoopNode import LoopNode
from discopop_explorer.classes.PEGraph.Node import Node
from discopop_explorer.enums.EdgeType import EdgeType
from discopop_explorer.enums.NodeType import NodeType

# --- Node ---------------------------------------------------------------------------------


def test_node_id_is_split_into_file_and_node_id() -> None:
    node = Node(NodeID("3:42"))

    assert (node.file_id, node.node_id) == (3, 42)
    assert f"{node}" == "3:42"


def test_str_of_a_node_is_its_id() -> None:
    """str() re-initializes a str subclass returned by __str__ with the object it was called on, so
    returning the NodeID itself made str(node) run NodeID.__init__(node), which rejects it."""
    value = str(Node(NodeID("3:42")))

    assert value == "3:42"
    assert type(value) is str


def test_start_and_end_positions() -> None:
    node = Node(NodeID("3:42"))
    node.start_line, node.end_line = 10, 12

    assert node.start_position() == "3:10"
    assert node.end_position() == "3:12"
    assert node.get_contained_line_ids() == ["3:10", "3:11", "3:12"]


@pytest.mark.parametrize(  # type: ignore[misc]
    "line, contained",
    [
        ("3:10", True),
        ("3:11", True),
        ("3:12", True),
        ("3:9", False),
        ("3:13", False),
        ("4:11", False),  # same line, other file
        ("GlobalVar", False),
        ("LineNotFound", False),
        ("11", False),
    ],
)
def test_contains_line(line: str, contained: bool) -> None:
    node = Node(NodeID("3:42"))
    node.start_line, node.end_line = 10, 12

    assert node.contains_line(line) is contained


def test_nodes_are_equal_by_id_regardless_of_their_class() -> None:
    """A PET graph holds exactly one node per id, so the id alone identifies a node."""
    cu, same_id, other = CUNode(NodeID("1:2")), Node(NodeID("1:2")), CUNode(NodeID("1:3"))

    assert cu == same_id and hash(cu) == hash(same_id)
    assert cu != other
    assert cu != "1:2", "a node does not compare equal to its bare id"
    assert len({cu, same_id, other}) == 2


@pytest.mark.parametrize(  # type: ignore[misc]
    "node_class, node_type",
    [
        (CUNode, NodeType.CU),
        (FunctionNode, NodeType.FUNC),
        (LoopNode, NodeType.LOOP),
        (DummyNode, NodeType.DUMMY),
        (FunctionReturnNode, NodeType.DUMMY),
    ],
)
def test_node_classes_set_their_type(node_class: Any, node_type: NodeType) -> None:
    assert node_class(NodeID("1:1")).type == node_type


# --- FunctionNode -------------------------------------------------------------------------


def _function_with_cus(make_node: Any, build_pet_graph: Any) -> Any:
    """function 1:0 with 1:1 -> 1:2 -> 1:3, plus 1:4 which has neither predecessors nor successors"""
    function = make_node("1:0", NodeType.FUNC, name="f")
    cus = [make_node("1:" + str(i), NodeType.CU) for i in range(1, 5)]
    edges = [("1:0", cu.id, EdgeType.CHILD) for cu in cus]
    edges += [("1:1", "1:2", EdgeType.SUCCESSOR), ("1:2", "1:3", EdgeType.SUCCESSOR)]
    pet = build_pet_graph([function] + cus, edges)
    function.children_cu_ids = [cu.id for cu in cus]
    return pet, function


def test_function_entry_cu_is_a_child_without_predecessor(make_node: Any, build_pet_graph: Any) -> None:
    pet, function = _function_with_cus(make_node, build_pet_graph)

    assert function.get_entry_cu_id(pet) in ("1:1", "1:4")


def test_function_without_entry_cu_is_rejected(make_node: Any, build_pet_graph: Any) -> None:
    function = make_node("1:0", NodeType.FUNC, name="f")
    pet = build_pet_graph(
        [function, make_node("1:1", NodeType.CU), make_node("1:2", NodeType.CU)],
        [
            ("1:0", "1:1", EdgeType.CHILD),
            ("1:0", "1:2", EdgeType.CHILD),
            ("1:1", "1:2", EdgeType.SUCCESSOR),
            ("1:2", "1:1", EdgeType.SUCCESSOR),
        ],
    )

    with pytest.raises(ValueError, match="No entry CU found"):
        function.get_entry_cu_id(pet)


def test_function_exit_cus_are_reached_but_lead_nowhere(make_node: Any, build_pet_graph: Any) -> None:
    """An isolated CU is not an exit, since control flow never reaches it."""
    pet, function = _function_with_cus(make_node, build_pet_graph)

    assert function.get_exit_cu_ids(pet) == {"1:3"}


def test_function_exit_cus_need_the_children_metadata(make_node: Any, build_pet_graph: Any) -> None:
    pet, function = _function_with_cus(make_node, build_pet_graph)
    function.children_cu_ids = None

    assert function.get_exit_cu_ids(pet) == set()


def test_function_reachability_pairs(make_node: Any, build_pet_graph: Any) -> None:
    pet, function = _function_with_cus(make_node, build_pet_graph)

    reachability = function.calculate_reachability_pairs(pet)

    assert reachability == {
        "1:1": {"1:1", "1:2", "1:3"},
        "1:2": {"1:2", "1:3"},
        "1:3": {"1:3"},
        "1:4": {"1:4"},
    }


def test_function_reachability_pairs_share_the_set_of_a_cycle(make_node: Any, build_pet_graph: Any) -> None:
    function = make_node("1:0", NodeType.FUNC, name="f")
    cus = [make_node("1:" + str(i), NodeType.CU) for i in range(1, 4)]
    edges = [("1:0", cu.id, EdgeType.CHILD) for cu in cus]
    edges += [
        ("1:1", "1:2", EdgeType.SUCCESSOR),
        ("1:2", "1:1", EdgeType.SUCCESSOR),
        ("1:2", "1:3", EdgeType.SUCCESSOR),
    ]
    pet = build_pet_graph([function] + cus, edges)
    function.children_cu_ids = [cu.id for cu in cus]

    reachability = function.calculate_reachability_pairs(pet)

    assert reachability["1:1"] == reachability["1:2"] == {"1:1", "1:2", "1:3"}
    assert reachability["1:3"] == {"1:3"}


# --- LoopNode -----------------------------------------------------------------------------


def _nested_loops(make_node: Any, build_pet_graph: Any, depth: int) -> Any:
    """function 1:0 containing loop 1:1 containing loop 1:2 ... down to loop 1:<depth>"""
    nodes = [make_node("1:0", NodeType.FUNC, name="f")]
    nodes += [make_node("1:" + str(i), NodeType.LOOP) for i in range(1, depth + 1)]
    edges = [("1:" + str(i), "1:" + str(i + 1), EdgeType.CHILD) for i in range(depth)]
    return build_pet_graph(nodes, edges)


def test_loop_nesting_level_counts_down_from_the_outermost_loop(make_node: Any, build_pet_graph: Any) -> None:
    """The profiler's loop stack tracks three levels: 2 for a loop directly inside a function, then
    1 and 0 further inside. Anything deeper is cut off at 0. Every loop used to get level 2, since
    the enclosing loop itself was not counted."""
    pet = _nested_loops(make_node, build_pet_graph, 4)

    levels = [pet.node_at(NodeID("1:" + str(i))).get_nesting_level(pet) for i in range(1, 5)]

    assert levels == [2, 1, 0, 0]


def test_loop_entry_node_is_entered_from_outside_the_loop(make_node: Any, build_pet_graph: Any) -> None:
    """before -> header -> body -> header: the header is the only child with a predecessor outside"""
    loop = make_node("1:1", NodeType.LOOP)
    before, header, body = (make_node(i, NodeType.CU) for i in ("1:2", "1:3", "1:4"))
    pet = build_pet_graph(
        [loop, before, header, body],
        [
            ("1:1", "1:3", EdgeType.CHILD),
            ("1:1", "1:4", EdgeType.CHILD),
            ("1:2", "1:3", EdgeType.SUCCESSOR),
            ("1:3", "1:4", EdgeType.SUCCESSOR),
            ("1:4", "1:3", EdgeType.SUCCESSOR),
        ],
    )

    assert loop.get_entry_node(pet) is header


def test_loop_without_entry_from_outside_has_no_entry_node(make_node: Any, build_pet_graph: Any) -> None:
    loop = make_node("1:1", NodeType.LOOP)
    pet = build_pet_graph([loop, make_node("1:2", NodeType.CU)], [("1:1", "1:2", EdgeType.CHILD)])

    assert loop.get_entry_node(pet) is None


def test_loop_indices_are_per_instance() -> None:
    first, second = LoopNode(NodeID("1:1")), LoopNode(NodeID("1:2"))

    first.loop_indices.append("i")

    assert second.loop_indices == []
