# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import copy
from multiprocessing import Pool
from typing import List, Set, Tuple, cast
from sympy import Integer, Symbol

import networkx as nx  # type: ignore

import tqdm
from discopop_explorer.pattern_detectors.do_all_detector import DoAllInfo  # type: ignore
from discopop_library.PatternIdManagement.unique_pattern_id import get_unique_pattern_id
from discopop_library.discopop_optimizer.Variables.Experiment import Experiment
from discopop_library.discopop_optimizer.classes.edges.MutuallyExclusiveEdge import MutuallyExclusiveEdge
from discopop_library.discopop_optimizer.classes.edges.OptionEdge import OptionEdge
from discopop_library.discopop_optimizer.classes.edges.RequirementEdge import RequirementEdge
from discopop_library.discopop_optimizer.classes.nodes.Loop import Loop
from discopop_library.discopop_optimizer.classes.nodes.Workload import Workload
from discopop_library.discopop_optimizer.utilities.MOGUtilities import (
    get_all_function_nodes,
    get_all_loop_nodes,
    get_all_parents,
    get_parents,
    show,
)
from discopop_library.discopop_optimizer.utilities.simple_utilities import data_at

global_graph = None
global_experiment = None


def collapse_loops(experiment: Experiment) -> nx.DiGraph:
    """identifies collapse loops and depicts them in the optimization graph"""
    global global_graph
    global global_experiment
    global_graph = experiment.optimization_graph
    global_experiment = experiment

    param_list = [(function_node) for function_node in get_all_function_nodes(experiment.optimization_graph)]

#   NOTE: Multiprocessing disabled due to inconsistencies when modifying the graph
#    with Pool(
#    initializer=__initialize_worker,
#    initargs=(experiment.optimization_graph, experiment),
#    ) as pool:
#        tmp_result = list(
#            tqdm.tqdm(pool.imap_unordered(__collapse_loops_in_function, param_list), total=len(param_list))
#        )
    for function in param_list:
        __collapse_loops_in_function(function)

    return global_graph


def __initialize_worker(graph, experiment):
    global global_graph
    global global_experiment
    global_graph = graph
    global_experiment = experiment


def __collapse_loops_in_function(function_node_id):
    """Return True, if a modification has been found. Return False otherwise."""
    global global_graph
    global global_experiment

    modifiation_found = True
    return_value = False
    visited_inner_loop: Set[int] = set()
    while modifiation_found:
        modifiation_found = False

        # set of loops could change when modifications are applied
        loops = get_all_loop_nodes(global_graph)

        for loop in loops:
            loop_data = data_at(global_graph, loop)
            if function_node_id not in get_all_parents(global_graph, loop):
                continue
            # loop contained in function
            # check for loop nesting
            queue: List[int] = get_parents(global_graph, loop)
            collapse_sources: Set[int] = set()
            while queue:
                current = queue.pop()
                current_data = data_at(global_graph, current)

                if type(current_data) == Loop:
                    # parent is parallelizable loop -> collapse and end search
                    if current_data.suggestion_type == "do_all":
                        # if loops are located on the same device, collapse
                        if loop_data.device_id == current_data.device_id:
                            if loop not in visited_inner_loop:
                                collapse_sources.add(current)
                                visited_inner_loop.add(loop)
                            continue
                    # parent is regular loop -> end search on this path
                    continue

                # parent is empty node -> skip
                if isinstance(current_data, Workload):
                    if cast(Workload, current_data).sequential_workload == Integer(0):
                        queue += get_parents(global_graph, current)
                        continue
                # parent is regular node -> end search on this path (no perfect nesting)
                continue

            # apply collapses
            for csrc in collapse_sources:
                modifiation_found = True
                # create new collapse node
                new_node_id = global_experiment.get_next_free_node_id()
                node_data_copy = copy.deepcopy(data_at(global_graph, csrc))
                node_data_copy.node_id = new_node_id
                # increase and set collapse level
                # register a new pattern
                pattern_id = get_unique_pattern_id()
                global_experiment.suggestion_to_node_ids_dict[pattern_id] = [new_node_id]

                cast(Loop, node_data_copy).collapse_level = loop_data.collapse_level + 1
                # create a new node
                global_graph.add_node(new_node_id, data=node_data_copy)

                # copy edges
                for edge in global_graph.in_edges(csrc):
                    edge_data = copy.deepcopy(global_graph.edges[edge]["data"])
                    global_graph.add_edge(edge[0], new_node_id, data=edge_data)
                for edge in global_graph.out_edges(csrc):
                    edge_data = copy.deepcopy(global_graph.edges[edge]["data"])
                    global_graph.add_edge(new_node_id, edge[1], data=edge_data)
                # identify the sequential version of the inner loop
                seq_loop_option = -1
                for option in [
                    e[0] for e in global_graph.in_edges(loop, data="data") if isinstance(e[2], MutuallyExclusiveEdge)
                ]:
                    if cast(Loop, data_at(global_graph, option)).suggestion == None:
                        seq_loop_option = option
                        break
                # create a copy of the sequential version of the inner loop with only a single iteration
                copy_seq_loop_option_id = global_experiment.get_next_free_node_id()
                copy_seq_loop_option_data = copy.deepcopy(data_at(global_graph, seq_loop_option))
                copy_seq_loop_option_data.node_id = copy_seq_loop_option_id

                cast(Loop, copy_seq_loop_option_data).iterations = 1
                cast(Loop, copy_seq_loop_option_data).iterations_symbol = Symbol(
                    "loop_"
                    + str(copy_seq_loop_option_id)
                    + "_pos_"
                    + str(cast(Loop, copy_seq_loop_option_data).position)
                    + "_iterations"
                )
                global_experiment.register_free_symbol(
                    cast(Loop, copy_seq_loop_option_data).iterations_symbol,
                    value_suggestion=Integer(cast(Loop, copy_seq_loop_option_data).iterations),
                )
                global_graph.add_node(copy_seq_loop_option_id, data=copy_seq_loop_option_data)

                # copy edges
                for edge in global_graph.in_edges(seq_loop_option):
                    edge_data = copy.deepcopy(global_graph.edges[edge]["data"])
                    global_graph.add_edge(edge[0], copy_seq_loop_option_id, data=edge_data)
                for edge in global_graph.out_edges(seq_loop_option):
                    edge_data = copy.deepcopy(global_graph.edges[edge]["data"])
                    global_graph.add_edge(copy_seq_loop_option_id, edge[1], data=edge_data)

                # update the iteration count for the collapse root
                cast(Loop, data_at(global_graph, new_node_id)).iterations *= cast(
                    Loop, data_at(global_graph, seq_loop_option)
                ).iterations
                cast(Loop, data_at(global_graph, new_node_id)).iterations_symbol = Symbol(
                    "loop_" + str(new_node_id) + "_pos_" + str(cast(Loop, node_data_copy).position) + "_iterations"
                )
                global_experiment.register_free_symbol(
                    cast(Loop, node_data_copy).iterations_symbol,
                    value_suggestion=Integer(cast(Loop, node_data_copy).iterations),
                )

                # create a new requirements edge to the single-iteration sequential version of the inner loop
                global_graph.add_edge(copy_seq_loop_option_id, new_node_id, data=RequirementEdge())
                global_graph.add_edge(new_node_id, copy_seq_loop_option_id, data=RequirementEdge())

                # register pattern for output
                pattern_info = DoAllInfo(global_experiment.detection_result.pet, global_experiment.detection_result.pet.node_at(node_data_copy.original_cu_id))
                pattern_info.collapse_level = node_data_copy.collapse_level
                global_experiment.detection_result.do_all.append(pattern_info)
                print("REGISTERED PATTERN INFO:")
                print(pattern_info)
                print()

        return_value = return_value or modifiation_found
    return return_value
