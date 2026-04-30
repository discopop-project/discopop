# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import tkinter as tk
from typing import Any

from GUI.Objects.Canvases.Viewable import Viewable
from GUI.Objects.Canvases.RoundedSquareButtons.Magnifier import Magnifier
from GUI.Objects.Canvases.RoundedSquareButtons.Panner import Panner
from GUI.Enums.ViewerMode import ViewerMode



class CanvasViewer(tk.Frame):
    def __init__(self, parent: tk.Misc, *args: Any, **kwargs: Any) -> None:
        super().__init__(parent, *args, **kwargs)

        self._selected_option: ViewerMode = ViewerMode.PAN

        self._canvas = Viewable(self, self._selected_option, bg="white")
        self._toolbar = tk.Frame(self)

        self._panner = Panner(self._toolbar, command = self.select_pan)
        self._magnifier = Magnifier(self._toolbar, command = self.select_magnifier)

        self._canvas.grid(row=0, column=0, sticky="nsew")
        self._toolbar.grid(row=1, column=0, sticky="ew")

        self._panner.grid(row=0, column=0, padx=4, pady=4)
        self._magnifier.grid(row=0, column=1, padx=4, pady=4)

        self.grid_rowconfigure(0, weight=1)
        self.grid_columnconfigure(0, weight=1)

        self._update_toolbar()

    def _update_toolbar(self) -> None:
        self._panner.set_selected(self._selected_option == ViewerMode.PAN)
        self._magnifier.set_selected(self._selected_option == ViewerMode.ZOOM)

    def select_pan(self) -> None:
        self._selected_option = ViewerMode.PAN
        self._canvas.set_viewer_mode(self._selected_option)
        self._update_toolbar()

    def select_magnifier(self) -> None:
        self._selected_option = ViewerMode.ZOOM
        self._canvas.set_viewer_mode(self._selected_option)
        self._update_toolbar()

    def getCanvas(self) -> tk.Canvas:
        return self._canvas