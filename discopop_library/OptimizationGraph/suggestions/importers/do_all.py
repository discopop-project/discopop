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
from discopop_library.OptimizationGraph.classes.edges.OptionEdge import OptionEdge
from discopop_library.OptimizationGraph.classes.edges.RequirementEdge import RequirementEdge
from discopop_library.OptimizationGraph.classes.edges.SuccessorEdge import SuccessorEdge
from discopop_library.OptimizationGraph.classes.nodes.Loop import Loop
from discopop_library.OptimizationGraph.classes.nodes.Workload import Workload
from discopop_library.OptimizationGraph.utilities.MOGUtilities import data_at

do_all_device_ids = [0]


def import_suggestion(
    graph: nx.DiGraph, suggestion, get_next_free_node_id_function, environment: Environment
) -> nx.DiGraph:
    # find a node which belongs to the suggestion
    buffer = [n for n in graph.nodes]
    introduced_options = []
    for node in buffer:
        if suggestion.node_id == data_at(graph, node).cu_id:
            # todo: This implementation for the device id is temporary and MUST be replaced
            for device_id in do_all_device_ids:
                # reserve a node id for the new parallelization option
                new_node_id = get_next_free_node_id_function()
                print(
                    "Do-All @ ",
                    new_node_id,
                    " @ CUID: ",
                    suggestion.node_id,
                    " @ Device: ",
                    device_id,
                )
                # copy data from exsting node
                node_data_copy = copy.deepcopy(data_at(graph, node))

                # set the device id for the suggestion
                node_data_copy.device_id = device_id
                # remove cu_id to prevent using parallelization options as basis for new versions
                node_data_copy.cu_id = None
                # add suggestion to node data
                node_data_copy.suggestion = suggestion
                # add the cost multiplier to represent the effects of the suggestion
                (
                    cast(Workload, node_data_copy).cost_multiplier,
                    introduced_symbols,
                ) = get_cost_multiplier(new_node_id, environment, device_id)
                # add the overhead term to represent the overhead incurred by the suggestion
                cast(Workload, node_data_copy).overhead, tmp_introduced_symbols = get_overhead_term(
                    cast(Loop, node_data_copy), environment, device_id
                )
                introduced_symbols += tmp_introduced_symbols

                node_data_copy.introduced_symbols += introduced_symbols

                # create a new node for the option
                graph.add_node(new_node_id, data=node_data_copy)
                # mark the newly created option
                graph.add_edge(node, new_node_id, data=OptionEdge())

                # save the id of the introduced parallelization option to connect them afterwards
                introduced_options.append(new_node_id)

                # connect the newly created node to the parent and successor of node
                for edge in graph.in_edges(node):
                    edge_data = copy.deepcopy(graph.edges[edge]["data"])
                    graph.add_edge(edge[0], new_node_id, data=edge_data)
                for edge in graph.out_edges(node):
                    edge_data = copy.deepcopy(graph.edges[edge]["data"])
                    graph.add_edge(new_node_id, edge[1], data=edge_data)
                    # if a successor has no device id already,
                    # set it to 0 to simulate "leaving" the device after the suggestion
                    if (
                        type(edge_data) == SuccessorEdge
                        and data_at(graph, edge[1]).device_id is None
                    ):
                        data_at(graph, edge[1]).device_id = 0

    # connect introduced parallelization options to support path restraining
    for node_id_1 in introduced_options:
        for node_id_2 in introduced_options:
            if node_id_1 == node_id_2:
                continue
            graph.add_edge(node_id_1, node_id_2, data=RequirementEdge())
    return graph


def get_cost_multiplier(
    node_id: int, environment: Environment, device_id: int
) -> Tuple[CostModel, List[Symbol]]:
    """Creates and returns the multiplier to represent the effects of the given suggestion on the cost model.
    A CostModel object is used to store the information on the path selection.
    Returns the multiplier and the list of introduces symbols
    Multiplier for Do-All:
        1 / OMP ThreadCount"""
    # get device specifications

    # thread_count = Symbol("thread_count_do_all_" + str(node_id))
    thread_count = environment.thread_counts_by_device[device_id]

    multiplier = Integer(1) / thread_count
    cm = CostModel(multiplier)

    print("\tcost multiplier: ", multiplier)

    # return cm, [thread_count]
    return cm, []


def get_overhead_term(
    node_data: Loop, environment: Environment, device_id: int
) -> Tuple[CostModel, List[Symbol]]:
    """Creates and returns the Expression which represents the Overhead incurred by the given suggestion.
    For testing purposes, the following function is used to represent the overhead incurred by a do-all loop.
    The function has been created using Extra-P.
    # Todo: In the future, this shall happen dynamically, such that the used function is created per system.

    Overhead(Threads, Iterations, Workload) = 11.95830999763869
                                              + 7.119516221079432e-07
                                              * log2(Threads) ^ (1) * Workload ^ (1)
                                              * log2(Workload) ^ (1) * Iterations ^ (5 / 4)
                                              + 0.0002157726704611484 * log2(Threads) ^ (1)
                                              * Workload ^ (1) * log2(Workload) ^ (1)"""
    thread_count = environment.thread_counts_by_device[device_id]

    overhead = Float(11.95830999763869)
    overhead += (
        (Float(7.119516221079432) ** (-7))
        * log(thread_count, 2)
        * (cast(int, node_data.workload) / node_data.iterations)
        * log((cast(int, node_data.workload) / node_data.iterations), 2)
        * (node_data.iterations ** (5 / 4))
    )
    overhead += (
        Float(0.0002157726704611484)
        * log(thread_count, 2)
        * (cast(int, node_data.workload) / node_data.iterations)
        * log((cast(int, node_data.workload) / node_data.iterations), 2)
    )

    # add weight to overhead
    overhead *= environment.do_all_overhead_weight_by_device[device_id]

    print("\toverhead: ", overhead)

    cm = CostModel(overhead)
    # add weight to overhead
    return cm, []
