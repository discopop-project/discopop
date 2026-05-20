# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import logging
import tkinter as tk
import tkinter.font
from tkinter import scrolledtext
from typing import Optional, Literal, Any


class TextAreaHandler(logging.Handler):
    """Custom logging handler that writes to a tkinter Text widget with color coding"""

    def __init__(self, text_area: scrolledtext.ScrolledText) -> None:
        super().__init__()
        self.text_area = text_area

    def emit(self, record: logging.LogRecord) -> None:
        try:
            msg = self.format(record)
            level_name = record.levelname

            self.text_area.config(state=tk.NORMAL)
            self.text_area.insert(tk.END, msg + "\n", level_name)
            self.text_area.see(tk.END)
            self.text_area.config(state="disabled")
        except Exception:
            self.handleError(record)


class Tooltip:
    def __init__(self, widget: tk.Widget, text: str) -> None:
        self.widget = widget
        self.text = text
        self.tipwindow: Optional[tk.Toplevel] = None
        self.id: Optional[str] = None
        self.x = self.y = 0

    def showtip(self, x: int, y: int) -> None:
        if self.tipwindow:
            return
        self.tipwindow = tw = tk.Toplevel(self.widget)
        tw.wm_overrideredirect(True)
        tw.wm_geometry(f"+{x}+{y}")
        label = tk.Label(
            tw,
            text=self.text,
            background="#ffffe0",
            relief=tk.SOLID,
            borderwidth=1,
            font=("Arial", 9),
            justify=tk.LEFT,
            wraplength=300,
            padx=8,
            pady=8,
        )
        label.pack()

    def hidetip(self) -> None:
        if self.tipwindow:
            self.tipwindow.destroy()
            self.tipwindow = None


def _adjust_dialog_size(dialog: tk.Toplevel, text: tk.Text, parent: Any) -> None:  # type: ignore
    """Adjust dialog size to fit text content and center it on the parent window."""
    font = text.cget("font")
    content = text.get("1.0", "end-1c")

    # Width: measure the longest raw line via font metrics (works regardless of widget visibility)
    longest_line = max(content.split("\n"), key=len) if content.strip() else ""
    text_pixel_width = tk.font.Font(font=font).measure(longest_line)  # type: ignore

    # Height: count content lines and measure line height from font metrics
    line_count = max(1, content.count("\n") + 1)
    font_obj = tk.font.Font(font=font)  # type: ignore
    px_per_line = font_obj.metrics("linespace")
    text_height = line_count * px_per_line

    padding_h = 60  # horizontal: 30px each side
    padding_v = 120  # vertical: title bar + button row + frame margins

    w = max(400, min(900, text_pixel_width + padding_h))
    h = max(200, min(600, text_height + padding_v))

    # Center on the parent window
    px = parent.winfo_rootx()
    py = parent.winfo_rooty()
    pw = parent.winfo_width()
    ph = parent.winfo_height()
    x = px + (pw - w) // 2
    y = py + (ph - h) // 2

    dialog.geometry(f"{int(w)}x{int(h)}+{int(x)}+{int(y)}")


def show_message(parent: Any, title: str, message: str) -> None:  # type: ignore
    """Display a message dialog with normal (non-bold) text."""
    dialog = tk.Toplevel(parent)  # type: ignore
    dialog.withdraw()
    dialog.title(title)
    dialog.geometry("600x250")
    dialog.minsize(500, 150)
    dialog.resizable(True, True)

    button_frame = tk.Frame(dialog, padx=15)
    button_frame.pack(side=tk.BOTTOM, fill=tk.X, pady=(10, 15))

    ok_button = tk.Button(button_frame, text="OK", command=dialog.destroy, width=10)
    ok_button.pack(side=tk.LEFT)

    main_frame = tk.Frame(dialog, padx=15, pady=15)
    main_frame.pack(fill=tk.BOTH, expand=True)

    text = tk.Text(main_frame, wrap=tk.WORD, height=1, width=60, font=("TkDefaultFont", 9))
    text.pack(fill=tk.BOTH, expand=True)
    text.insert(1.0, message)
    text.config(state=tk.DISABLED)

    _adjust_dialog_size(dialog, text, parent)

    dialog.transient(parent)  # type: ignore
    dialog.deiconify()
    dialog.grab_set()  # type: ignore
    dialog.wait_window()  # type: ignore


def show_warning(parent: Any, title: str, message: str) -> None:
    """Display a warning dialog with normal text."""
    show_message(parent, title, message)


def show_error(parent: Any, title: str, message: str) -> None:
    """Display an error dialog with normal text."""
    show_message(parent, title, message)


def ask_yes_no(parent: Any, title: str, message: str) -> bool:  # type: ignore
    """Display a yes/no confirmation dialog with normal text. Returns True for Yes, False for No."""
    dialog = tk.Toplevel(parent)  # type: ignore
    dialog.withdraw()
    dialog.title(title)
    dialog.geometry("600x250")
    dialog.minsize(500, 150)
    dialog.resizable(True, True)

    result: list[bool] = [False]

    button_frame = tk.Frame(dialog, padx=15)
    button_frame.pack(side=tk.BOTTOM, fill=tk.X, pady=(10, 15))

    def on_yes() -> None:
        result[0] = True
        dialog.destroy()

    def on_no() -> None:
        result[0] = False
        dialog.destroy()

    yes_button = tk.Button(button_frame, text="Yes", command=on_yes, width=10)
    yes_button.pack(side=tk.LEFT, padx=5)

    no_button = tk.Button(button_frame, text="No", command=on_no, width=10)
    no_button.pack(side=tk.LEFT, padx=5)

    main_frame = tk.Frame(dialog, padx=15, pady=15)
    main_frame.pack(fill=tk.BOTH, expand=True)

    text = tk.Text(main_frame, wrap=tk.WORD, height=1, width=60, font=("TkDefaultFont", 9))
    text.pack(fill=tk.BOTH, expand=True)
    text.insert(1.0, message)
    text.config(state=tk.DISABLED)

    _adjust_dialog_size(dialog, text, parent)

    dialog.transient(parent)  # type: ignore
    dialog.deiconify()
    dialog.grab_set()  # type: ignore
    dialog.wait_window()

    return result[0]
