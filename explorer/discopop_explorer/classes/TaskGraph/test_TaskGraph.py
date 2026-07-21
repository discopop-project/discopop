# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
"""Regression tests for __add_branching_nodes_for_function's dominance-based
region wrapping. Both cases reproduce shapes that previously let a
TGStartBranchParentNode/TGEndBranchParentNode end up with zero successors/
predecessors - an orphaned node that later crashed __calculate_context_nesting
because it looks like a valid entry point despite being an "exit" marker."""

from __future__ import annotations

from typing import Any, List

from discopop_explorer.classes.TaskGraph.Branching.TGEndBranchParentNode import TGEndBranchParentNode
from discopop_explorer.classes.TaskGraph.Branching.TGStartBranchParentNode import TGStartBranchParentNode
from discopop_explorer.classes.TaskGraph.TaskGraph import TaskGraph
from discopop_explorer.classes.TaskGraph.TGNode import TGNode


def _add_branching_nodes_for_function(tg: TaskGraph, function_node: TGNode) -> None:
    # name-mangled private method - intentional, this is testing that method directly
    tg._TaskGraph__add_branching_nodes_for_function(function_node)  # type: ignore[attr-defined]


def _assert_no_degenerate_branch_parent_nodes(tg: TaskGraph) -> None:
    for node in tg.graph.nodes:
        if isinstance(node, TGEndBranchParentNode):
            assert len(tg.get_predecessors(node)) > 0, (
                "TGEndBranchParentNode " + node.get_label() + " has no predecessors - "
                "it can never be entered, and __calculate_context_nesting will treat it as a "
                "bogus entry point starting mid-context."
            )
        if isinstance(node, TGStartBranchParentNode):
            assert len(tg.get_successors(node)) > 0, (
                "TGStartBranchParentNode " + node.get_label() + " has no successors - "
                "the context it opens can never be closed."
            )


def test_branch_point_that_is_its_own_merge_predecessor(build_task_graph: Any, make_tg_node: Any) -> None:
    """One arm of a branch goes directly to the merge point (e.g. an "if" with no "else"),
    so the branch point is trivially one of the merge point's own predecessors. The
    predecessor-of-merge rewiring must not try to remove that edge a second time after the
    branch point's own successor-rewiring already relocated it."""
    f = make_tg_node("F")
    a = make_tg_node("A")  # branch point: direct arm to m, long arm via b
    b = make_tg_node("B")
    m = make_tg_node("M")
    tg = build_task_graph(None, [f, a, b, m])
    tg.add_edge(f, a)
    tg.add_edge(a, m)
    tg.add_edge(a, b)
    tg.add_edge(b, m)

    _add_branching_nodes_for_function(tg, f)

    _assert_no_degenerate_branch_parent_nodes(tg)


def test_branch_point_dominates_none_of_its_merges_predecessors(build_task_graph: Any, make_tg_node: Any) -> None:
    """A branch point's own arms can rejoin the merge point via nodes that are also reachable
    from outside the branch (e.g. a preamble that both enters the branch and separately jumps
    straight to what look like the branch's own targets). In that case the branch point
    dominates none of the merge point's current predecessors, and must be left unwrapped for
    the fallback pass rather than producing an EndBranchParent with zero predecessors."""
    f = make_tg_node("F")
    x = make_tg_node("X")  # preamble / outer branch point
    n = make_tg_node("N")  # inner branch point that ends up owning nothing
    m1 = make_tg_node("M1")
    m2 = make_tg_node("M2")
    merge = make_tg_node("MERGE")
    tg = build_task_graph(None, [f, x, n, m1, m2, merge])
    tg.add_edge(f, x)
    tg.add_edge(x, n)
    tg.add_edge(x, m1)  # bypasses n directly
    tg.add_edge(x, m2)  # bypasses n directly
    tg.add_edge(n, m1)
    tg.add_edge(n, m2)
    tg.add_edge(m1, merge)
    tg.add_edge(m2, merge)

    _add_branching_nodes_for_function(tg, f)
    tg._TaskGraph__add_branching_nodes_fallback_cleanup()  # type: ignore[attr-defined]

    _assert_no_degenerate_branch_parent_nodes(tg)
