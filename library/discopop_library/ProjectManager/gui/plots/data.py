# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

"""Pure data-reduction helpers for the results plots.

Everything here is free of Tk and matplotlib so it can be unit-tested directly.
Two data sources are handled:

* ``execution_results.json`` (Report tab) -- nested ``config -> script -> setting
  -> [executions]``; flattened into :class:`ExecutionRecord`s with derived speedup
  and efficiency (relative to the ``seq`` baseline of the same config+script).
* the autotuner progress stream (Autotuning tab) -- ``@@AT_PROGRESS`` stdout lines
  and ``progress.jsonl``; parsed into plain event dicts, plus a ``best_so_far``
  convergence series.
"""

from __future__ import annotations

import json
from dataclasses import dataclass
from typing import Any, Dict, List, Optional, Sequence, Tuple

from discopop_library.EmpiricalAutotuning.output.progress import PROGRESS_PREFIX

_SETTINGS_SUFFIX = "_settings.json"


@dataclass
class ExecutionRecord:
    """One measured execution, flattened from ``execution_results.json``."""

    config: str
    script: str
    mode: str  # execution mode / setting stem: seq, par, dp, hd, or a custom name
    label: str
    thread_count: int
    applied_suggestions: List[int]
    time: float
    code: int
    timeout: bool
    valid: bool  # ran successfully (return code 0 and not timed out)
    speedup: Optional[float]  # seq-baseline time / this time (same config+script)
    efficiency: Optional[float]  # speedup / thread_count


def mode_of_setting(setting: str) -> str:
    """``"par_settings.json"`` -> ``"par"``; leaves other names unchanged."""
    if setting.endswith(_SETTINGS_SUFFIX):
        return setting[: -len(_SETTINGS_SUFFIX)]
    return setting


def _best_valid_runtime(executions: Sequence[Dict[str, Any]]) -> Optional[float]:
    """Best (smallest) runtime among valid (code 0, no timeout) executions, or None."""
    best: Optional[float] = None
    for execution in executions:
        if execution.get("code") == 0 and not execution.get("timeout_expired", False):
            time = execution.get("time")
            if time is not None and (best is None or time < best):
                best = time
    return best


def _seq_runtime(settings: Dict[str, Any]) -> Optional[float]:
    """Best (smallest) valid sequential runtime for a config+script, or None."""
    seq_executions = settings.get("seq" + _SETTINGS_SUFFIX)
    if not seq_executions:
        return None
    return _best_valid_runtime(seq_executions)


def _unsuggested_runtime(executions: Sequence[Dict[str, Any]]) -> Optional[float]:
    """Best valid runtime among executions with *no* suggestions applied, or None.

    This is the autotuner's own reference: it measures ``par_settings.json`` with
    an empty suggestion set and reports every combination's speedup relative to it.
    Used as the baseline when no ``seq_settings.json`` group exists (autotuner runs
    write only the explored ``par`` combinations, never a sequential baseline).
    """
    unsuggested = [e for e in executions if not e.get("applied_suggestions")]
    if not unsuggested:
        return None
    return _best_valid_runtime(unsuggested)


def parse_execution_results(data: Dict[str, Any]) -> List[ExecutionRecord]:
    """Flatten the nested ``execution_results.json`` structure into records."""
    records: List[ExecutionRecord] = []
    for config in data:
        for script in data[config]:
            settings = data[config][script]
            seq_runtime = _seq_runtime(settings)
            for setting in settings:
                mode = mode_of_setting(setting)
                # Prefer the sequential baseline (normal Execute runs); fall back to
                # the no-suggestions run within this setting group (autotuner runs,
                # which have no seq baseline) so their speedups still render.
                baseline_runtime = seq_runtime
                if baseline_runtime is None:
                    baseline_runtime = _unsuggested_runtime(settings[setting])
                for execution in settings[setting]:
                    code = int(execution.get("code", -1))
                    timeout = bool(execution.get("timeout_expired", False))
                    time = float(execution.get("time", 0.0))
                    thread_count = int(execution.get("thread_count", 1))
                    valid = code == 0 and not timeout
                    speedup = baseline_runtime / time if (baseline_runtime is not None and time > 0) else None
                    efficiency = speedup / thread_count if (speedup is not None and thread_count > 0) else None
                    records.append(
                        ExecutionRecord(
                            config=config,
                            script=script,
                            mode=mode,
                            label=str(execution.get("label", "")),
                            thread_count=thread_count,
                            applied_suggestions=[int(s) for s in execution.get("applied_suggestions", [])],
                            time=time,
                            code=code,
                            timeout=timeout,
                            valid=valid,
                            speedup=speedup,
                            efficiency=efficiency,
                        )
                    )
    return records


def pareto_frontier(points: Sequence[Tuple[float, float]]) -> List[int]:
    """Indices of the non-dominated points when *maximizing both* coordinates.

    A point is dominated if another point is >= in both coordinates and strictly
    greater in at least one. Returned indices are sorted by ascending x.
    """
    frontier: List[int] = []
    for i, (xi, yi) in enumerate(points):
        dominated = False
        for j, (xj, yj) in enumerate(points):
            if j == i:
                continue
            if xj >= xi and yj >= yi and (xj > xi or yj > yi):
                dominated = True
                break
        if not dominated:
            frontier.append(i)
    frontier.sort(key=lambda idx: points[idx][0])
    return frontier


def best_so_far(measurements: Sequence[Tuple[int, Optional[float], bool]]) -> List[Tuple[int, float]]:
    """Running best (maximum) speedup over valid measurements, in search order.

    ``measurements`` is a sequence of ``(index, speedup, valid)``. The result is a
    monotonically non-decreasing step series ``[(index, best_so_far), ...]`` that
    starts at the first index for which a valid speedup exists.
    """
    out: List[Tuple[int, float]] = []
    best: Optional[float] = None
    for index, speedup, valid in measurements:
        if valid and speedup is not None and (best is None or speedup > best):
            best = speedup
        if best is not None:
            out.append((index, best))
    return out


def parse_progress_line(line: str) -> Optional[Dict[str, Any]]:
    """Parse one ``@@AT_PROGRESS {json}`` stdout line into an event dict.

    Returns None for lines without the prefix or with malformed JSON, so a caller
    can filter progress events out of an interleaved stdout stream.
    """
    stripped = line.strip()
    if not stripped.startswith(PROGRESS_PREFIX):
        return None
    try:
        obj = json.loads(stripped[len(PROGRESS_PREFIX) :])
    except json.JSONDecodeError:
        return None
    return obj if isinstance(obj, dict) else None


def parse_progress_jsonl(text: str) -> List[Dict[str, Any]]:
    """Parse the contents of a ``progress.jsonl`` file into event dicts."""
    events: List[Dict[str, Any]] = []
    for raw in text.splitlines():
        line = raw.strip()
        if not line:
            continue
        try:
            obj = json.loads(line)
        except json.JSONDecodeError:
            continue
        if isinstance(obj, dict):
            events.append(obj)
    return events
