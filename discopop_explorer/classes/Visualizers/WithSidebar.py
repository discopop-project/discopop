# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import tkinter as tk
from tkinter import ttk
from typing import Dict


class WithSidebar:
    def __init__(self) -> None:
        self._root = tk.Tk()
        self._root.title("Discopop explorer")

        # Root layout: sidebar | content
        self._root.grid_rowconfigure(0, weight=1)
        self._root.grid_columnconfigure(0, weight=0)
        self._root.grid_columnconfigure(1, weight=1)

        # Sidebar
        self._sidebar_container = ttk.Frame(self._root)
        self._sidebar_container.grid(row=0, column=0, sticky="ns")

        self._sidebar_canvas = tk.Canvas(self._sidebar_container, highlightthickness=0, width=220)

        self._sidebar_scrollbar = ttk.Scrollbar(
            self._sidebar_container,
            orient="vertical",
            command=self._sidebar_canvas.yview
        )

        self._sidebar = ttk.Frame(self._sidebar_canvas)

        self._sidebar_window = self._sidebar_canvas.create_window(
            (0, 0),
            window=self._sidebar,
            anchor="nw"
        )

        self._sidebar_canvas.configure(yscrollcommand=self._sidebar_scrollbar.set)

        self._sidebar_canvas.grid(row=0, column=0, sticky="ns")
        self._sidebar_scrollbar.grid(row=0, column=1, sticky="ns")

        self._sidebar_container.grid_rowconfigure(0, weight=1)
        self._sidebar_container.grid_columnconfigure(0, weight=1)

        self._sidebar.bind("<Configure>", self._on_sidebar_configure)
        self._sidebar_canvas.bind("<Configure>", self._on_canvas_configure)

        # Frame
        self._frame_container = ttk.Frame(self._root)
        self._frame_container.grid(row=0, column=1, sticky="nsew")

        self._frame_container.grid_rowconfigure(0, weight=1)
        self._frame_container.grid_columnconfigure(0, weight=1)

        self._frames: Dict[str, ttk.Frame] = {}
        self._frame_selectors: Dict[str, ttk.Button] = {}
        self._current_frame_name: str | None = None

    def _on_sidebar_configure(self, _: tk.Event) -> None:
        self._sidebar_canvas.configure(scrollregion=self._sidebar_canvas.bbox("all"))

    def _on_canvas_configure(self, event: tk.Event) -> None:
        self._sidebar_canvas.itemconfigure(self._sidebar_window, width=event.width)

    def _rebuild_selector_layout(self) -> None:
        for row_index, frame_name in enumerate(self._frame_selectors):
            self._frame_selectors[frame_name].grid_configure(row=row_index)

    def create_frame(self, name: str) -> ttk.Frame:
        if name in self._frames:
            raise ValueError(f"Frame '{name}' already exists.")

        frame = ttk.Frame(self._frame_container)
        self._frames[name] = frame
        frame.grid(row=0, column=0, sticky="nsew")

        frame_selector = ttk.Button(
            self._sidebar,
            text=name,
            command=lambda frame_name=name: self.show_frame(frame_name)
        )

        self._frame_selectors[name] = frame_selector

        frame_selector.grid(
            row=len(self._frame_selectors) - 1,
            column=0,
            sticky="ew",
            padx=5,
            pady=2
        )

        self._sidebar.grid_columnconfigure(0, weight=1)

        if self._current_frame_name is None:
            self.show_frame(name)

        return frame

    def get_frame(self, name: str) -> ttk.Frame:
        try:
            return self._frames[name]
        except KeyError as e:
            raise KeyError(f"No frame named '{name}'.") from e

    def get_frame_selector(self, name: str) -> ttk.Button:
        try:
            return self._frame_selectors[name]
        except KeyError as e:
            raise KeyError(f"No selector button for frame '{name}'.") from e

    def show_frame(self, name: str) -> None:
        frame = self.get_frame(name)
        frame.tkraise()
        self._current_frame_name = name

    def delete_frame(self, name: str) -> None:
        frame = self.get_frame(name)
        selector = self.get_frame_selector(name)

        frame.destroy()
        selector.destroy()

        del self._frames[name]
        del self._frame_selectors[name]

        self._rebuild_selector_layout()

        if self._current_frame_name == name:
            self._current_frame_name = None

            if self._frames:
                first_name = next(iter(self._frames))
                self.show_frame(first_name)

    def run(self) -> None:
        self._root.mainloop()