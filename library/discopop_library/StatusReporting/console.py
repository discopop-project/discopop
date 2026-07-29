# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

"""Unified console status reporting: colored stage banners with spinners, progress bars,
and log-backed success/warning/error messages, all sharing the same look and feel.

`stage(...)` is the single entry point for announcing a step of work, whether it is a
top-level pipeline phase or one of many sequential sub-steps of a larger construction
process. It shows an animated spinner for the duration of the `with` block, so every
currently-running step has a visible indicator even if it has no countable inner loop.
`progress(...)` is used for the inner loops themselves. Because both are backed by `tqdm`,
progress bars started inside a `stage(...)` block are automatically positioned below its
spinner line, so the step header keeps animating while its progress bar(s) run underneath.
"""

import logging
import os
import sys
import threading
import time
from types import TracebackType
from typing import IO, Any, Iterable, Optional, Type, TypeVar

from termcolor import colored
from tqdm import tqdm  # type: ignore

logger = logging.getLogger("Explorer")

_SPINNER_FRAMES = "⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏"
_SPINNER_INTERVAL_SECONDS = 0.1

T = TypeVar("T")


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


class Spinner:
    """Animated single-line indicator for the duration of a running step. Redraws in place
    on interactive consoles; on non-interactive streams (files, pipes, CI logs) it instead
    prints a single start line and a single done/fail line, since redrawing is not possible."""

    def __init__(self, label: str, stream: Optional[IO[str]] = None) -> None:
        self.label = label
        self.stream = stream if stream is not None else sys.stderr
        self._redraw = supports_redrawing(self.stream)
        self._line: Optional[tqdm] = None
        self._stop_event = threading.Event()
        self._thread: Optional[threading.Thread] = None
        self._start_time = 0.0

    def __enter__(self) -> "Spinner":
        self._start_time = time.monotonic()
        if self._redraw:
            self._line = tqdm(total=0, bar_format="{desc}", leave=True, file=self.stream)
            self._thread = threading.Thread(target=self._animate, daemon=True)
            self._thread.start()
        else:
            tqdm.write(colored(self.label + "...", "cyan", attrs=["bold"]), file=self.stream)
        return self

    def __exit__(
        self,
        exc_type: Optional[Type[BaseException]],
        exc_value: Optional[BaseException],
        traceback: Optional[TracebackType],
    ) -> None:
        elapsed = time.monotonic() - self._start_time
        failed = exc_type is not None
        final_line = self._render_final(elapsed, failed)
        if self._redraw:
            self._stop_event.set()
            assert self._thread is not None
            self._thread.join()
            assert self._line is not None
            self._line.set_description_str(final_line, refresh=True)
            self._line.close()
        else:
            tqdm.write(final_line, file=self.stream)

    def _render_final(self, elapsed: float, failed: bool) -> str:
        if failed:
            return colored(f"✗ {self.label} failed after {elapsed:.1f}s", "red", attrs=["bold"])
        return colored(f"✓ {self.label} ({elapsed:.1f}s)", "green")

    def _animate(self) -> None:
        assert self._line is not None
        frame_index = 0
        while not self._stop_event.is_set():
            frame = _SPINNER_FRAMES[frame_index % len(_SPINNER_FRAMES)]
            self._line.set_description_str(colored(f"{frame} {self.label}...", "cyan", attrs=["bold"]), refresh=True)
            frame_index += 1
            self._stop_event.wait(_SPINNER_INTERVAL_SECONDS)


def stage(name: str, index: Optional[int] = None, total: Optional[int] = None) -> Spinner:
    """Announce a step of work, showing an animated spinner for the duration of the
    surrounding `with` block. Use `index`/`total` for steps that are part of a known-length
    sequence, e.g. `with stage("Breaking cycles", 2, total=15):`.

    >>> with stage("Loading Hotspots"):
    ...     load_hotspots()
    """
    label = f"[{index}/{total}] {name}" if index is not None and total is not None else name
    return Spinner(label)


def progress(
    iterable: Optional[Iterable[T]] = None, total: Optional[int] = None, desc: str = "", **kwargs: Any
) -> tqdm:
    """Thin wrapper around `tqdm` fixing shared styling, so every progress bar in the
    codebase looks and behaves the same way. Use exactly like `tqdm(...)`."""
    kwargs.setdefault("dynamic_ncols", True)
    kwargs.setdefault("leave", False)
    return tqdm(iterable, total=total, desc=desc, **kwargs)


def success(msg: str) -> None:
    """Log a successful step outcome, consistently color-coded across the codebase."""
    logger.info(colored(f"✓ {msg}", "green"))


def warn(msg: str) -> None:
    """Log a warning, consistently color-coded across the codebase."""
    logger.warning(colored(f"⚠ {msg}", "yellow"))


def error(msg: str) -> None:
    """Log an error, consistently color-coded across the codebase."""
    logger.error(colored(f"✗ {msg}", "red", attrs=["bold"]))


def banner(title: str) -> None:
    """Print a consistently-framed section header for persistent, user-facing console
    output (e.g. end-of-run instructions or a suggestions overview), as opposed to
    `stage(...)`'s transient step narration."""
    line = colored("─" * max(20, len(title) + 4), "cyan")
    print(line)
    print(colored(f"  {title}", "cyan", attrs=["bold"]))
    print(line)
