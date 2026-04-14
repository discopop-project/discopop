# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

from typing import Callable
import tkinter as tk
from matplotlib.axes import Axes
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg, NavigationToolbar2Tk  # type: ignore
from matplotlib.figure import Figure
from GUI.Visualizers.Base import Base
from GUI.Objects.Frames.MultiFrame import MultiFrame

class Plottable():
    def __init__(self, visualizer: Base | None = None) -> None:
        self._visualizer = visualizer

    def create_frame(self, name: str) -> tk.Frame:
        if self._visualizer == None:
            raise ValueError("Visualizer not initialized.")
        
        return self._visualizer.create_frame(name)

    def create_multi_frame(self, name: str, rows: int, columns: int) -> MultiFrame:
        if self._visualizer is None:
            raise ValueError("Visualizer not initialized.")

        if rows < 1 or columns < 1:
            raise ValueError("Rows and columns must be >= 1")

        frame: MultiFrame = self._visualizer.create_frame(name, MultiFrame)

        for row in range(rows):
            frame.grid_rowconfigure(row, weight=1)

        for column in range(columns):
            frame.grid_columnconfigure(column, weight=1)

        inner_frames = []

        for i in range(rows * columns):
            row = i // columns
            column = i % columns

            inner_frame = tk.Frame(frame, borderwidth=1, relief="solid")
            inner_frame.grid(row=row, column=column, sticky="nsew", padx=5, pady=5)
            inner_frames.append(inner_frame)

        frame.initialize(inner_frames)
        return frame

    def get_from_multi_frame(self, name: str, index: int) -> tk.Frame:
        if self._visualizer == None:
            raise ValueError("Visualizer not initialized.")
        
        frame = self._visualizer.get_frame(name)
        
        if isinstance(frame, MultiFrame):
            return frame.get_from_inner(index)
        else:
            raise KeyError(f"No multi frame named '{name}'.")
        
    def set_filter_callback(self, callback: Callable[[str], None]) -> None:
        if self._visualizer == None:
            raise ValueError("Visualizer not initialized.")
        
        self._visualizer.set_filter_callback(callback)

    def delete_frame(self, name: str) -> None:
        if self._visualizer == None:
            raise ValueError("Visualizer not initialized.")
        
        self._visualizer.delete_frame(name)
        
    def create_plot(self, name: str) -> Axes:
        if self._visualizer == None:
            raise ValueError("Visualizer not initialized.")
        
        frame = self._visualizer.create_frame(name)
        figure = Figure()
        axes = figure.add_subplot(111)
        axes.set_title("Task graph")
        canvas = FigureCanvasTkAgg(figure, master=frame)
        canvas.draw()
        canvas.get_tk_widget().grid(row=0, sticky="nsew")
        toolbar = NavigationToolbar2Tk(canvas, pack_toolbar=False)
        toolbar.update()
        toolbar.grid(row=1)
        frame.grid_rowconfigure(0, weight=1)
        frame.grid_columnconfigure(0, weight=1)

        return axes
    
    def create_multi_plot(self, name: str, inner_plot_titles: list[str], rows: int, columns: int) -> list[Axes]:
        self.create_multi_frame(name, rows, columns)
        axeses = []

        for index in range(rows * columns):
            frame = self.get_from_multi_frame(name, index)
            figure = Figure()
            axes = figure.add_subplot(111)
            axes.set_title(inner_plot_titles[index])
            canvas = FigureCanvasTkAgg(figure, master=frame)
            canvas.draw()
            canvas.get_tk_widget().grid(row=0, sticky="nsew")
            toolbar = NavigationToolbar2Tk(canvas, pack_toolbar=False)
            toolbar.update()
            toolbar.grid(row=1)
            frame.grid_rowconfigure(0, weight=1)
            frame.grid_columnconfigure(0, weight=1)
            axeses.append(axes)
        
        return axeses

    def run_visualizer(self):
        if self._visualizer != None:
            self._visualizer.run()