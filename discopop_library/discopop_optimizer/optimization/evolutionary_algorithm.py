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
from typing import Dict, List, Tuple, cast
import warnings

from sympy import Expr
import tqdm  # type: ignore
from discopop_library.discopop_optimizer.CostModels.CostModel import CostModel
from discopop_library.discopop_optimizer.OptimizerArguments import OptimizerArguments

from discopop_library.discopop_optimizer.Variables.Experiment import Experiment
from discopop_library.discopop_optimizer.classes.context.ContextObject import ContextObject
from discopop_library.discopop_optimizer.classes.nodes.FunctionRoot import FunctionRoot
import random

from discopop_library.discopop_optimizer.optimization.evaluate import evaluate_configuration
from discopop_library.discopop_optimizer.utilities.MOGUtilities import (
    data_at,
    get_in_options,
    get_out_mutex_edges,
    get_out_options,
    get_requirements,
)


def perform_evolutionary_search(
    experiment: Experiment,
    function_performance_models: Dict[FunctionRoot, List[Tuple[CostModel, ContextObject]]],
    arguments: OptimizerArguments,
    optimizer_dir: str,
):
    ### SETTINGS
    population_size = 50
    generations = 10
    selection_strength = 0.85  # 0.8 --> 80% of the population will be selected for the next generation
    crossovers = int(population_size / 10)
    mutations = int(population_size / 10)
    ### END SETTINGS

    population: List[List[int]] = __initialize(experiment, population_size, function_performance_models, arguments)
    population, fitness = __calculate_fitness(experiment, function_performance_models, population, arguments)
    generation_counter = 0

    while generation_counter < generations:
        population, fitness = __calculate_fitness(experiment, function_performance_models, population, arguments)
        __print_population(experiment, function_performance_models, population, fitness, arguments)
        population = __select(
            experiment,
            function_performance_models,
            arguments,
            population,
            fitness,
            int(len(population) * selection_strength),
        )
        population = __fill_population(experiment, function_performance_models, arguments, population, population_size)
        population = __crossover(experiment, function_performance_models, arguments, population, crossovers)
        population = __mutate(experiment, function_performance_models, arguments, population, crossovers)
        generation_counter += 1
    population, fitness = __calculate_fitness(experiment, function_performance_models, population, arguments)
    __print_population(experiment, function_performance_models, population, fitness, arguments)
    __dump_result(experiment, population, fitness, optimizer_dir, population_size, generations)


global_experiment = None
global_function_performance_models = None
global_arguments = None


def __calculate_fitness(
    experiment: Experiment,
    function_performance_models: Dict[FunctionRoot, List[Tuple[CostModel, ContextObject]]],
    population: List[List[int]],
    arguments: OptimizerArguments,
) -> Tuple[List[List[int]], List[int]]:
    """returning the population is necessary since the order of the population can change due to multiprocessing"""
    global global_experiment
    global global_function_performance_models
    global global_arguments
    global_experiment = experiment
    global_function_performance_models = function_performance_models
    global_arguments = arguments

    param_list = [(element) for element in population]
    print("Calculating fitness...")
    with Pool(
        initializer=__initialize_worker,
        initargs=(
            experiment,
            function_performance_models,
            arguments,
        ),
    ) as pool:
        tmp_result = list(tqdm.tqdm(pool.imap_unordered(__get_score, param_list), total=len(param_list)))
    population = []
    fitness = []
    for local_result in tmp_result:
        population.append(local_result[0])
        fitness.append(local_result[1])
    return population, fitness


def __initialize_worker(
    experiment: Experiment,
    function_performance_models: Dict[FunctionRoot, List[Tuple[CostModel, ContextObject]]],
    arguments: OptimizerArguments,
):
    global global_experiment
    global global_function_performance_models
    global global_arguments
    global_experiment = experiment
    global_function_performance_models = function_performance_models
    global_arguments = arguments


def __get_score(param_tuple) -> Tuple[List[int], int]:
    global global_experiment
    global global_function_performance_models
    global global_arguments
    configuration = param_tuple
    return configuration, int(
        float(
            str(
                evaluate_configuration(
                    cast(Experiment, global_experiment),
                    cast(Dict[FunctionRoot, List[Tuple[CostModel, ContextObject]]], global_function_performance_models),
                    configuration,
                    cast(OptimizerArguments, global_arguments),
                )[1].evalf()
            )
        )
    )


def __print_population(
    experiment: Experiment,
    function_performance_models: Dict[FunctionRoot, List[Tuple[CostModel, ContextObject]]],
    population: List[List[int]],
    fitness: List[int],
    arguments: OptimizerArguments,
):
    sorted_fitness = sorted(enumerate(fitness), key=lambda x: x[1], reverse=True)
    print("# POPULATION")
    for fitness_idx, fitness_value in sorted_fitness:
        print("#", population[fitness_idx], "->", fitness_value)
    print("# AVG: ", int(sum(fitness) / len(fitness)))
    print()


def __initialize(
    experiment: Experiment,
    population_size: int,
    function_performance_models: Dict[FunctionRoot, List[Tuple[CostModel, ContextObject]]],
    arguments: OptimizerArguments,
) -> List[List[int]]:
    # select random candidates
    population: List[List[int]] = []
    while len(population) < population_size:
        population.append(__get_random_configuration(experiment, function_performance_models, arguments))
    return population


def __fill_population(
    experiment: Experiment,
    function_performance_models: Dict[FunctionRoot, List[Tuple[CostModel, ContextObject]]],
    arguments: OptimizerArguments,
    population: List[List[int]],
    population_size: int,
):
    while len(population) < population_size:
        population.append(__get_random_configuration(experiment, function_performance_models, arguments))
    return population


def __select(
    experiment: Experiment,
    function_performance_models: Dict[FunctionRoot, List[Tuple[CostModel, ContextObject]]],
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
        print("PRESERVED BEST OPTION: ", population[idx], "->", fitness_value)
        break
    return new_population


def __crossover(
    experiment: Experiment,
    function_performance_models: Dict[FunctionRoot, List[Tuple[CostModel, ContextObject]]],
    arguments: OptimizerArguments,
    population: List[List[int]],
    crossovers: int,
):
    counter = 0
    while counter < crossovers:
        # select two random elements
        element_1 = random.choice(population)
        element_2 = random.choice(population)
        # select crossover point
        max_crossover_idx = min(len(element_1), len(element_2))
        crossover_idx = random.choice(range(0, max_crossover_idx))

        new_element_1 = element_1[:crossover_idx] + element_2[crossover_idx:]
        new_element_2 = element_2[:crossover_idx] + element_1[crossover_idx:]

        # validate elements
        if not __check_configuration_validity(experiment, new_element_1):
            continue
        if not __check_configuration_validity(experiment, new_element_2):
            continue

        # update population
        try:
            population.remove(element_1)
            population.remove(element_2)
        except ValueError:
            pass
        population.append(new_element_1)
        population.append(new_element_2)

        counter += 1
    return population


def __mutate(
    experiment: Experiment,
    function_performance_models: Dict[FunctionRoot, List[Tuple[CostModel, ContextObject]]],
    arguments: OptimizerArguments,
    population: List[List[int]],
    mutations: int,
) -> List[List[int]]:
    counter = 0
    while counter < mutations:
        # select random mutation target from population
        mutation_target = random.choice(population)

        # select random mutation within the target
        mutation_index = random.choice(range(0, len(mutation_target)))

        # perform mutation if possible
        options = get_out_options(experiment.optimization_graph, mutation_target[mutation_index])
        if len(options) > 0:
            index_mutant = random.choice(options)
            mutant = copy.deepcopy(mutation_target)
            mutant[mutation_index] = index_mutant

            # validate
            if not __check_configuration_validity(experiment, mutant):
                continue

            # update population
            try:
                population.remove(mutation_target)
            except ValueError:
                pass
            population.append(mutant)
        counter += 1
    return population


def __dump_result(
    experiment: Experiment,
    population: List[List[int]],
    fitness: List[int],
    optimizer_dir: str,
    population_size: int,
    generations: int,
):
    # replace keys to allow dumping
    dumpable_dict = dict()
    for idx, key in enumerate(population):
        new_key = []
        for entry in key:
            # find pattern id
            for pattern_id in experiment.suggestion_to_node_id_dict:
                if entry == experiment.suggestion_to_node_id_dict[pattern_id]:
                    new_key.append(pattern_id)
        dumpable_dict[str(new_key)] = str(fitness[idx])

    dump_path: str = os.path.join(
        optimizer_dir, "evolutionary_results_" + str(population_size) + "x" + str(generations) + ".json"
    )
    with open(dump_path, "w") as fp:
        json.dump(dumpable_dict, fp)

    # dump the best option
    for idx, fitness_value in sorted(enumerate(fitness), key=lambda x: x[1]):
        new_key_2 = []
        for node_id in population[idx]:
            # find pattern id
            for pattern_id in experiment.suggestion_to_node_id_dict:
                if node_id == experiment.suggestion_to_node_id_dict[pattern_id]:
                    new_key_2.append(
                        str(pattern_id) + "@" + str(data_at(experiment.optimization_graph, node_id).device_id)
                    )
        best_option_path: str = os.path.join(optimizer_dir, "evolutionary_optimum.txt")
        with open(best_option_path, "w") as fp:
            fp.write(" ".join(new_key_2))
        break


def __check_configuration_validity(experiment: Experiment, configuration: List[int]) -> bool:
    """Returns True if the given configuration is valid. Returns False otherwise."""
    warnings.warn("TODO: VALIDITY CHECK NOT IMPLEMENTED")
    # todo check requirements edges
    for node_id in configuration:
        requirements = get_requirements(experiment.optimization_graph, node_id)
        for r in requirements:
            if r not in configuration:
                # requirement not satisfied
                return False

    # todo check option edges (for mutual exclusivity)
    for node_id in configuration:
        mutex_options = get_out_mutex_edges(experiment.optimization_graph, node_id)
        if len([e for e in configuration if e in mutex_options]) != 0:
            # mutual exclusivity of suggestions violated
            return False

    return True


def __get_random_configuration(
    experiment: Experiment,
    function_performance_models: Dict[FunctionRoot, List[Tuple[CostModel, ContextObject]]],
    arguments: OptimizerArguments,
):
    while True:
        random_configuration: List[int] = []
        # fill configuration
        for function in function_performance_models:
            options = [tpl[0].path_decisions for tpl in function_performance_models[function]]
            random_configuration += random.choice(options)

        # validate configuration
        if __check_configuration_validity(experiment, random_configuration):
            return random_configuration
