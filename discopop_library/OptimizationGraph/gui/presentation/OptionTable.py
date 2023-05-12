from typing import List, Tuple, Dict

from sympy import Symbol

from discopop_library.OptimizationGraph.CostModels.CostModel import CostModel
from tkinter import *

from discopop_library.OptimizationGraph.gui.plotting.CostModels import plot_CostModels


def show_options(options: List[Tuple[CostModel, str]], sorted_free_symbols: List[Symbol],
    free_symbol_ranges: Dict[Symbol, Tuple[float, float]], window_title=None):
    """Shows a tkinter table to browse and plot models"""
    root = Tk()
    if window_title is not None:
        root.configure()
        root.title(window_title)

    rows = []
    column_headers = ["Label", "Decisions", "Options"]
    # set column headers
    header_cols = []
    for col_idx, header in enumerate(column_headers):
        e = Entry(root, relief=RIDGE)
        e.grid(row=0, column=col_idx, sticky=NSEW)
        e.insert(END, header)
        e.configure(state=DISABLED, disabledforeground="black")
        header_cols.append(e)
    rows.append(header_cols)

    # create option entries
    for row_idx, option_tuple in enumerate(options):
        option, option_name = option_tuple
        row_idx = row_idx + 1  # to account for column headers
        cols = []
        label = Entry(relief=RIDGE)
        label.grid(row=row_idx, column=0, sticky=NSEW)
        label.insert(END, option_name)
        label.configure(state=DISABLED, disabledforeground="black")

        decisions = Entry(relief=RIDGE)
        decisions.grid(row=row_idx, column=1, sticky=NSEW)
        decisions.insert(END, str(option.path_decisions))
        decisions.configure(state=DISABLED, disabledforeground="black")

        options_field = Entry(relief=RIDGE)
        options_field.grid(row=row_idx, column=2, sticky=NSEW)
        options_field.configure(state=DISABLED, disabledforeground="black")

        plot_button = Button(options_field, text="Plot", command=lambda opt=option, opt_name=option_name: plot_CostModels([opt], sorted_free_symbols, free_symbol_ranges, [opt_name], title=opt_name)) # type: ignore
        plot_button.grid(row=0, column=0)
        cols.append(label)

    Button(root, text="Plot All", command=lambda: plot_CostModels([t[0] for t in options], sorted_free_symbols, free_symbol_ranges, [t[1] for t in options], title="Full Plot")).grid() # type: ignore
    Button(root, text="Continue",
           command=lambda: root.destroy()).grid()

    mainloop()



