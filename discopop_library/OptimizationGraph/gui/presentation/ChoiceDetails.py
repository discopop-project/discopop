from typing import Optional

import networkx as nx  # type: ignore

from discopop_library.OptimizationGraph.CostModels.CostModel import CostModel

from tkinter import *

from discopop_library.OptimizationGraph.gui.widgets.ScrollableFrame import ScrollableFrameWidget
from discopop_library.OptimizationGraph.utilities.MOGUtilities import data_at
from discopop_wizard.screens.widgets.ScrollableText import ScrollableTextWidget


def display_choices_for_model(graph: nx.DiGraph, model: CostModel, window_title: Optional[str] = None):
    root = Tk()
    if window_title is not None:
        root.configure()
        root.title(window_title)
    # configure window size
    root.geometry("1000x600")
    # configure weights
    root.rowconfigure(0, weight=1)
    root.columnconfigure(0, weight=1)

    # create scrollable frame
    scrollable_frame_widget = ScrollableFrameWidget(root)
    scrollable_frame = scrollable_frame_widget.get_scrollable_frame()

    rows = []

    column_headers = ["Decision", "Details"]
    # set column headers
    header_cols = []
    for col_idx, header in enumerate(column_headers):
        e = Entry(scrollable_frame, relief=RIDGE)
        e.grid(row=0, column=col_idx, sticky=NSEW)
        e.insert(END, header)
        e.configure(state=DISABLED, disabledforeground="black")
        header_cols.append(e)
    rows.append(header_cols)

    for row_idx, decision in enumerate(model.path_decisions):
        row_idx = row_idx + 1  # account for header row
        # add decision id
        e = Entry(scrollable_frame, relief=RIDGE)
        e.grid(row=row_idx, column=0, sticky=NSEW)
        e.insert(END, str(decision))
        e.configure(state=DISABLED, disabledforeground="black")

        # add decision details
        d = Frame(scrollable_frame)
        d.grid(row=row_idx, column=1, sticky=NSEW)
        #d = Text(root, relief=RIDGE)
        #d.grid(row=row_idx, column=1, sticky=NSEW)
        #d.insert(END, str(data_at(graph, decision).suggestion))
        #d.config(state=DISABLED)
        stw = ScrollableTextWidget(d)
        stw.set_text(str(data_at(graph, decision).suggestion))
        stw.text_container.config(height=10)

    scrollable_frame_widget.finalize(len(model.path_decisions))



    pass


