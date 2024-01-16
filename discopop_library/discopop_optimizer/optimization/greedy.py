# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
import json
from multiprocessing import Pool
import os
from typing import Dict, List, Optional, Set, Tuple, cast

from sympy import Expr
import tqdm  # type: ignore
from discopop_explorer.PEGraphX import NodeID  # type: ignore

from discopop_library.discopop_optimizer.CostModels.CostModel import CostModel
from discopop_library.discopop_optimizer.OptimizerArguments import OptimizerArguments
from discopop_library.discopop_optimizer.Variables.Experiment import Experiment
from discopop_library.discopop_optimizer.classes.context.ContextObject import ContextObject
from discopop_library.discopop_optimizer.classes.nodes.FunctionRoot import FunctionRoot
from discopop_library.discopop_optimizer.optimization.evaluate import evaluate_configuration
from itertools import product
from discopop_library.discopop_optimizer.optimization.validation import check_configuration_validity

from discopop_library.discopop_optimizer.utilities.simple_utilities import data_at
from discopop_library.result_classes.OptimizerOutputPattern import OptimizerOutputPattern


global_experiment = None
global_arguments = None


def greedy_search(
    experiment: Experiment,
    available_decisions: Dict[FunctionRoot, List[List[int]]],
    arguments: OptimizerArguments,
    optimizer_dir: str,
) -> Optional[OptimizerOutputPattern]:
    """find a good combination of suggestions via greedy search"""
    global global_experiment
    global global_arguments
    global_experiment = experiment
    global_arguments = arguments

    costs_dict: Dict[Tuple[int, ...], Expr] = dict()
    contexts_dict: Dict[Tuple[int, ...], ContextObject] = dict()

    print("AVIAL:")
    print(available_decisions)

    import sys
    sys.exit(0)
    
    # get list of all combinations
    combinations: List[List[int]] = []
    for c in product(*combinations_by_function.values()):
        combination_list: List[int] = []
        for function_decisions in c:
            for entry in function_decisions:
                combination_list.append(entry)
        # remove invalid combinations
        if check_configuration_validity(experiment, arguments, combination_list):
            combinations.append(combination_list)

    # evaluate each combination in parallel
    print("# Parallel calculation of costs of all decision combinations...")
    param_list = [(combination_list) for combination_list in combinations]
    with Pool(
        initializer=__initialize_worker,
        initargs=(
            experiment,
            arguments,
        ),
    ) as pool:
        tmp_result = list(tqdm.tqdm(pool.imap_unordered(__evaluate_configuration, param_list), total=len(param_list)))

    #    tmp_result = []
    #    for p in param_list:
    #        tmp_result.append(__evaluate_configuration(p))

    for local_result in tmp_result:
        # result += local_result
        if local_result is not None:
            costs_dict[local_result[0]] = local_result[1]
            contexts_dict[local_result[0]] = local_result[2]

    if arguments.verbose:
        print()

        # print the sorted result for improved readability
        print("# Sorted and simplified costs of all combinations using PATH NODE IDS")
        for combination_tuple in sorted(costs_dict.keys(), key=lambda x: costs_dict[x], reverse=True):
            print(
                "#",
                combination_tuple,
                " = ",
                str(costs_dict[combination_tuple].evalf()),
            )
        print("# Sorted and simplified costs of all combinations using PATH NODE IDS")
        print()

        # print the sorted result list using parallel pattern ids for improved interpretability
        print("# Sorted and simplified costs of all combinations using PARALLEL PATTERN IDS")
        for combination_tuple in sorted(costs_dict.keys(), key=lambda x: costs_dict[x], reverse=True):
            new_key = []
            for node_id in combination_tuple:
                # find pattern id
                for pattern_id in experiment.suggestion_to_node_ids_dict:
                    if node_id in experiment.suggestion_to_node_ids_dict[pattern_id]:
                        new_key.append(
                            str(pattern_id) + "@" + str(data_at(experiment.optimization_graph, node_id).device_id)
                        )
            if len(new_key) == 0:
                print("EMPTY: ", combination_tuple)
                print(experiment.suggestion_to_node_ids_dict)

            print(
                "#",
                new_key,
                " = ",
                str(costs_dict[combination_tuple].evalf()),
            )
        print("# Sorted and simplified costs of all combinations using PARALLEL PATTERN IDS")
        print()

    return __dump_result_to_file_using_pattern_ids(experiment, optimizer_dir, costs_dict, contexts_dict, arguments)


def __initialize_worker(
    experiment: Experiment,
    arguments: OptimizerArguments,
):
    global global_experiment
    global global_arguments
    global_experiment = experiment
    global_arguments = arguments


def __evaluate_configuration(param_tuple):
    global global_experiment
    global global_arguments
    decisions = param_tuple
    return evaluate_configuration(global_experiment, decisions, global_arguments)


def __dump_result_to_file_using_pattern_ids(
    experiment: Experiment,
    optimizer_dir: str,
    costs_dict: Dict[Tuple[int, ...], Expr],
    contexts_dict: Dict[Tuple[int, ...], ContextObject],
    arguments: OptimizerArguments,
) -> Optional[OptimizerOutputPattern]:
    # replace keys to allow dumping
    dumpable_dict = dict()
    for key in costs_dict:
        new_key = []
        for entry in key:
            # find pattern id
            for pattern_id in experiment.suggestion_to_node_ids_dict:
                if entry in experiment.suggestion_to_node_ids_dict[pattern_id]:
                    new_key.append(str(pattern_id) + "@" + str(data_at(experiment.optimization_graph, entry).device_id))
        dumpable_dict[str(new_key)] = str(int(float(str(costs_dict[key].evalf()))))

    dump_path: str = os.path.join(optimizer_dir, "exhaustive_results.json")
    with open(dump_path, "w") as fp:
        json.dump(dumpable_dict, fp)

    # dump the best option
    for combination_tuple in sorted(costs_dict.keys(), key=lambda x: costs_dict[x]):
        new_key_2 = []
        best_configuration = None
        # collect applied suggestions
        for node_id in combination_tuple:
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
        for update in contexts_dict[combination_tuple].necessary_updates:
            best_configuration.add_data_movement(update)
        # export results to file
        best_option_id_path: str = os.path.join(optimizer_dir, "exhaustive_pattern_id.txt")
        with open(best_option_id_path, "w+") as f:
            f.write(str(best_configuration.pattern_id))

        return best_configuration
    raise ValueError("No configuration found!")
