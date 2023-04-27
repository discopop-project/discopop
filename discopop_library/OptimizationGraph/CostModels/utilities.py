from typing import List, Dict, cast, Optional

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
            performance_models[node_data] = get_node_performance_model(graph, node_id)
    return performance_models


def get_node_performance_model(graph: nx.DiGraph, node_id: int) -> List[CostModel]:
    """Returns the performance models for the given node"""
    result_list: List[CostModel] = []
    successors = get_successors(graph, node_id)
    successor_count = len(successors)
    node_data = cast(GenericNode, data_at(graph, node_id))

    # consider performance models of children
    model_plus_children = node_data.get_cost_model().plus_combine(get_performance_model_for_children(graph, node_id))

    # construct the performance model
    if successor_count >= 1:
        for successor in successors:
            combined_model = model_plus_children
            # add transfer costs
            transfer_costs_model = get_edge_data(graph, node_id, successor).get_cost_model()
            combined_model = combined_model.plus_combine(transfer_costs_model)
            # append the model of the successor
            for model in get_node_performance_model(graph, successor):
                result_list.append(combined_model.plus_combine(model))
        return result_list

    # successor count == 0 or successor count > 1
    return [model_plus_children]


def get_performance_model_for_children(graph: nx.DiGraph, node_id: int) -> Optional[CostModel]:
    """Construct a performance model for the children of the given node, or return None if no children exist"""
    # todo: consider children
    children_models: List[CostModel] = []
    for child_id in get_children(graph, node_id):
        for model in get_node_performance_model(graph, child_id):
            children_models.append(model)
    # construct model from individual performance models of the children
    if len(children_models) == 0:
        return None
    else:
        model = children_models[0]
        for child_model in children_models[1:]:
            model = model.plus_combine(child_model)
        return model

def print_introduced_symbols_per_node(graph: nx.DiGraph):
    print("Introduced Symbols:")
    for node_id in graph.nodes:
        print("NodeID: ", node_id)
        for symbol in data_at(graph, node_id).introduced_symbols:
            print("\t: ", symbol)
    print()
