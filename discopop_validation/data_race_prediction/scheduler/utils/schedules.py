from typing import List

from discopop_validation.data_race_prediction.scheduler.classes.Schedule import Schedule
from discopop_validation.data_race_prediction.scheduler.classes.ScheduleElement import ScheduleElement
from discopop_validation.data_race_prediction.scheduler.utils.filtering import filter_schedules


def __get_paths(graph, current_node_identifier) -> List[List[ScheduleElement]]:
    # recursion condition
    if len(graph.out_edges(current_node_identifier)) == 0:
        return [[graph.nodes[current_node_identifier]["data"]]]
    paths = []
    # collect paths of children
    for out_edge in graph.out_edges(current_node_identifier):
        child_node_identifier = out_edge[1]
        paths += __get_paths(graph, child_node_identifier)
    # append ScheduleElement of current node to front of children's paths
    for path in paths:
        path.insert(0, graph.nodes[current_node_identifier]["data"])
    return paths


# TODO currently unused, kept for now for possible debugging
def __count_paths(graph, current_node_identifier) -> int:
    if len(graph.out_edges(current_node_identifier)) == 0:
        count = 1
    else:
        count = 0
    for out_edge in graph.out_edges(current_node_identifier):
        child_node_identifier = out_edge[1]
        count += __count_paths(graph, child_node_identifier)
    return count


def __convert_path_to_schedule(path: List[ScheduleElement]) -> Schedule:
    schedule = Schedule()
    for element in path:
        # skip root node of scheduling graph
        if element is None:
            continue
        schedule.add_element(element)
    return schedule


def get_schedules(graph, root_node_identifier) -> List[Schedule]:
    paths = __get_paths(graph, root_node_identifier)
    #for path in paths:
     #   print()
      #  print([str(e) for e in path])
    schedules: List[Schedule] = []
    for path in paths:
        schedules.append(__convert_path_to_schedule(path))
    # schedules can contain invalid schedules (such, that violate locking orders (i.e. lock(a)-lock(a)-unlock(a)-unlock(a))
    # filter out such cases
    schedules = filter_schedules(schedules)
    return schedules