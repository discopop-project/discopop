# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

"""Live console plot of a graph's size (amount of nodes and edges).

Used to visualize the graph growth during the long-running TaskGraph construction steps
(function call inlining and branching node insertion), which otherwise only report plain
progress bars without any indication of how the graph develops.

If the output stream is an interactive console, the plot occupies a fixed block of lines
which is rewritten in place. Those lines are managed as `tqdm` instances, so the plot
coexists with the regular progress bars: bars created while the plot is alive are placed
below it by tqdm's automatic position assignment.

If the output stream does not support redrawing (e.g. because it is redirected to a file),
the intermediate states are not written at all - instead, the finished plot is printed
exactly once, when the visualized step is done.
"""

import os
import re
import shutil
import sys
import time
from types import TracebackType
from typing import IO, List, Optional, Tuple, Type

import plotille  # type: ignore
from tqdm import tqdm  # type: ignore

# Upper bound on the amount of stored samples. Once exceeded, the history is thinned out
# by dropping every second sample (and the sampling stride is doubled accordingly), which
# keeps both the memory footprint and the plotting effort bounded while retaining the
# overall shape of the curves.
MAX_SAMPLES = 512

# Amount of lines a rendered plotille figure requires in addition to its configured height:
# the header line added by render(), the y axis header, the x axis and its labels, and the
# legend. Kept as a constant since the block of occupied console lines must be of fixed size.
LINES_AROUND_PLOT = 10

# Amount of console lines left available for the progress bars below the plot
RESERVED_CONSOLE_LINES = 10

_ANSI_ESCAPE_PATTERN = re.compile(r"\x1b\[[0-9;]*[a-zA-Z]")


def _display_length(line: str) -> int:
    """Length of a line as displayed, i.e. ignoring color escape sequences."""
    return len(_ANSI_ESCAPE_PATTERN.sub("", line))


def supports_redrawing(stream: IO[str]) -> bool:
    """Check whether previously written lines of the given stream can be overwritten, i.e.
    whether it is an interactive console rather than a file, a pipe, or a dumb terminal."""
    try:
        if not stream.isatty():
            return False
    except Exception:
        # closed or replaced streams (e.g. when embedded into another application)
        return False
    return os.environ.get("TERM", "") != "dumb"


class GraphSizeProgressPlot:
    """Plot of the amount of nodes and edges of a graph over time. Updated live if the
    output stream supports redrawing, printed once on close otherwise."""

    def __init__(
        self,
        title: str = "Graph size",
        height: int = 15,
        width: int = 60,
        min_sample_interval_seconds: float = 0.25,
        enabled: bool = True,
        stream: Optional[IO[str]] = None,
    ) -> None:
        """
        :param title: label shown in the plot's header line
        :param height: height of the plot in console lines
        :param width: width of the plot in console columns
        :param min_sample_interval_seconds: lower bound on the time between two samples, so
            that measuring and plotting stay negligible compared to the visualized work
        :param enabled: set to False to disable the plot entirely
        :param stream: output stream to plot to, defaults to the stream used by tqdm (stderr)
        """
        self.title = title
        self.height = max(3, height)
        self.width = max(10, width)
        self.min_sample_interval_seconds = max(0.0, min_sample_interval_seconds)
        self.enabled = enabled
        self.stream = stream if stream is not None else sys.stderr
        self.redrawing_supported = supports_redrawing(self.stream)

        self.samples: List[Tuple[int, int]] = []
        # amount of raw samples represented by a single stored sample
        self.__stride = 1
        self.__raw_sample_count = 0
        self.__last_sample_time = 0.0
        self.__latest: Tuple[int, int] = (0, 0)
        self.__opened = False
        self.__lines: List[tqdm] = []
        # layout of the occupied console block, determined in open()
        self.__plot_height = self.height
        self.__plot_width = self.width
        self.__console_width = 80
        self.__line_count = self.__plot_height + LINES_AROUND_PLOT

    @property
    def line_count(self) -> int:
        """Amount of console lines occupied by the plot, fixed while it is open."""
        return self.__line_count

    # -------------------------------------------------------------------- lifecycle

    def __enter__(self) -> "GraphSizeProgressPlot":
        self.open()
        return self

    def __exit__(
        self,
        exc_type: Optional[Type[BaseException]],
        exc_value: Optional[BaseException],
        traceback: Optional[TracebackType],
    ) -> None:
        self.close()

    def open(self) -> None:
        if not self.enabled or self.__opened:
            return
        self.__opened = True
        if not self.redrawing_supported:
            # nothing is written before close(), so the plot layout can be independent of
            # the (unknown) size of the console
            return
        # adapt the block to the console, so that the plot never fills it up entirely and
        # the progress bars below it stay visible
        console_size = shutil.get_terminal_size((80, 24))
        self.__console_width = max(40, console_size.columns)
        self.__plot_width = max(20, min(self.width, self.__console_width - 15))
        self.__plot_height = max(5, min(self.height, console_size.lines - RESERVED_CONSOLE_LINES - LINES_AROUND_PLOT))
        self.__line_count = self.__plot_height + LINES_AROUND_PLOT
        for _ in range(self.__line_count):
            self.__lines.append(tqdm(total=0, bar_format="{desc}", desc="", leave=False, file=self.stream))

    def close(self) -> None:
        if not self.__opened:
            return
        self.__opened = False
        if not self.redrawing_supported:
            # the plot has not been shown yet, so print its final state once
            if len(self.samples) > 0:
                tqdm.write("\n".join(self.render()), file=self.stream)
            return
        self.__redraw()
        # close bottom-up, so that tqdm's line clearing does not leave gaps behind
        for line in reversed(self.__lines):
            line.close()
        self.__lines = []

    # --------------------------------------------------------------------- sampling

    def sample_due(self) -> bool:
        """Check whether a new sample would be recorded. Allows the caller to skip
        determining the amount of nodes and edges, which is not necessarily cheap."""
        if not self.enabled:
            return False
        return time.monotonic() - self.__last_sample_time >= self.min_sample_interval_seconds

    def sample(self, nodes: int, edges: int, force: bool = False) -> None:
        """Record the current amount of nodes and edges and redraw the plot.

        Samples arriving within min_sample_interval_seconds of the previous one are dropped,
        unless force is set (used to capture the final state of the visualized step).
        """
        if not self.enabled:
            return
        if not force and not self.sample_due():
            return
        self.__last_sample_time = time.monotonic()
        self.__latest = (nodes, edges)
        self.__raw_sample_count += 1
        if self.__raw_sample_count % self.__stride != 0:
            return

        self.samples.append((nodes, edges))
        if len(self.samples) > MAX_SAMPLES:
            self.samples = self.samples[::2]
            self.__stride *= 2

        if self.redrawing_supported:
            self.__redraw()

    # -------------------------------------------------------------------- rendering

    def __redraw(self) -> None:
        if len(self.__lines) == 0:
            return
        contents = self.render()
        # keep the amount of written lines constant, as the plot occupies a fixed block
        contents = contents[: self.__line_count]
        contents += [""] * (self.__line_count - len(contents))
        for line, line_contents in zip(self.__lines, contents):
            # pad to the console width, so that leftovers of previously printed output
            # (e.g. finished progress bars) are overwritten instead of shining through
            line.set_description_str(self.__pad(line_contents), refresh=True)

    def __pad(self, line: str) -> str:
        padding = self.__console_width - 1 - _display_length(line)
        return line + " " * padding if padding > 0 else line

    def render(self) -> List[str]:
        """Build the plot's lines. Exposed separately to keep it testable."""
        nodes, edges = self.__latest
        header = f"{self.title}: {nodes} nodes, {edges} edges ({self.__raw_sample_count} samples)"
        if len(self.samples) < 2:
            return [header]

        x_values = [index * self.__stride for index in range(len(self.samples))]
        fig = plotille.Figure()
        fig.height = self.__plot_height
        fig.width = self.__plot_width
        fig.x_label = "Sample"
        fig.y_label = "Count"
        fig.plot(x_values, [sample[0] for sample in self.samples], interp="linear", lc="green", label="Nodes")
        fig.plot(x_values, [sample[1] for sample in self.samples], interp="linear", lc="yellow", label="Edges")
        figure_lines: List[str] = str(fig.show(legend=True)).splitlines()
        return [header] + figure_lines
