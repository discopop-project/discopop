import copy
import random
from random import shuffle
from symtable import Symbol
from typing import List, Dict, Tuple

from spb import plot3d, MB  # type: ignore

from discopop_library.OptimizationGraph.CostModels.CostModel import CostModel


def find_quasi_optimal_using_random_samples(
    models: List[CostModel],
    random_sample_count: int,
    sorted_free_symbols: List[Symbol],
    free_symbol_ranges: Dict[Symbol, Tuple[float, float]],
):
    # test: try sorting
    # random shuffle
    shuffle(models)
    # todo remove
    # pick random samples, if the list is bigger than the sample count
    if len(models) > random_sample_count:
        random_samples = random.choices(models, k=random_sample_count)
    else:
        random_samples = copy.deepcopy(
            models
        )  # copy required to leave the original list unmodified

    sorted_list = sorted(random_samples)  # BOTTLENECK!
    minimum = sorted_list[0]
    maximum = sorted_list[-1]
    median = sorted_list[int(len(sorted_list) / 2)]
    upper_quartile = sorted_list[int(len(sorted_list) / 4 * 3)]
    lower_quartile = sorted_list[int(len(sorted_list) / 4 * 1)]
    # plot minimum, maximum and median

    print()
    print("Maximum:")
    print(maximum.model)
    print(maximum.path_decisions)

    print()
    print("Median:")
    print(median.model)
    print(median.path_decisions)
    print()
    print("Minimum:")
    print(minimum.model)
    print(minimum.path_decisions)
    if True:  # plot results
        combined_plot = plot3d(
            minimum.model,
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
            label="Min: " + str(minimum.path_decisions),
            zlabel="Costs",
        )
        combined_plot.extend(
            plot3d(
                maximum.model,
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
                label="max: " + str(maximum.path_decisions),
                zlabel="Costs",
            )
        )
        combined_plot.extend(
            plot3d(
                median.model,
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
                label="Median: " + str(median.path_decisions),
                zlabel="Costs",
            )
        )
        combined_plot.extend(
            plot3d(
                lower_quartile.model,
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
                label="Lower 25%: " + str(lower_quartile.path_decisions),
                zlabel="Costs",
            )
        )
        combined_plot.extend(
            plot3d(
                upper_quartile.model,
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
                label="Upper 25%: " + str(upper_quartile.path_decisions),
                zlabel="Costs",
            )
        )
        combined_plot.show()
