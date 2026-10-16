# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
"""Tests for TaskGraph.__apply_dependency_overwrites, which drops a dependency read from the
profiler's files whenever the same dependency was also observed with more specific callpath state
information.

A state id is either a number or "NO_STATE". A dependency is unspecified if neither its source nor
its sink carries a state, partially specified if one of them does, and fully specified if both do.
Less specific entries are overwritten by more specific ones between the same two locations, but two
partially specified entries never overwrite each other."""

from __future__ import annotations

from typing import Any, Dict, List

# {dep_type: {source_location: {source_state_id: {sink_location: {sink_state_id: [var_info]}}}}}
Dependencies = Dict[str, Dict[str, Dict[str, Dict[str, Dict[str, List[str]]]]]]

SOURCE, SINK = "1:5", "1:7"


def _overwrite(build_task_graph: Any, dependencies: Dependencies) -> Dependencies:
    tg = build_task_graph(None)
    # name-mangled private method - intentional, this is testing that method directly
    result: Dependencies = tg._TaskGraph__apply_dependency_overwrites(dependencies)
    return result


def _deps(*entries: str) -> Dependencies:
    """Dependencies of variable x from SOURCE to SINK, one per "<source_state>-><sink_state>"."""
    deps: Dependencies = {"DYN_RAW": {SOURCE: {}}}
    for entry in entries:
        source_state, sink_state = entry.split("->")
        deps["DYN_RAW"][SOURCE].setdefault(source_state, {}).setdefault(SINK, {})[sink_state] = ["x"]
    return deps


def _remaining(dependencies: Dependencies) -> List[str]:
    return sorted(
        source_state + "->" + sink_state
        for source_location_deps in dependencies.get("DYN_RAW", {}).values()
        for source_state, source_state_deps in source_location_deps.items()
        for sink_location_deps in source_state_deps.values()
        for sink_state in sink_location_deps
    )


def test_unrelated_dependencies_are_kept(build_task_graph: Any) -> None:
    dependencies: Dependencies = {
        "STAT_RAW": {"1:1": {"NO_STATE": {"1:2": {"NO_STATE": ["a"]}}}},
        "DYN_WAR": {"1:3": {"4": {"1:4": {"5": ["b"]}}}},
    }

    assert _overwrite(build_task_graph, dependencies) == {
        "STAT_RAW": {"1:1": {"NO_STATE": {"1:2": {"NO_STATE": ["a"]}}}},
        "DYN_WAR": {"1:3": {"4": {"1:4": {"5": ["b"]}}}},
    }


def test_unspecified_dependency_is_overwritten_by_a_specified_source_state(build_task_graph: Any) -> None:
    result = _overwrite(build_task_graph, _deps("NO_STATE->NO_STATE", "3->NO_STATE"))

    assert _remaining(result) == ["3->NO_STATE"]


def test_unspecified_dependency_is_overwritten_by_a_specified_sink_state(build_task_graph: Any) -> None:
    result = _overwrite(build_task_graph, _deps("NO_STATE->NO_STATE", "NO_STATE->4"))

    assert _remaining(result) == ["NO_STATE->4"]


def test_unspecified_dependency_is_overwritten_by_a_fully_specified_one(build_task_graph: Any) -> None:
    result = _overwrite(build_task_graph, _deps("NO_STATE->NO_STATE", "3->4"))

    assert _remaining(result) == ["3->4"]


def test_partially_specified_sink_state_is_overwritten_by_a_fully_specified_one(build_task_graph: Any) -> None:
    result = _overwrite(build_task_graph, _deps("NO_STATE->4", "3->4"))

    assert _remaining(result) == ["3->4"]


def test_partially_specified_dependencies_do_not_overwrite_each_other(build_task_graph: Any) -> None:
    result = _overwrite(build_task_graph, _deps("NO_STATE->4", "3->NO_STATE"))

    assert _remaining(result) == ["3->NO_STATE", "NO_STATE->4"]


def test_overwrites_are_limited_to_the_same_sink_location(build_task_graph: Any) -> None:
    """A more specific dependency towards a different sink says nothing about this one."""
    dependencies: Dependencies = {
        "DYN_RAW": {
            SOURCE: {
                "NO_STATE": {SINK: {"NO_STATE": ["x"]}},
                "3": {"1:9": {"NO_STATE": ["x"]}},
            }
        }
    }

    result = _overwrite(build_task_graph, dependencies)

    assert result["DYN_RAW"][SOURCE]["NO_STATE"] == {SINK: {"NO_STATE": ["x"]}}


def test_emptied_levels_are_removed(build_task_graph: Any) -> None:
    """Removing the last dependency below a key removes the key as well, so the consumers'
    nested loops never visit an empty level."""
    result = _overwrite(build_task_graph, _deps("NO_STATE->NO_STATE", "3->4"))

    assert "NO_STATE" not in result["DYN_RAW"][SOURCE]


def test_partially_specified_source_state_is_overwritten_by_a_fully_specified_one(build_task_graph: Any) -> None:
    """Used to raise an UnboundLocalError from the debug output, which printed a variable bound only by
    a loop that does not run for a dependency with a specified source state."""
    result = _overwrite(build_task_graph, _deps("3->NO_STATE", "3->4"))

    assert _remaining(result) == ["3->4"]
