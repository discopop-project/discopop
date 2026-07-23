# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

from discopop_library.ProjectManager.gui.plots.data import ExecutionRecord
from discopop_library.ProjectManager.gui.plots.report_charts import best_of, metric_value, more_is_better


def _rec(config: str, mode: str, threads: int, time: float, speedup: float, valid: bool = True) -> ExecutionRecord:
    return ExecutionRecord(
        config=config,
        script="execute.sh",
        mode=mode,
        label="",
        thread_count=threads,
        applied_suggestions=[],
        time=time,
        code=0 if valid else 1,
        timeout=False,
        valid=valid,
        speedup=speedup,
        efficiency=speedup / threads,
    )


def test_metric_value() -> None:
    r = _rec("c", "par", 8, 4.0, 2.5)
    assert metric_value(r, "runtime") == 4.0
    assert metric_value(r, "threads") == 8.0
    assert metric_value(r, "speedup") == 2.5
    efficiency = metric_value(r, "efficiency")
    assert efficiency is not None and abs(efficiency - 2.5 / 8) < 1e-9
    assert metric_value(r, "bogus") is None


def test_more_is_better() -> None:
    assert more_is_better("speedup")
    assert more_is_better("efficiency")
    assert not more_is_better("runtime")


def test_best_of_prefers_max_speedup() -> None:
    records = [
        _rec("c", "par", 8, 5.0, 2.0),
        _rec("c", "par", 8, 4.0, 2.5),  # best speedup for (c, par)
        _rec("c", "dp", 8, 3.0, 3.3),
        _rec("c", "par", 8, 1.0, 9.9, valid=False),  # invalid ignored despite high speedup
    ]
    best = best_of(records, "speedup")
    assert best[("c", "par")].speedup == 2.5
    assert best[("c", "dp")].speedup == 3.3


def test_best_of_prefers_min_runtime() -> None:
    records = [
        _rec("c", "par", 8, 5.0, 2.0),
        _rec("c", "par", 8, 4.0, 2.5),  # smallest runtime
    ]
    best = best_of(records, "runtime")
    assert best[("c", "par")].time == 4.0


def test_best_of_ignores_all_invalid() -> None:
    records = [_rec("c", "par", 8, 4.0, 2.5, valid=False)]
    assert best_of(records, "speedup") == {}
