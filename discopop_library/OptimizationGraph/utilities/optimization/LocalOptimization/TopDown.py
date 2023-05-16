from typing import Dict, List, Tuple, Set

import networkx as nx  # type: ignore
from sympy import Symbol, Expr

from discopop_library.OptimizationGraph.CostModels.CostModel import CostModel
from discopop_library.OptimizationGraph.CostModels.utilities import get_node_performance_models
from discopop_library.OptimizationGraph.classes.context.ContextObject import ContextObject
from discopop_library.OptimizationGraph.classes.nodes.FunctionRoot import FunctionRoot
from discopop_library.OptimizationGraph.utilities.MOGUtilities import get_all_function_nodes, get_successors, \
    get_children


def get_locally_optimized_models(graph: nx.DiGraph, substitutions: Dict[Symbol, Expr]) -> Dict[
    FunctionRoot, List[Tuple[CostModel, ContextObject]]]:
    result_dict: Dict[FunctionRoot, List[Tuple[CostModel, ContextObject]]] = dict()
    for function_node in get_all_function_nodes(graph):
        # get a list of all decisions that have to be made
        decisions_to_be_made = __find_decisions(graph, function_node)

        # create performance models for individual options of decisions
        for decision_options in decisions_to_be_made:
            print("Decision options: ", decision_options)
            for decision in decision_options:
                print("DECISION: ", decision)
                # create a performance model for the specific decision
                print("\trestrict to: ", {decision})
                print("\tdo not allow: ", set(
                                                                     [o for o in decision_options if o != decision]))
                performance_models = get_node_performance_models(graph, function_node, set(),
                                                                 restrict_to_decisions={decision},
                                                                 do_not_allow_decisions=set(
                                                                     [o for o in decision_options if o != decision]))
                print("PERFORMANCE MODELS: ")
                for model in performance_models:
                    print(model.path_decisions)

                #            for entry in decision:
                #                print("\tEntry: ")
                #                print(data_at(graph, entry).suggestion)

                #        def get_node_performance_models(
                #                graph: nx.DiGraph, node_id: int, visited_nodes: Set[int],
                #                restrict_to_decisions: Optional[Set[int]] = None
                #
                #
                #            locally_optimal_choices: List[int] = []

                import sys
                sys.exit(0)

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
