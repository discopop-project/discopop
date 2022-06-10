import concurrent.futures
import copy

from typing import List, Tuple, cast

from discopop_validation.data_race_prediction.scheduler.classes.ScheduleElement import ScheduleElement
from discopop_validation.data_race_prediction.scheduler.classes.SchedulingGraph import SchedulingGraph
from discopop_validation.data_race_prediction.vc_data_race_detector.classes.DataRace import DataRace
from discopop_validation.data_race_prediction.vc_data_race_detector.classes.State import State
from discopop_validation.data_race_prediction.vc_data_race_detector.data_race_detector import goto_next_state


def get_data_races_and_successful_states(scheduling_graph: SchedulingGraph, dimensions: List[int],
                                         initial_states: List[State]) -> Tuple[List[DataRace], List[State]]:
    graph_depth = 0
    for entry in dimensions:
        graph_depth += entry
    # if list of initial States is empty, create a new State (required for root node)
    # initial_states = []
    if len(initial_states) == 0:
        initial_states.append(
            State(scheduling_graph.thread_count, scheduling_graph.lock_names, scheduling_graph.var_names))
    # start data race detection for each possible initial state and combine the results
    data_races: List[DataRace] = []
    successful_states: List[State] = []
    for state in initial_states:
        data_races_buffer, successful_states_buffer = __check_node(scheduling_graph,
                                                                   scheduling_graph.root_node_identifier,
                                                                   copy.deepcopy(state), [], 0, graph_depth, [])
        data_races += [elem for elem in data_races_buffer if not elem in data_races]
        successful_states += [elem for elem in successful_states_buffer if not elem in successful_states]
    return data_races, successful_states


def __check_node(scheduling_graph: SchedulingGraph, node_identifier, state: State,
                 previous_accesses: List[ScheduleElement], level, graph_depth, visited) -> Tuple[
    List[DataRace], List[State]]:
    visited.append(node_identifier)
    global futures_cutoff_level
    node_schedule_element: ScheduleElement = scheduling_graph.graph.nodes[node_identifier]["data"]
    if node_schedule_element is not None:
        # perform State update
        result = goto_next_state(state, node_schedule_element, previous_accesses)
        if type(result) == State:
            state = result
        else:
            data_race: DataRace = cast(DataRace, result)
            return [data_race], []

    data_races = []
    successful_states = []

    # no multithreading
    for source, target in scheduling_graph.graph.out_edges(node_identifier):
        state_copy = copy.deepcopy(state)
        previous_accesses_copy = copy.copy(previous_accesses)
        if node_schedule_element is not None:
            previous_accesses_copy.append(node_schedule_element)
        if target not in visited:
            visited_copy = copy.deepcopy(visited)
            data_races_buffer, successful_states_buffer = __check_node(scheduling_graph, target, state_copy,
                                                                       previous_accesses_copy, level + 1, graph_depth,
                                                                       visited_copy)
        else:
            data_races_buffer = []
            successful_states_buffer = []
        data_races += data_races_buffer
        successful_states += successful_states_buffer
    # check for successful states
    if len(scheduling_graph.graph.out_edges(node_identifier)) == 0:
        # successful end state
        successful_states.append(state)
    return data_races, successful_states


# todo remove dead code
futures_cutoff_level = 14  # determines cutoff level (bottom-up), arbitrarily selected


def check_scheduling_graph(scheduling_graph: SchedulingGraph, dimensions: List[int]) -> List[DataRace]:
    # todo use dimensions to determine cutoff depth for task creation -> e.g. create tasks above 6 remaining levels
    initial_state = State(len(dimensions), scheduling_graph.lock_names, scheduling_graph.var_names)
    graph_depth = 0
    for entry in dimensions:
        graph_depth += entry
    return __old_check_node(scheduling_graph, scheduling_graph.root_node_identifier, initial_state, [], 0, graph_depth)


# todo keep for now as a template for multithreading
def __old_check_node(scheduling_graph: SchedulingGraph, node_identifier, state: State,
                     previous_writes: List[ScheduleElement], level, graph_depth) -> List[DataRace]:
    global futures_cutoff_level
    node_schedule_element: ScheduleElement = scheduling_graph.graph.nodes[node_identifier]["data"]
    if node_schedule_element is not None:
        # perform State update
        result = goto_next_state(state, node_schedule_element, previous_writes)
        if type(result) == State:
            state = result
        else:
            data_race: DataRace = cast(DataRace, result)
            return [data_race]

    data_races = []

    # check if multithreading should be used
    if level <= graph_depth - futures_cutoff_level:
        futures = []
        with concurrent.futures.ThreadPoolExecutor() as executor:
            for source, target in scheduling_graph.graph.out_edges(node_identifier):
                state_copy = copy.deepcopy(state)
                previous_writes_copy = copy.copy(previous_writes)
                if node_schedule_element is not None:
                    if node_schedule_element.contains_write():
                        previous_writes_copy.append(node_schedule_element)
                futures.append(
                    executor.submit(__old_check_node, scheduling_graph, target, state_copy, previous_writes_copy,
                                    level + 1, graph_depth))
                # data_races += __check_node(scheduling_graph, target, state_copy, previous_writes_copy)
        for future in futures:
            if future.result() is not None:
                data_races += future.result()
    else:
        # no multithreading
        for source, target in scheduling_graph.graph.out_edges(node_identifier):
            state_copy = copy.deepcopy(state)
            previous_writes_copy = copy.copy(previous_writes)
            if node_schedule_element is not None:
                if node_schedule_element.contains_write():
                    previous_writes_copy.append(node_schedule_element)
            data_races += __old_check_node(scheduling_graph, target, state_copy, previous_writes_copy, level + 1,
                                           graph_depth)
    return data_races
