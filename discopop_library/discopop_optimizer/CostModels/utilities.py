# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
import copy
import random
from typing import List, Dict, cast, Set, Optional

import networkx as nx  # type: ignore
import sympy  # type: ignore
from sympy import Integer  # type: ignore

from discopop_library.discopop_optimizer.CostModels.CostModel import CostModel
from discopop_library.discopop_optimizer.classes.nodes.FunctionRoot import FunctionRoot
from discopop_library.discopop_optimizer.classes.nodes.GenericNode import GenericNode
from discopop_library.discopop_optimizer.utilities.MOGUtilities import (
    get_successors,
    get_children,
    data_at,
    get_edge_data,
    get_requirements,
    get_out_options,
    get_in_options,
)


def get_performance_models_for_functions(graph: nx.DiGraph) -> Dict[FunctionRoot, List[CostModel]]:
    performance_models: Dict[FunctionRoot, List[CostModel]] = dict()
    for node_id in graph.nodes:
        node_data = graph.nodes[node_id]["data"]
        node_data.node_id = node_id  # fix potential mismatches due to node copying

        if isinstance(node_data, FunctionRoot):
            performance_models[node_data] = get_node_performance_models(graph, node_id, set())

            # filter out NaN - Models
            performance_models[node_data] = [
                model
                for model in performance_models[node_data]
                if model.parallelizable_costs != sympy.nan
            ]
    return performance_models


def get_node_performance_models(
    graph: nx.DiGraph,
    node_id: int,
    visited_nodes: Set[int],
    restrict_to_decisions: Optional[Set[int]] = None,
    do_not_allow_decisions: Optional[Set[int]] = None,
    get_single_random_model: bool = False,
) -> List[CostModel]:
    """Returns the performance models for the given node.
    If a set of decision is specified for restrict_to_decisions, only those non-sequential decisions will be allowed.
    """
    result_list: List[CostModel] = []
    print("NODE ID: ", node_id)
    print("\ttype: ", type(node_id))
    print("\tgraph: ", type(graph))
    successors = get_successors(graph, node_id)
    print("SUCCS: ", successors)
    successor_count = len(successors)
    node_data = cast(GenericNode, data_at(graph, node_id))
    visited_nodes.add(node_id)

    # consider performance models of children
    children_models = get_performance_models_for_children(
        graph,
        node_id,
        copy.deepcopy(visited_nodes),
        restrict_to_decisions=restrict_to_decisions,
        do_not_allow_decisions=do_not_allow_decisions,
        get_single_random_model=get_single_random_model,
    )

    if len(children_models) == 0:
        children_models = [node_data.get_cost_model()]
    else:
        tmp_node_cost_model = node_data.get_cost_model()
        for idx, child_model in enumerate(children_models):
            children_models[idx] = child_model.parallelizable_plus_combine(tmp_node_cost_model)

    # construct the performance models
    if successor_count >= 1:
        removed_successors = False
        if get_single_random_model and successor_count > 1:
            # pick only a single successor
            successors = [random.choice(successors)]
            removed_successors = True

        for children_model in children_models:
            for successor in successors:
                # ## CHECK REQUIREMENTS ##
                # check if successor validates a requirements edge to restrain the created combinations
                # 1.1. check if optionEdge between any node in visited_nodes and successor exists
                # 1.2. if so, check if option edge to other node in visited nodes exists
                # 1.3. if so, check if a requirements edge between both option exists.
                # 1.4. if not, the path is not valid since two options for the same
                #      source code location would be selected
                path_invalid = False
                # 1.1
                for visited_node_id in visited_nodes:
                    options = get_out_options(graph, visited_node_id)
                    if successor in options:
                        # 1.2
                        visited_options = [opt for opt in options if opt in visited_nodes]
                        if len(visited_options) > 0:
                            # 1.3
                            for vo in visited_options:
                                # 1.4
                                if successor not in get_requirements(graph, vo):
                                    path_invalid = True
                                    break
                    if path_invalid:
                        break
                if path_invalid:
                    continue

                # 2 check if a sibling of successor exists which has a requirements edge to a visited node
                # 2.1 check if an incoming or outgoing option edge exists, get the node id for the sequential version
                # 2.2 for all parallelization options
                # 2.3 check if a requirements edge to a visited node exists
                # 2.4 if so, stop if successor is NOT the parallelization option with the requirements edge
                # 2.1
                for sibling in successors:
                    sequential_version_ids = []
                    if len(get_out_options(graph, sibling)) > 0:
                        sequential_version_ids = [sibling]
                    else:
                        for seq in get_in_options(graph, sibling):
                            sequential_version_ids.append(seq)
                    # 2.2
                    for seq in sequential_version_ids:
                        for option in get_out_options(graph, seq):
                            # 2.3
                            for visited_req in [
                                req
                                for req in get_requirements(graph, option)
                                if req in visited_nodes
                            ]:
                                # 2.4
                                if visited_req != successor:
                                    path_invalid = True
                                    break
                            if path_invalid:
                                break
                    if path_invalid:
                        break

                # check if the current decision invalidates decision requirements, if some are specified
                if restrict_to_decisions is not None:
                    if not (
                        successor in restrict_to_decisions
                        or data_at(graph, successor).suggestion is None
                    ):
                        path_invalid = True
                    if not path_invalid:
                        if data_at(graph, successor).suggestion is None:
                            # if the sequential "fallback" has been used, check if a different option is specifically
                            # mentioned in restrict_to_decisions. If so, the sequential fallback shall be ignored.
                            options = get_out_options(graph, successor)
                            restricted_options = [
                                opt for opt in options if opt in restrict_to_decisions
                            ]
                            if len(restricted_options) != 0:
                                # do not use he sequential fallback since a required option exists
                                path_invalid = True

                if do_not_allow_decisions is not None:
                    if successor in do_not_allow_decisions:
                        path_invalid = True

                if path_invalid:
                    continue

                # ## END OF REQUIREMENTS CHECK ##

                combined_model = children_model
                # add transfer costs
                transfer_costs_model = get_edge_data(graph, node_id, successor).get_cost_model()
                combined_model = combined_model.parallelizable_plus_combine(transfer_costs_model)

                # if the successor is "determined" by a path decision, add path decision to the combined model
                if len(successors) > 1 or removed_successors:
                    combined_model.path_decisions.append(successor)
                # append the model of the successor
                for model in get_node_performance_models(
                    graph,
                    successor,
                    copy.deepcopy(visited_nodes),
                    restrict_to_decisions=restrict_to_decisions,
                    do_not_allow_decisions=do_not_allow_decisions,
                    get_single_random_model=get_single_random_model,
                ):
                    result_list.append(combined_model.parallelizable_plus_combine(model))
        return result_list

    # successor count == 0 or successor count > 1
    return children_models


def get_performance_models_for_children(
    graph: nx.DiGraph,
    node_id: int,
    visited_nodes: Set[int],
    restrict_to_decisions: Optional[Set[int]] = None,
    do_not_allow_decisions: Optional[Set[int]] = None,
    get_single_random_model: bool = False,
) -> List[CostModel]:
    """Construct a performance model for the children of the given node, or return None if no children exist"""
    # todo: consider children
    child_models: List[CostModel] = []

    # create all combinations for models from children
    first_iteration = True
    for child_id in get_children(graph, node_id):
        if first_iteration:
            first_iteration = False
            for model in get_node_performance_models(
                graph,
                child_id,
                copy.deepcopy(visited_nodes),
                restrict_to_decisions=restrict_to_decisions,
                do_not_allow_decisions=do_not_allow_decisions,
                get_single_random_model=get_single_random_model,
            ):
                # initialize list of child models
                child_models.append(model)
        else:
            # create "product set" of child models
            product_set = []
            for model in get_node_performance_models(
                graph,
                child_id,
                copy.deepcopy(visited_nodes),
                restrict_to_decisions=restrict_to_decisions,
                do_not_allow_decisions=do_not_allow_decisions,
                get_single_random_model=get_single_random_model,
            ):
                temp_models = [cm.parallelizable_plus_combine(model) for cm in child_models]
                product_set += temp_models
            child_models = product_set
    return child_models


def print_introduced_symbols_per_node(graph: nx.DiGraph):
    print("Introduced Symbols:")
    for node_id in graph.nodes:
        print("NodeID: ", node_id)
        for symbol in data_at(graph, node_id).introduced_symbols:
            print("\t: ", symbol)
    print()


def get_random_path(
    graph: nx.DiGraph, root_id: int, must_contain: Optional[Set[int]] = None
) -> CostModel:
    random_models = get_node_performance_models(
        graph, root_id, set(), restrict_to_decisions=must_contain, get_single_random_model=True
    )
    # filter out NaN - Models
    random_models = [model for model in random_models if model.parallelizable_costs != sympy.nan]
    return random.choice(random_models)
