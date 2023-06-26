from tkinter import *
from typing import List, Tuple, Dict

import networkx as nx  # type: ignore
from sympy import Symbol, Expr

from discopop_explorer import PETGraphX
from discopop_library.discopop_optimizer.CostModels.CostModel import CostModel
from discopop_library.discopop_optimizer.Variables.Experiment import Experiment
from discopop_library.discopop_optimizer.bindings.CodeGenerator import export_code
from discopop_library.discopop_optimizer.classes.context.ContextObject import ContextObject
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
    pet: PETGraphX,
    graph: nx.DiGraph,
    experiment: Experiment,
    options: List[Tuple[CostModel, ContextObject, str]],
    substitutions: Dict[Symbol, Expr],
    sorted_free_symbols: List[Symbol],
    free_symbol_ranges: Dict[Symbol, Tuple[float, float]],
    free_symbol_distributions: Dict[Symbol, FreeSymbolDistribution],
    function_root: FunctionRoot,
    window_title=None,
) -> List[Tuple[CostModel, ContextObject, str]]:
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

    Button(
        root,
        text="Plot All",
        command=lambda: plot_CostModels(
            [t[0] for t in options],
            sorted_free_symbols,
            free_symbol_ranges,
            [t[2] for t in options],
            title="Full Plot",
        ),
    ).grid()  # type: ignore
    Button(
        root,
        text="Add Random (10)",
        command=lambda: add_random_models(
            root,
            pet,
            graph,
            experiment,
            [opt for opt in options if not opt[2].startswith("Rand ")],
            substitutions,
            sorted_free_symbols,
            free_symbol_ranges,
            free_symbol_distributions,
            function_root,
            window_title,
        ),
    ).grid()
    Button(
        root, text="Save Models", command=lambda: __save_models(experiment, function_root, options)
    ).grid()
    Button(
        root,
        text="Export all codes",
        command=lambda: __export_all_codes(pet, graph, experiment, options, function_root),
    ).grid()
    Button(root, text="Continue", command=lambda: root.destroy()).grid()

    # create option entries
    for row_idx, option_tuple in enumerate(options):
        option, context, option_name = option_tuple
        row_idx = row_idx + 1 + 5  # to account for column headers
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

        export_code_button = Button(
            options_field,
            text="Export Code",
            command=lambda opt=option, opt_name=option_name, ctx=context: export_code(  # type: ignore
                pet, graph, experiment, opt, ctx, opt_name, function_root
            ),
        )
        export_code_button.grid(row=0, column=2)

    mainloop()

    return options


def __save_models(
    experiment: Experiment,
    function_root: FunctionRoot,
    options: List[Tuple[CostModel, ContextObject, str]],
):
    print("SAVE: ", function_root)
    print("\ttype; ", type(function_root))
    experiment.function_models[function_root] = options
    print("Saved models for: ", function_root.name)


def add_random_models(
    root: Tk,
    pet: PETGraphX,
    graph: nx.DiGraph,
    experiment: Experiment,
    conserve_options: List[Tuple[CostModel, ContextObject, str]],
    substitutions: Dict[Symbol, Expr],
    sorted_free_symbols: List[Symbol],
    free_symbol_ranges: Dict[Symbol, Tuple[float, float]],
    free_symbol_distributions: Dict[Symbol, FreeSymbolDistribution],
    function_root: FunctionRoot,
    window_title=None,
    show_results: bool = True,
) -> List[Tuple[CostModel, ContextObject, str]]:
    root.destroy()

    # generate random models
    # sort random models
    # add models to the list of options
    random_paths = 10  # amount of random models to be generated

    (
        minimum,
        maximum,
        median,
        lower_quartile,
        upper_quartile,
    ) = find_quasi_optimal_using_random_samples(
        experiment,
        graph,
        function_root,
        random_paths,
        substitutions,
        sorted_free_symbols,
        free_symbol_ranges,
        free_symbol_distributions,
        verbose=False,
    )
    conserve_options.append((minimum[0], minimum[1], "Rand Minimum"))
    conserve_options.append((maximum[0], maximum[1], "Rand Maximum"))
    conserve_options.append((median[0], median[1], "Rand Median"))
    conserve_options.append((lower_quartile[0], lower_quartile[1], "Rand 25% Quartile"))
    conserve_options.append((upper_quartile[0], upper_quartile[1], "Rand 75% Quartile"))

    # plot
    if show_results:
        show_options(
            pet,
            graph,
            experiment,
            conserve_options,
            substitutions,
            sorted_free_symbols,
            free_symbol_ranges,
            free_symbol_distributions,
            function_root,
            window_title,
        )

    return conserve_options


def __export_all_codes(
    pet: PETGraphX,
    graph: nx.DiGraph,
    experiment: Experiment,
    options: List[Tuple[CostModel, ContextObject, str]],
    function_root: FunctionRoot,
):
    for opt, ctx, label in options:
        export_code(pet, graph, experiment, opt, ctx, label, function_root)
