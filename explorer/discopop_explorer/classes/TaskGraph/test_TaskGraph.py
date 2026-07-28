# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
"""Regression tests for the TaskGraph construction passes in TaskGraph.py.

test_branch_point_* cover __add_branching_nodes_for_function's dominance-based
region wrapping. Both reproduce shapes that previously let a
TGStartBranchParentNode/TGEndBranchParentNode end up with zero successors/
predecessors - an orphaned node that later crashed __calculate_context_nesting
because it looks like a valid entry point despite being an "exit" marker.

test_visit_pet_* / test_break_cycles_* cover __visit_pet's control-flow
reconstruction, where a dropped successor edge made __break_cycles misidentify a
loop's header (see INVARIANTS.md, invariant 1).

test_validate_context_structure_* cover the Context relation checks that run
after __calculate_context_successions."""

from __future__ import annotations

import logging
from typing import Any, List, Sequence, Tuple

import networkx as nx

from discopop_explorer.classes.PEGraph.PEGraphX import PEGraphX
from discopop_explorer.classes.TaskGraph.Branching.TGEndBranchParentNode import TGEndBranchParentNode
from discopop_explorer.classes.TaskGraph.Branching.TGStartBranchParentNode import TGStartBranchParentNode
from discopop_explorer.classes.TaskGraph.Contexts.Context import Context
from discopop_explorer.classes.TaskGraph.Loops.TGEndLoopNode import TGEndLoopNode
from discopop_explorer.classes.TaskGraph.Loops.TGStartLoopNode import TGStartLoopNode
from discopop_explorer.classes.TaskGraph.TaskGraph import TaskGraph
from discopop_explorer.classes.TaskGraph.TGNode import TGNode
from discopop_explorer.enums.EdgeType import EdgeType
from discopop_explorer.enums.NodeType import NodeType


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


# --- __visit_pet control-flow reconstruction ---------------------------------------------

FUNCTION_ID = "0:1"
# CU ids of the loop-with-a-shared-exit-CU shape built by _build_loop_with_shared_exit_pet
ENTRY, GUARD, EARLY, EXIT, PREHEADER = "1:1", "1:2", "1:3", "1:4", "1:5"
HEADER, COND, THEN, ELSE, MERGE, LATCH = "1:6", "1:7", "1:8", "1:9", "1:10", "1:11"

# (source, target) SUCCESSOR edges; mirrors the control flow of libstdc++'s __insertion_sort:
#
#   void f(It first, It last) {
#     if (first == last) return;                    // GUARD -> EARLY -> EXIT
#     for (It i = first + 1; i != last; ++i) {      // PREHEADER, HEADER (exits to EXIT), LATCH
#       if (comp(i, first)) { ... }                 // COND -> THEN
#       else { ... }                                //      -> ELSE
#     }                                             // MERGE
#   }
#
# The early return and the loop exit share the function's exit CU, and the loop body
# contains a branch - the combination that used to break loop reconstruction.
_SHARED_EXIT_LOOP_SUCCESSORS: Sequence[Tuple[str, str]] = (
    (ENTRY, GUARD),
    (GUARD, EARLY),  # guard taken: early return, reaching (and registering) EXIT first
    (GUARD, PREHEADER),  # guard not taken: enter the loop
    (EARLY, EXIT),
    (PREHEADER, HEADER),
    (HEADER, COND),  # loop header: continue into the body
    (HEADER, EXIT),  # loop header: leave the loop - EXIT is already visited by now
    (COND, THEN),  # branch inside the loop body
    (COND, ELSE),
    (THEN, MERGE),
    (ELSE, MERGE),
    (MERGE, LATCH),
    (LATCH, HEADER),  # back edge
)


def _build_loop_with_shared_exit_pet(build_pet_graph: Any, make_node: Any) -> Any:
    cu_ids = [ENTRY, GUARD, EARLY, EXIT, PREHEADER, HEADER, COND, THEN, ELSE, MERGE, LATCH]
    # pet.main is what __visit_pet starts its traversal from, hence the name
    nodes = [make_node(FUNCTION_ID, NodeType.FUNC, name="main")]
    nodes += [make_node(cu_id, NodeType.CU, name="cu") for cu_id in cu_ids]
    edges: List[Tuple[str, str, EdgeType]] = [(FUNCTION_ID, cu_id, EdgeType.CHILD) for cu_id in cu_ids]
    edges += [(source, target, EdgeType.SUCCESSOR) for source, target in _SHARED_EXIT_LOOP_SUCCESSORS]
    return build_pet_graph(nodes, edges)


def _visit_pet(tg: TaskGraph, pet: PEGraphX) -> None:
    # name-mangled private methods - intentional, these tests drive the construction passes
    tg._TaskGraph__assign_function_ids(pet)  # type: ignore[attr-defined]
    tg._TaskGraph__visit_pet(pet)  # type: ignore[attr-defined]


def test_visit_pet_keeps_edge_from_branch_point_to_already_visited_successor(
    build_pet_graph: Any, make_node: Any, build_task_graph: Any
) -> None:
    """__visit_branching must not queue an already visited successor again (that would never
    terminate on cyclic control flow), but it still has to record the edge to it - the edge
    is otherwise only created by the successor's own visit, which already happened. Here the
    loop's exit edge targets the function's exit CU, which the early return reached first."""
    pet = _build_loop_with_shared_exit_pet(build_pet_graph, make_node)
    tg = build_task_graph(pet)

    _visit_pet(tg, pet)

    header = tg.TGNode_pet_node_id_to_tg_node[HEADER]
    exit_cu = tg.TGNode_pet_node_id_to_tg_node[EXIT]
    assert tg.graph.has_edge(header, exit_cu), (
        "the loop exit edge " + HEADER + " -> " + EXIT + " is missing from the TaskGraph although "
        "it exists in the PET graph - dropping it makes the loop look exit-less to __break_cycles."
    )
    # every PET successor edge inside the function must be present
    for source, target in _SHARED_EXIT_LOOP_SUCCESSORS:
        assert tg.graph.has_edge(tg.TGNode_pet_node_id_to_tg_node[source], tg.TGNode_pet_node_id_to_tg_node[target]), (
            "PET successor edge " + source + " -> " + target + " was not reconstructed"
        )


def test_break_cycles_anchors_loop_markers_at_the_loop_header(
    build_pet_graph: Any, make_node: Any, build_task_graph: Any
) -> None:
    """__break_cycles derives the loop header from the cycle nx.find_cycle returns. That cycle
    only contains one arm of a branch inside the loop body, so if the loop's exit edge is
    missing the branch inside the body is the only node that looks like a header (one
    successor inside the cycle, one outside) - and the resulting TGStartLoopNode ends up
    anchored at the branch, with no predecessors and no path to its TGEndLoopNode."""
    pet = _build_loop_with_shared_exit_pet(build_pet_graph, make_node)
    tg = build_task_graph(pet)

    _visit_pet(tg, pet)
    tg._TaskGraph__break_cycles()  # type: ignore[attr-defined]

    start_loop_nodes = [n for n in tg.graph.nodes if isinstance(n, TGStartLoopNode)]
    end_loop_nodes = [n for n in tg.graph.nodes if isinstance(n, TGEndLoopNode)]
    assert [n.pet_node_id for n in start_loop_nodes] == [HEADER]
    assert [n.pet_node_id for n in end_loop_nodes] == [HEADER]

    start_loop, end_loop = start_loop_nodes[0], end_loop_nodes[0]
    assert tg.get_predecessors(start_loop) == [tg.TGNode_pet_node_id_to_tg_node[PREHEADER]]
    assert tg.get_successors(end_loop) == [tg.TGNode_pet_node_id_to_tg_node[EXIT]]
    assert nx.has_path(tg.graph, start_loop, end_loop)


def test_assign_loop_contexts_finds_loop_end_node_for_loop_with_shared_exit_cu(
    build_pet_graph: Any, make_node: Any, build_task_graph: Any
) -> None:
    """End-to-end guard for the failure this shape used to produce far away from its cause:
    ValueError("Could not determine loop end node for loop: ...") in __assign_loop_contexts."""
    pet = _build_loop_with_shared_exit_pet(build_pet_graph, make_node)
    tg = build_task_graph(pet)

    _visit_pet(tg, pet)
    tg._TaskGraph__break_cycles()  # type: ignore[attr-defined]
    tg._TaskGraph__assign_loop_contexts()  # type: ignore[attr-defined]


# --- context structure validation ---------------------------------------------------------


def _nest_context(parent: Context, child: Context) -> None:
    # bypasses add_contained_context/register_parent_context, which reject the cycles they can
    # detect themselves - here the malformed structures those checks miss are built on purpose
    parent.contained_contexts.add(child)
    child.parent_context = parent


def _validate_context_structure(tg: TaskGraph) -> None:
    tg._TaskGraph__validate_context_structure()  # type: ignore[attr-defined]


def test_validate_context_structure_breaks_containment_cycle(build_task_graph: Any, caplog: Any) -> None:
    """A cycle in the containment relation makes every traversal of it diverge. The pass must
    remove the edge closing it and say where it was."""
    outer, middle, inner = Context(), Context(), Context()
    _nest_context(outer, middle)
    _nest_context(middle, inner)
    _nest_context(inner, outer)  # closes the cycle
    tg = build_task_graph(None)
    tg.contexts = [outer, middle, inner]

    with caplog.at_level(logging.ERROR, logger="Explorer"):
        _validate_context_structure(tg)

    assert outer not in inner.contained_contexts
    assert outer.parent_context is None
    assert outer.get_contained_contexts(inclusive=True) == {middle, inner}
    assert "one of its own ancestors" in caplog.text


def test_validate_context_structure_breaks_succession_cycle(build_task_graph: Any, caplog: Any) -> None:
    """A cycle in the successor relation is not rejected on registration unless it is a
    two-element one, so it has to be caught here."""
    first, second, third = Context(), Context(), Context()
    first.register_successor_context(second)
    second.register_successor_context(third)
    third.register_successor_context(first)  # closes the cycle
    assert third.successor is first, "registration is expected to accept a cycle of this length"
    tg = build_task_graph(None)
    tg.contexts = [first, second, third]

    with caplog.at_level(logging.ERROR, logger="Explorer"):
        _validate_context_structure(tg)

    assert third.successor is None
    assert first.predecessor is None
    assert "runs back into" in caplog.text


def test_validate_context_structure_finds_contexts_not_in_the_contexts_list(build_task_graph: Any) -> None:
    """self.contexts only holds what the __assign_*_contexts passes created themselves, so the
    validation has to collect the contexts reachable from them as well."""
    listed, unlisted_first, unlisted_second = Context(), Context(), Context()
    _nest_context(listed, unlisted_first)
    unlisted_first.register_successor_context(unlisted_second)
    unlisted_second.successor = unlisted_first  # closes the cycle, bypassing the two-cycle check
    tg = build_task_graph(None)
    tg.contexts = [listed]

    _validate_context_structure(tg)

    assert unlisted_second.successor is None


def test_validate_context_structure_reports_one_sided_links(build_task_graph: Any, caplog: Any) -> None:
    """A containment or succession link recorded on only one of its two ends is not repaired -
    which end is authoritative is not decidable here - but it must be reported."""
    parent, child = Context(), Context()
    parent.contained_contexts.add(child)  # child.parent_context stays None
    tg = build_task_graph(None)
    tg.contexts = [parent, child]

    with caplog.at_level(logging.WARNING, logger="Explorer"):
        _validate_context_structure(tg)

    assert "one-sided containment" in caplog.text


def test_validate_context_structure_accepts_a_well_formed_structure(build_task_graph: Any, caplog: Any) -> None:
    loop, iteration_1, iteration_2, work = Context(), Context(), Context(), Context()
    for iteration in (iteration_1, iteration_2):
        loop.add_contained_context(iteration)
        iteration.register_parent_context(loop)
    iteration_1.add_contained_context(work)
    work.register_parent_context(iteration_1)
    iteration_1.register_successor_context(iteration_2)
    tg = build_task_graph(None)
    tg.contexts = [loop, iteration_1, iteration_2, work]

    with caplog.at_level(logging.WARNING, logger="Explorer"):
        _validate_context_structure(tg)

    assert caplog.text == ""
    assert iteration_1.successor is iteration_2
    assert loop.get_contained_contexts(inclusive=True) == {iteration_1, iteration_2, work}
