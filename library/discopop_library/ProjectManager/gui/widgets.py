# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import tkinter as tk
from tkinter import scrolledtext, ttk

# Catppuccin Mocha theme colors
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


def create_styled_output_console(parent: tk.Misc) -> scrolledtext.ScrolledText:
    """Creates a Catppuccin Mocha-themed scrolled text widget for log output."""
    widget = scrolledtext.ScrolledText(
        parent,
        wrap=tk.WORD,
        state="disabled",
        bg=CATPPUCCIN_OUTPUT_BG,
        fg=CATPPUCCIN_FG,
        font=("Courier New", 11),
        insertbackground=CATPPUCCIN_FG,
        relief=tk.FLAT,
        bd=0,
    )
    widget.tag_config("DEBUG", foreground=CATPPUCCIN_BLUE)
    widget.tag_config("INFO", foreground=CATPPUCCIN_CYAN)
    widget.tag_config("WARNING", foreground=CATPPUCCIN_YELLOW)
    widget.tag_config("ERROR", foreground=CATPPUCCIN_RED)
    widget.tag_config("CRITICAL", foreground=CATPPUCCIN_RED, background=CATPPUCCIN_CRITICAL_BG)
    widget.tag_config("SUCCESS", foreground=CATPPUCCIN_GREEN)
    widget.tag_config("timestamp", foreground=CATPPUCCIN_PEACH)
    return widget
