import tkinter as tk 
from GUI.Visualizers.Base import Base
from GUI.Objects.Frames.MultiFrame import MultiFrame

class Plottable():
    def __init__(self, visualizer: Base | None = None) -> None:
        self._visualizer = visualizer

    def create_plot(self, name: str) -> tk.Frame:
        if self._visualizer == None:
            raise ValueError("Visualizer not initialized.")
        
        return self._visualizer.create_frame(name)

    def create_multi_plot(self, name: str, rows: int, columns: int) -> MultiFrame:
        if self._visualizer is None:
            raise ValueError("Visualizer not initialized.")

        if rows < 1 or columns < 1:
            raise ValueError("Rows and columns must be >= 1")

        frame: MultiFrame = self._visualizer.create_frame(name, MultiFrame)

        for r in range(rows):
            frame.grid_rowconfigure(r, weight=1)

        for c in range(columns):
            frame.grid_columnconfigure(c, weight=1)

        inner_frames = []

        for i in range(rows * columns):
            row = i // columns
            column = i % columns

            inner = tk.Frame(frame, borderwidth=1, relief="solid")
            inner.grid(row=row, column=column, sticky="nsew", padx=5, pady=5)
            inner_frames.append(inner)

        frame.initialize(inner_frames)
        return frame

    def get_from_multi_plot(self, name: str, index: int) -> tk.Frame:
        if self._visualizer == None:
            raise ValueError("Visualizer not initialized.")
        
        frame = self._visualizer.get_frame(name)
        
        if isinstance(frame, MultiFrame):
            return frame.get_from_inner(index)
        else:
            raise KeyError(f"No multi frame named '{name}'.")

    def run_visualizer(self):
        if self._visualizer != None:
            self._visualizer.run()