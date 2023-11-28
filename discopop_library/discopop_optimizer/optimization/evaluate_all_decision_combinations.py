from typing import Dict, List, Tuple, cast
from discopop_library.discopop_optimizer.CostModels.CostModel import CostModel
from discopop_library.discopop_optimizer.OptimizerArguments import OptimizerArguments
from discopop_library.discopop_optimizer.Variables.Experiment import Experiment
from discopop_library.discopop_optimizer.classes.context.ContextObject import ContextObject
from discopop_library.discopop_optimizer.classes.nodes.FunctionRoot import FunctionRoot
from discopop_library.discopop_optimizer.optimization.evaluate import evaluate_configuration
from itertools import product


def evaluate_all_decision_combinations(
    experiment: Experiment,
    function_performance_models: Dict[FunctionRoot, List[Tuple[CostModel, ContextObject]]],
    arguments: OptimizerArguments,
):
    """Create and evaluate every possible combination of decisions"""
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
    for tuple in raw_combinations:
        tmp: List[int] = []
        for decision_list in tuple:
            for decision in decision_list:
                tmp.append(decision)
        combinations.append(tmp)

    # evaluate each combination
    print("# Calculating costs of all decision combinations...")
    for combination in combinations:
        print(
            "#",
            combination,
            " = ",
            str(evaluate_configuration(experiment, function_performance_models, combination, arguments)),
        )
    print()
    pass
