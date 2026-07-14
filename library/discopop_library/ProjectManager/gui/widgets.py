# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

"""Central component library and theme configuration for the ProjectManager GUI.

This module is the single place to configure the appearance of shared GUI
components. Rather than re-declaring buttons, labels, text areas and colors
wherever they are needed (which caused the same semantic component to look
different in different tabs), call sites use the factories and tokens defined
here, and the named ttk styles registered in
``ConfigManagerApp._setup_styles``.
"""

import tkinter as tk
from tkinter import scrolledtext, ttk
from typing import Any, Literal, Optional

_Wrap = Literal["none", "char", "word"]

# ---------------------------------------------------------------------------
# Color palette
# ---------------------------------------------------------------------------
# Catppuccin Mocha theme colors - used for the dark, monospaced output/code
# surfaces (log consoles, patch/code viewers). The rest of the app uses the
# light ttk theme, so the status/label colors below are chosen to be readable
# on a light background rather than reusing this (dark-oriented) palette.
CATPPUCCIN_BG = "#1e1e2e"
CATPPUCCIN_OUTPUT_BG = "#45475a"
CATPPUCCIN_FG = "#cdd6f4"
CATPPUCCIN_BLUE = "#89b4fa"
CATPPUCCIN_CYAN = "#89dceb"
CATPPUCCIN_GREEN = "#a6e3a1"
CATPPUCCIN_YELLOW = "#f9e2af"
CATPPUCCIN_PEACH = "#fab387"
CATPPUCCIN_RED = "#f38ba8"
CATPPUCCIN_CRITICAL_BG = "#3b3052"

# Semantic aliases for the dark console/code surfaces.
CONSOLE_BG = CATPPUCCIN_OUTPUT_BG
CONSOLE_FG = CATPPUCCIN_FG

# Status colors (readable on the light ttk theme). One color per state, so the
# status bar no longer mixes "#FF6B6B", named "red"/"green"/"orange" and the
# Catppuccin palette for the same handful of states.
STATUS_IDLE = "gray"  # Ready / neutral
STATUS_BUSY = "#1e66f5"  # in progress / working
STATUS_OK = "#2e7d32"  # success
STATUS_FAIL = "#c62828"  # failure / error
STATUS_STOP = "#e65100"  # stopping / interrupted

# Accent colors used by the suggestion browser.
LINK_FG = "#6699cc"  # clickable file/patch name
APPLIED_FG = "#5ca668"  # "applied" success marker

# Grayed-out placeholder text inside editors.
PLACEHOLDER_FG = "#999999"

# Listbox selection (config list).
LISTBOX_SELECT_BG = "#4A90E2"
LISTBOX_SELECT_FG = "white"

# Report Treeview colors.
TREE_BG = "#ffffff"
TREE_HEADING_BG = "#e0e0e0"
TREE_BORDER = "#e0e0e0"
TREE_EVEN_ROW = "#d9e8f5"
TREE_ODD_ROW = "#ffffff"

# ---------------------------------------------------------------------------
# Fonts (semantic tokens)
# ---------------------------------------------------------------------------
# A single family for the proportional UI text, so headings/body/captions no
# longer mix "Arial" and "TkDefaultFont" for the same role.
FONT_FAMILY = "TkDefaultFont"
FONT_TITLE = (FONT_FAMILY, 12, "bold")  # top-level panel titles
FONT_HEADING = (FONT_FAMILY, 11, "bold")  # section headers
FONT_BODY = (FONT_FAMILY, 11)  # body / dialog / hint text
FONT_CAPTION = (FONT_FAMILY, 9)  # small parenthetical captions
FONT_MONO = ("Courier New", 11)  # console / code surfaces

# ---------------------------------------------------------------------------
# Dropdown value lists (shared, so the same selector offers the same options)
# ---------------------------------------------------------------------------
THREAD_VALUES = ["auto", "1", "2", "4", "8", "16"]
LOG_LEVEL_VALUES = ["DEBUG", "INFO", "WARNING", "ERROR", "CRITICAL"]

# Named ttk button styles registered in ConfigManagerApp._setup_styles.
STYLE_PRIMARY_BUTTON = "Primary.TButton"
STYLE_DANGER_BUTTON = "Danger.TButton"
STYLE_ICON_BUTTON = "Icon.TButton"
STYLE_SUCCESS_BUTTON = "Success.TButton"


def _apply_log_level_tags(widget: "scrolledtext.ScrolledText | tk.Text") -> None:
    """Configure the shared log-level color tags on a console/text widget."""
    widget.tag_config("DEBUG", foreground=CATPPUCCIN_BLUE)
    widget.tag_config("INFO", foreground=CATPPUCCIN_CYAN)
    widget.tag_config("WARNING", foreground=CATPPUCCIN_YELLOW)
    widget.tag_config("ERROR", foreground=CATPPUCCIN_RED)
    widget.tag_config("CRITICAL", foreground=CATPPUCCIN_RED, background=CATPPUCCIN_CRITICAL_BG)
    widget.tag_config("SUCCESS", foreground=CATPPUCCIN_GREEN)
    widget.tag_config("timestamp", foreground=CATPPUCCIN_PEACH)


def create_styled_output_console(
    parent: tk.Misc, *, wrap: _Wrap = "word", editable: bool = False
) -> scrolledtext.ScrolledText:
    """Create a Catppuccin Mocha-themed scrolled text widget for log/output.

    Used for every log console and read-only text output surface so they share
    one look. Pass ``editable=True`` for a writable variant.
    """
    widget = scrolledtext.ScrolledText(
        parent,
        wrap=wrap,
        state="normal" if editable else "disabled",
        bg=CONSOLE_BG,
        fg=CONSOLE_FG,
        font=FONT_MONO,
        insertbackground=CONSOLE_FG,
        relief=tk.FLAT,
        bd=0,
    )
    _apply_log_level_tags(widget)
    return widget


def create_code_view(parent: tk.Misc, *, wrap: _Wrap = "none") -> tk.Text:
    """Create a read-only, dark-themed code/patch viewer with x/y scrollbars.

    Matches the console look and adds unified diff highlight tags
    (``diff_add`` / ``diff_remove`` / ``diff_header`` / ``diff_hunk``).
    Scrollbars and the text widget are packed directly into ``parent``.
    """
    text = tk.Text(
        parent,
        wrap=wrap,
        font=FONT_MONO,
        bg=CONSOLE_BG,
        fg=CONSOLE_FG,
        insertbackground=CONSOLE_FG,
        relief=tk.FLAT,
        bd=0,
        state=tk.DISABLED,
    )
    y_scroll = ttk.Scrollbar(parent, orient=tk.VERTICAL, command=text.yview)
    x_scroll = ttk.Scrollbar(parent, orient=tk.HORIZONTAL, command=text.xview)
    text.configure(yscrollcommand=y_scroll.set, xscrollcommand=x_scroll.set)
    y_scroll.pack(side=tk.RIGHT, fill=tk.Y)
    x_scroll.pack(side=tk.BOTTOM, fill=tk.X)
    text.pack(fill=tk.BOTH, expand=True)

    text.tag_config("diff_add", foreground=CATPPUCCIN_GREEN)
    text.tag_config("diff_remove", foreground=CATPPUCCIN_RED)
    text.tag_config("diff_header", foreground=CATPPUCCIN_BLUE)
    text.tag_config("diff_hunk", foreground=CATPPUCCIN_YELLOW)
    return text


def create_script_editor(
    parent: tk.Misc,
    *,
    height: Optional[int] = None,
    width: Optional[int] = None,
    yscrollcommand: Optional[Any] = None,
) -> tk.Text:
    """Create an editable script/settings editor with the shared editor style.

    Unifies the ``wrap=WORD``/``FONT_BODY`` style that was copy-pasted across
    the execute.sh / compile.sh / settings editors. Scrollbar wiring and
    geometry management are left to the caller (they differ per call site).
    """
    kwargs: dict[str, Any] = {"wrap": tk.WORD, "font": FONT_BODY}
    if height is not None:
        kwargs["height"] = height
    if width is not None:
        kwargs["width"] = width
    if yscrollcommand is not None:
        kwargs["yscrollcommand"] = yscrollcommand
    return tk.Text(parent, **kwargs)


def heading_label(parent: tk.Misc, text: str, *, title: bool = False, **kwargs: Any) -> ttk.Label:
    """A bold section header (``title=True`` for the slightly larger panel title)."""
    kwargs.setdefault("font", FONT_TITLE if title else FONT_HEADING)
    return ttk.Label(parent, text=text, **kwargs)


def caption_label(parent: tk.Misc, text: str, **kwargs: Any) -> ttk.Label:
    """A small, gray parenthetical caption/hint label."""
    kwargs.setdefault("font", FONT_CAPTION)
    kwargs.setdefault("foreground", STATUS_IDLE)
    return ttk.Label(parent, text=text, **kwargs)


def error_label(parent: tk.Misc, text: str, **kwargs: Any) -> ttk.Label:
    """A red error/warning label."""
    kwargs.setdefault("font", FONT_BODY)
    kwargs.setdefault("foreground", STATUS_FAIL)
    return ttk.Label(parent, text=text, **kwargs)


def primary_button(parent: tk.Misc, text: str, command: Any = None, **kwargs: Any) -> ttk.Button:
    """An emphasized primary-action button (Run / Execute / Apply / Generate)."""
    return ttk.Button(parent, text=text, command=command, style=STYLE_PRIMARY_BUTTON, **kwargs)


def danger_button(parent: tk.Misc, text: str, command: Any = None, **kwargs: Any) -> ttk.Button:
    """A destructive-action button (Reset / Delete), visually distinct (red)."""
    return ttk.Button(parent, text=text, command=command, style=STYLE_DANGER_BUTTON, **kwargs)


def icon_button(parent: tk.Misc, text: str, command: Any = None, *, width: int = 2, **kwargs: Any) -> ttk.Button:
    """A small, flat icon/toolbar button (expand toggles, row checkboxes)."""
    return ttk.Button(parent, text=text, command=command, width=width, style=STYLE_ICON_BUTTON, **kwargs)
