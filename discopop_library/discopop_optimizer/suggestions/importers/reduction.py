# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
import copy
from typing import cast, Tuple, List, Dict

import networkx as nx  # type: ignore
from sympy import Expr, Integer, Symbol, log, Float, init_printing  # type: ignore

from discopop_library.discopop_optimizer.CostModels.CostModel import CostModel
from discopop_library.discopop_optimizer.Microbench.utils import (
    convert_microbench_to_discopop_workload,
    convert_discopop_to_microbench_workload,
)
from discopop_library.discopop_optimizer.Variables.Experiment import Experiment
from discopop_library.discopop_optimizer.classes.nodes.Loop import Loop
from discopop_library.discopop_optimizer.classes.nodes.Workload import Workload
from discopop_library.discopop_optimizer.utilities.MOGUtilities import data_at

reduction_device_ids = [0]


def import_suggestion(
    graph: nx.DiGraph, suggestion, get_next_free_node_id_function, environment: Experiment
) -> nx.DiGraph:
    # find a node which belongs to the suggestion
    buffer = [n for n in graph.nodes]
    for node in buffer:
        if suggestion.node_id == data_at(graph, node).cu_id:
            for device_id in reduction_device_ids:
                # reserve a node id for the new parallelization option
                new_node_id = get_next_free_node_id_function()
                # copy data from existing node
                node_data_copy = copy.deepcopy(data_at(graph, node))
                # set the device id for the suggestion
                node_data_copy.device_id = device_id
                # remove cu_id to prevent using parallelization options as basis for new versions
                node_data_copy.cu_id = None
                # mark node for parallel execution
                node_data_copy.execute_in_parallel = True
                # copy loop iteration variable
                cast(Loop, node_data_copy).iterations_symbol = cast(
                    Loop, node_data_copy
                ).iterations_symbol
                # add suggestion to node data
                node_data_copy.suggestion = suggestion
                node_data_copy.suggestion_type = "reduction"
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

                # connect the newly created node to the parent and successor of node
                for edge in graph.in_edges(node):
                    edge_data = copy.deepcopy(graph.edges[edge]["data"])
                    graph.add_edge(edge[0], new_node_id, data=edge_data)
                for edge in graph.out_edges(node):
                    edge_data = copy.deepcopy(graph.edges[edge]["data"])
                    graph.add_edge(new_node_id, edge[1], data=edge_data)
                    # if the successor has no device id already,
                    # set it to 0 to simulate "leaving" the device after the suggestion
                    # todo: this should not happen here, but be considered when calculating the updates in order to
                    #  prevent suggestions from influencing each other by "mapping" workloads to certain devices.
                    # todo re-enable?
                    # if data_at(graph, edge[1]).device_id is None:
                    #     data_at(graph, edge[1]).device_id = 0
    return graph


def get_cost_multiplier(
    node_id: int, environment: Experiment, device_id: int
) -> Tuple[CostModel, List[Symbol]]:
    """Creates and returns the multiplier to represent the effects of the given suggestion on the cost model.
    A CostModel object is used to store the information on the path selection.
    Returns the multiplier and the list of introduces symbols
    Multiplier for Reduction:
        1 / Compute_capa"""
    # get device specifications
    thread_count = environment.get_system().get_device(device_id).get_thread_count()

    multiplier = Integer(1) / thread_count
    cm = CostModel(multiplier, Integer(1))

    # return cm, [thread_count]
    return cm, []


def get_overhead_term(
    node_data: Loop, environment: Experiment, device_id: int
) -> Tuple[CostModel, List[Symbol]]:
    """Creates and returns the Expression which represents the Overhead incurred by the given suggestion.
    For testing purposes, the following function is used to represent the overhead incurred by a do-all loop.
    The function has been created using Extra-P.
    Unit of the overhead term are micro seconds."""

    # retrieve Reduction overhead model
    overhead_model = environment.get_system().get_device_reduction_overhead_model(
        environment.get_system().get_device(device_id)
    )
    # substitute workload, iterations and threads
    thread_count = environment.get_system().get_device(device_id).get_thread_count()
    iterations = node_data.iterations_symbol
    # since node_data is of type Loop, parallelizable_workload has to exist
    per_iteration_workload = cast(Expr, node_data.parallelizable_workload)
    # convert DiscoPoP workload to Microbench workload
    converted_per_iteration_workload = convert_discopop_to_microbench_workload(
        per_iteration_workload, iterations
    )

    substitutions: Dict[Symbol, Expr] = {}

    for symbol in cast(List[Symbol], overhead_model.free_symbols):
        if symbol.name == "workload":
            substitutions[symbol] = converted_per_iteration_workload
        elif symbol.name == "iterations":
            substitutions[symbol] = iterations
        elif symbol.name == "threads":
            substitutions[symbol] = thread_count
        else:
            raise ValueError("Unknown symbol: ", symbol)

    substituted_overhead_model = overhead_model.xreplace(substitutions)

    cm = CostModel(Integer(0), substituted_overhead_model)

    # todo: convert result (in s) to workload

    # add weight to overhead
    return cm, []
