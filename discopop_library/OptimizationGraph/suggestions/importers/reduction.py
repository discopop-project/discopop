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
from sympy import Expr, Integer, Symbol, log, Float, init_printing  # type: ignore

from discopop_library.OptimizationGraph.CostModels.CostModel import CostModel
from discopop_library.OptimizationGraph.Variables.Environment import Environment
from discopop_library.OptimizationGraph.classes.nodes.Loop import Loop
from discopop_library.OptimizationGraph.classes.nodes.Workload import Workload
from discopop_library.OptimizationGraph.utilities.MOGUtilities import data_at


def import_suggestion(graph: nx.DiGraph, suggestion, get_next_free_node_id_function,
                      environment: Environment) -> nx.DiGraph:
    # find a node which belongs to the suggestion
    buffer = [n for n in graph.nodes]
    for node in buffer:
        if suggestion.node_id == data_at(graph, node).cu_id:
            # reserve a node id for the new parallelization option
            new_node_id = get_next_free_node_id_function()
            print("Reduction @ ", new_node_id, " @ CUID: ", suggestion.node_id)
            # copy data from existing node
            node_data_copy = copy.deepcopy(data_at(graph, node))
            # remove cu_id to prevent using parallelization options as basis for new versions
            node_data_copy.cu_id = None
            # add suggestion to node data
            node_data_copy.suggestion = suggestion
            # add the cost multiplier to represent the effects of the suggestion
            cast(Workload, node_data_copy).cost_multiplier, introduced_symbols = get_cost_multiplier(new_node_id,
                                                                                                     environment)
            # add the overhead term to represent the overhead incurred by the suggestion
            cast(Workload, node_data_copy).overhead, tmp_introduced_symbols = get_overhead_term(
                cast(Loop, node_data_copy), environment)
            introduced_symbols += tmp_introduced_symbols

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


def get_cost_multiplier(node_id: int, environment: Environment) -> Tuple[CostModel, List[Symbol]]:
    """Creates and returns the multiplier to represent the effects of the given suggestion on the cost model.
    A CostModel object is used to store the information on the path selection.
    Returns the multiplier and the list of introduces symbols
    Multiplier for Reduction:
        1 / OMP ThreadCount """
    # thread_count = Symbol("thread_count_do_all_" + str(node_id))
    mulitplier = Integer(1) / environment.thread_num
    cm = CostModel(mulitplier)
    cm.path_decisions.append(node_id)

    # return cm, [thread_count]
    return cm, []


def get_overhead_term(node_data: Loop, environment: Environment) -> Tuple[CostModel, List[Symbol]]:
    """Creates and returns the Expression which represents the Overhead incurred by the given suggestion.
    For testing purposes, the following function is used to represent the overhead incurred by a do-all loop.
    The function has been created using Extra-P.
    # Todo: In the future, this shall happen dynamically, such that the used function is created per system.

    Overhead(Threads, Iterations, Workload) = 137.7196222048026
            + 5.426563196957141e-09 * Workload^(5/4) * log2(Workload)^(1) * Iterations^(3/2) * log2(Iterations)^(1)
            + 0.0005095826581781916 * Threads^(3)"""
    overhead = Float(137.7196222048026)
    overhead += (Float(5.426563196957141) ** (-9)) * (cast(int, node_data.workload) / node_data.iterations) \
                * log((cast(int, node_data.workload) / node_data.iterations), 2) * (node_data.iterations ** (3 / 2)) \
                * log(node_data.iterations, 2)
    overhead += Float(0.0005095826581781916) * (environment.thread_num ** 3)

    # add weight to overhead
    overhead *= environment.workload_overhead_weight

    cm = CostModel(overhead)
    # add weight to overhead
    return cm, []
