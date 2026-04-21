# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import tkinter as tk
from typing import Any

class MultiFrame(tk.Frame):
    def __init__(self, parent : tk.Misc, *args : Any, **kwargs : Any) -> None:
        super().__init__(parent, *args, **kwargs)
        self._inner_frames: list[tk.Frame] = []

    def initialize(self, inner_frames : list[tk.Frame]) -> None:
        self._inner_frames = inner_frames

    def get_from_inner(self, index : int) -> tk.Frame:
        return self._inner_frames[index]