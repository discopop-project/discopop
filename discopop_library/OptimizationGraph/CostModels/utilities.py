# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
import copy
from typing import List, Dict, cast, Set

import networkx as nx  # type: ignore
from sympy import Integer  # type: ignore

from discopop_library.OptimizationGraph.CostModels.CostModel import CostModel
from discopop_library.OptimizationGraph.classes.nodes.FunctionRoot import FunctionRoot
from discopop_library.OptimizationGraph.classes.nodes.GenericNode import GenericNode
from discopop_library.OptimizationGraph.utilities.MOGUtilities import get_successors, get_children, data_at, \
    get_edge_data, get_requirements, get_out_options, get_in_options


def get_performance_models_for_functions(graph: nx.DiGraph) -> Dict[FunctionRoot, List[CostModel]]:
    performance_models: Dict[FunctionRoot, List[CostModel]] = dict()
    for node_id in graph.nodes:
        node_data = graph.nodes[node_id]["data"]
        if isinstance(node_data, FunctionRoot):
            performance_models[node_data] = get_node_performance_models(graph, node_id, set())
    return performance_models


def get_node_performance_models(graph: nx.DiGraph, node_id: int, visited_nodes: Set[int]) -> List[CostModel]:
    """Returns the performance models for the given node"""
    result_list: List[CostModel] = []
    successors = get_successors(graph, node_id)
    successor_count = len(successors)
    node_data = cast(GenericNode, data_at(graph, node_id))
    visited_nodes.add(node_id)

    # consider performance models of children
    children_models = get_performance_models_for_children(graph, node_id, copy.deepcopy(visited_nodes))

    if len(children_models) == 0:
        children_models = [node_data.get_cost_model()]
    else:
        tmp_node_cost_model = node_data.get_cost_model()
        for idx, child_model in enumerate(children_models):
            children_models[idx] = child_model.plus_combine(tmp_node_cost_model)

    # construct the performance models
    if successor_count >= 1:
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
                            for visited_req in [req for req in get_requirements(graph, option) if req in visited_nodes]:
                                # 2.4
                                if visited_req != successor:
                                    path_invalid = True
                                    break
                            if path_invalid:
                                break
                    if path_invalid:
                        break
                if path_invalid:
                    continue
                # ## END OF REQUIREMENTS CHECK ##

                combined_model = children_model
                # add transfer costs
                transfer_costs_model = get_edge_data(graph, node_id, successor).get_cost_model()
                combined_model = combined_model.plus_combine(transfer_costs_model)
                # append the model of the successor
                for model in get_node_performance_models(graph, successor, copy.deepcopy(visited_nodes)):
                    result_list.append(combined_model.plus_combine(model))
        return result_list

    # successor count == 0 or successor count > 1
    return children_models


def get_performance_models_for_children(graph: nx.DiGraph, node_id: int, visited_nodes: Set[int]) -> List[CostModel]:
    """Construct a performance model for the children of the given node, or return None if no children exist"""
    # todo: consider children
    child_models: List[CostModel] = []

    # create all combinations for models from children
    first_iteration = True
    for child_id in get_children(graph, node_id):
        if first_iteration:
            first_iteration = False
            for model in get_node_performance_models(graph, child_id, copy.deepcopy(visited_nodes)):
                # initialize list of child models
                child_models.append(model)
        else:
            # create "product set" of child models
            product_set = []
            for model in get_node_performance_models(graph, child_id, copy.deepcopy(visited_nodes)):
                temp_models = [cm.plus_combine(model) for cm in child_models]
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
