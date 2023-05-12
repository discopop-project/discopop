from typing import List, Dict, Tuple, Optional

from sympy import Symbol

from discopop_library.OptimizationGraph.CostModels.CostModel import CostModel

from spb import plot3d, MB, plot  # type: ignore


def plot_CostModels(
    models: List[CostModel],
    sorted_free_symbols: List[Symbol],
    free_symbol_ranges: Dict[Symbol, Tuple[float, float]],
    labels: Optional[List[str]] = None,
    title: Optional[str] = None,
):
    if len(sorted_free_symbols) == 2:
        __3d_plot(models, sorted_free_symbols, free_symbol_ranges, labels=labels, title=title)
    elif len(sorted_free_symbols) == 1:
        __2d_plot(models, sorted_free_symbols, free_symbol_ranges, labels=labels, title=title)
    else:
        print("Plotiting not supported for", len(sorted_free_symbols), "free symbols!")


def __2d_plot(
    models: List[CostModel],
    sorted_free_symbols: List[Symbol],
    free_symbol_ranges: Dict[Symbol, Tuple[float, float]],
    labels: Optional[List[str]] = None,
    title: Optional[str] = None,
):
    combined_plot = None
    for idx, model in enumerate(models):
        model_label = str(model.path_decisions) if labels is None else labels[idx]
        if combined_plot is None:
            combined_plot = plot(
                model.parallelizable_costs + model.sequential_costs,
                (
                    sorted_free_symbols[0],
                    free_symbol_ranges[sorted_free_symbols[0]][0],
                    free_symbol_ranges[sorted_free_symbols[0]][1],
                ),
                show=False,
                backend=MB,
                label=model_label,
                zlabel="Costs",
                title=title,
            )
        else:
            combined_plot.extend(
                plot(
                    model.parallelizable_costs + model.sequential_costs,
                    (
                        sorted_free_symbols[0],
                        free_symbol_ranges[sorted_free_symbols[0]][0],
                        free_symbol_ranges[sorted_free_symbols[0]][1],
                    ),
                    show=False,
                    backend=MB,
                    label=model_label,
                    zlabel="Costs",
                )
            )
    combined_plot.show()  # type: ignore


def __3d_plot(
    models: List[CostModel],
    sorted_free_symbols: List[Symbol],
    free_symbol_ranges: Dict[Symbol, Tuple[float, float]],
    labels: Optional[List[str]] = None,
    title: Optional[str] = None,
):
    combined_plot = None
    for idx, model in enumerate(models):
        model_label = str(model.path_decisions) if labels is None else labels[idx]
        if combined_plot is None:
            combined_plot = plot3d(
                model.parallelizable_costs + model.sequential_costs,
                (
                    sorted_free_symbols[0],
                    free_symbol_ranges[sorted_free_symbols[0]][0],
                    free_symbol_ranges[sorted_free_symbols[0]][1],
                ),
                (
                    sorted_free_symbols[1],
                    free_symbol_ranges[sorted_free_symbols[1]][0],
                    free_symbol_ranges[sorted_free_symbols[1]][1],
                ),
                show=False,
                backend=MB,
                label=model_label,
                zlabel="Costs",
                title=title,
            )
        else:
            combined_plot.extend(
                plot3d(
                    model.parallelizable_costs + model.sequential_costs,
                    (
                        sorted_free_symbols[0],
                        free_symbol_ranges[sorted_free_symbols[0]][0],
                        free_symbol_ranges[sorted_free_symbols[0]][1],
                    ),
                    (
                        sorted_free_symbols[1],
                        free_symbol_ranges[sorted_free_symbols[1]][0],
                        free_symbol_ranges[sorted_free_symbols[1]][1],
                    ),
                    show=False,
                    backend=MB,
                    label=model_label,
                    zlabel="Costs",
                )
            )
    combined_plot.show()  # type: ignore