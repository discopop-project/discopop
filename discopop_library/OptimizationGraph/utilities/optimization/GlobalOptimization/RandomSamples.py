import copy
import random
from random import shuffle
from typing import List, Dict, Tuple

from spb import plot3d, MB, plot  # type: ignore
from sympy import Symbol

from discopop_library.OptimizationGraph.CostModels.CostModel import CostModel
from discopop_library.OptimizationGraph.classes.enums.Distributions import FreeSymbolDistribution
from discopop_library.OptimizationGraph.gui.plotting.CostModels import plot_CostModels


def find_quasi_optimal_using_random_samples(
    models: List[CostModel],
    random_path_count: int,
    sorted_free_symbols: List[Symbol],
    free_symbol_ranges: Dict[Symbol, Tuple[float, float]],
    plot: bool = False,
):
    """Returns the identified minimum, maximum, median, 25% quartile and 75% quartile.
    NOTE: The decisions should be treated as suggestions, not mathematically accurate decisions
    due to the used comparison method!"""
    # test: try sorting
    # random shuffle
    shuffle(models)
    # todo remove
    # pick random samples, if the list is bigger than the sample count
    if len(models) > random_path_count:
        random_paths = random.choices(models, k=random_path_count)
    else:
        random_paths = copy.deepcopy(models)  # copy required to leave the original list unmodified

    sorted_list = sorted(random_paths)  # BOTTLENECK!
    minimum = sorted_list[0]
    maximum = sorted_list[-1]
    median = sorted_list[int(len(sorted_list) / 2)]
    upper_quartile = sorted_list[int(len(sorted_list) / 4 * 3)]
    lower_quartile = sorted_list[int(len(sorted_list) / 4 * 1)]
    # plot minimum, maximum and median

    print()
    print("Maximum:")
    print("Par: ", maximum.parallelizable_costs)
    print("Seq: ", maximum.sequential_costs)
    print(maximum.path_decisions)

    print()
    print("Median:")
    print("Par: ", median.parallelizable_costs)
    print("Seq: ", median.sequential_costs)

    print(median.path_decisions)
    print()
    print("Minimum:")
    print("Par: ", minimum.parallelizable_costs)
    print("Seq: ", minimum.sequential_costs)
    print(minimum.path_decisions)

    print()
    print("25% Quartile:")
    print("Par: ", lower_quartile.parallelizable_costs)
    print("Seq: ", lower_quartile.sequential_costs)
    print(lower_quartile.path_decisions)

    print()
    print("75% Quartile:")
    print("Par: ", upper_quartile.parallelizable_costs)
    print("Seq: ", upper_quartile.sequential_costs)
    print(upper_quartile.path_decisions)


    if plot:  # plot results
        plot_CostModels(
            [minimum, maximum, median, lower_quartile, upper_quartile],
            sorted_free_symbols,
            free_symbol_ranges,
            labels=["Minimum", "Maximum", "Median", "25% Quartile", "75% Quartile"],
        )

    return minimum, maximum, median, lower_quartile, upper_quartile
