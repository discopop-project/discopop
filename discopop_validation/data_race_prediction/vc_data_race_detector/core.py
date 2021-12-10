from typing import List

from discopop_validation.data_race_prediction.scheduler.classes.ScheduleElement import ScheduleElement
from discopop_validation.data_race_prediction.scheduler.classes.SchedulingGraph import SchedulingGraph
from discopop_validation.data_race_prediction.vc_data_race_detector.classes.State import State
from discopop_validation.data_race_prediction.vc_data_race_detector.data_race_detector import goto_next_state


def check_scheduling_graph(scheduling_graph: SchedulingGraph, dimensions: List[int]):
    # todo use dimensions to determine cutoff depth for task creation -> e.g. create tasks above 6 remaining levels
    initial_state = State(len(dimensions), scheduling_graph.lock_names, scheduling_graph.var_names)
    __check_node(scheduling_graph, scheduling_graph.root_node_identifier, initial_state)


def __check_node(scheduling_graph: SchedulingGraph, node_identifier,state: State):

    node_schedule_element: ScheduleElement = scheduling_graph.graph.nodes[node_identifier]["data"]
    #print("-->", node_schedule_element)
    if node_schedule_element is not None:
        # perform State update
        updated_state = goto_next_state(state, node_schedule_element)
        state = updated_state

    for source, target in scheduling_graph.graph.out_edges(node_identifier):
        try:
            __check_node(scheduling_graph, target, state)
        except ValueError:
            print("DATA RACE: TODO: create DR object", )

    pass