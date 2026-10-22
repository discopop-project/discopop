# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
"""Tests of the task detection against the hand-written OpenMP task versions of BOTS (bots/omp-tasks).

The detector reads the code scopes of the parent context of a group of tasks and of each task. The scopes
used here are the ones the detector received in a run on the serial BOTS applications; the expectations come
from omp-tasks, which parallelized the same code by hand. A test marked xfail documents a known deviation
of the explorer from it (see design/task_suggestions.md).
"""

from __future__ import annotations

from types import SimpleNamespace
from typing import Any, Callable, List, Tuple

import pytest

from discopop_explorer.classes.PEGraph.Node import Node
from discopop_explorer.classes.patterns.TaskParallelismInfo import ParallelRegionInfo, TaskParallelismInfo
from discopop_explorer.enums.NodeType import NodeType
from discopop_explorer.pattern_detectors.new_task_detector import identify_simple_tasking

MakeNode = Callable[..., Node]


def _lines(file_id: int, first: int, last: int) -> List[str]:
    return [f"{file_id}:{n}" for n in range(first, last + 1)]


def _context(scope: List[str], node: Node | None = None) -> Any:
    return SimpleNamespace(
        get_code_scope=lambda pet, inclusive=False: list(scope),
        get_first_pet_node=lambda pet: node,
    )


def _detect(parent_node: Node, parent_scope: List[str], task_scopes: List[List[str]]) -> Tuple[Any, Any]:
    """The tasks and the parallel region the detector reports for one group of tasks."""
    tpc = SimpleNamespace(
        parent_context=_context(parent_scope, parent_node),
        registered_tasks=[_context(scope) for scope in task_scopes],
    )
    patterns = identify_simple_tasking(SimpleNamespace(pet=None), [tpc])  # type: ignore[arg-type, list-item]
    tasks = [p for p in patterns if isinstance(p, TaskParallelismInfo) and not isinstance(p, ParallelRegionInfo)]
    regions = [p for p in patterns if isinstance(p, ParallelRegionInfo)]
    return tasks, regions


def _span(task: TaskParallelismInfo) -> Tuple[int, int]:
    return int(str(task.region_start_line)), int(str(task.region_end_line))


@pytest.fixture  # type: ignore[misc]
def fib_group(isolated_pattern_id_cwd: Any, make_node: MakeNode) -> Tuple[Any, Any]:
    """fib.c, lines 31 and 32: x = fib(n - 1); y = fib(n - 2);  (omp-tasks/fib/fib.c: one task each).

    The scopes are those of the explorer's run: the second task is the CU 3:237, which the CU
    generation starts at line 31 although its call is on line 32."""
    parent = make_node("3:233", NodeType.CU, start_line=29, end_line=29)
    return _detect(parent, ["3:29", "3:35"], [["3:31"], ["3:31", "3:32"]])


def test_the_two_recursive_calls_of_fib_are_two_tasks_in_one_region(fib_group: Tuple[Any, Any]) -> None:
    tasks, regions = fib_group
    assert len(tasks) == 2
    assert len(regions) == 1
    region = regions[0]
    assert (int(region.region_start_line), int(region.region_end_line)) == (31, 32)
    assert region.contains_patterns == [t.pattern_id for t in tasks]
    assert all(t.task_group == region.task_group for t in tasks)
    assert region.pragma == ["#pragma omp parallel", "#pragma omp single"]
    assert all(t.pragma == ["#pragma omp task"] for t in tasks)


@pytest.mark.xfail(
    strict=True,
    reason="the CU of the second call starts at line 31 although the call is on line 32 (CU 3:237 of fib), "
    "so the lines of the two tasks overlap",
)  # type: ignore[misc]
def test_the_tasks_of_fib_cover_one_statement_each(fib_group: Tuple[Any, Any]) -> None:
    tasks, _ = fib_group
    assert [_span(t) for t in tasks] == [(31, 31), (32, 32)]


def test_a_group_without_scope_inside_its_parent_is_skipped(isolated_pattern_id_cwd: Any, make_node: MakeNode) -> None:
    parent = make_node("3:233", NodeType.CU, start_line=29, end_line=29)
    with pytest.warns(UserWarning, match="Empty task scope"):
        tasks, regions = _detect(parent, ["3:29", "3:35"], [["3:31"], ["4:50"]])
    assert tasks == []
    assert regions == []


@pytest.mark.xfail(
    strict=True,
    reason="a closing brace is reported as the body of a task (bots_get_params, bots_main.c:440)",
)  # type: ignore[misc]
def test_a_closing_brace_is_no_task(isolated_pattern_id_cwd: Any, make_node: MakeNode) -> None:
    """bots_get_params: a call and the closing brace of the function. omp-tasks has no tasks here."""
    parent = make_node("1:76", NodeType.CU, start_line=436, end_line=440)
    tasks, _ = _detect(parent, _lines(1, 436, 440), [["1:438"], ["1:440"]])
    assert tasks == []


@pytest.mark.xfail(
    strict=True,
    reason="independent calls of formatting code are reported as tasks (bots_print_results, bots_common.c)",
)  # type: ignore[misc]
def test_formatting_calls_outside_of_the_computation_are_no_tasks(
    isolated_pattern_id_cwd: Any, make_node: MakeNode
) -> None:
    """bots_print_results: sprintf calls. omp-tasks has no tasks in the shared BOTS sources."""
    parent = make_node("2:136", NodeType.CU, start_line=115, end_line=336)
    _, regions = _detect(parent, _lines(2, 115, 336), [_lines(2, 170, 171), _lines(2, 173, 184)])
    assert regions == []
