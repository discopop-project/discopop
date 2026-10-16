# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
"""Tests for TGNode and the marker node classes TaskGraph wraps contexts with. The labels are
what the plots and the construction passes' log output identify nodes by."""

from __future__ import annotations

from typing import Any

import pytest

from discopop_explorer.aliases.NodeID import NodeID
from discopop_explorer.classes.TaskGraph.Branching.TGEndBranchNode import TGEndBranchNode
from discopop_explorer.classes.TaskGraph.Branching.TGEndBranchParentNode import TGEndBranchParentNode
from discopop_explorer.classes.TaskGraph.Branching.TGStartBranchNode import TGStartBranchNode
from discopop_explorer.classes.TaskGraph.Branching.TGStartBranchParentNode import TGStartBranchParentNode
from discopop_explorer.classes.TaskGraph.Contexts.Context import Context
from discopop_explorer.classes.TaskGraph.Functions.TGEndFunctionNode import TGEndFunctionNode
from discopop_explorer.classes.TaskGraph.Functions.TGEndInlinedFunctionNode import TGEndInlinedFunctionNode
from discopop_explorer.classes.TaskGraph.Functions.TGStartFunctionNode import TGStartFunctionNode
from discopop_explorer.classes.TaskGraph.Functions.TGStartInlinedFunctionNode import TGStartInlinedFunctionNode
from discopop_explorer.classes.TaskGraph.Loops.TGEndLoopNode import TGEndLoopNode
from discopop_explorer.classes.TaskGraph.Loops.TGEndtIterationNode import TGEndIterationNode
from discopop_explorer.classes.TaskGraph.Loops.TGStartIterationNode import TGStartIterationNode
from discopop_explorer.classes.TaskGraph.Loops.TGStartLoopNode import TGStartLoopNode
from discopop_explorer.classes.TaskGraph.RootNode import RootNode
from discopop_explorer.classes.TaskGraph.TGFunctionNode import TGFunctionNode
from discopop_explorer.classes.TaskGraph.TGNode import TGNode
from discopop_explorer.classes.TaskGraph.VisitorMarker import EndFunctionMarker, VisitorMarker
from discopop_explorer.classes.TaskGraph.Work.TGEndWorkNode import TGEndWorkNode
from discopop_explorer.classes.TaskGraph.Work.TGStartWorkNode import TGStartWorkNode
from discopop_explorer.enums.NodeType import NodeType

NODE_ID = NodeID("1:7")


def test_new_node_has_no_contexts_and_no_state() -> None:
    node = TGNode(NODE_ID, 3, 4)

    assert (node.pet_node_id, node.level, node.position) == (NODE_ID, 3, 4)
    assert node.parent_context == set()
    assert node.created_context is None
    assert node.state_id is None
    assert node.get_label() == "1:7"


def test_parent_contexts_are_collected_and_the_created_context_is_replaced() -> None:
    node = TGNode(NODE_ID, 0, 0)
    first, second = Context(), Context()

    node.add_parent_context(first)
    node.add_parent_context(second)
    node.add_parent_context(first)
    node.register_created_context(first)
    node.register_created_context(second)

    assert node.parent_context == {first, second}
    assert node.created_context is second


def test_nodes_do_not_share_parent_contexts() -> None:
    """parent_context is assigned per instance - a class-level set would be shared by all nodes."""
    first, second = TGNode(NODE_ID, 0, 0), TGNode(NODE_ID, 0, 0)

    first.add_parent_context(Context())

    assert second.parent_context == set()


def test_get_pet_node(make_node: Any, build_pet_graph: Any) -> None:
    cu = make_node("1:7", NodeType.CU)
    pet = build_pet_graph([cu])

    assert TGNode(NODE_ID, 0, 0).get_pet_node(pet) is cu
    assert RootNode(None, 0, 0).get_pet_node(pet) is None, "nodes without a PET node, e.g. the root"


@pytest.mark.parametrize(  # type: ignore[misc]
    "node, label",
    [
        (RootNode(None, 0, 0), "Root"),
        (TGFunctionNode(NODE_ID, 0, 0), "FN 1:7"),
        (TGStartFunctionNode(NODE_ID, 0, 0), "Start FN 1:7\nstate: None"),
        (TGEndFunctionNode(NODE_ID, 0, 0), "End FN 1:7"),
        (TGStartInlinedFunctionNode(NODE_ID, 0, 0, 12), "Start inline FN 1:7"),
        (TGEndInlinedFunctionNode(NODE_ID, 0, 0), "End inline FN 1:7"),
        (TGStartLoopNode(NODE_ID, 0, 0), "Start Loop 1:7"),
        (TGEndLoopNode(NODE_ID, 0, 0), "End Loop 1:7"),
        (TGEndIterationNode(NODE_ID, 0, 0, NodeID("1:2")), "END IT 1:7"),
        (TGStartBranchParentNode(NODE_ID, 0, 0), "Start BranchParent"),
        (TGEndBranchParentNode(NODE_ID, 0, 0), "End BranchParent"),
        (TGStartBranchNode(NODE_ID, 0, 0), "Start Branch"),
        (TGEndBranchNode(NODE_ID, 0, 0), "End Branch"),
        (TGStartWorkNode(NODE_ID, 0, 0), "Start Work"),
        (TGEndWorkNode(NODE_ID, 0, 0), "End Work"),
        (EndFunctionMarker(NODE_ID, 0, 0), "EFM 1:7"),
    ],
)
def test_labels(node: TGNode, label: str) -> None:
    assert node.get_label() == label


def test_iteration_nodes_remember_their_loop() -> None:
    start = TGStartIterationNode(NODE_ID, 0, 0, NodeID("1:2"))
    end = TGEndIterationNode(NODE_ID, 0, 0, NodeID("1:2"))

    assert start.parent_loop_pet_node_id == "1:2" and end.parent_loop_pet_node_id == "1:2"
    assert start.loopstate_iteration_ids is None
    start.set_loopstate_iteration_ids([0, 2])
    assert start.loopstate_iteration_ids == [0, 2]
    assert start.get_label() == "Start IT 1:7\nstate_id: None"


def test_start_inlined_function_node_remembers_the_call_instruction() -> None:
    assert TGStartInlinedFunctionNode(NODE_ID, 0, 0, 12).call_instruction_id == 12
    assert TGStartInlinedFunctionNode(NODE_ID, 0, 0).call_instruction_id is None


def test_end_function_marker_refers_to_its_function_instead_of_a_pet_node() -> None:
    """__visit_pet queues the marker in place of a PET node, and it is only turned into a
    TGEndFunctionNode once the traversal reaches it."""
    marker = EndFunctionMarker(NODE_ID, 1, 2)

    assert isinstance(marker, VisitorMarker)
    assert marker.function_node == NODE_ID
    assert marker.pet_node_id is None
    assert (marker.level, marker.position) == (1, 2)


def test_start_loop_node_has_no_loopstate_position_until_assigned() -> None:
    assert TGStartLoopNode(NODE_ID, 0, 0).loopstate_position is None
