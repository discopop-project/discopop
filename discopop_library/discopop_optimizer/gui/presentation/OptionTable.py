from tkinter import *
from typing import List, Tuple, Dict, Optional

import networkx as nx  # type: ignore
from sympy import Symbol, Expr

from discopop_library.discopop_optimizer.CostModels.CostModel import CostModel
from discopop_library.discopop_optimizer.Variables.Experiment import Experiment
from discopop_library.discopop_optimizer.bindings.CodeGenerator import export_code
from discopop_library.discopop_optimizer.classes.enums.Distributions import FreeSymbolDistribution
from discopop_library.discopop_optimizer.classes.nodes.FunctionRoot import FunctionRoot
from discopop_library.discopop_optimizer.gui.plotting.CostModels import plot_CostModels
from discopop_library.discopop_optimizer.gui.presentation.ChoiceDetails import (
    display_choices_for_model,
)
from discopop_library.discopop_optimizer.utilities.optimization.GlobalOptimization.RandomSamples import (
    find_quasi_optimal_using_random_samples,
)


def show_options(
    graph: nx.DiGraph,
    experiment: Experiment,
    options: List[Tuple[CostModel, str]],
    substitutions: Dict[Symbol, Expr],
    sorted_free_symbols: List[Symbol],
    free_symbol_ranges: Dict[Symbol, Tuple[float, float]],
    free_symbol_distributions: Dict[Symbol, FreeSymbolDistribution],
    function_root: FunctionRoot,
    window_title=None,
):
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

        plot_button = Button(
            options_field,
            text="Plot",
            command=lambda opt=option, opt_name=option_name: plot_CostModels(  # type: ignore
                [opt],  # type: ignore
                sorted_free_symbols,
                free_symbol_ranges,
                [opt_name],
                title=opt_name,
            ),
        )
        plot_button.grid(row=0, column=0)
        details_button = Button(
            options_field,
            text="Details",
            command=lambda opt=option, opt_name=option_name: display_choices_for_model(  # type: ignore
                graph, opt, window_title=opt_name  # type: ignore
            ),
        )
        details_button.grid(row=0, column=1)

        export_code_button = Button(options_field, text="Export Code", command=lambda opt=option: export_code(graph, experiment, option))  # type: ignore
        export_code_button.grid(row=0, column=2)

    Button(
        root,
        text="Plot All",
        command=lambda: plot_CostModels(
            [t[0] for t in options],
            sorted_free_symbols,
            free_symbol_ranges,
            [t[1] for t in options],
            title="Full Plot",
        ),
    ).grid()  # type: ignore
    Button(
        root,
        text="Add Random (50)",
        command=lambda: add_random_models(
            root,
            graph,
            experiment,
            [opt for opt in options if not opt[1].startswith("Rand ")],
            substitutions,
            sorted_free_symbols,
            free_symbol_ranges,
            free_symbol_distributions,
            function_root,
            window_title,
        ),
    ).grid()
    Button(root, text="Continue", command=lambda: root.destroy()).grid()

    mainloop()


def add_random_models(
    root: Tk,
    graph: nx.DiGraph,
    experiment: Experiment,
    options: List[Tuple[CostModel, str]],
    substitutions: Dict[Symbol, Expr],
    sorted_free_symbols: List[Symbol],
    free_symbol_ranges: Dict[Symbol, Tuple[float, float]],
    free_symbol_distributions: Dict[Symbol, FreeSymbolDistribution],
    function_root: FunctionRoot,
    window_title=None,
):
    root.destroy()

    # generate random models
    # sort random models
    # add models to the list of options
    random_paths = 50  # amount of random models to be generated

    (
        minimum,
        maximum,
        median,
        lower_quartile,
        upper_quartile,
    ) = find_quasi_optimal_using_random_samples(
        graph,
        function_root,
        random_paths,
        substitutions,
        sorted_free_symbols,
        free_symbol_ranges,
        free_symbol_distributions,
        verbose=False,
    )
    options.append((minimum, "Rand Minimum"))
    options.append((maximum, "Rand Maximum"))
    options.append((median, "Rand Median"))
    options.append((lower_quartile, "Rand 25% Quartile"))
    options.append((upper_quartile, "Rand 75% Quartile"))

    # plot
    show_options(
        graph,
        experiment,
        options,
        substitutions,
        sorted_free_symbols,
        free_symbol_ranges,
        free_symbol_distributions,
        function_root,
        window_title,
    )
