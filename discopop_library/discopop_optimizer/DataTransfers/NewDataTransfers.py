# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import logging
from typing import Dict, List, Optional, Set, Tuple, cast
import networkx as nx  # type: ignore
from discopop_explorer.PEGraphX import MemoryRegion

from discopop_library.discopop_optimizer.CostModels.CostModel import CostModel
from discopop_library.discopop_optimizer.Variables.Experiment import Experiment
from discopop_library.discopop_optimizer.classes.context.Update import Update
from discopop_library.discopop_optimizer.classes.context.ContextObject import ContextObject

from discopop_library.discopop_optimizer.classes.nodes.FunctionRoot import FunctionRoot
from discopop_library.discopop_optimizer.classes.types.Aliases import DeviceID
from discopop_library.discopop_optimizer.classes.types.DataAccessType import ReadDataAccess, WriteDataAccess
from discopop_library.discopop_optimizer.utilities.MOGUtilities import (
    get_all_function_nodes,
    get_children,
    get_predecessors,
    get_requirements,
    get_successors,
    show_decision_graph,
)
from discopop_library.discopop_optimizer.utilities.simple_utilities import data_at
from discopop_library.discopop_optimizer.classes.nodes.ContextRestore import ContextRestore
from discopop_library.discopop_optimizer.classes.nodes.ContextSave import ContextSave

logger = logging.getLogger("Optimizer")


class DeviceMemory(object):
    memory: Dict[DeviceID, Dict[MemoryRegion, WriteDataAccess]] = dict()
    graph: nx.DiGraph
    experiment: Experiment

    def __init__(self, graph: nx.DiGraph, experiment: Experiment):
        self.graph = graph
        self.experiment = experiment

    def perform_read(self, node_id: int, device_id: DeviceID, rda: ReadDataAccess) -> List[Update]:
        updates: List[Update] = []
        # get most recent write to the memory region
        most_recent_write: Optional[Tuple[DeviceID, WriteDataAccess]] = None
        for dvid in self.memory:
            if rda.memory_region in self.memory[dvid]:
                if most_recent_write is None:
                    most_recent_write = (dvid, self.memory[dvid][rda.memory_region])
                else:
                    if self.memory[dvid][rda.memory_region].unique_id > most_recent_write[1].unique_id:
                        most_recent_write = (dvid, self.memory[dvid][rda.memory_region])

        # check for update necessity
        if most_recent_write is None:
            # data written outside the current function. Issue update from host device to device_id
            predecessors = get_predecessors(self.graph, node_id)
            if len(predecessors) == 0:
                predecessor = node_id
            else:
                predecessor = predecessors[0]
            dummy_wda = WriteDataAccess(rda.memory_region, 0, rda.var_name)
            updates.append(
                Update(
                    predecessor,
                    node_id,
                    self.experiment.get_system().get_host_device_id(),
                    device_id,
                    dummy_wda,
                    is_first_data_occurrence=True,
                    source_cu_id=data_at(self.graph, predecessor).original_cu_id,
                    target_cu_id=data_at(self.graph, node_id).original_cu_id,
                )
            )

        elif most_recent_write[0] != device_id:
            # update necessary
            predecessors = get_predecessors(self.graph, node_id)
            if len(predecessors) == 0:
                predecessor = node_id
            else:
                predecessor = predecessors[0]

            # check if the update creates the memory on the device
            if device_id in self.memory:
                if rda.memory_region in self.memory[device_id]:
                    is_first_data_occurrence = False
                else:
                    is_first_data_occurrence = True
            else:
                is_first_data_occurrence = True

            # check for differing unique ids to prevent updates in an already synchronized state, if the data is already present on the device
            already_synchronized = False
            if not is_first_data_occurrence:
                if device_id in self.memory:
                    if rda.memory_region in self.memory[device_id]:
                        if self.memory[device_id][rda.memory_region].unique_id >= most_recent_write[1].unique_id:
                            already_synchronized = True
                            logger.debug("Already synchronized: " + str(Update(
                        predecessor,
                        node_id,
                        most_recent_write[0],
                        device_id,
                        most_recent_write[1],
                        is_first_data_occurrence=is_first_data_occurrence,
                        source_cu_id=data_at(self.graph, predecessor).original_cu_id,
                        target_cu_id=data_at(self.graph, node_id).original_cu_id,
                    )))

            if not already_synchronized:
                updates.append(
                    Update(
                        predecessor,
                        node_id,
                        most_recent_write[0],
                        device_id,
                        most_recent_write[1],
                        is_first_data_occurrence=is_first_data_occurrence,
                        source_cu_id=data_at(self.graph, predecessor).original_cu_id,
                        target_cu_id=data_at(self.graph, node_id).original_cu_id,
                    )
                )

        else:
            # no update necessary, most recent data on the device
            pass

        if len(updates) > 0:
            # update the memory state according to the updates
            for update in updates:
                self.perform_write(update.target_node_id, update.target_device_id, update.write_data_access)

        return updates

    def perform_write(self, node_id: int, device_id: DeviceID, wda: WriteDataAccess):
        if device_id not in self.memory:
            self.memory[device_id] = dict()
        self.memory[device_id][wda.memory_region] = wda

    def log_state(self):
        logger.debug("Memory state:")
        for device_id in self.memory:
            logger.debug("-> Device: " + str(device_id))
            for mem_reg in self.memory[device_id]:
                logger.debug("\t-> " + str(self.memory[device_id][mem_reg]))
        logger.debug("")

class DataFrame(object):
    entered_data_regions_by_device: Dict[DeviceID, List[WriteDataAccess]]
    
    def __init__(self):
        self.entered_data_regions_by_device = dict()

    def parse_update(self, update: Update):
        if update.is_first_data_occurrence:
            if update.target_device_id not in self.entered_data_regions_by_device:
                self.entered_data_regions_by_device[update.target_device_id] = []
            self.entered_data_regions_by_device[update.target_device_id].append(update.write_data_access)

    def cleanup_dataframe(self, node_id: int, memory: DeviceMemory, experiment: Experiment) -> List[Update]:
        """synchronize data to the host device and issue a delete update"""
        updates: List[Update] = []
        # identify last cu_id for update positioning
        queue = [node_id]
        last_cu_id = None
        while queue:
            current = queue.pop(0)
            current_data = data_at(experiment.optimization_graph, current)
            if current_data.original_cu_id is not None:
                last_cu_id = current_data.original_cu_id
                break
            queue += [p for p in get_predecessors(experiment.optimization_graph, current) if p not in queue]


        for device_id in self.entered_data_regions_by_device:
            for wda in self.entered_data_regions_by_device[device_id]:
                # issue delete updates
                updates.append(Update(node_id, node_id, device_id, experiment.get_system().get_host_device_id(), wda, False, last_cu_id, last_cu_id, delete_data=True))
                # updates += memory.perform_read(node_id, experiment.get_system().get_host_device_id(), cast(ReadDataAccess, wda))
                # cleanup memory
                del memory.memory[device_id][wda.memory_region]
        
        logger.debug("CDF Updates: ")
        for u in updates:
            logger.debug("\t" + str(u))
        return updates
    
    def log_state(self):
        logger.debug("DataFrame:")
        for device_id in self.entered_data_regions_by_device:
            logger.debug("-> Device: " + str(device_id))
            for wda in self.entered_data_regions_by_device[device_id]:
                logger.debug("\t-> " + str(wda.memory_region) + " : " + wda.var_name)
        logger.debug("")

def new_calculate_data_transfers(graph: nx.DiGraph, decisions: List[int], experiment, targeted_functions: Optional[List[int]] = None) -> List[Update]:
    updates: List[Update] = []
    logger.debug("Calculating updates for configuration: " + str(decisions))

    if targeted_functions is None:
        targeted_functions = get_all_function_nodes(graph)

    for idx, function in enumerate(targeted_functions):
        logger.debug("\t-> Function: " + cast(FunctionRoot, data_at(graph, function)).name + " " + str(idx) + " / " + str(len(targeted_functions)))
        function_children = get_children(graph, function)
        if len(function_children) == 0:
            continue
        # initialize "walker"
        device_id_stack: List[int] = [cast(int, data_at(graph, function).device_id)]
        return_node_stack: List[int] = []
        current_node: Optional[int] = None
        next_node: Optional[int] = function_children[0]

        # initialize device memory
        memory = DeviceMemory(graph, experiment)

        # initialize data frame stack, used to cleanup data from the devices when leaving a branch or function
        dataframe_stack: List[DataFrame] = [DataFrame()]

        # traverse function graph and calculate necessary data updates
        while next_node is not None or len(return_node_stack) != 0:
            # 0: check if next_node exists
            if next_node is not None:
                current_node = next_node
                next_node = None
            else:
                # if not, get next node from the return stack
                current_node = return_node_stack.pop()

            # identify device id of the current node
            current_node_data = data_at(graph, current_node)
            current_device_id = (
                device_id_stack[-1] if current_node_data.device_id is None else current_node_data.device_id
            )
            logger.debug("Current node: " + str(current_node) + " @ device " + str(current_device_id))

            # identify necessary updates
            tmp_updates: List[Update] = []
            for rda in current_node_data.read_memory_regions:
                tmp_updates += memory.perform_read(current_node, current_device_id, rda)
            # assumption (potential improvements for later): each written memory region is also read
            # todo: replace this assumption with allocations on the device, if no prior data is read
            for rda in cast(Set[ReadDataAccess], current_node_data.written_memory_regions):
                tmp_updates += memory.perform_read(current_node, current_device_id, rda)
            for wda in current_node_data.written_memory_regions:
                memory.perform_write(current_node, current_device_id, wda)
            memory.log_state()

            # register newly created data on a device in the current data frame
            for update in tmp_updates:
                dataframe_stack[-1].parse_update(update)
            logger.debug("Data Frame Stack:")
            for df in dataframe_stack:
                df.log_state()
            logger.debug("")

            # add a new data frame, if a branch is entered
            if type(current_node_data) == ContextRestore:
                dataframe_stack.append(DataFrame())

            # close the current data frame if a branch is exited
            if type(current_node_data) == ContextSave:
                tmp_updates += dataframe_stack[-1].cleanup_dataframe(current_node, memory, experiment)
                dataframe_stack.pop()


            # 1: prepare graph traversal
            successors = get_successors(graph, current_node)
            children = get_children(graph, current_node)

            # 1.1: select successor according to decisions
            logger.debug("Successors: " + str(successors))
            logger.debug("Decisions: " + str(decisions))

            if len(successors) == 1:
                successor = successors[0]
            else:
                valid_successors = [s for s in successors if s in decisions]
                logger.debug("valid successors: " + str(valid_successors))
                if len(valid_successors) == 1:
                    # check if one successor exists after filtering
                    successor = valid_successors[0]
                else:
                    # check if any of the successors is a requirement
                    if len(valid_successors) == 0:
                        requirements = []
                        for dec in decisions:
                            requirements += get_requirements(graph, dec)
                        valid_successors = [s for s in successors if s in requirements]
                    logger.debug("valid after requirements: " + str(valid_successors))
                        
                    # if no successor is a requirement, select a successor which represents a sequential execution at device NONE
                    if len(valid_successors) == 0:
                        valid_successors = [s for s in successors if data_at(graph, s).represents_sequential_version() and data_at(graph,s).device_id == None]    
                    logger.debug("valid successors after strict sequential check: " +str( valid_successors))

                    # if no valid successor with the strict sequential version check could be found, relax the condition and try again
                    if len(valid_successors) == 0:
                        valid_successors = [s for s in successors if data_at(graph, s).represents_sequential_version()]    
                    logger.debug("valid successors after loose sequential check: " +str( valid_successors))
                    

                    if len(valid_successors) > 0:
                        logger.debug("valid successors: " + str(valid_successors))
                        successor = valid_successors[0]
                    else:
                        # still, no valid successor is identified, end of path or invalid path reached
                        successor = None
                        # pop element from device_stack
                        logger.debug("Path end reached!")
                        device_id_stack.pop()
                        tmp_updates += dataframe_stack[-1].cleanup_dataframe(current_node, memory, experiment)
                        dataframe_stack.pop()

            # 1.2: save successor to return_node_stack if required
            if len(children) == 0:
                next_node = successor
            else:
                return_node_stack.append(cast(int, successor))
                return_node_stack += children
                for c in children:
                    device_id_stack.append(current_device_id)
                    dataframe_stack.append(DataFrame())
                # add device id of the parent to the device_id_stack for each child, as the last element will be popped when the path end is reached
                # add a new dataframe for each child to enforce cleaning up before leaving a loop body, if necessary
                # children will be visited before the successor is visited

            # 1.3: log state
            logger.debug("next_node: " + str(next_node))
            logger.debug("return_stack: " + str(return_node_stack))
            logger.debug("device_id_stack: " + str(device_id_stack))
            logger.debug("")

            # todo remove
            memory.log_state()

            # register identified updates
            updates += tmp_updates

    logger.debug("Calculated updates: ")
    for u in updates:
        logger.debug("--> " + str(u))
    logger.debug("")

    return updates


def calculate_data_transfers_by_models(
    graph: nx.DiGraph, function_performance_models: Dict[FunctionRoot, List[CostModel]], experiment
) -> Dict[FunctionRoot, List[Tuple[CostModel, ContextObject]]]:
    """Calculate data transfers for each performance model and append the respective ContextObject to the result."""
    result_dict: Dict[FunctionRoot, List[Tuple[CostModel, ContextObject]]] = dict()
    for function in function_performance_models:
        result_dict[function] = []
        for model in function_performance_models[function]:
            # create a ContextObject for the current path
            context = ContextObject(function.node_id, [function.device_id])

            context.necessary_updates = new_calculate_data_transfers(graph, model.path_decisions, experiment, [function.node_id])
            
            result_dict[function].append((model, context))
    return result_dict