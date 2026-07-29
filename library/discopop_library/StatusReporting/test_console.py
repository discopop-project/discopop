# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

"""Tests for the unified console status reporting."""

import io
from typing import Any

import pytest

from discopop_library.StatusReporting.console import progress, stage, supports_redrawing


class _FakeConsole(io.StringIO):
    """Stream which claims to be an interactive console."""

    def isatty(self) -> bool:
        return True


def test_redrawing_detection() -> None:
    assert not supports_redrawing(io.StringIO())
    assert supports_redrawing(_FakeConsole())


def test_redrawing_detection_handles_dumb_terminals(monkeypatch: Any) -> None:
    monkeypatch.setenv("TERM", "dumb")
    assert not supports_redrawing(_FakeConsole())


def test_stage_label_includes_step_counter_when_given() -> None:
    with stage("Breaking cycles", 2, total=15) as spinner:
        assert spinner.label == "[2/15] Breaking cycles"


def test_stage_label_omits_step_counter_when_not_given() -> None:
    with stage("Loading Hotspots") as spinner:
        assert spinner.label == "Loading Hotspots"


def test_stage_reports_failure_without_swallowing_the_exception() -> None:
    with pytest.raises(ValueError):
        with stage("Some step"):
            raise ValueError("boom")


def test_progress_wraps_a_plain_iterable() -> None:
    assert list(progress([1, 2, 3], desc="counting")) == [1, 2, 3]
