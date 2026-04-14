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

    def create_multi_plot(self, name: str, rows: int, columns: int) -> None:
        if self._visualizer == None:
            raise ValueError("Visualizer not initialized.")
        
        self._visualizer.create_multi_frame(name, rows, columns)

    def get_from_multi_plot(self, name: str, index: int) -> tk.Frame:
        if self._visualizer == None:
            raise ValueError("Visualizer not initialized.")
        
        frame = self._visualizer.get_frame(name)
        
        if isinstance(frame, MultiFrame):
            return frame.inner_frames[index]
        else:
            raise KeyError(f"No multi frame named '{name}'.")

    def run_visualizer(self):
        if self._visualizer != None:
            self._visualizer.run()