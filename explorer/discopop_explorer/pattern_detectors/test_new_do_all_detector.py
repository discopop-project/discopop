# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
from __future__ import annotations

from typing import Any, Callable, Tuple

from discopop_explorer.classes.PEGraph.Dependency import Dependency
from discopop_explorer.classes.PEGraph.Node import Node
from discopop_explorer.classes.PEGraph.PEGraphX import PEGraphX
from discopop_explorer.classes.TaskGraph.Contexts.IterationContext import IterationContext
from discopop_explorer.classes.TaskGraph.Contexts.LoopParentContext import LoopParentContext
from discopop_explorer.classes.TaskGraph.Contexts.WorkContext import WorkContext
from discopop_explorer.classes.TaskGraph.TaskGraph import TaskGraph
from discopop_explorer.enums.DepOrigin import DepOrigin
from discopop_explorer.enums.DepType import DepType
from discopop_explorer.enums.EdgeType import EdgeType
from discopop_explorer.enums.NodeType import NodeType
from discopop_explorer.pattern_detectors.do_all_detector import DoAllInfo
from discopop_explorer.pattern_detectors.new_do_all_detector import identify_simple_doall_and_reduction
from discopop_explorer.utilities.ASTUtils.ASTPatternDetectionIntegration import ASTPatternDetectionHelper

MakeNode = Callable[..., Node]
BuildPetGraph = Callable[..., PEGraphX]


def _build_two_iteration_loop(
    make_node: MakeNode, build_pet_graph: BuildPetGraph, build_task_graph: Any, make_tg_node: Any, **pet_kwargs: Any
) -> Tuple[TaskGraph, Node, LoopParentContext, WorkContext, WorkContext]:
    """Builds a minimal PEGraphX (main -> loop -> body_cu) plus a TaskGraph whose
    loop TGNode has a LoopParentContext containing two IterationContexts, each
    wrapping a WorkContext for one dynamic execution of `body_cu`."""
    main = make_node("1:1", NodeType.FUNC, name="main")
    loop = make_node("1:2", NodeType.LOOP, name="loop", start_line=5, end_line=10)
    body_cu = make_node("1:3", NodeType.CU, name="body", start_line=6, end_line=6)
    pet = build_pet_graph(
        [main, loop, body_cu],
        [(main.id, loop.id, EdgeType.CHILD), (loop.id, body_cu.id, EdgeType.CHILD)],
        **pet_kwargs,
    )

    loop_ctx = LoopParentContext(parent_loop=loop.id)
    iter1 = IterationContext(parent_context=loop_ctx, loopstate_iteration_ids=[0])
    iter2 = IterationContext(parent_context=loop_ctx, loopstate_iteration_ids=[1])
    loop_ctx.add_contained_context(iter1)
    loop_ctx.add_contained_context(iter2)
    iter1.register_parent_context(loop_ctx)
    iter2.register_parent_context(loop_ctx)

    work1 = WorkContext()
    work2 = WorkContext()
    work1.add_node(make_tg_node(body_cu.id, level=1, position=0))
    work2.add_node(make_tg_node(body_cu.id, level=1, position=1))
    iter1.add_contained_context(work1)
    iter2.add_contained_context(work2)
    work1.register_parent_context(iter1)
    work2.register_parent_context(iter2)

    tg_loop = make_tg_node(loop.id, level=0, position=0)
    tg_loop.register_created_context(loop_ctx)
    tg = build_task_graph(pet, [tg_loop])

    return tg, loop, loop_ctx, work1, work2


def test_identify_simple_doall_detected_without_inter_iteration_dependencies(
    make_node: MakeNode,
    build_pet_graph: BuildPetGraph,
    build_task_graph: Any,
    make_tg_node: Any,
    isolated_pattern_id_cwd: Any,
) -> None:
    tg, loop, loop_ctx, work1, work2 = _build_two_iteration_loop(
        make_node, build_pet_graph, build_task_graph, make_tg_node
    )
    patterns = identify_simple_doall_and_reduction(tg, ASTPatternDetectionHelper())
    assert len(patterns) == 1
    assert isinstance(patterns[0], DoAllInfo)
    assert patterns[0].node_id == loop.id


def test_identify_simple_doall_allows_war_dependency_between_iterations(
    make_node: MakeNode,
    build_pet_graph: BuildPetGraph,
    build_task_graph: Any,
    make_tg_node: Any,
    isolated_pattern_id_cwd: Any,
) -> None:
    """A WAR dependency between iterations is explicitly documented as non-critical
    (privatizable), unlike RAW/WAW, and must not prevent the do-all suggestion."""
    tg, loop, loop_ctx, work1, work2 = _build_two_iteration_loop(
        make_node, build_pet_graph, build_task_graph, make_tg_node
    )
    dep = Dependency(EdgeType.DATA)
    dep.dtype = DepType.WAR
    dep.var_name = "x"
    dep.origin = DepOrigin.DYNAMIC_ANALYSIS
    work1.register_outgoing_dependency(work2, dep)

    patterns = identify_simple_doall_and_reduction(tg, ASTPatternDetectionHelper())
    assert len(patterns) == 1
    assert isinstance(patterns[0], DoAllInfo)


def test_identify_simple_doall_prevented_by_dynamic_cross_iteration_dependency(
    make_node: MakeNode,
    build_pet_graph: BuildPetGraph,
    build_task_graph: Any,
    make_tg_node: Any,
    isolated_pattern_id_cwd: Any,
) -> None:
    tg, loop, loop_ctx, work1, work2 = _build_two_iteration_loop(
        make_node, build_pet_graph, build_task_graph, make_tg_node
    )
    dep = Dependency(EdgeType.DATA)
    dep.dtype = DepType.RAW
    dep.var_name = "x"
    dep.origin = DepOrigin.DYNAMIC_ANALYSIS
    work1.register_outgoing_dependency(work2, dep)

    patterns = identify_simple_doall_and_reduction(tg, ASTPatternDetectionHelper())
    assert patterns == []


def test_identify_simple_doall_allows_dependency_on_loop_variable(
    make_node: MakeNode,
    build_pet_graph: BuildPetGraph,
    build_task_graph: Any,
    make_tg_node: Any,
    isolated_pattern_id_cwd: Any,
) -> None:
    tg, loop, loop_ctx, work1, work2 = _build_two_iteration_loop(
        make_node, build_pet_graph, build_task_graph, make_tg_node
    )
    dep = Dependency(EdgeType.DATA)
    dep.dtype = DepType.RAW
    dep.var_name = "i"
    dep.memory_region = "M_I"  # type: ignore[assignment]
    dep.origin = DepOrigin.DYNAMIC_ANALYSIS
    loop_ctx.loop_variables = [("i", "M_I")]  # type: ignore[list-item]
    work1.register_outgoing_dependency(work2, dep)

    patterns = identify_simple_doall_and_reduction(tg, ASTPatternDetectionHelper())
    assert len(patterns) == 1
    assert isinstance(patterns[0], DoAllInfo)


def test_identify_simple_reduction_dependency_currently_only_prevents_doall(
    make_node: MakeNode,
    build_pet_graph: BuildPetGraph,
    build_task_graph: Any,
    make_tg_node: Any,
    isolated_pattern_id_cwd: Any,
) -> None:
    """Characterizes current (likely unintended) behavior: the reduction-detection branch in
    identify_simple_doall_and_reduction checks `red_var_dict["loop_line"] in
    node.created_context.get_code_scope(tg.pet)`, but get_code_scope() is called without
    inclusive=True, so it only looks at nodes added directly to the LoopParentContext via
    add_node(). No code path in the codebase ever calls add_node() on a LoopParentContext
    (the one call site that would, in TaskGraph.py's __assign_contexts, is commented out) --
    so get_code_scope() is always [], the "loop_line in scope" check always fails, and
    is_reduction_dependency can never become True. A dependency shaped like a reduction
    therefore isn't converted into a ReductionInfo suggestion here; since it also isn't a
    recognized loop variable, it just falls through to preventing the do-all suggestion
    entirely, exactly like an ordinary cross-iteration dependency would.
    """
    tg, loop, loop_ctx, work1, work2 = _build_two_iteration_loop(
        make_node,
        build_pet_graph,
        build_task_graph,
        make_tg_node,
        reduction_vars=[
            {
                "loop_line": "1:6",
                "name": "sum",
                "operation": "+",
                "reduction_line": "1:6",
            }
        ],
    )
    dep = Dependency(EdgeType.DATA)
    dep.dtype = DepType.RAW
    dep.var_name = "sum"
    dep.origin = DepOrigin.DYNAMIC_ANALYSIS
    work1.register_outgoing_dependency(work2, dep)

    patterns = identify_simple_doall_and_reduction(tg, ASTPatternDetectionHelper())
    assert patterns == []


def test_identify_simple_doall_allows_static_dependency_first_written_inside_loop(
    make_node: MakeNode,
    build_pet_graph: BuildPetGraph,
    build_task_graph: Any,
    make_tg_node: Any,
    isolated_pattern_id_cwd: Any,
) -> None:
    """A cross-iteration dependency whose origin is static analysis (as opposed to dynamic
    analysis) gets a "second chance": unlike a dynamic-analysis dependency, it does not
    immediately break do-all detection, and is instead only re-checked against variables
    that are first written inside the loop body. Here "x" is first written (an INIT
    dependency on the body CU itself), so the static dependency must not prevent the
    do-all suggestion."""
    main = make_node("1:1", NodeType.FUNC, name="main")
    loop = make_node("1:2", NodeType.LOOP, name="loop", start_line=5, end_line=10)
    body_cu = make_node("1:3", NodeType.CU, name="body", start_line=6, end_line=6)
    init_dep = Dependency(EdgeType.DATA)
    init_dep.dtype = DepType.INIT
    init_dep.var_name = "x"
    pet = build_pet_graph(
        [main, loop, body_cu],
        [
            (main.id, loop.id, EdgeType.CHILD),
            (loop.id, body_cu.id, EdgeType.CHILD),
            (body_cu.id, body_cu.id, init_dep),
        ],
    )

    loop_ctx = LoopParentContext(parent_loop=loop.id)
    iter1 = IterationContext(parent_context=loop_ctx, loopstate_iteration_ids=[0])
    iter2 = IterationContext(parent_context=loop_ctx, loopstate_iteration_ids=[1])
    loop_ctx.add_contained_context(iter1)
    loop_ctx.add_contained_context(iter2)
    iter1.register_parent_context(loop_ctx)
    iter2.register_parent_context(loop_ctx)

    work1 = WorkContext()
    work2 = WorkContext()
    work1.add_node(make_tg_node(body_cu.id, level=1, position=0))
    work2.add_node(make_tg_node(body_cu.id, level=1, position=1))
    iter1.add_contained_context(work1)
    iter2.add_contained_context(work2)
    work1.register_parent_context(iter1)
    work2.register_parent_context(iter2)

    dep = Dependency(EdgeType.DATA)
    dep.dtype = DepType.RAW
    dep.var_name = "x"
    dep.origin = DepOrigin.STATIC_ANALYSIS
    work1.register_outgoing_dependency(work2, dep)

    tg_loop = make_tg_node(loop.id, level=0, position=0)
    tg_loop.register_created_context(loop_ctx)
    tg = build_task_graph(pet, [tg_loop])

    patterns = identify_simple_doall_and_reduction(tg, ASTPatternDetectionHelper())
    assert len(patterns) == 1
    assert isinstance(patterns[0], DoAllInfo)


def test_identify_simple_doall_skips_loops_with_fewer_than_two_iterations(
    make_node: MakeNode,
    build_pet_graph: BuildPetGraph,
    build_task_graph: Any,
    make_tg_node: Any,
    isolated_pattern_id_cwd: Any,
) -> None:
    main = make_node("1:1", NodeType.FUNC, name="main")
    loop = make_node("1:2", NodeType.LOOP, name="loop")
    pet = build_pet_graph([main, loop], [(main.id, loop.id, EdgeType.CHILD)])

    loop_ctx = LoopParentContext(parent_loop=loop.id)
    tg_loop = make_tg_node(loop.id)
    tg_loop.register_created_context(loop_ctx)
    tg = build_task_graph(pet, [tg_loop])

    patterns = identify_simple_doall_and_reduction(tg, ASTPatternDetectionHelper())
    assert patterns == []


def test_identify_simple_doall_skips_loop_with_exactly_one_iteration(
    make_node: MakeNode,
    build_pet_graph: BuildPetGraph,
    build_task_graph: Any,
    make_tg_node: Any,
    isolated_pattern_id_cwd: Any,
) -> None:
    """A single-iteration loop has no other iteration to compare against, so it can never
    be shown to be free of cross-iteration dependencies; the "< 2" check must reject it
    just like the zero-iteration case."""
    main = make_node("1:1", NodeType.FUNC, name="main")
    loop = make_node("1:2", NodeType.LOOP, name="loop", start_line=5, end_line=10)
    body_cu = make_node("1:3", NodeType.CU, name="body", start_line=6, end_line=6)
    pet = build_pet_graph(
        [main, loop, body_cu],
        [(main.id, loop.id, EdgeType.CHILD), (loop.id, body_cu.id, EdgeType.CHILD)],
    )

    loop_ctx = LoopParentContext(parent_loop=loop.id)
    iter1 = IterationContext(parent_context=loop_ctx, loopstate_iteration_ids=[0])
    loop_ctx.add_contained_context(iter1)
    iter1.register_parent_context(loop_ctx)

    work1 = WorkContext()
    work1.add_node(make_tg_node(body_cu.id, level=1, position=0))
    iter1.add_contained_context(work1)
    work1.register_parent_context(iter1)

    tg_loop = make_tg_node(loop.id, level=0, position=0)
    tg_loop.register_created_context(loop_ctx)
    tg = build_task_graph(pet, [tg_loop])

    patterns = identify_simple_doall_and_reduction(tg, ASTPatternDetectionHelper())
    assert patterns == []
