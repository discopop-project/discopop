# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

"""Structured progress channel for the empirical autotuner.

The autotuner emits one JSON object per search event via :class:`ProgressReporter`.
Each event is both

* printed to **stdout**, prefixed with :data:`PROGRESS_PREFIX`, so a consumer that
  already streams the autotuner's stdout (e.g. the Project Manager GUI) can update
  a live plot without extra IPC, and
* appended to a **``progress.jsonl``** file (one object per line) so the run can be
  re-visualized afterwards without re-running.

Event kinds (field ``event``):

* ``baseline``    -- the untuned reference measurement (``par_settings.json``).
* ``measurement`` -- one measured configuration, in search order.
* ``generation``  -- one evolutionary generation summary (evolutionary only).
* ``result``      -- the final best configuration + run statistics.

The reference for speedups is the *full-parallel* reference configuration, so
``speedup = reference_runtime / runtime`` is a speedup relative to full
parallelization, not to sequential execution.

``ProgressList`` is a drop-in replacement for the ``debug_stats`` list used
throughout the optimization algorithms: appending an entry additionally emits a
``measurement`` event via the process-global active reporter. This keeps the
step-based algorithms (greedy, coordinate descent, linear, measure-only, single
combination) unchanged -- they already append every measured configuration to
``debug_stats``.
"""

from __future__ import annotations

import json
import time
from typing import Any, Dict, List, Optional, Tuple

from discopop_library.EmpiricalAutotuning.Types import SUGGESTION_ID

PROGRESS_PREFIX = "@@AT_PROGRESS "

# The entry tuple stored in ``debug_stats``:
# (applied_suggestions, runtime, return_code, result_valid, thread_sanitizer, path)
DebugStatEntry = Tuple[List[SUGGESTION_ID], float, int, bool, bool, str]


class ProgressReporter:
    """Emits autotuner search events to stdout and to ``progress.jsonl``."""

    def __init__(self, configuration: str, jsonl_path: Optional[str] = None) -> None:
        self.configuration = configuration
        self.reference_runtime: Optional[float] = None
        self._index = 0
        self._start = time.time()
        self._fh = open(jsonl_path, "w") if jsonl_path is not None else None

    # -- emission ----------------------------------------------------------------

    def _emit(self, obj: Dict[str, Any]) -> None:
        obj.setdefault("config", self.configuration)
        line = json.dumps(obj, sort_keys=True)
        print(PROGRESS_PREFIX + line, flush=True)
        if self._fh is not None:
            self._fh.write(line + "\n")
            self._fh.flush()

    def _speedup(self, runtime: float) -> Optional[float]:
        if self.reference_runtime is None or runtime <= 0:
            return None
        return round(self.reference_runtime / runtime, 4)

    # -- events ------------------------------------------------------------------

    def baseline(self, runtime: float, valid: bool, thread_count: int) -> None:
        self.reference_runtime = runtime
        self._emit(
            {
                "event": "baseline",
                "runtime": round(runtime, 4),
                "valid": bool(valid),
                "thread_count": int(thread_count),
            }
        )

    def measurement(
        self,
        suggestions: List[SUGGESTION_ID],
        runtime: float,
        return_code: int,
        valid: bool,
        tsan: bool,
        generation: Optional[int] = None,
    ) -> None:
        self._index += 1
        obj: Dict[str, Any] = {
            "event": "measurement",
            "index": self._index,
            "suggestions": [int(s) for s in suggestions],
            "runtime": round(runtime, 4),
            "return_code": int(return_code),
            "valid": bool(valid),
            "tsan": bool(tsan),
            "speedup": self._speedup(runtime),
        }
        if generation is not None:
            obj["generation"] = int(generation)
        self._emit(obj)

    def generation(
        self, generation: int, max_fitness: float, avg_fitness: float, threshold: float, evaluated: int
    ) -> None:
        self._emit(
            {
                "event": "generation",
                "generation": int(generation),
                "max_fitness": round(max_fitness, 4),
                "avg_fitness": round(avg_fitness, 4),
                "threshold": round(threshold, 4),
                "evaluated": int(evaluated),
            }
        )

    def result(
        self,
        suggestions: List[SUGGESTION_ID],
        speedup: float,
        efficiency: float,
        runtime: float,
        valid_count: int,
        invalid_count: int,
        failed_count: int,
        optimization_time_s: float,
    ) -> None:
        self._emit(
            {
                "event": "result",
                "suggestions": [int(s) for s in suggestions],
                "speedup": round(speedup, 4),
                "efficiency": round(efficiency, 4),
                "runtime": round(runtime, 4),
                "valid_count": int(valid_count),
                "invalid_count": int(invalid_count),
                "failed_count": int(failed_count),
                "evaluated": self._index,
                "optimization_time_s": round(optimization_time_s, 2),
            }
        )

    def close(self) -> None:
        if self._fh is not None:
            self._fh.close()
            self._fh = None


# -- process-global active reporter ---------------------------------------------
# The evolutionary algorithm measures configurations via its ``fitness_cache``
# rather than ``debug_stats``, so it reaches the reporter through this handle
# instead of a threaded parameter. The autotuner runs as a single process per
# invocation, so a module global is safe here.

_ACTIVE_REPORTER: Optional[ProgressReporter] = None


def set_active_reporter(reporter: Optional[ProgressReporter]) -> None:
    global _ACTIVE_REPORTER
    _ACTIVE_REPORTER = reporter


def get_active_reporter() -> Optional[ProgressReporter]:
    return _ACTIVE_REPORTER


class ProgressList(List[DebugStatEntry]):
    """A ``debug_stats`` list that emits a ``measurement`` event on append.

    Behaves exactly like a plain list otherwise; when no reporter is active
    (e.g. in unit tests), ``append`` is a normal list append.
    """

    def append(self, entry: DebugStatEntry) -> None:
        super().append(entry)
        reporter = get_active_reporter()
        if reporter is not None:
            suggestions, runtime, return_code, valid, tsan, _path = entry
            reporter.measurement(suggestions, runtime, return_code, valid, tsan)


def count_outcomes(debug_stats: List[DebugStatEntry]) -> Tuple[int, int, int]:
    """Return (valid, invalid, failed) counts over measured configurations.

    * failed  -- non-zero return code (compilation/execution error or timeout)
    * invalid -- ran (return code 0) but the result or thread-sanitizer check failed
    * valid   -- ran and passed both validity and thread-sanitizer checks
    """
    valid = invalid = failed = 0
    for _suggestions, _runtime, return_code, result_valid, tsan, _path in debug_stats:
        if return_code != 0:
            failed += 1
        elif result_valid and tsan:
            valid += 1
        else:
            invalid += 1
    return valid, invalid, failed
