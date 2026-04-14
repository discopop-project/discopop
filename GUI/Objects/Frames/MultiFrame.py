import tkinter as tk

class MultiFrame(tk.Frame):
    def __init__(self, parent, *args, **kwargs):
        super().__init__(parent, *args, **kwargs)
        self._inner_frames : list[tk.Frame] = []

    def initialize(self, inner_frames : list[tk.Frame]):
        self._inner_frames = inner_frames

    def get_from_inner(self, index: int) -> tk.Frame:
        return self._inner_frames[index]