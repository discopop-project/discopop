import tkinter as tk

class MultiFrame(tk.Frame):
    def __init__(self, parent, *args, **kwargs):
        super().__init__(parent, *args, **kwargs)
        self._inner_frames : list[tk.Frame] = []

    def initialize_inner_frames(self, inner_frames : list[tk.Frame]):
        self._inner_frames = inner_frames

    @property
    def inner_frames(self) -> list[tk.Frame]:
        return self._inner_frames