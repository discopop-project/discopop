# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
from typing import Dict, List, Optional, Set, Tuple, cast

import networkx as nx
from discopop_explorer.PEGraphX import EdgeType
from discopop_explorer.pattern_detectors.combined_gpu_patterns.classes.Aliases import MemoryRegion  # type: ignore

from discopop_library.discopop_optimizer.CostModels.CostModel import CostModel
from discopop_library.discopop_optimizer.classes.context.ContextObject import ContextObject
from discopop_library.discopop_optimizer.classes.nodes.ContextNode import ContextNode
from discopop_library.discopop_optimizer.classes.nodes.FunctionRoot import FunctionRoot
from discopop_library.discopop_optimizer.classes.nodes.SynchronizationTrigger import SynchronizationTrigger
from discopop_library.discopop_optimizer.classes.types.DataAccessType import ReadDataAccess, WriteDataAccess
from discopop_library.discopop_optimizer.utilities.MOGUtilities import (
    get_all_nodes_in_function,
    get_function_return_node,
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
            context = get_path_context_iterative(function.node_id, graph, model, context, experiment, top_level_call=False)
            result_dict[function].append((model, context))
    return result_dict


def get_path_context_iterative(
    root_node_id: int, graph: nx.DiGraph, model: CostModel, context: ContextObject, experiment, top_level_call:bool=False
) -> ContextObject:
    """passes the context Object along the path and returns the context once the end has been reached"""
    node_id = None
    next_node_id: Optional[int] = root_node_id

    while next_node_id is not None:
        node_id = next_node_id

        # push device id to stack if necessary
        node_data = data_at(graph, node_id)
        if node_data.device_id is not None:
            context.last_seen_device_ids.append(node_data.device_id)

        # calculate context modifications for the current node
        context = __check_current_node(node_id, graph, model, context, experiment)

        # set last_visited_device id
        if node_data.device_id is not None:
            context.last_visited_device_id = node_data.device_id
        else:
            context.last_visited_device_id = context.last_seen_device_ids[-1]

        # calculate context modifications for the children of the current node
        context = __check_children(node_id, graph, model, context, experiment)

        # pop device id from stack if necessary
        if node_data.device_id is not None:
            # condition to prevent issues due to added dummy nodes
            if len(context.last_seen_device_ids) > 1:
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
                requirements: List[int] = []
                for dec in model.path_decisions:
                    requirements += [r for r in get_requirements(graph, dec) if r not in requirements]
                if len(requirements) == 0:
                    # select the sequential version
                    for succ in successors:
                        if data_at(graph, succ).represents_sequential_version() and data_at(graph, succ).device_id in [
                            None,
                            experiment.get_system().get_host_device_id(),
                        ]:
                            suitable_successors = [succ]
                            model.path_decisions.append(succ)
                            break
                else:
                    # select the correct successor
                    for succ in successors:
                        if succ in requirements:
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

    # force update to host device of the function (not system host device, to allow offloading functions to devices)
    if top_level_call:
        print("CURRENT NODE_ID: ", node_id, type(data_at(graph, node_id)))
        print("RETURNING FROM TOP LEVEL")
        # force synchronization with executing device

        
        # create a filter for the data accesses to be synchronized
        # only consider such memory regions which are used outside the function
        filter: Set[MemoryRegion] = set()
        nodes_in_function = get_all_nodes_in_function(graph, root_node_id)
        cu_nodes_in_function = set([data_at(graph, n).original_cu_id for n in nodes_in_function])
        for node in nodes_in_function:
            node_data = data_at(graph, node)
            if node_data.original_cu_id is None:
                continue
            print("NODE: ", node, node_data.original_cu_id)
            for out_dep_edge in experiment.detection_result.pet.out_edges(node_data.original_cu_id, etype=EdgeType.DATA):
                target = out_dep_edge[1]
                if target in cu_nodes_in_function:
                    continue
                # target outside the function. MemoryRegions qualifies for synchronization at the end of the function
                filter.add(out_dep_edge[2].memory_region)
                print(out_dep_edge[0], out_dep_edge[1], out_dep_edge[2])
        print("FILTER", filter)



        # collect all write data accesses which might need synchronization
        seen_writes: Set[WriteDataAccess] = set()
        for device_id in context.seen_writes_by_device:
            for mem_reg in context.seen_writes_by_device[device_id]:
                for wda in context.seen_writes_by_device[device_id][mem_reg]:
                    # check wda against filter
                    if wda.memory_region in filter:
                        seen_writes.add(wda)

        print("Seen writes: ", seen_writes)
        print("FUNCTION DEVICE ID: ", data_at(graph, root_node_id).device_id)
        print("Function return node: ", get_function_return_node(graph, root_node_id), " cu: ",  data_at(graph, get_function_return_node(graph, root_node_id)).original_cu_id)

        forced_sync_context = context.calculate_and_perform_necessary_updates(
            cast(Set[ReadDataAccess], seen_writes),
            data_at(graph, root_node_id).device_id,
            get_function_return_node(graph, root_node_id),
            graph,
            experiment
        )

        # add the writes performed by the given node to the context
        forced_sync_context = forced_sync_context.add_writes(node_data.written_memory_regions, cast(int, context.last_seen_device_ids[-1]))

    
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
            requirements: List[int] = []
            for dec in model.path_decisions:
                requirements += [r for r in get_requirements(graph, dec) if r not in requirements]
            if len(requirements) == 0:
                # select the sequential version
                for succ in successors:
                    if data_at(graph, succ).represents_sequential_version() and data_at(graph, succ).device_id in [
                        None,
                        experiment.get_system().get_host_device_id(),
                    ]:
                        suitable_successors = [succ]
                        model.path_decisions.append(succ)
                        break
            else:
                # select the correct successor
                for succ in successors:
                    if succ in requirements:
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

    if node_id == 49:
        print("ENCOUNTERED NODE 49")

    if isinstance(node_data, ContextNode):
        # apply modifications according to encountered context node
        updated_context = cast(ContextNode, data_at(graph, node_id)).get_modified_context(
            node_id, graph, model, context
        )
        return updated_context
    
    if node_id == 49:
        print("1 NODE 49")

    # only allow updates on device switches
    device_switch = False
    if data_at(graph, node_id).device_id is None:
        if context.last_seen_device_ids[-1] != context.last_visited_device_id:
            device_switch = True
    elif context.last_visited_device_id != data_at(graph, node_id).device_id:
        device_switch = True

    if device_switch or type(node_data) == SynchronizationTrigger:
        if node_id == 49:
            print("2 NODE 49")

        context = context.calculate_and_perform_necessary_updates(
            node_data.read_memory_regions,
            cast(int, context.last_seen_device_ids[-1]),
            node_data.node_id,
            graph,
            experiment,
        )
    if node_id == 49:
        print("3 NODE 49")

    # add the writes performed by the given node to the context
    context = context.add_writes(node_data.written_memory_regions, cast(int, context.last_seen_device_ids[-1]))

    return context


def __check_children(
    node_id: int, graph: nx.DiGraph, model: CostModel, context: ContextObject, experiment
) -> ContextObject:
    # pass context to all children
    for child in get_children(graph, node_id):
        # reset last_visited_node_id inbetween visiting children
        context.last_visited_node_id = node_id
        context = get_path_context_iterative(child, graph, model, context, experiment)
    return context
