import json
from multiprocessing import Pool
import os
from typing import Dict, List, Tuple, cast

from sympy import Expr
import tqdm  # type: ignore
from discopop_library.discopop_optimizer.CostModels.CostModel import CostModel
from discopop_library.discopop_optimizer.OptimizerArguments import OptimizerArguments
from discopop_library.discopop_optimizer.Variables.Experiment import Experiment
from discopop_library.discopop_optimizer.classes.context.ContextObject import ContextObject
from discopop_library.discopop_optimizer.classes.nodes.FunctionRoot import FunctionRoot
from discopop_library.discopop_optimizer.optimization.evaluate import evaluate_configuration
from itertools import product


global_experiment = None
global_function_performance_models = None
global_arguments = None


def evaluate_all_decision_combinations(
    experiment: Experiment,
    function_performance_models: Dict[FunctionRoot, List[Tuple[CostModel, ContextObject]]],
    arguments: OptimizerArguments,
    optimizer_dir: str,
) -> Dict[Tuple[int, ...], Expr]:
    """Create and evaluate every possible combination of decisions"""
    global global_experiment
    global global_function_performance_models
    global global_arguments
    global_experiment = experiment
    global_function_performance_models = function_performance_models
    global_arguments = arguments

    costs_dict: Dict[Tuple[int, ...], Expr] = dict()

    # preapare available decisions
    available_decisions: Dict[FunctionRoot, List[List[int]]] = dict()
    for function in function_performance_models:
        available_decisions[function] = []
        for entry in function_performance_models[function]:
            available_decisions[function].append(entry[0].path_decisions)

    packed_decisions: List[List[List[int]]] = []
    for function in available_decisions:
        packed_decisions.append(available_decisions[function])

    # create combinations of decisions
    raw_combinations: List[Tuple[List[int], ...]] = cast(List[Tuple[List[int], ...]], product(*packed_decisions))
    # clean the combinations into List[int]
    combinations: List[List[int]] = []
    for tpl in raw_combinations:
        tmp: List[int] = []
        for decision_list in tpl:
            for decision in decision_list:
                tmp.append(decision)
        combinations.append(tmp)

    # evaluate each combination in parallel
    print("# Parallel calculatiion of costs of all decision combinations...")
    param_list = [(combination_list) for combination_list in combinations]
    with Pool(
        initializer=__initialize_worker,
        initargs=(
            experiment,
            function_performance_models,
            arguments,
        ),
    ) as pool:
        tmp_result = list(tqdm.tqdm(pool.imap_unordered(__evaluate_configuration, param_list), total=len(param_list)))
    for local_result in tmp_result:
        # result += local_result
        print("#", local_result[0], "=", str(local_result[1]))
        costs_dict[local_result[0]] = local_result[1]

    # print the sorted result for improved readability
    print("# Sorted and simplified costs of all combinations")
    for combination_tuple in sorted(costs_dict.keys(), key=lambda x: costs_dict[x], reverse=True):
        print(
            "#",
            combination_tuple,
            " = ",
            str(costs_dict[combination_tuple].evalf()),
        )

    print("# Sorted and simplified costs of all combinations")
    print()

    __dump_result_to_file(optimizer_dir, costs_dict)

    return costs_dict


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


def __evaluate_configuration(param_tuple):
    global global_experiment
    global global_function_performance_models
    global global_arguments
    decisions = param_tuple
    return evaluate_configuration(global_experiment, global_function_performance_models, decisions, global_arguments)


def __dump_result_to_file(optimizer_dir: str, costs_dict: Dict[Tuple[int, ...], Expr]):
    # replace keys to allow dumping
    dumpable_dict = dict()
    for key in costs_dict:
        dumpable_dict[str(key)] = str(costs_dict[key].evalf())

    dump_path: str = os.path.join(optimizer_dir, "all_combination_costs.json")
    with open(dump_path, "w") as fp:
        json.dump(dumpable_dict, fp)
