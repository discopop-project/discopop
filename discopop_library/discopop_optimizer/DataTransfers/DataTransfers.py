# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
from typing import Dict, List, Tuple, cast

import networkx as nx  # type: ignore

from discopop_library.discopop_optimizer.CostModels.CostModel import CostModel
from discopop_library.discopop_optimizer.classes.context.ContextObject import ContextObject
from discopop_library.discopop_optimizer.classes.nodes.ContextNode import ContextNode
from discopop_library.discopop_optimizer.classes.nodes.FunctionRoot import FunctionRoot
from discopop_library.discopop_optimizer.utilities.MOGUtilities import (
    get_requirements,
    get_successors,
    get_children,
    show,
)
from discopop_library.discopop_optimizer.utilities.simple_utilities import data_at


def calculate_data_transfers(
    graph: nx.DiGraph, function_performance_models: Dict[FunctionRoot, List[CostModel]], experiment
) -> Dict[FunctionRoot, List[Tuple[CostModel, ContextObject]]]:
    """Calculate data transfers for each performance model and append the respective ContextObject to the result."""
    result_dict: Dict[FunctionRoot, List[Tuple[CostModel, ContextObject]]] = dict()
    for function in function_performance_models:
        result_dict[function] = []
        for model in function_performance_models[function]:
            # create a ContextObject for the current path
            context = ContextObject(function.node_id, [function.device_id])
            context = get_path_context_iterative(function.node_id, graph, model, context, experiment)
            result_dict[function].append((model, context))
    return result_dict


def get_path_context_iterative(
    root_node_id: int, graph: nx.DiGraph, model: CostModel, context: ContextObject, experiment
) -> ContextObject:
    """passes the context Object along the path and returns the context once the end has been reached"""
    node_id = None
    next_node_id = root_node_id

    while next_node_id is not None:
        node_id = next_node_id
        print("CONTEXT CALCULATION FOR: ", node_id)

        # push device id to stack if necessary
        node_data = data_at(graph, node_id)
        if node_data.device_id is not None:
            context.last_seen_device_ids.append(node_data.device_id)
        
        # calculate context modifications for the current node
        context = __check_current_node(node_id, graph, model, context, experiment)

        # calculate context modifications for the children of the current node
        context = __check_children(node_id, graph, model, context, experiment)

        # pop device id from stack if necessary
        if node_data.device_id is not None:
            context.last_seen_device_ids.pop()

        # set last_visited_node_id to the original node_id,
        # since the calculation continues from node_id after the children have been visited
        context.last_visited_node_id = node_id

        # pass context to the right successor of the current node
        # At most a single node can be a successor, since the given model represents a single path through the graph.
        successors = get_successors(graph, node_id)
        if len(successors) == 0:
            # stop the loop
            next_node_id = None
        elif len(successors) == 1:
            # pass context to the single successor
            next_node_id = successors[0]
        else:
            # multiple successors exist
            # find the successor which represents the path decision included in the model
            suitable_successors = [succ for succ in successors if succ in model.path_decisions]
            if len(suitable_successors) != 1:

                print("Invalid amount of potential successors (",
                    len(suitable_successors),
                    ") for path split at node:",
                    node_id,
                    "using decisions: ",
                    model.path_decisions,
                    "successors:",
                    successors,
                )
                print("Try to fix the decision...")
                requirements: List[int] = []
                for dec in model.path_decisions:
                    requirements += [r for r in get_requirements(graph, dec) if r not in requirements]
                print("REQUIREMENTS: ", requirements)
                if len(requirements) == 0:
                    # select the sequential version
                    for succ in successors:
                        if data_at(graph, succ).represents_sequential_version() and data_at(graph, succ).device_id in [None, experiment.get_system().get_host_device_id()]:
                            print("FOUND SEQUENTIAL: ", succ)                        
                            suitable_successors = [succ]
                            model.path_decisions.append(succ)
                            break
                else:
                    # select the correct successor
                    for succ in successors:
                        if succ in requirements:
                            print("FOUND REQUIREMENT: ", succ)
                            suitable_successors = [succ]
                            model.path_decisions.append(succ)
                            break
                if len(suitable_successors) != 1:
                    print("No correction possible")
                    show(graph)

                    raise ValueError(
                        "Invalid amount of potential successors (",
                        len(suitable_successors),
                        ") for path split at node:",
                        node_id,
                        "using decisions: ",
                        model.path_decisions,
                        "successors:",
                        successors,
                    )
            # suitable successor identified.
            # pass the current context to the successor
            next_node_id = suitable_successors[0]
    return context


def get_path_context(
    node_id: int, graph: nx.DiGraph, model: CostModel, context: ContextObject, experiment
) -> ContextObject:
    """passes the context Object along the path and returns the context once the end has been reached"""
    # push device id to stack if necessary
    node_data = data_at(graph, node_id)
    if node_data.device_id is not None:
        context.last_seen_device_ids.append(node_data.device_id)

    # calculate context modifications for the current node
    context = __check_current_node(node_id, graph, model, context, experiment)

    # calculate context modifications for the children of the current node
    context = __check_children(node_id, graph, model, context, experiment)

    # pop device id from stack if necessary
    if node_data.device_id is not None:
        context.last_seen_device_ids.pop()

    # set last_visited_node_id to the original node_id,
    # since the calculation continues from node_id after the children have been visited
    context.last_visited_node_id = node_id

    # pass context to the right successor of the current node
    # At most a single node can be a successor, since the given model represents a single path through the graph.
    successors = get_successors(graph, node_id)
    if len(successors) == 1:
        # pass context to the single successor
        return get_path_context(successors[0], graph, model, context, experiment)

    elif len(successors) == 0:
        # no successor exists, return the current context
        return context

    else:
        # multiple successors exist
        # find the successor which represents the path decision included in the model
        suitable_successors = [succ for succ in successors if succ in model.path_decisions]
        if len(suitable_successors) != 1:

            print("Invalid amount of potential successors (",
                len(suitable_successors),
                ") for path split at node:",
                node_id,
                "using decisions: ",
                model.path_decisions,
                "successors:",
                successors,
            )
            print("Try to fix the decision...")
            requirements: List[int] = []
            for dec in model.path_decisions:
                requirements += [r for r in get_requirements(graph, dec) if r not in requirements]
            print("REQUIREMENTS: ", requirements)
            if len(requirements) == 0:
                # select the sequential version
                for succ in successors:
                    if data_at(graph, succ).represents_sequential_version() and data_at(graph, succ).device_id in [None, experiment.get_system().get_host_device_id()]:
                        print("FOUND SEQUENTIAL: ", succ)                        
                        suitable_successors = [succ]
                        model.path_decisions.append(succ)
                        break
            else:
                # select the correct successor
                for succ in successors:
                    if succ in requirements:
                        print("FOUND REQUIREMENT: ", succ)
                        suitable_successors = [succ]
                        model.path_decisions.append(succ)
                        break
            if len(suitable_successors) != 1:
                print("No correction possible")
                show(graph)

                raise ValueError(
                    "Invalid amount of potential successors (",
                    len(suitable_successors),
                    ") for path split at node:",
                    node_id,
                    "using decisions: ",
                    model.path_decisions,
                    "successors:",
                    successors,
                )
        # suitable successor identified.
        # pass the current context to the successor
        return get_path_context(suitable_successors[0], graph, model, context, experiment)


def __check_current_node(
    node_id: int, graph: nx.DiGraph, model: CostModel, context: ContextObject, experiment
) -> ContextObject:
    """Check if the given node results in modifications to the given context.
    Return a modified version of the context which contains the required updates."""
    # due to the Read-Compute-Write paradigm used to create the Computational Units,
    # this structure is assumed for the nodes and their MemoryAccesses as well.

    # check if any data needs to be updated from a different device before reading
    # if so, the context will be supplemented with the identified updates
    node_data = data_at(graph, node_id)

    if isinstance(node_data, ContextNode):
        # apply modifications according to encountered context node
        updated_context = cast(ContextNode, data_at(graph, node_id)).get_modified_context(
            node_id, graph, model, context
        )
        return updated_context

    context = context.calculate_and_perform_necessary_updates(
        node_data.read_memory_regions, cast(int, context.last_seen_device_ids[-1]), node_data.node_id, graph, experiment
    )

    # add the writes performed by the given node to the context
    context = context.add_writes(node_data.written_memory_regions, cast(int, context.last_seen_device_ids[-1]))

    return context


def __check_children(
    node_id: int, graph: nx.DiGraph, model: CostModel, context: ContextObject, experiment
) -> ContextObject:
    print("ENTER CHECK_CHILDREN")
    # pass context to all children
    for child in get_children(graph, node_id):
        # reset last_visited_node_id inbetween visiting children
        context.last_visited_node_id = node_id
        context = get_path_context_iterative(child, graph, model, context, experiment)
    print("EXIT CHECK_CHILDREN")
    return context
