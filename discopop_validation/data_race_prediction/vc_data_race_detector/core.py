import copy
from typing import List, Optional

from discopop_validation.data_race_prediction.scheduler.classes.ScheduleElement import ScheduleElement
from discopop_validation.data_race_prediction.scheduler.classes.SchedulingGraph import SchedulingGraph
from discopop_validation.data_race_prediction.vc_data_race_detector.classes.DataRace import DataRace
from discopop_validation.data_race_prediction.vc_data_race_detector.classes.State import State
from discopop_validation.data_race_prediction.vc_data_race_detector.data_race_detector import goto_next_state
import concurrent.futures

futures_cutoff_level = 6
def check_scheduling_graph(scheduling_graph: SchedulingGraph, dimensions: List[int]) -> List[DataRace]:
    # todo use dimensions to determine cutoff depth for task creation -> e.g. create tasks above 6 remaining levels
    initial_state = State(len(dimensions), scheduling_graph.lock_names, scheduling_graph.var_names)
    return __check_node(scheduling_graph, scheduling_graph.root_node_identifier, initial_state, [], 0)


def __check_node(scheduling_graph: SchedulingGraph, node_identifier, state: State, previous_writes: List[ScheduleElement], level) -> List[DataRace]:
    global futures_cutoff_level
    node_schedule_element: ScheduleElement = scheduling_graph.graph.nodes[node_identifier]["data"]
    if node_schedule_element is not None:
        # perform State update
        result = goto_next_state(state, node_schedule_element, previous_writes)
        if type(result) == State:
            state = result
        else:
            data_race = result
            return [data_race]

    data_races = []

    # check if multithreading should be used
    if level <= futures_cutoff_level:
        futures = []
        with concurrent.futures.ThreadPoolExecutor() as executor:
            for source, target in scheduling_graph.graph.out_edges(node_identifier):
                state_copy = copy.deepcopy(state)
                previous_writes_copy = copy.copy(previous_writes)
                if node_schedule_element is not None:
                    if node_schedule_element.contains_write():
                        previous_writes_copy.append(node_schedule_element)
                futures.append(executor.submit(__check_node, scheduling_graph, target, state_copy, previous_writes_copy, level+1))
                #data_races += __check_node(scheduling_graph, target, state_copy, previous_writes_copy)
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
            data_races += __check_node(scheduling_graph, target, state_copy, previous_writes_copy, level+1)
    return data_races
