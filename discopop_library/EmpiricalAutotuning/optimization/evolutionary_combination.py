# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import copy
from logging import Logger
from multiprocessing.pool import Pool
import random
import sys
from typing import Callable, Dict, List, Set, Tuple, cast

from tabulate import tabulate  # type: ignore
from tqdm import tqdm  # type: ignore
from discopop_library.EmpiricalAutotuning.ArgumentClasses import AutotunerArguments
from discopop_library.EmpiricalAutotuning.output.intermediate import show_info_stats
from discopop_library.EmpiricalAutotuning.Classes.CodeConfiguration import CodeConfiguration
from discopop_library.EmpiricalAutotuning.Classes.ExecutionResult import ExecutionResult
from discopop_library.EmpiricalAutotuning.Types import SUGGESTION_ID
from discopop_library.EmpiricalAutotuning.output.intermediate import show_debug_stats
from discopop_library.HostpotLoader.utilities import get_patterns_by_hotspot_type
from discopop_library.HostpotLoader.HotspotNodeType import HotspotNodeType
from discopop_library.HostpotLoader.HotspotType import HotspotType
from discopop_library.HostpotLoader.hostpot_loader import AVERAGE_RUNTIME, FILEID, NAME, STARTLINE
from discopop_library.result_classes.DetectionResult import DetectionResult

import time
import plotille  # type: ignore

FITNESS = float
CHROMOSOME = Tuple[int, ...]
fitness_cache: Dict[CHROMOSOME, FITNESS] = dict()
runtime_cache: Dict[CHROMOSOME, float] = dict()
return_code_cache: Dict[CHROMOSOME, int] = dict()
best_execution_time: float = sys.float_info.max
worst_execution_time: float = 0.0


def execute_evolutionary_combination(
    detection_result: DetectionResult,
    hotspot_information: Dict[HotspotType, List[Tuple[FILEID, STARTLINE, HotspotNodeType, NAME, AVERAGE_RUNTIME]]],
    logger: Logger,
    time_limit_s: int,
    reference_configuration: CodeConfiguration,
    arguments: AutotunerArguments,
    timeout_after: float,
    debug_stats: List[Tuple[List[SUGGESTION_ID], float, int, bool, bool, str]],
    get_unique_configuration_id: Callable[[], int],
) -> None:

    ## NOTES:
    # - increase selection likelihood by hotspot type -> more hotspots contained, higher likelihood
    # - initialize population with all YES suggestions
    # - fill the population until population size K with MAYBE suggestions
    # - upon selection, fill population with MAYBE suggestions until all were used once
    # - after all were used, fill population with random combination
    # --> In theory, this apporach should allow a refinement of YES suggestion combinations independent of the added MAYBE's,
    #     and increase result quality in general in case of early termination

    logger.info("Executing evolutionary combination.")

    # time limited reverse greedy search in hotspot parallelizations
    patterns_by_hotspot_type = get_patterns_by_hotspot_type(detection_result, hotspot_information)
    logger.debug("Patterns by hotspot type")
    logger.debug(str(patterns_by_hotspot_type))

    # initialize population with all selected suggestions
    if "maybe" not in arguments.hotspot_types:
        patterns_by_hotspot_type[HotspotType.MAYBE] = []
    if "no" not in arguments.hotspot_types:
        patterns_by_hotspot_type[HotspotType.NO] = []

    search_result = perform_evolutionary_search(
        patterns_by_hotspot_type, logger, reference_configuration, arguments, timeout_after, get_unique_configuration_id
    )

    # execute best combination to save results
    tmp_config = reference_configuration.create_copy(arguments, "par_settings.json", get_unique_configuration_id)
    tmp_config.apply_suggestions(arguments, list(search_result))
    tmp_config.execute(arguments, timeout=timeout_after, thread_count=arguments.thread_count)
    if not arguments.skip_cleanup:
        tmp_config.deleteFolder()
    debug_stats.append(
        (
            list(search_result),
            cast(ExecutionResult, tmp_config.execution_result).runtime,
            cast(ExecutionResult, tmp_config.execution_result).return_code,
            cast(ExecutionResult, tmp_config.execution_result).result_valid,
            cast(ExecutionResult, tmp_config.execution_result).thread_sanitizer,
            tmp_config.root_path,
        )
    )


#    # step 1: identify valid suggestions
#    valid: Set[int] = set()
#    queue: List[List[int]] = [[suggestion] for suggestion in configuration]
#    logger.info("Measuring individual suggestions:")
#    logger.info("Press CTRL+C to manually stop the search.")
#    try:
#        for current in tqdm(queue):
#            # execute current and check validity
#            tmp_config = reference_configuration.create_copy(
#                arguments, "par_settings.json", get_unique_configuration_id
#            )
#            tmp_config.apply_suggestions(arguments, current)
#            tmp_config.execute(arguments, timeout=timeout_after, thread_count=arguments.thread_count)
#            if not arguments.skip_cleanup:
#                tmp_config.deleteFolder()
#            debug_stats.append(
#                (
#                    current,
#                    cast(ExecutionResult, tmp_config.execution_result).runtime,
#                    cast(ExecutionResult, tmp_config.execution_result).return_code,
#                    cast(ExecutionResult, tmp_config.execution_result).result_valid,
#                    cast(ExecutionResult, tmp_config.execution_result).thread_sanitizer,
#                    tmp_config.root_path,
#                )
#            )
#            visited.append(current)
#
#            # if invalid, split current into two parts and put into queue
#            exec_res = cast(ExecutionResult, tmp_config.execution_result)
#            if exec_res.return_code == 0 and (
#                (exec_res.thread_sanitizer and exec_res.result_valid)
#                or (not exec_res.thread_sanitizer and exec_res.result_valid)
#            ):
#                # result valid
#                valid = valid.union(current)
#                show_debug_stats(debug_stats, logger)
#            else:
#                # result invalid
#                continue
#    except KeyboardInterrupt:
#        logger.info("Manually stopped search for valid suggestions.")
#        show_info_stats(debug_stats, logger)
#        pass
#
#    logger.info("Valid: " + str(valid))


#########################################################################################################
#########################################################################################################
#########################################################################################################
# Considerations regarding parameter tuning from: https://www.datacamp.com/tutorial/genetic-algorithm-python
# As with any model, the performance of a genetic algorithm depends on various parameters, notably population size, crossover rate, mutation rate, and bounding parameters. Changing these parameters will change how your model performs.

# As a general rule of thumb, larger population sizes will help you find the optimal solution quicker because there are more options to choose from. However, larger population sizes also require more time and resources to run.

# A higher crossover rate can lead to faster convergence by combining beneficial traits from different individuals more frequently. However, a crossover rate that is too high might disrupt the population structure, leading to premature convergence.

# A higher mutation rate helps maintain genetic diversity, preventing the algorithm from getting stuck at a local optimum. However, if the mutation rate is too high, it can disrupt the convergence process by introducing too much randomness, making it difficult for the algorithm to refine solutions.

# Bounding parameters define the range within which the algorithm searches for solutions. These are important to tune to your particular business problem. Too narrow of a bounding area may miss optimal solutions to your problem. Too broad of a bounding area will take more time and resources to run. But there are other considerations too.

# For instance, in our coded example above, that equation theoretically has no limits. But practically, we can’t ask the computer to find the flattest arc in an infinitely large graph. So, boundaries are necessary. But changing those boundaries will also change the optimal answer. In my opinion, establishing appropriate boundaries for your specific use case is imperative with any model.

# There may be other important parameters to tune in your particular model. Experiment with different values to find the best settings for your problem. To learn about tuning GA’s specifically, check out Informed Methods: Genetic Algorithms.

#########################################################################################################
#########################################################################################################
#########################################################################################################


def perform_evolutionary_search(
    patterns_by_hotspot_type: Dict[HotspotType, List[int]],
    logger: Logger,
    reference_configuration: CodeConfiguration,
    arguments: AutotunerArguments,
    timeout_after: float,
    get_unique_configuration_id: Callable[[], int],
) -> Tuple[int, ...]:
    ### SETTINGS
    population_size = max(10, len(patterns_by_hotspot_type[HotspotType.YES]) * 2)
    selection_strength = 0.85  # 0.8 --> 80% of the population will be selected for the next generation
    crossover_factor = 0.4
    mutations_factor = 0.5
    setting_convergence_factor = 1.0  # 0.9 --> average fitnes of the reached 90% of the best specimen
    convergence_generation_threshold = 2  # 2 -> average has to be greater than threshold for 3 generations
    ### END SETTINGS

    ## statistics
    current_convergence_factor = setting_convergence_factor
    generations_max_not_changed = 0
    generations_avg_not_changed = 0
    generations_threshold_not_reached = 0
    ## end statistics

    population, unused_maybes = __initialize(logger, population_size, patterns_by_hotspot_type)
    __calculate_fitness(
        logger, population, reference_configuration, arguments, timeout_after, get_unique_configuration_id
    )
    selection_size = min(population_size, max(1, int(len(population) * 0.85)))

    generation_counter = 0
    converged = False
    convergence_threshold_reached = 0

    time_series_x_values: List[int] = [generation_counter]
    time_series_max: List[float] = [get_maximum_fitness()]
    time_series_avg: List[float] = [get_average_fitness(population)]
    time_series_convergence_threshold: List[float] = [time_series_max[-1] * current_convergence_factor]
    plot_time_series(time_series_x_values, time_series_max, time_series_avg, time_series_convergence_threshold)

    try:
        while not converged:
            logger.info("\nGeneration: " + str(generation_counter))

            population, unused_maybes = __fill_population(logger, population, population_size, unused_maybes)
            population = __crossover(logger, population, max(1, int(selection_size * crossover_factor)))
            population = __mutate(logger, population, max(1, int(selection_size * mutations_factor)))
            generation_counter += 1
            __calculate_fitness(
                logger, population, reference_configuration, arguments, timeout_after, get_unique_configuration_id
            )
            population = __select(logger, population, selection_size)
            # update time series
            time_series_x_values.append(generation_counter)
            time_series_max.append(get_maximum_fitness())
            time_series_avg.append(get_average_fitness(population))

            # update statistics

            if time_series_avg[-1] >= (time_series_max[-1] * current_convergence_factor):
                generations_threshold_not_reached = 0
            else:
                generations_threshold_not_reached += 1

            if time_series_max[-1] > time_series_max[-2]:
                generations_max_not_changed = 0
                generations_threshold_not_reached = 0
                # if new max found, reset threshold and convergence factor
                current_convergence_factor = setting_convergence_factor
            else:
                generations_max_not_changed += 1

            if time_series_avg[-1] > time_series_avg[-2]:
                generations_avg_not_changed = 0
                generations_threshold_not_reached = 0
                current_convergence_factor = setting_convergence_factor
            else:
                generations_avg_not_changed += 1

            # reduce threshold in 5% steps if required
            if (
                generations_max_not_changed > convergence_generation_threshold
                and generations_threshold_not_reached > convergence_generation_threshold
                and generations_avg_not_changed > convergence_generation_threshold
            ):
                current_convergence_factor -= setting_convergence_factor * 0.05
                generations_threshold_not_reached = 0

            # update and plot time series
            time_series_convergence_threshold.append(time_series_max[-1] * current_convergence_factor)
            plot_time_series(time_series_x_values, time_series_max, time_series_avg, time_series_convergence_threshold)

            # check convergence
            if (
                round(time_series_avg[-1], 2) >= round((time_series_max[-1] * current_convergence_factor), 2)
                and generation_counter > 2
            ):
                convergence_threshold_reached += 1
                if convergence_threshold_reached > convergence_generation_threshold:
                    converged = True
            else:
                convergence_threshold_reached = 0
    except KeyboardInterrupt:
        logger.info("Manually stopped search.")
        # update time series
        time_series_x_values.append(generation_counter)
        time_series_max.append(get_maximum_fitness())
        time_series_avg.append(get_average_fitness(population))
        time_series_convergence_threshold.append(time_series_max[-1] * current_convergence_factor)
        plot_time_series(time_series_x_values, time_series_max, time_series_avg, time_series_convergence_threshold)

    population = __select(logger, population, selection_size)
    logger.info("Final population:\n" + __population_to_string(population))
    logger.info("Generations: " + str(generation_counter))

    for key in {k: v for k, v in sorted(fitness_cache.items(), key=lambda item: item[1], reverse=True)}:
        best_combination = key
        break
    print("--> Best combination: ", best_combination)

    return best_combination


def plot_time_series(
    time_series_x_values: List[int],
    time_series_max: List[float],
    time_series_avg: List[float],
    time_series_convergence_threshold: List[float],
) -> None:
    fig = plotille.Figure()
    fig.height = 30
    fig.width = 60
    fig.x_label = "Generation"
    fig.y_label = "Fitness (speedup)"
    fig.plot(time_series_x_values, time_series_max, interp="linear", lc="green", label="Maximum fitness")
    fig.plot(time_series_x_values, time_series_avg, interp="linear", lc="cyan", label="Average fitness")
    fig.plot(
        time_series_x_values,
        time_series_convergence_threshold,
        interp="linear",
        lc="yellow",
        label="Convergence threshold",
    )
    print(fig.show(legend=True))


def get_maximum_fitness() -> float:
    global fitness_cache
    max_val = 0.0
    for key in fitness_cache:
        max_val = max(max_val, fitness_cache[key])
    return max_val


def get_average_fitness(population: List[CHROMOSOME]) -> float:
    global fitness_cache
    sum = 0.0
    element_count = 0
    for key in population:
        if key not in fitness_cache:
            continue
        sum += fitness_cache[key]
        element_count += 1
    return sum / max(1, element_count)


def __mutate(logger: Logger, population: List[CHROMOSOME], mutations_count: int) -> List[CHROMOSOME]:
    # get list of known genes
    known_genes_set: Set[int] = set()
    for entry in fitness_cache:
        for gene in entry:
            known_genes_set.add(gene)
    known_genes = list(known_genes_set)

    # perform mutations
    for i in range(0, mutations_count):
        element_1 = list(random.choice(population))
        index = random.randint(0, len(known_genes) - 1)
        target_gene = known_genes[index]
        if target_gene in element_1:
            element_1.remove(target_gene)
        else:
            element_1.append(target_gene)
        population.append(tuple(element_1))

    logger.debug("Mutated population:\n" + __population_to_string(population))
    return population


def __crossover(logger: Logger, population: List[CHROMOSOME], crossover_count: int) -> List[CHROMOSOME]:
    logger.debug("Performing " + str(crossover_count) + " crossovers on population.")
    # get list of known genes
    known_genes: Set[int] = set()
    for entry in population:
        for gene in entry:
            known_genes.add(gene)
    # perform crossover
    for i in range(0, crossover_count):
        # selection
        element_1 = random.choice(population)
        element_2 = random.choice(population)
        # determine crossover points
        cp1 = random.randint(0, len(known_genes))
        cp2 = random.randint(0, len(known_genes))
        if cp1 == cp2:
            for j in range(0, 10):
                cp2 = random.randint(0, len(known_genes))
                if cp1 != cp2:
                    break
        # fix ordering of cut points
        if cp1 > cp2:
            buffer = cp1
            cp1 = cp2
            cp2 = buffer
        # crossover
        new_element_1: List[int] = []
        new_element_2: List[int] = []
        new_element_3: List[int] = []
        for idx, gene in enumerate(list(known_genes)):
            # pure crossover
            if idx >= cp1 and idx < cp2:
                if gene in element_1:
                    new_element_2.append(gene)
                if gene in element_2:
                    new_element_1.append(gene)
            # majority voting for child 3
            if gene in element_1 and gene in element_2:
                new_element_3.append(gene)
            elif gene not in element_1 and gene not in element_2:
                pass
            elif bool(random.getrandbits(1)):
                new_element_3.append(gene)

        population.append(tuple(new_element_1))
        population.append(tuple(new_element_2))
        population.append(tuple(new_element_3))

    logger.debug("Crossed-over population:\n" + __population_to_string(population))

    return population


def __fill_population(
    logger: Logger, population: List[CHROMOSOME], population_size: int, unused_maybes: List[int]
) -> Tuple[List[CHROMOSOME], List[int]]:
    logger.debug("Filling population to " + str(population_size) + " Elements.")
    if len(unused_maybes) > 0:
        while len(population) < population_size and len(unused_maybes) > 0:
            population.append((unused_maybes.pop(),))

    # get list of known genes
    known_genes: Set[int] = set()
    for entry in fitness_cache:
        for gene in entry:
            known_genes.add(gene)

    #    while len(population) < population_size:
    #        new_elem_list: List[int] = []
    #        for gene in list(known_genes):
    #            if bool(random.getrandbits(1)):
    #                new_elem_list.append(gene)
    #        population.append(tuple(new_elem_list))

    logger.debug("Filled population:\n" + __population_to_string(population))
    return population, unused_maybes


def __select(logger: Logger, population: List[CHROMOSOME], selection_size: int) -> List[CHROMOSOME]:
    global fitness_cache
    selection: List[CHROMOSOME] = []

    for key in {k: v for k, v in sorted(fitness_cache.items(), key=lambda item: item[1], reverse=True)}:
        if len(selection) >= selection_size:
            break
        selection.append(key)

    logger.info("Selected:\n " + __population_to_string(selection))

    return selection


entry_to_configuration: Dict[CHROMOSOME, CodeConfiguration] = dict()


def __calculate_fitness(
    logger: Logger,
    population: List[CHROMOSOME],
    reference_configuration: CodeConfiguration,
    arguments: AutotunerArguments,
    timeout_after: float,
    get_unique_configuration_id: Callable[[], int],
) -> None:
    global fitness_cache
    global runtime_cache
    global best_execution_time
    global worst_execution_time
    global entry_to_configuration
    logger.info("Calculating fitness...")
    logger.info("--- Removing duplicates")
    population_wo_duplicates = list(set(population))

    compilation_successful: Dict[CHROMOSOME, bool] = dict()

    compilation_successful, entry_to_configuration = __compile_population(
        logger,
        population_wo_duplicates,
        reference_configuration,
        arguments,
        timeout_after,
        get_unique_configuration_id,
        compilation_successful,
    )

    logger.info("--- Executing population")
    for entry in tqdm([p for p in population_wo_duplicates if p not in fitness_cache]):
        if entry not in compilation_successful or not compilation_successful[entry]:
            continue

        entry_to_configuration[entry].execute_only(
            arguments, timeout=timeout_after, thread_count=arguments.thread_count
        )

        return_code_cache[entry] = cast(ExecutionResult, entry_to_configuration[entry].execution_result).return_code
        if (
            cast(ExecutionResult, entry_to_configuration[entry].execution_result).return_code != 0
            or not cast(ExecutionResult, entry_to_configuration[entry].execution_result).result_valid
            or not cast(ExecutionResult, entry_to_configuration[entry].execution_result).thread_sanitizer
        ):
            fitness_cache[entry] = 0.0
        runtime = cast(ExecutionResult, entry_to_configuration[entry].execution_result).runtime
        runtime_cache[entry] = runtime

        if not arguments.skip_cleanup:
            entry_to_configuration[entry].deleteFolder()
            del entry_to_configuration[entry]

    logger.info("--- Cleanup ")
    for entry in tqdm(entry_to_configuration):
        if not arguments.skip_cleanup:
            entry_to_configuration[entry].deleteFolder()
    entry_to_configuration.clear()

    # find new best and worst runtime
    for key in population_wo_duplicates:
        if key not in runtime_cache:
            continue
        if runtime_cache[key] < best_execution_time:
            best_execution_time = runtime_cache[key]
        if runtime_cache[key] > worst_execution_time:
            worst_execution_time = runtime_cache[key]

    # update fitness
    for key in population_wo_duplicates:
        if key in return_code_cache:
            if return_code_cache[key] == 0:
                fitness_cache[key] = (
                    cast(ExecutionResult, reference_configuration.execution_result).runtime / runtime_cache[key]
                )
            else:
                fitness_cache[key] = 0.0
        else:
            fitness_cache[key] = 0.0
    logger.info("Calculated fitness:\n" + __population_to_string(population))


def __compile_population(
    logger: Logger,
    population: List[CHROMOSOME],
    reference_configuration: CodeConfiguration,
    arguments: AutotunerArguments,
    timeout_after: float,
    get_unique_configuration_id: Callable[[], int],
    compilation_successful: Dict[CHROMOSOME, bool],
) -> Tuple[Dict[CHROMOSOME, bool], Dict[CHROMOSOME, CodeConfiguration]]:
    global entry_to_configuration
    logger.info("--- Compiling population")

    logger.info("----- Prepare code")
    for entry in tqdm(population):
        if entry in fitness_cache:
            continue
        entry_to_configuration[entry] = reference_configuration.create_copy(
            arguments, "par_settings.json", get_unique_configuration_id
        )
        entry_to_configuration[entry].apply_suggestions(arguments, list(entry))
    logger.info("----- Compiling")
    local_results: List[Tuple[CHROMOSOME, bool]] = []
    param_list: List[Tuple[CHROMOSOME, AutotunerArguments, float]] = []
    for entry in population:
        if entry in fitness_cache:
            continue
        param_list.append((entry, copy.deepcopy(arguments), timeout_after))
    with Pool() as pool:
        # local_results = list(tqdm(pool.imap_unordered(__compile_configuration, param_list), total=len(param_list)))
        local_results = list(tqdm(pool.imap_unordered(__compile_configuration, param_list), total=len(param_list)))

    # merge local into global result
    for local in local_results:
        compilation_successful[local[0]] = local[1]
    return compilation_successful, entry_to_configuration


def __compile_configuration(args: Tuple[CHROMOSOME, AutotunerArguments, float]) -> Tuple[CHROMOSOME, bool]:
    global entry_to_configuration
    configuration, arguments, timeout_after = args
    compilation_successful = entry_to_configuration[configuration].compile_only(
        arguments, timeout=timeout_after, thread_count=arguments.thread_count
    )
    compilation_successful = True
    return configuration, compilation_successful


def __initialize(
    logger: Logger, population_size: int, patterns_by_hotspot_type: Dict[HotspotType, List[int]]
) -> Tuple[List[CHROMOSOME], List[int]]:
    population: List[CHROMOSOME] = []
    # add all YES suggestions
    for suggestion_id in patterns_by_hotspot_type[HotspotType.YES]:
        population.append((suggestion_id,))
    # fill with MAYBE suggestions
    unused_maybes: List[int] = patterns_by_hotspot_type[HotspotType.MAYBE]
    for suggestion_id in patterns_by_hotspot_type[HotspotType.MAYBE]:
        if len(population) < population_size:
            population.append((suggestion_id,))
            if suggestion_id in unused_maybes:
                unused_maybes.remove(suggestion_id)
        else:
            break
    # fill with NO suggestions
    for suggestion_id in patterns_by_hotspot_type[HotspotType.NO]:
        if len(population) < population_size:
            population.append((suggestion_id,))
        else:
            break

    logger.info("Initialized population:\n" + __population_to_string(population))

    return population, unused_maybes


def __population_to_string(
    population: List[CHROMOSOME],
) -> str:
    global fitness_cache
    global return_code_cache

    table = []
    genes = []
    headers = ["fitness", "code", "Individual"]

    tmp_genes: Set[int] = set()
    # get list of genes
    for entry in population:
        for gene in entry:
            tmp_genes.add(gene)

    # sort list of genes
    genes = sorted(list(tmp_genes))

    result_str = "Genes: " + str(genes)
    # add individuals to table
    for chromosome in population:
        individual_str = ""
        for gene in genes:
            if gene in chromosome:
                individual_str += "X"
            else:
                individual_str += "-"
        if chromosome in return_code_cache:
            individual_return_code = str(return_code_cache[chromosome])
        else:
            individual_return_code = "---"
        individual_fitness = fitness_cache[chromosome] if chromosome in fitness_cache else 0.0
        row = [individual_fitness, individual_return_code, individual_str]
        table.append(row)

    return result_str + "\n" + str(tabulate(table, headers, tablefmt="github"))
