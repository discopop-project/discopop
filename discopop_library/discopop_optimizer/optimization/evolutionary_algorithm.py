# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import copy
import json
from multiprocessing import Pool
import os
from typing import Dict, List, Optional, Set, Tuple, cast
import warnings

from sympy import Expr
import tqdm  # type: ignore
from discopop_explorer.PEGraphX import NodeID  # type: ignore
from discopop_library.discopop_optimizer.CostModels.CostModel import CostModel
from discopop_library.discopop_optimizer.OptimizerArguments import OptimizerArguments

from discopop_library.discopop_optimizer.Variables.Experiment import Experiment
from discopop_library.discopop_optimizer.classes.context.ContextObject import ContextObject
from discopop_library.discopop_optimizer.classes.nodes.FunctionRoot import FunctionRoot
import random

from discopop_library.discopop_optimizer.optimization.evaluate import evaluate_configuration
from discopop_library.discopop_optimizer.optimization.validation import check_configuration_validity
from discopop_library.discopop_optimizer.utilities.MOGUtilities import (
    get_in_options,
    get_out_mutex_edges,
    get_out_options,
    get_requirements,
)
from discopop_library.discopop_optimizer.utilities.simple_utilities import data_at
from discopop_library.result_classes.OptimizerOutputPattern import OptimizerOutputPattern


def perform_evolutionary_search(
    experiment: Experiment,
    available_decisions: Dict[FunctionRoot, List[List[int]]],
    arguments: OptimizerArguments,
    optimizer_dir: str,
) -> Optional[OptimizerOutputPattern]:
    if arguments.evolutionary is None:
        raise ValueError("Invalid arguments for evolutionary search: " + str(arguments.evolutionary))
    ### SETTINGS
    population_size = int(arguments.evolutionary[0])
    generations = int(arguments.evolutionary[1])
    selection_strength = 0.85  # 0.8 --> 80% of the population will be selected for the next generation
    crossovers = int(population_size / 10)
    mutations = int(population_size / 10)
    ### END SETTINGS

    population: List[List[int]] = __initialize(experiment, population_size, available_decisions, arguments)
    population, fitness, _ = __calculate_fitness(experiment, population, arguments)
    generation_counter = 0

    while generation_counter < generations:
        print("\nGeneration", generation_counter, "/", generations)
        population, fitness, _ = __calculate_fitness(experiment, population, arguments)
        if arguments.verbose:
            __print_population(experiment, population, fitness, arguments)
        population = __select(
            experiment,
            arguments,
            population,
            fitness,
            int(len(population) * selection_strength),
        )
        population = __fill_population(experiment, available_decisions, arguments, population, population_size)
        population = __crossover(experiment, arguments, population, crossovers)
        population = __mutate(experiment, arguments, population, crossovers)
        generation_counter += 1
    population, fitness, contexts = __calculate_fitness(experiment, population, arguments)
    if arguments.verbose:
        __print_population(experiment, population, fitness, arguments)
    return __dump_result(experiment, population, fitness, optimizer_dir, population_size, generations, contexts)


global_experiment = None
global_arguments = None
global_available_decisions = None
global_population = None


def __calculate_fitness(
    experiment: Experiment,
    population: List[List[int]],
    arguments: OptimizerArguments,
) -> Tuple[List[List[int]], List[int], List[ContextObject]]:
    """returning the population is necessary since the order of the population can change due to multiprocessing"""
    global global_experiment
    global global_arguments
    global_experiment = experiment
    global_arguments = arguments

    print("Calculating fitness...")
    param_list = [(element) for element in population]
    with Pool(
        initializer=__initialize_fitness_worker,
        initargs=(
            experiment,
            arguments,
        ),
    ) as pool:
        tmp_result = list(tqdm.tqdm(pool.imap_unordered(__get_score, param_list), total=len(param_list)))
    population = []
    fitness = []
    contexts = []
    for local_result in tmp_result:
        # remove invalid elements
        if local_result[1] == -1:
            continue

        population.append(local_result[0])
        fitness.append(local_result[1])
        contexts.append(local_result[2])
    return population, fitness, contexts


def __initialize_fitness_worker(
    experiment: Experiment,
    arguments: OptimizerArguments,
):
    global global_experiment
    global global_arguments
    global_experiment = experiment
    global_arguments = arguments


def __get_score(param_tuple) -> Tuple[List[int], int, ContextObject]:
    global global_experiment
    global global_arguments
    configuration = param_tuple
    try:
        _, score_expr, context = evaluate_configuration(
            cast(Experiment, global_experiment),
            configuration,
            cast(OptimizerArguments, global_arguments),
        )
        result = int(float(str(score_expr.evalf())))
    except ValueError:
        result = -1

    return configuration, result, context


def __print_population(
    experiment: Experiment,
    population: List[List[int]],
    fitness: List[int],
    arguments: OptimizerArguments,
):
    sorted_fitness = sorted(enumerate(fitness), key=lambda x: x[1], reverse=True)
    print("# POPULATION")
    for fitness_idx, fitness_value in sorted_fitness:
        element_with_mapping = []
        for entry in population[fitness_idx]:
            # find pattern id
            for pattern_id in experiment.suggestion_to_node_ids_dict:
                if entry in experiment.suggestion_to_node_ids_dict[pattern_id]:
                    element_with_mapping.append(
                        str(pattern_id) + "@" + str(data_at(experiment.optimization_graph, entry).device_id)
                    )
        print("#", element_with_mapping, "->", fitness_value)
    print("# AVG: ", int(sum(fitness) / len(fitness)))
    print()


def __initialize(
    experiment: Experiment,
    population_size: int,
    available_decisions: Dict[FunctionRoot, List[List[int]]],
    arguments: OptimizerArguments,
) -> List[List[int]]:
    return __fill_population(experiment, available_decisions, arguments, [], population_size)


def __initialize_fill_worker(
    experiment: Experiment,
    available_decisions: Dict[FunctionRoot, List[List[int]]],
    arguments: OptimizerArguments,
):
    global global_experiment
    global global_arguments
    global global_available_decisions
    global_experiment = experiment
    global_arguments = arguments
    global_available_decisions = available_decisions


def __parallel_get_random_configuration(param_tuple):
    global global_experiment
    global global_arguments
    global global_available_decisions
    return __get_random_configuration(global_experiment, global_available_decisions, global_arguments)


def __fill_population(
    experiment: Experiment,
    available_decisions: Dict[FunctionRoot, List[List[int]]],
    arguments: OptimizerArguments,
    population: List[List[int]],
    population_size: int,
) -> List[List[int]]:
    global global_experiment
    global global_arguments
    global global_available_decisions
    global_experiment = experiment
    global_arguments = arguments
    global_available_decisions = available_decisions  # type: ignore
    # select random candidates
    print("Filling the population...")
    param_list = [(None) for element in range(len(population), population_size)]
    with Pool(
        initializer=__initialize_fill_worker,
        initargs=(
            experiment,
            available_decisions,
            arguments,
        ),
    ) as pool:
        tmp_result = list(
            tqdm.tqdm(pool.imap_unordered(__parallel_get_random_configuration, param_list), total=len(param_list))
        )

    #    tmp_result = []
    #    for p in param_list:
    #        tmp_result.append(__parallel_get_random_configuration(p))

    for local_result in tmp_result:
        population.append(local_result)
    return population


def __select(
    experiment: Experiment,
    arguments: OptimizerArguments,
    population: List[List[int]],
    fitness: List[int],
    new_population_size: int,
):
    """Performs a fitness-proportionate Selection"""
    # get Sum of scores
    score_sum = 0.0
    for val in fitness:
        score_sum += val

    # get Probabilities for each element
    probabilityMap: Dict[Tuple[int, ...], float] = dict()
    for element_idx, element in enumerate(population):
        probabilityMap[tuple(element)] = 1 - (fitness[element_idx] / score_sum)

    # get weights list
    weights = [probabilityMap[tuple(elem)] for elem in population]

    # select population to preserve
    new_population = random.choices(population, weights=weights, k=new_population_size - 1)

    # always preserve the current best element
    for idx, fitness_value in sorted(enumerate(fitness), key=lambda x: x[1]):
        new_population.append(population[idx])
        break
    return new_population


def __crossover(
    experiment: Experiment,
    arguments: OptimizerArguments,
    population: List[List[int]],
    crossovers: int,
):
    global global_experiment
    global global_arguments
    global global_population
    global_experiment = experiment
    global_arguments = arguments
    global_population = population

    print("Calculating crossovers...")
    param_list = [(None) for element in range(0, crossovers)]
    with Pool(
        initializer=__initialize_crossover_worker,
        initargs=(experiment, arguments, population),
    ) as pool:
        tmp_result = list(tqdm.tqdm(pool.imap_unordered(__parallel_crossover, param_list), total=len(param_list)))
    for local_result in tmp_result:
        if local_result is None:
            continue
        if local_result[1] is not None:
            (old_element_1, old_element_2), (new_element_1, new_element_2) = local_result
            old_element_1, old_element_2 = local_result[1]
            if old_element_1 in population and old_element_2 in population and old_element_1 != old_element_2:
                population.remove(old_element_1)
                population.remove(old_element_2)
                population.append(new_element_1)
                population.append(new_element_2)
    return population


def __initialize_crossover_worker(experiment: Experiment, arguments: OptimizerArguments, population: List[List[int]]):
    global global_experiment
    global global_arguments
    global global_population
    global_experiment = experiment
    global_arguments = arguments
    global_population = population


def __parallel_crossover(param_tuple):
    global global_experiment
    global global_arguments
    global global_population

    for i in range(0, 1000):
        # select two random elements
        element_1 = random.choice(global_population)
        element_2 = random.choice(global_population)
        # select crossover point
        max_crossover_idx = min(len(element_1), len(element_2))
        crossover_idx = random.choice(range(0, max_crossover_idx))

        new_element_1 = element_1[:crossover_idx] + element_2[crossover_idx:]
        new_element_2 = element_2[:crossover_idx] + element_1[crossover_idx:]

        # validate elements
        if not check_configuration_validity(global_experiment, global_arguments, new_element_1):
            continue
        if not check_configuration_validity(global_experiment, global_arguments, new_element_2):
            continue
        return (element_1, element_2), (new_element_1, new_element_2)
    return None


def __mutate(
    experiment: Experiment,
    arguments: OptimizerArguments,
    population: List[List[int]],
    mutations: int,
) -> List[List[int]]:
    global global_experiment
    global global_arguments
    global global_population
    global_experiment = experiment
    global_arguments = arguments
    global_population = population

    print("Calculating mutations...")
    param_list = [(None) for element in range(0, mutations)]
    with Pool(
        initializer=__initialize_mutate_worker,
        initargs=(experiment, arguments, population),
    ) as pool:
        tmp_result = list(tqdm.tqdm(pool.imap_unordered(__parallel_mutate, param_list), total=len(param_list)))
    for local_result in tmp_result:
        if local_result is None:
            continue
        if local_result[0] in population and local_result[1] is not None:
            population.remove(local_result[0])
            population.append(local_result[1])
    return population


def __initialize_mutate_worker(experiment: Experiment, arguments: OptimizerArguments, population: List[List[int]]):
    global global_experiment
    global global_arguments
    global global_population
    global_experiment = experiment
    global_arguments = arguments
    global_population = population


def __parallel_mutate(param_tuple):
    global global_experiment
    global global_arguments
    global global_population

    for i in range(0, 1000):
        # select random mutation target from population
        mutation_target = random.choice(global_population)

        # select random mutation within the target
        mutation_index = random.choice(range(0, len(mutation_target)))

        # perform mutation if possible
        options = get_out_mutex_edges(global_experiment.optimization_graph, mutation_target[mutation_index])
        if len(options) > 0:
            index_mutant = random.choice(options)
            mutant = copy.deepcopy(mutation_target)
            mutant[mutation_index] = index_mutant

            # validate
            if not check_configuration_validity(global_experiment, global_arguments, mutant):
                continue
            return mutation_target, mutant
    return None


def __dump_result(
    experiment: Experiment,
    population: List[List[int]],
    fitness: List[int],
    optimizer_dir: str,
    population_size: int,
    generations: int,
    contexts: List[ContextObject],
) -> Optional[OptimizerOutputPattern]:
    # replace keys to allow dumping
    dumpable_dict = dict()
    for idx, key in enumerate(population):
        new_key = []
        for entry in key:
            # find pattern id
            for pattern_id in experiment.suggestion_to_node_ids_dict:
                if entry in experiment.suggestion_to_node_ids_dict[pattern_id]:
                    new_key.append(str(pattern_id) + "@" + str(data_at(experiment.optimization_graph, entry).device_id))
        dumpable_dict[str(new_key)] = str(fitness[idx])

    dump_path: str = os.path.join(
        optimizer_dir, "evolutionary_results_" + str(population_size) + "x" + str(generations) + ".json"
    )
    with open(dump_path, "w") as fp:
        json.dump(dumpable_dict, fp)

    # prepare dumping the best option
    for idx, fitness_value in sorted(enumerate(fitness), key=lambda x: x[1]):
        new_key_2 = []
        best_configuration = None
        for node_id in population[idx]:
            # find pattern id
            for pattern_id in experiment.suggestion_to_node_ids_dict:
                if node_id in experiment.suggestion_to_node_ids_dict[pattern_id]:
                    new_key_2.append(
                        str(pattern_id) + "@" + str(data_at(experiment.optimization_graph, node_id).device_id)
                    )
                    device_id = data_at(experiment.optimization_graph, node_id).device_id
                    if best_configuration is None:
                        best_configuration = OptimizerOutputPattern(
                            experiment.detection_result.pet.node_at(
                                cast(NodeID, data_at(experiment.optimization_graph, node_id).original_cu_id)
                            ),
                            [],
                            experiment.get_system().get_host_device_id(),
                        )
                    best_configuration.add_pattern(
                        pattern_id, device_id, experiment.get_system().get_device(device_id).get_device_type()
                    )
        if best_configuration is None:
            return None
        # collect data movement information
        for update in contexts[idx].necessary_updates:
            best_configuration.add_data_movement(update)
        # export results to file
        best_option_id_path: str = os.path.join(optimizer_dir, "evolutionary_pattern_id.txt")
        with open(best_option_id_path, "w+") as f:
            f.write(str(best_configuration.pattern_id))

        return best_configuration
    raise ValueError("No configuration found!")


def __get_random_configuration(
    experiment: Experiment,
    available_decisions: Dict[FunctionRoot, List[List[int]]],
    arguments: OptimizerArguments,
):
    while True:
        random_configuration: List[int] = []
        # fill configuration
        for function in available_decisions:
            excluded: Set[int] = set()
            requirements: Set[int] = set()

            for decision_list in available_decisions[function]:
                decision_set = set(decision_list)
                decision_set = decision_set - (decision_set & excluded)
                reduced_decision_set = decision_set.intersection(requirements)
                if len(reduced_decision_set) != 0:
                    random_decision = random.choice(list(reduced_decision_set))
                else:
                    random_decision = random.choice(list(decision_set))
                random_configuration.append(random_decision)
                requirements.update(get_requirements(experiment.optimization_graph, random_decision))
                excluded.update(get_out_mutex_edges(experiment.optimization_graph, random_decision))

        # validate configuration
        if check_configuration_validity(experiment, arguments, random_configuration):
            return random_configuration
