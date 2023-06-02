from typing import Dict, List, Tuple, Set, cast

import networkx as nx  # type: ignore
from sympy import Symbol, Expr

from discopop_library.discopop_optimizer.CostModels.CostModel import CostModel
from discopop_library.discopop_optimizer.CostModels.DataTransfer.DataTransferCosts import (
    add_data_transfer_costs,
)
from discopop_library.discopop_optimizer.CostModels.utilities import get_node_performance_models
from discopop_library.discopop_optimizer.DataTransfers.DataTransfers import calculate_data_transfers
from discopop_library.discopop_optimizer.Variables.Environment import Environment
from discopop_library.discopop_optimizer.classes.context.ContextObject import ContextObject
from discopop_library.discopop_optimizer.classes.enums.Distributions import FreeSymbolDistribution
from discopop_library.discopop_optimizer.classes.nodes.FunctionRoot import FunctionRoot
from discopop_library.discopop_optimizer.utilities.MOGUtilities import (
    get_all_function_nodes,
    get_successors,
    get_children,
    data_at,
    show,
)


def get_locally_optimized_models(
    graph: nx.DiGraph,
    substitutions: Dict[Symbol, Expr],
    environment: Environment,
    free_symbol_ranges: Dict[Symbol, Tuple[float, float]],
    free_symbol_distributions: Dict[Symbol, FreeSymbolDistribution],
) -> Dict[FunctionRoot, List[Tuple[CostModel, ContextObject]]]:
    result_dict: Dict[FunctionRoot, List[Tuple[CostModel, ContextObject]]] = dict()
    for function_node in get_all_function_nodes(graph):
        # get a list of all decisions that have to be made
        decisions_to_be_made = __find_decisions(graph, function_node)
        locally_optimal_choices: List[int] = []

        # create performance models for individual options of decisions
        for decision_options in decisions_to_be_made:
            print("Decision options: ", decision_options)
            decision_models: List[Tuple[int, Tuple[CostModel, ContextObject]]] = []
            for decision in decision_options:
                try:
                    # create a performance model for the specific decision
                    performance_models = get_node_performance_models(
                        graph,
                        function_node,
                        set(),
                        restrict_to_decisions={decision},
                        do_not_allow_decisions=set([o for o in decision_options if o != decision]),
                    )
                    # calculate and append necessary data transfers to the models
                    performance_models_with_transfers = calculate_data_transfers(
                        graph,
                        {cast(FunctionRoot, data_at(graph, function_node)): performance_models},
                    )

                    # calculate and append costs of data transfers to the performance models
                    complete_performance_models = add_data_transfer_costs(
                        graph, performance_models_with_transfers, environment
                    )
                    # add performance models to decision models for the later selection of the best candidate
                    for function in complete_performance_models:
                        for pair in complete_performance_models[function]:
                            decision_models.append((decision, pair))
                except ValueError as ex:
                    print(ex)
                    print("==> Ignoring Decision: ", decision)
                    continue

            #            print("Decisions MODELS: ")
            #            for model in decision_models:
            #                print()
            #                print(model.path_decisions)
            #                print(model.sequential_costs + model.parallelizable_costs)

            # apply variable substitutions
            for decision, pair in decision_models:
                model, context = pair
                model.parallelizable_costs = model.parallelizable_costs.subs(substitutions)
                model.sequential_costs = model.sequential_costs.subs(substitutions)

            # set free symbol ranges and distributions for comparisons
            for decision, pair in decision_models:
                model, context = pair
                model.free_symbol_ranges = free_symbol_ranges
                model.free_symbol_distributions = free_symbol_distributions

            # find minimum in decision_models
            unpacked_models: List[Tuple[int, CostModel]] = []
            for decision, pair in decision_models:
                model, context = pair
                unpacked_models.append((decision, model))
            minimum = sorted(unpacked_models, key=lambda x: x[1])[0]
            print()
            print("MINIMUM: ", minimum)
            print("DEC: ", minimum[0])
            print("PATH: ", minimum[1].path_decisions)
            print()
            locally_optimal_choices.append(minimum[0])

        print("FUNCTION: ", function_node)
        print("\tChoices: ", locally_optimal_choices)

        # construct locally optimal model
        performance_models = get_node_performance_models(
            graph, function_node, set(), restrict_to_decisions=set(locally_optimal_choices)
        )
        print("GOT: ", [p.path_decisions for p in performance_models])
        # calculate and append necessary data transfers to the models
        performance_models_with_transfers = calculate_data_transfers(
            graph, {cast(FunctionRoot, data_at(graph, function_node)): performance_models}
        )

        # calculate and append costs of data transfers to the performance models
        complete_performance_models = add_data_transfer_costs(
            graph, performance_models_with_transfers, environment
        )
        result_dict = result_dict | complete_performance_models

    print(result_dict)
    for key in result_dict:
        print("KEY: ", key)
        for entry in result_dict[key]:
            print("ENTRY: ", entry[0].path_decisions)

    return result_dict


def __find_decisions(graph: nx.DiGraph, root_node: int) -> Set[Tuple[int, ...]]:
    result_set: Set[Tuple[int, ...]] = set()
    successors = get_successors(graph, root_node)
    children = get_children(graph, root_node)

    # check if children have decisions
    for child in children:
        result_set.update(__find_decisions(graph, child))

    # check if current node has a decision
    if len(successors) > 1:
        local_decision = list()
        for successor in successors:
            local_decision.append(successor)
        result_set.add(tuple(local_decision))

    # check if successors have decisions
    for successor in successors:
        result_set.update(__find_decisions(graph, successor))

    return result_set
