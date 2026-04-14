# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import tkinter as tk
from typing import Dict, Type
from GUI.Visualizers.Base import Base
from GUI.Objects.Frames.MultiFrame import MultiFrame
from GUI.Types.FrameT import FrameT

class WithSidebar(Base):
    def __init__(self) -> None:
        super().__init__()

        self._root.grid_rowconfigure(0, weight=1)
        self._root.grid_columnconfigure(0, weight=1)

        # Draggable split: sidebar | content
        self._paned = tk.PanedWindow(self._root, orient=tk.HORIZONTAL, sashrelief=tk.RAISED, opaqueresize=False, bg="black")
        self._paned.grid(row=0, column=0, sticky="nsew")

        # Sidebar
        self._sidebar_container = tk.Frame(self._paned)
        self._sidebar_container.grid_rowconfigure(0, weight=1)
        self._sidebar_container.grid_columnconfigure(0, weight=1)

        self._sidebar_canvas = tk.Canvas(
            self._sidebar_container,
            highlightthickness=0,
            width=220
        )

        self._sidebar_scrollbar = tk.Scrollbar(
            self._sidebar_container,
            orient="vertical",
            command=self._sidebar_canvas.yview
        )

        self._sidebar_canvas.grid(row=0, column=0, sticky="nsew")
        self._sidebar_scrollbar.grid(row=0, column=1, sticky="ns")

        self._sidebar = tk.Frame(self._sidebar_canvas)
        self._sidebar.grid_columnconfigure(0, weight=1)

        self._sidebar_window = self._sidebar_canvas.create_window(
            (0, 0),
            window=self._sidebar,
            anchor="nw"
        )

        self._sidebar_canvas.configure(yscrollcommand=self._sidebar_scrollbar.set)

        self._sidebar.bind("<Configure>", self._on_sidebar_configure)
        self._sidebar_canvas.bind("<Configure>", self._on_canvas_configure)

        # Content area
        self._frame_container = tk.Frame(self._paned)
        self._frame_container.grid_rowconfigure(0, weight=1)
        self._frame_container.grid_columnconfigure(0, weight=1)

        # Add both panes to the PanedWindow
        self._paned.add(self._sidebar_container, minsize=150, width=220)
        self._paned.add(self._frame_container, minsize=300)

        self._frame_selectors: Dict[str, tk.Button] = {}

    def _on_sidebar_configure(self, _: tk.Event) -> None:
        self._sidebar_canvas.configure(scrollregion=self._sidebar_canvas.bbox("all"))

    def _on_canvas_configure(self, event: tk.Event) -> None:
        self._sidebar_canvas.itemconfigure(self._sidebar_window, width=event.width)

    def _rebuild_selector_layout(self) -> None:
        for row_index, frame_name in enumerate(self._frame_selectors):
            self._frame_selectors[frame_name].grid_configure(row=row_index)

    def create_frame(self, name: str, frame_type: Type[FrameT] = tk.Frame) -> FrameT:
        if name in self._frames:
            raise ValueError(f"Frame '{name}' already exists.")

        frame = frame_type(self._frame_container)
        self._frames[name] = frame
        frame.grid(row=0, column=0, sticky="nsew")

        frame_selector = tk.Button(
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

        if self._current_frame_name is None:
            self.show_frame(name)
        else:
            self.show_frame(self._current_frame_name)

        return frame

    def get_frame_selector(self, name: str) -> tk.Button:
        try:
            return self._frame_selectors[name]
        except KeyError as e:
            raise KeyError(f"No selector button for frame '{name}'.") from e

    def delete_frame(self, name: str) -> None:
        super().delete_frame(name)
        
        selector = self.get_frame_selector(name)

        selector.destroy()
        del self._frame_selectors[name]

        self._rebuild_selector_layout()