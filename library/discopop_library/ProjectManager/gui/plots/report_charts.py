# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

"""Chart renderers for the Report tab, driven by :class:`ExecutionRecord`s.

Three chart types share the encoding language from :mod:`mode_style` (colour =
configuration, marker/dash = execution mode, fill = validity):

* :func:`render_pareto`  -- trade-off scatter of every measured run;
* :func:`render_scaling` -- one line per (config, mode) across thread counts;
* :func:`render_bars`    -- best-of comparison per configuration and mode.

The pure metric/reduction helpers are matplotlib-free and unit-tested; only the
``render_*`` functions touch a figure (passed in by the caller). Record metadata
is stored on each point/line/bar so hovering shows a tooltip and clicking can
report the record back to the caller (e.g. to fill an always-visible detail panel).
"""

from __future__ import annotations

from typing import Any, Callable, Dict, List, Optional, Sequence, Tuple

from discopop_library.ProjectManager.gui.plots import mode_style
from discopop_library.ProjectManager.gui.plots.data import ExecutionRecord, pareto_frontier

# Sentinel for storing ExecutionRecord metadata on artists for hover tooltips.
_RECORD_METADATA_KEY = "_discopop_record"

# metric key -> (axis label, "more is better")
METRICS: Dict[str, Tuple[str, bool]] = {
    "speedup": ("Speedup ×", True),
    "efficiency": ("Parallel efficiency", True),
    "runtime": ("Runtime (s)", False),
    "threads": ("Threads", True),
}

# Grouped-bar colours are keyed by mode (the within-group series); kept separate
# from the categorical config palette, which encodes colour on the other charts.
MODE_BAR_COLORS: Dict[str, str] = {
    "seq": mode_style.REFERENCE_COLOR,
    "par": mode_style.CONFIG_PALETTE[0],
    "dp": mode_style.CONFIG_PALETTE[2],
    "hd": mode_style.CONFIG_PALETTE[3],
}


def metric_value(record: ExecutionRecord, metric: str) -> Optional[float]:
    if metric == "runtime":
        return record.time
    if metric == "threads":
        return float(record.thread_count)
    if metric == "speedup":
        return record.speedup
    if metric == "efficiency":
        return record.efficiency
    return None


def more_is_better(metric: str) -> bool:
    return METRICS.get(metric, ("", True))[1]


def best_of(records: Sequence[ExecutionRecord], metric: str) -> Dict[Tuple[str, str], ExecutionRecord]:
    """Best *valid* record per (config, mode) by ``metric`` (max, or min for runtime)."""
    prefer_max = more_is_better(metric)
    best: Dict[Tuple[str, str], ExecutionRecord] = {}
    for record in records:
        if not record.valid:
            continue
        value = metric_value(record, metric)
        if value is None:
            continue
        key = (record.config, record.mode)
        current = best.get(key)
        if current is None:
            best[key] = record
            continue
        current_value = metric_value(current, metric)
        assert current_value is not None
        if (prefer_max and value > current_value) or (not prefer_max and value < current_value):
            best[key] = record
    return best


def _format_record_tooltip(record: ExecutionRecord) -> str:
    """Format an ExecutionRecord as a multi-line tooltip string."""
    lines = [
        f"Config: {record.config}",
        f"Mode: {record.mode}",
        f"Suggestions: {record.applied_suggestions if record.applied_suggestions else '(none)'}",
        f"Threads: {record.thread_count}",
        f"Runtime: {record.time:.3f}s",
    ]
    if record.speedup is not None:
        lines.append(f"Speedup: {record.speedup:.3f}×")
    if record.efficiency is not None:
        lines.append(f"Efficiency: {record.efficiency:.3f}")
    status = "✓ valid" if record.valid else ("⧗ timeout" if record.timeout else "✗ failed")
    lines.append(f"Status: {status}")
    return "\n".join(lines)


def _empty(ax: Any, message: str = "No execution results yet") -> None:
    ax.text(
        0.5,
        0.5,
        message,
        ha="center",
        va="center",
        color=mode_style.REFERENCE_COLOR,
        fontsize=mode_style.ANNOTATION_SIZE,
    )
    ax.set_xticks([])
    ax.set_yticks([])


_INTERACTION_BOUND_KEY = "_discopop_interaction_bound"


def _find_record_at_event(figure: Any, event: Any) -> Optional[ExecutionRecord]:
    """Return the ExecutionRecord nearest ``event`` (within 2% of the axis range).

    Shared by hover tooltips and click selection so both react to exactly the
    same set of points/lines/bars carrying record metadata.
    """
    if event.inaxes is None or event.xdata is None or event.ydata is None:
        return None
    for ax in figure.axes:
        if not ax.get_visible():
            continue
        xdata, ydata = event.xdata, event.ydata
        threshold = 0.02 * (ax.get_xlim()[1] - ax.get_xlim()[0])
        # Scatter collections (pareto, autotuning).
        for coll in ax.collections:
            if not hasattr(coll, "get_offsets") or len(coll.get_offsets()) == 0:
                continue
            offsets = coll.get_offsets()
            dists = ((offsets[:, 0] - xdata) ** 2 + (offsets[:, 1] - ydata) ** 2) ** 0.5
            min_dist_idx = dists.argmin()
            if dists[min_dist_idx] < threshold:
                records = getattr(coll, _RECORD_METADATA_KEY, None)
                if records and min_dist_idx < len(records):
                    return records[min_dist_idx]  # type: ignore[no-any-return]
        # Line artists (scaling).
        for line in ax.get_lines():
            if not line.get_visible() or len(line.get_xdata()) == 0:
                continue
            xs, ys = line.get_xdata(), line.get_ydata()
            dists = ((xs - xdata) ** 2 + (ys - ydata) ** 2) ** 0.5
            min_dist_idx = dists.argmin()
            if dists[min_dist_idx] < threshold:
                record = getattr(line, _RECORD_METADATA_KEY, None)
                if record is not None:
                    return record  # type: ignore[no-any-return]
        # Bar patches (bars chart).
        for patch in ax.patches:
            if not patch.get_visible():
                continue
            bbox = patch.get_bbox() if hasattr(patch, "get_bbox") else patch.get_path().get_extents()
            if bbox.contains(xdata, ydata):
                record = getattr(patch, _RECORD_METADATA_KEY, None)
                if record is not None:
                    return record  # type: ignore[no-any-return]
    return None


def _setup_record_interaction(figure: Any, on_select: Optional[Callable[[ExecutionRecord], None]] = None) -> None:
    """Enable hover tooltips and click-to-select for records in the figure.

    Call this after every render. Hovering near a point/line/bar with attached
    record metadata shows a floating tooltip; clicking one calls ``on_select``
    with its :class:`ExecutionRecord` (a click that misses every artist is
    ignored, leaving the previous selection displayed) -- e.g. to fill an
    always-visible detail panel next to the plot. Safe to call in headless
    environments (silently skips setup).

    A chart tab re-renders its figure repeatedly (control changes, data
    refreshes) while reusing the same canvas, so the handlers -- which look up
    artists via ``figure.axes`` at event time, not bind time -- only need to be
    attached once; a flag on the canvas guards against piling up duplicate
    bindings (which would otherwise fire the callback multiple times per click).
    """
    # Guard against headless backends (no Tk canvas).
    if not hasattr(figure.canvas, "mpl_connect") or not hasattr(figure.canvas, "get_tk_widget"):
        return
    if getattr(figure.canvas, _INTERACTION_BOUND_KEY, False):
        return
    setattr(figure.canvas, _INTERACTION_BOUND_KEY, True)

    _setup_hover_tooltips(figure)

    def on_click(event: Any) -> None:
        record = _find_record_at_event(figure, event)
        if record is not None and on_select is not None:
            on_select(record)

    figure.canvas.mpl_connect("button_press_event", on_click)


def _setup_hover_tooltips(figure: Any) -> None:
    """Enable hover tooltips on a figure that have record metadata attached.

    Binds to the figure canvas's motion_notify_event and displays a sticky label
    when hovering over a point, line, or bar with attached record metadata.
    """
    import tkinter as tk

    # The tooltip label, created on first hover and shown/hidden thereafter.
    tooltip_label: Optional[tk.Label] = None
    last_record: Optional[ExecutionRecord] = None

    def on_motion(event: Any) -> None:
        nonlocal tooltip_label, last_record
        record = _find_record_at_event(figure, event)

        if record is None:
            if tooltip_label is not None:
                tooltip_label.place_forget()
            last_record = None
            return

        # If we're hovering the same record, don't recreate the label.
        if last_record is record:
            return
        last_record = record

        text = _format_record_tooltip(record)

        # Create/update the tooltip label.
        if tooltip_label is None:
            canvas_widget = figure.canvas.get_tk_widget()
            tooltip_label = tk.Label(
                canvas_widget,
                text=text,
                background="#fffacd",
                relief=tk.SOLID,
                borderwidth=1,
                font=("TkDefaultFont", 9),
                justify=tk.LEFT,
                padx=4,
                pady=2,
            )
        else:
            tooltip_label.config(text=text)

        # Position the tooltip near the cursor, inside the canvas bounds.
        canvas_x = figure.canvas.get_tk_widget().winfo_pointerx()
        canvas_y = figure.canvas.get_tk_widget().winfo_pointery()
        canvas_x -= figure.canvas.get_tk_widget().winfo_rootx()
        canvas_y -= figure.canvas.get_tk_widget().winfo_rooty()
        tooltip_label.place(x=canvas_x + 10, y=canvas_y + 10)

    # Bind the motion handler to the figure's canvas.
    figure.canvas.mpl_connect("motion_notify_event", on_motion)


def _config_mode_legends(ax: Any, configs: Sequence[str], modes: Sequence[str], colors: Dict[str, str]) -> None:
    from matplotlib.lines import Line2D
    from matplotlib.patches import Patch

    config_handles = [Patch(facecolor=colors[c], label=c) for c in configs]
    mode_handles = [
        Line2D([], [], marker=mode_style.mode_marker(m), color="0.35", linestyle="None", label=m) for m in modes
    ]
    if config_handles:
        first = ax.legend(handles=config_handles, title="config", loc="upper left", fontsize=mode_style.LEGEND_SIZE)
        mode_style.style_legend(first)
        ax.add_artist(first)
    if mode_handles:
        second = ax.legend(handles=mode_handles, title="mode", loc="lower right", fontsize=mode_style.LEGEND_SIZE)
        mode_style.style_legend(second)


def render_pareto(
    figure: Any,
    records: Sequence[ExecutionRecord],
    x_metric: str = "efficiency",
    y_metric: str = "speedup",
    config_filter: Optional[str] = None,
    valid_only: bool = False,
    show_frontier: bool = True,
    on_select: Optional[Callable[[ExecutionRecord], None]] = None,
) -> None:
    figure.clear()
    ax = figure.add_subplot(111)

    rows = [r for r in records if r.config == config_filter or config_filter in (None, "all")]
    rows = [r for r in rows if not r.timeout]
    if valid_only:
        rows = [r for r in rows if r.valid]
    points: List[Tuple[ExecutionRecord, float, float]] = []
    for r in rows:
        x = metric_value(r, x_metric)
        y = metric_value(r, y_metric)
        if x is None or y is None:
            continue
        points.append((r, x, y))
    if not points:
        _empty(ax)
        return

    colors = mode_style.assign_config_colors([r.config for r in records])
    # group by (config, mode, valid) so we can set colour, marker, and fill together
    groups: Dict[Tuple[str, str, bool], List[Tuple[ExecutionRecord, float, float]]] = {}
    for r, x, y in points:
        groups.setdefault((r.config, r.mode, r.valid), []).append((r, float(x), float(y)))
    for (config, mode, valid), rxy in groups.items():
        xs = [p[1] for p in rxy]
        ys = [p[2] for p in rxy]
        recs = [p[0] for p in rxy]
        color = colors.get(config, mode_style.CONFIG_PALETTE[0])
        if valid:
            coll = ax.scatter(
                xs,
                ys,
                marker=mode_style.mode_marker(mode),
                color=color,
                edgecolors="white",
                linewidths=0.6,
                s=mode_style.SCATTER_SIZE,
                zorder=3,
            )
        else:
            coll = ax.scatter(
                xs,
                ys,
                marker=mode_style.mode_marker(mode),
                facecolors="none",
                edgecolors=color,
                linewidths=1.8,
                s=mode_style.SCATTER_SIZE,
                zorder=3,
            )
        setattr(coll, _RECORD_METADATA_KEY, recs)

    # Pareto frontier only makes sense when both axes are "more is better"
    if show_frontier and more_is_better(x_metric) and more_is_better(y_metric):
        valid_points = [(x, y) for (r, x, y) in points if r.valid]
        frontier = pareto_frontier(valid_points)
        if len(frontier) > 1:
            fx = [valid_points[i][0] for i in frontier]
            fy = [valid_points[i][1] for i in frontier]
            ax.plot(
                fx,
                fy,
                color=mode_style.REFERENCE_COLOR,
                linestyle="--",
                linewidth=1.4,
                zorder=2,
                label="Pareto frontier",
            )

    x_label = METRICS.get(x_metric, (x_metric, True))[0]
    y_label = METRICS.get(y_metric, (y_metric, True))[0]
    ax.set_xlabel(x_label)
    ax.set_ylabel(y_label)
    configs = sorted({r.config for r, _x, _y in points})
    modes = sorted({r.mode for r, _x, _y in points})
    _config_mode_legends(ax, configs, modes, colors)
    mode_style.style_axes(ax)
    _setup_record_interaction(figure, on_select)


def render_scaling(
    figure: Any,
    records: Sequence[ExecutionRecord],
    metric: str = "speedup",
    config_filter: Optional[str] = None,
    show_ideal: bool = True,
    on_select: Optional[Callable[[ExecutionRecord], None]] = None,
) -> None:
    figure.clear()
    ax = figure.add_subplot(111)

    rows = [r for r in records if (config_filter in (None, "all") or r.config == config_filter) and r.valid]
    if not rows:
        _empty(ax)
        return

    colors = mode_style.assign_config_colors([r.config for r in records])
    series: Dict[Tuple[str, str], List[Tuple[int, float]]] = {}
    for r in rows:
        value = metric_value(r, metric)
        if value is None:
            continue
        series.setdefault((r.config, r.mode), []).append((r.thread_count, float(value)))

    max_threads = 1
    for (config, mode), pts in sorted(series.items()):
        pts = sorted(pts)
        xs = [p[0] for p in pts]
        ys = [p[1] for p in pts]
        max_threads = max(max_threads, *xs) if xs else max_threads
        dashes = mode_style.mode_dashes(mode)
        line_kwargs: Dict[str, Any] = {
            "color": colors.get(config, mode_style.CONFIG_PALETTE[0]),
            "marker": mode_style.mode_marker(mode),
            "markersize": mode_style.LINE_MARKER_SIZE,
            "linewidth": 2.0,
        }
        if dashes != (None, None):
            line_kwargs["dashes"] = list(dashes)
        (line,) = ax.plot(xs, ys, **line_kwargs)
        # Store a representative record from this series (the best one by the metric).
        best_record = max(
            [r for r in rows if r.config == config and r.mode == mode], key=lambda r: metric_value(r, metric) or 0.0
        )
        setattr(line, _RECORD_METADATA_KEY, best_record)

    if show_ideal and metric == "speedup":
        ax.plot(
            [0, max_threads],
            [0, max_threads],
            color=mode_style.REFERENCE_COLOR,
            linestyle="--",
            linewidth=1.3,
            label="ideal (linear)",
        )

    ax.set_xlabel("Threads")
    ax.set_ylabel(METRICS.get(metric, (metric, True))[0])
    ax.set_ylim(bottom=0)
    configs = sorted({c for (c, _m) in series})
    modes = sorted({m for (_c, m) in series})
    _config_mode_legends(ax, configs, modes, colors)
    mode_style.style_axes(ax)
    _setup_record_interaction(figure, on_select)


def render_bars(
    figure: Any,
    records: Sequence[ExecutionRecord],
    metric: str = "speedup",
    on_select: Optional[Callable[[ExecutionRecord], None]] = None,
) -> None:
    figure.clear()
    ax = figure.add_subplot(111)

    best = best_of(records, metric)
    if not best:
        _empty(ax, "No valid execution results yet")
        return

    configs = sorted({config for (config, _mode) in best})
    modes = sorted({mode for (_config, mode) in best})
    n_modes = max(1, len(modes))
    bar_width = 0.8 / n_modes

    import numpy as np

    x = np.arange(len(configs))
    for i, mode in enumerate(modes):
        records_in_mode = []
        heights = []
        for config in configs:
            record = best.get((config, mode))
            records_in_mode.append(record)
            value = metric_value(record, metric) if record is not None else None
            heights.append(value if value is not None else 0.0)
        offset = (i - (n_modes - 1) / 2) * bar_width
        bars = ax.bar(
            x + offset,
            heights,
            width=bar_width,
            color=MODE_BAR_COLORS.get(mode, mode_style.CONFIG_PALETTE[i % len(mode_style.CONFIG_PALETTE)]),
            label=mode,
        )
        # Attach record metadata to each bar patch.
        for bar, record in zip(bars, records_in_mode):
            if record is not None:
                setattr(bar, _RECORD_METADATA_KEY, record)

    ax.set_xticks(list(x))
    ax.set_xticklabels(configs)
    ax.set_ylabel(METRICS.get(metric, (metric, True))[0])
    ax.set_xlabel("Configuration")
    legend = ax.legend(title="mode", fontsize=mode_style.LEGEND_SIZE)
    mode_style.style_legend(legend)
    mode_style.style_axes(ax)
    _setup_record_interaction(figure, on_select)
