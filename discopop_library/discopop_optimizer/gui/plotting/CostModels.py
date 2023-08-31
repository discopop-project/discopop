# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
from typing import List, Dict, Tuple, Optional

import numpy as np
from matplotlib import pyplot as plt  # type: ignore
import matplotlib
from spb import plot3d, MB, plot  # type: ignore
from sympy import Symbol
import sympy

from discopop_library.discopop_optimizer.CostModels.CostModel import CostModel


def plot_CostModels(
    models: List[CostModel],
    sorted_free_symbols: List[Symbol],
    free_symbol_ranges: Dict[Symbol, Tuple[float, float]],
    labels: Optional[List[str]] = None,
    title: Optional[str] = None,
    super_title: Optional[str] = None,
):
    if len(sorted_free_symbols) == 2:
        __3d_plot(
            models,
            sorted_free_symbols,
            free_symbol_ranges,
            labels=labels,
            title=str(title) + str(super_title) if super_title is not None else title,
        )
    elif len(sorted_free_symbols) == 1:
        __2d_plot(
            models,
            sorted_free_symbols,
            free_symbol_ranges,
            labels=labels,
            title=str(title) + str(super_title) if super_title is not None else title,
        )
    elif len(sorted_free_symbols) == 0:
        __1d_plot(
            models,
            sorted_free_symbols,
            free_symbol_ranges,
            labels=labels,
            title=title,
            super_title=super_title,
        )
    else:
        print("Plotiting not supported for", len(sorted_free_symbols), "free symbols!")


__unique_plot_id = 0


def __1d_plot(
    models: List[CostModel],
    sorted_free_symbols: List[Symbol],
    free_symbol_ranges: Dict[Symbol, Tuple[float, float]],
    labels: Optional[List[str]] = None,
    title: Optional[str] = None,
    super_title: Optional[str] = None,
):
    global __unique_plot_id
    matplotlib.use("TkAgg")
    # Make a dataset from models:
    height: List[float] = []
    bars: List[str] = []

    for idx, model in enumerate(models):
        model_label = str(model.path_decisions) if labels is None else labels[idx]
        bars.append(model_label)

        # get numeric value from model
        num_value = float(
            sympy.re(model.sequential_costs.evalf() + model.parallelizable_costs.evalf())
        )
        height.append(num_value)

    bars_tuple = tuple(bars)
    y_pos = np.arange(len(bars_tuple))

    # Create bars
    plt.figure(__unique_plot_id)
    __unique_plot_id += 1
    if title is not None:
        plt.title(title)  # type: ignore
    if super_title is not None:
        plt.suptitle(super_title)  # type: ignore
    plt.bar(y_pos, height)  # type: ignore
    # Create names on the x-axis
    plt.xticks(y_pos, bars_tuple)
    # Show graphic
    plt.show()


def __2d_plot(
    models: List[CostModel],
    sorted_free_symbols: List[Symbol],
    free_symbol_ranges: Dict[Symbol, Tuple[float, float]],
    labels: Optional[List[str]] = None,
    title: Optional[str] = None,
):
    matplotlib.use("TkAgg")
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
                zlabel="Execution time",
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
                    zlabel="Execution time",
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
    matplotlib.use("TkAgg")
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
                zlabel="Execution time",
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
                    zlabel="Execution time",
                )
            )
    combined_plot.show()  # type: ignore
