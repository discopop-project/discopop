# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import tkinter as tk
from typing import Any

from discopop_gui.Objects.Frames.Base import Base
from discopop_gui.ClassMaps.Frames import FramesMap

class MultiFrame(Base):
    def __init__(self, parent: tk.Misc, *args: Any, **kwargs: Any) -> None:
        super().__init__(parent, *args, **kwargs)
        self._inner_frames: list[Base] = []

    def initialize(self, inner_frames: list[Base]) -> None:
        self._inner_frames = inner_frames

    def get_from_inner(self, index: int) -> tk.Frame:
        return self._inner_frames[index]

    def serialize(self) -> dict:
        return {
            "inner_frames" : [{"type" : FramesMap[frame.__class__.__name__].value, "data" : frame.serialize()} for frame in self._inner_frames]
        }
