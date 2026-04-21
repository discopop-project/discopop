# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

from abc import abstractmethod, ABC
import tkinter as tk
from typing import Dict, Type, Callable
from GUI.Types.FrameT import FrameT

class Base(ABC):
    def __init__(self) -> None:
        self._root = tk.Tk()
        self._root.title("DiscoPoP")
        self._root.protocol("WM_DELETE_WINDOW", self._on_close)

        self._frames: Dict[str, tk.Frame] = {}
        self._current_frame_name: str | None = None

    def _on_close(self) -> None:
        self._root.quit()
        self._root.destroy()

    @abstractmethod
    def create_frame(self, name: str,  frame_type: Type[FrameT]) -> FrameT:
        pass

    def get_frame(self, name: str) -> tk.Frame:
        try:
            return self._frames[name]
        except KeyError as e:
            raise KeyError(f"No frame named '{name}'.") from e

    def show_frame(self, name: str) -> None:
        frame = self.get_frame(name)

        if (frame == None):
            raise KeyError(f"No frame named '{name}'.")
        
        frame.tkraise()        
        self._current_frame_name = name

    def delete_frame(self, name: str) -> None:
        frame = self.get_frame(name)

        if (frame == None):
            raise KeyError(f"No frame named '{name}'.")
        
        frame.destroy()

        del self._frames[name]

        if self._current_frame_name == name:
            self._current_frame_name = None

            if self._frames:
                first_name = next(iter(self._frames))
                self.show_frame(first_name)

    @abstractmethod
    def set_filter_callback(self, callback: Callable[[str], None]) -> None:
        pass


    @abstractmethod
    def set_filter_text(self, text: str) -> None:
        pass

    def run(self) -> None:
        self._root.mainloop()