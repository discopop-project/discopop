# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
import copy

from typing import cast, Tuple, List

import networkx as nx  # type: ignore
from sympy import Expr, Integer, Symbol  # type: ignore

from discopop_library.OptimizationGraph.CostModels.CostModel import CostModel
from discopop_library.OptimizationGraph.classes.nodes.Workload import Workload
from discopop_library.OptimizationGraph.utilities.MOGUtilities import data_at, show


def import_suggestion(graph: nx.DiGraph, suggestion, get_next_free_node_id_function) -> nx.DiGraph:

    # find a node which belongs to the suggestion
    buffer = [n for n in graph.nodes]
    for node in buffer:
        if suggestion.node_id == data_at(graph, node).cu_id:
            print("MATCH AT: ", suggestion.node_id)
            # reserve a node id for the new parallelization option
            new_node_id = get_next_free_node_id_function()
            print("NEW NODE ID: ", new_node_id)
            # copy data from exsting node
            node_data_copy = copy.deepcopy(data_at(graph, node))
            # remove cu_id to prevent using parallelization options as basis for new versions
            node_data_copy.cu_id = None
            # add suggestion to node data
            node_data_copy.suggestion = suggestion
            # add the cost multiplier to represent the effects of the suggestion
            cast(Workload, node_data_copy).cost_multiplier, introduced_symbols = get_cost_multiplier(new_node_id)
            node_data_copy.introduced_symbols += introduced_symbols

            # create a new node for the option
            graph.add_node(new_node_id, data=node_data_copy)

            # connect the newly created node to the parent and successor of node
            for edge in graph.in_edges(node):
                edge_data = copy.deepcopy(graph.edges[edge]["data"])
                graph.add_edge(edge[0], new_node_id, data=edge_data)
            for edge in graph.out_edges(node):
                edge_data = copy.deepcopy(graph.edges[edge]["data"])
                graph.add_edge(new_node_id, edge[1], data=edge_data)
    return graph

def get_cost_multiplier(node_id: int) -> Tuple[CostModel, List[Symbol]]:
    """Creates and returns the multiplier to represent the effects of the given suggestion on the cost model.
    A CostModel object is used to store the information on the path selection.
    Returns the multiplier and the list of introduces symbols
    Multiplier for Do-All:
        1 / ThreadCount """
    thread_count = Symbol("thread_count_do_all_" + str(node_id))
    mulitplier = Integer(1) / thread_count
    cm = CostModel(mulitplier)
    cm.path_decisions.append(node_id)

    return cm, [thread_count]
