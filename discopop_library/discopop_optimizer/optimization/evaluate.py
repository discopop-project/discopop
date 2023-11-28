import copy
from typing import Dict, List, Optional, Tuple, cast

from sympy import Expr, Integer, Symbol
import sympy
from discopop_library.discopop_optimizer.CostModels.CostModel import CostModel
from discopop_library.discopop_optimizer.CostModels.utilities import get_node_performance_models

from discopop_library.discopop_optimizer.Variables.Experiment import Experiment
from discopop_library.discopop_optimizer.classes.context.ContextObject import ContextObject
from discopop_library.discopop_optimizer.classes.nodes.FunctionRoot import FunctionRoot
from discopop_library.discopop_optimizer.utilities.MOGUtilities import data_at, get_all_function_nodes
from discopop_library.discopop_optimizer.OptimizerArguments import OptimizerArguments


def evaluate_configuration(
    experiment: Experiment,
    function_performance_models: Dict[FunctionRoot, List[Tuple[CostModel, ContextObject]]],
    decisions: List[int],
    arguments: OptimizerArguments,
) -> Expr:
    """Evaluate the configuration specified by the decisions for the current set of substitutions.
    Note: To compare values across ranges of system specifications, use the ranges obtainable via System.get_symbol_values_and_distributions 
    to update the substitutions and execute evaluate_configuration for each set of values."""
    result = Expr(-42)
    # get main function
    main_function: Optional[FunctionRoot] = None
    funciton_node_ids = get_all_function_nodes(experiment.optimization_graph)
    function_root_nodes = [cast(FunctionRoot, data_at(experiment.optimization_graph, fid)) for fid in funciton_node_ids]
    for function_id in funciton_node_ids:
        if cast(FunctionRoot, data_at(experiment.optimization_graph, function_id)).name == "main":
            main_function = cast(FunctionRoot, data_at(experiment.optimization_graph, function_id))
    if main_function is None:
        raise ValueError("No main function found!")

    # identify function models which correspond to the given decisions
    selected_function_models: Dict[FunctionRoot, Tuple[CostModel, ContextObject]] = dict()
    for function in function_performance_models:
        # get the correct model according to the selected decisions
        selected_function_model: Optional[Tuple[CostModel, ContextObject]] = None
        for tuple in function_performance_models[function]:
            cost, ctx = tuple
            # check if all decisions are specified
            if set(cost.path_decisions).issubset(set(decisions)):
                selected_function_model = tuple
                selected_function_models[function] = selected_function_model
        if selected_function_model is None:
            raise ValueError(
                "No valid configuration found for function: "
                + function.name
                + " and specified decisions: "
                + str(decisions)
            )

    # apply selected substitutions
    # collect substitutions
    local_substitutions = copy.deepcopy(experiment.substitutions)
    for function in function_performance_models:
        # register substitution
        local_substitutions[cast(Symbol, function.sequential_costs)] = selected_function_models[function][
            0
        ].sequential_costs
        local_substitutions[cast(Symbol, function.parallelizable_costs)] = selected_function_models[function][
            0
        ].parallelizable_costs

    result_model = copy.deepcopy(selected_function_models[main_function][0])

    # perform iterative substitutions
    modification_found = True
    while modification_found:
        modification_found = False
        # apply substitution to parallelizable costs
        tmp_model = result_model.parallelizable_costs.subs(local_substitutions)
        if tmp_model != result_model.parallelizable_costs:
            modification_found = True
        result_model.parallelizable_costs = tmp_model

        # apply substitutions to sequential costs
        tmp_model = result_model.sequential_costs.subs(local_substitutions)
        if tmp_model != result_model.sequential_costs:
            modification_found = True
        result_model.sequential_costs = result_model.sequential_costs.subs(local_substitutions)

    # replace Expr(0) with 0
    result_model.sequential_costs = result_model.sequential_costs.subs({Expr(Integer(0)): Integer(0)})
    result_model.parallelizable_costs = result_model.parallelizable_costs.subs({Expr(Integer(0)): Integer(0)})

    # unmark replaced free symbols
    local_sorted_free_symbols = copy.deepcopy(experiment.sorted_free_symbols)
    local_free_symbol_ranges = copy.deepcopy(experiment.free_symbol_ranges)
    for symbol in experiment.substitutions:
        if symbol in experiment.free_symbols:
            experiment.free_symbols.remove(symbol)
        if symbol in local_free_symbol_ranges:
            del local_free_symbol_ranges[symbol]
        if symbol in local_sorted_free_symbols:
            local_sorted_free_symbols.remove(symbol)

    # calculate costs
    result = sympy.re(result_model.parallelizable_costs + result_model.sequential_costs) + sympy.im(
        result_model.parallelizable_costs + result_model.sequential_costs
    )
    return result
