# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import tkinter as tk
from typing import Any, Generic, Callable

from discopop_gui.Types.ViewableCanvasT import ViewableCanvasT
from discopop_gui.Objects.Canvases.Viewables.WithTrees import WithTrees as ViewableCanvasWithTrees
from discopop_gui.Objects.Canvases.RoundedSquareButtons.Mouse import Mouse as MouseButton
from discopop_gui.Objects.Canvases.RoundedSquareButtons.Magnifier import Magnifier as MagnifierButton
from discopop_gui.Enums.ViewerMode import ViewerMode

class CanvasViewer(tk.Frame, Generic[ViewableCanvasT]):
    def __init__(self, parent: tk.Misc, canvas_builder: Callable[["CanvasViewer", ViewerMode], ViewableCanvasT], *args: Any, **kwargs: Any) -> None:
        super().__init__(parent, *args, **kwargs)

        self._selected_option: ViewerMode = ViewerMode.MAIN

        self._canvas = canvas_builder(self, self._selected_option)
        self._toolbar = tk.Frame(self)

        self._main = MouseButton(self._toolbar, command = self.select_main)
        self._magnifier = MagnifierButton(self._toolbar, command = self.select_magnifier)

        self._canvas.grid(row=0, column=0, sticky="nsew")
        self._toolbar.grid(row=1, column=0, sticky="ew")

        self._main.grid(row=0, column=0, padx=4, pady=4)
        self._magnifier.grid(row=0, column=1, padx=4, pady=4)

        self.grid_rowconfigure(0, weight=1)
        self.grid_columnconfigure(0, weight=1)

        self._update_toolbar()

    def _update_toolbar(self) -> None:
        self._main.set_selected(self._selected_option == ViewerMode.MAIN)
        self._magnifier.set_selected(self._selected_option == ViewerMode.ZOOM)

    def select_main(self) -> None:
        self._selected_option = ViewerMode.MAIN
        self._canvas.set_viewer_mode(self._selected_option)
        self._update_toolbar()

    def select_magnifier(self) -> None:
        self._selected_option = ViewerMode.ZOOM
        self._canvas.set_viewer_mode(self._selected_option)
        self._update_toolbar()

    def getCanvas(self) -> ViewableCanvasT:
        return self._canvas