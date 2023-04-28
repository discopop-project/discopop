# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
from typing import List, Dict, cast

import networkx as nx  # type: ignore
from sympy import Integer  # type: ignore

from discopop_library.OptimizationGraph.CostModels.CostModel import CostModel
from discopop_library.OptimizationGraph.classes.nodes.FunctionRoot import FunctionRoot
from discopop_library.OptimizationGraph.classes.nodes.GenericNode import GenericNode
from discopop_library.OptimizationGraph.utilities.MOGUtilities import get_successors, get_children, data_at, \
    get_edge_data


def get_performance_models_for_functions(graph: nx.DiGraph) -> Dict[FunctionRoot, List[CostModel]]:
    performance_models: Dict[FunctionRoot, List[CostModel]] = dict()
    for node_id in graph.nodes:
        node_data = graph.nodes[node_id]["data"]
        if isinstance(node_data, FunctionRoot):
            performance_models[node_data] = get_node_performance_models(graph, node_id)
    return performance_models


def get_node_performance_models(graph: nx.DiGraph, node_id: int) -> List[CostModel]:
    """Returns the performance models for the given node"""
    result_list: List[CostModel] = []
    successors = get_successors(graph, node_id)
    successor_count = len(successors)
    node_data = cast(GenericNode, data_at(graph, node_id))

    # consider performance models of children
    children_models = get_performance_models_for_children(graph, node_id)

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
                combined_model = children_model
                # add transfer costs
                transfer_costs_model = get_edge_data(graph, node_id, successor).get_cost_model()
                combined_model = combined_model.plus_combine(transfer_costs_model)
                # append the model of the successor
                for model in get_node_performance_models(graph, successor):
                    result_list.append(combined_model.plus_combine(model))
        return result_list

    # successor count == 0 or successor count > 1
    return children_models


def get_performance_models_for_children(graph: nx.DiGraph, node_id: int) -> List[CostModel]:
    """Construct a performance model for the children of the given node, or return None if no children exist"""
    # todo: consider children
    child_models: List[CostModel] = []

    # create all combinations for models from children
    first_iteration = True
    for child_id in get_children(graph, node_id):
        if first_iteration:
            first_iteration = False
            for model in get_node_performance_models(graph, child_id):
                # initialize list of child models
                child_models.append(model)
        else:
            # create "product set" of child models
            product_set = []
            for model in get_node_performance_models(graph, child_id):
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
