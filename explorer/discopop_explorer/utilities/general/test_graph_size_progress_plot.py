# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

"""Tests for the console plot of a graph's size."""

import io
from typing import Any, List

from discopop_explorer.utilities.general.graph_size_progress_plot import (
    LINES_AROUND_PLOT,
    MAX_SAMPLES,
    GraphSizeProgressPlot,
    supports_redrawing,
)


class _FakeConsole(io.StringIO):
    """Stream which claims to be an interactive console."""

    def isatty(self) -> bool:
        return True


def _plot_to(stream: Any, **kwargs: Any) -> GraphSizeProgressPlot:
    # no sample interval, so that tests can record an exact amount of samples
    return GraphSizeProgressPlot(min_sample_interval_seconds=0.0, stream=stream, **kwargs)


def test_redrawing_detection() -> None:
    assert not supports_redrawing(io.StringIO())
    assert supports_redrawing(_FakeConsole())


def test_redrawing_detection_handles_dumb_terminals(monkeypatch: Any) -> None:
    monkeypatch.setenv("TERM", "dumb")
    assert not supports_redrawing(_FakeConsole())


def test_disabled_plot_does_not_write_anything() -> None:
    stream = _FakeConsole()
    plot = _plot_to(stream, enabled=False)
    with plot:
        for index in range(100):
            plot.sample(index, 2 * index)
    assert len(plot.samples) == 0
    assert stream.getvalue() == ""


def test_stream_without_redrawing_support_receives_the_plot_exactly_once() -> None:
    stream = io.StringIO()
    plot = _plot_to(stream, title="Some graph")
    assert not plot.redrawing_supported
    with plot:
        for index in range(100):
            plot.sample(100 + index, 200 + 2 * index)
        # intermediate states must not be written, as they could not be overwritten again
        assert stream.getvalue() == ""
    written: List[str] = stream.getvalue().splitlines()
    assert written[0] == "Some graph: 199 nodes, 398 edges (100 samples)"
    assert len([line for line in written if line.startswith("Some graph:")]) == 1
    assert any("Nodes" in line for line in written)
    assert any("Edges" in line for line in written)


def test_interactive_console_is_updated_while_sampling() -> None:
    stream = _FakeConsole()
    plot = _plot_to(stream, title="Some graph")
    assert plot.redrawing_supported
    with plot:
        for index in range(100):
            plot.sample(100 + index, 200 + 2 * index)
        assert "Some graph" in stream.getvalue()


def test_samples_are_dropped_until_the_sample_interval_has_passed() -> None:
    plot = GraphSizeProgressPlot(min_sample_interval_seconds=3600.0, stream=io.StringIO())
    assert plot.sample_due()
    for index in range(100):
        plot.sample(index, index)
    assert len(plot.samples) == 1
    assert not plot.sample_due()
    # the final state of the visualized step is captured regardless of the interval
    plot.sample(999, 999, force=True)
    assert plot.samples[-1] == (999, 999)


def test_header_only_until_a_curve_can_be_drawn() -> None:
    plot = _plot_to(io.StringIO(), title="Some graph")
    plot.sample(10, 20)
    lines = plot.render()
    assert len(lines) == 1
    assert lines[0] == "Some graph: 10 nodes, 20 edges (1 samples)"


def test_rendered_plot_fits_into_the_reserved_block() -> None:
    plot = _plot_to(_FakeConsole(), height=12)
    plot.open()
    try:
        for index in range(200):
            plot.sample(100 + index, 200 + 2 * index)
        lines = plot.render()
        line_count = plot.line_count
    finally:
        plot.close()
    # the block of occupied console lines is allocated up front, so the amount of rendered
    # lines must match it exactly - otherwise parts of the plot would be cut off or leftovers
    # of a previous render would remain visible
    assert line_count >= LINES_AROUND_PLOT
    assert len(lines) == line_count
    assert lines[0] == "Graph size: 299 nodes, 598 edges (200 samples)"


def test_samples_are_thinned_out_to_stay_within_the_limit() -> None:
    plot = _plot_to(io.StringIO())
    for index in range(4 * MAX_SAMPLES + 1):
        plot.sample(index, index)
    assert len(plot.samples) <= MAX_SAMPLES
    # the retained history still spans the entire recorded range
    assert plot.samples[0][0] == 0
    assert plot.samples[-1][0] >= 3 * MAX_SAMPLES
