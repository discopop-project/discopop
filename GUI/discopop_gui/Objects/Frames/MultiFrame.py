# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import tkinter as tk
from typing import Any, Callable, Dict

from discopop_gui.Types.FrameT import FrameT
from discopop_gui.Enums.FrameType import FrameType
from discopop_gui.ClassMaps.Frames import FramesMap
from discopop_gui.Objects.Frames.Base import Base
from discopop_gui.Objects.Frames.CanvasViewer import CanvasViewer

class MultiFrame(Base):
    def __init__(self, parent: tk.Misc, *args: Any, **kwargs: Any) -> None:
        super().__init__(parent, *args, **kwargs)
        self._inner_frames: list[Base] = []

    def initialize(self, inner_frames: list[Base]) -> None:
        self._inner_frames = inner_frames

    def get_from_inner(self, index: int) -> tk.Frame:
        return self._inner_frames[index]

    def create_frame(self, row: int, column: int, frame_builder: Callable[[tk.Misc], FrameT]) -> FrameT:
        frame = frame_builder(self)
        frame.grid(row = row, column = column, sticky="nsew")
        self._inner_frames.append(frame)
        return frame

    def serialize(self) -> Dict[str, Any]:
        return {
            "inner_frames" : [{
                "type" : FramesMap[frame.__class__.__name__].value,
                "row" : frame.grid_info()["row"],
                "column" : frame.grid_info()["column"],
                "data" : frame.serialize()
            } for frame in self._inner_frames]
        }

    def deserialize(self, data: Dict[str, Any]) -> None:
        self._inner_frames = []

        for frame_data in data["inner_frames"]:
            frame = None

            match FrameType(frame_data["type"]):
                case FrameType.CANVAS_VIEWER:
                    frame = self.create_frame(
                        int(frame_data["row"]),
                        int(frame_data["column"]),
                        lambda parent: CanvasViewer(parent)
                    )

                case FrameType.MULTI_FRAME:
                    frame = self.create_frame(
                        int(frame_data["row"]),
                        int(frame_data["column"]),
                        lambda parent: MultiFrame(parent)
                    )

                case _:
                    frame = self.create_frame(
                        int(frame_data["row"]),
                        int(frame_data["column"]),
                        lambda parent: Base(parent)
                    )

            frame.deserialize(frame_data["data"])
