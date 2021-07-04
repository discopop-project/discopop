from typing import List, Tuple, Dict

from .scheduling_graph import SchedulingGraph
from ..interfaces.BBGraph import BBNode, BBGraph, Operation
from ..vc_data_race_detector.schedule import Schedule, ScheduleElement, UpdateType
from ..vc_data_race_detector.data_race_detector import check_schedule, State


def create_schedules_for_sections(bb_graph: BBGraph, sections_to_path_combinations_dict: Dict[int, List[List[List[BBNode]]]]) -> Dict[int, List[Schedule]]:
    """creates a mapping from sections to list of schedules to be checked based on the extracted behavior."""
    sections_to_schedules_dict: Dict[int, List[Schedule]] = {}
    for section_id in sections_to_path_combinations_dict:
        for combination in sections_to_path_combinations_dict[section_id]:
            if section_id in sections_to_schedules_dict:
                sections_to_schedules_dict[section_id] += __create_schedules_from_path_combination(bb_graph, combination)
            else:
                sections_to_schedules_dict[section_id] = __create_schedules_from_path_combination(bb_graph, combination)
    return sections_to_schedules_dict



def __create_schedules_from_path_combination(bb_graph: BBGraph, path_combination: List[List[BBNode]]) -> List[Schedule]:
    """creates a list of Schedules based on the given combination of paths"""
    if len(path_combination) == 0:
        return []
    if len(path_combination) == 1:
        # duplicate element to model schedules for "two threads execute same path"
        path_combination.append(path_combination[0])

    # convert path combination to schedule element combination
    schedule_element_combination: List[List[ScheduleElement]] = []
    for thread_id, elem in enumerate(path_combination):
        schedule_element_combination.append(__convert_operation_path_to_schedule_element_path(thread_id,
            bb_graph.convert_bb_path_to_operations(elem)))

    dimensions = [len(c) for c in schedule_element_combination]
    scheduling_graph = SchedulingGraph(dimensions, schedule_element_combination)
    schedules = scheduling_graph.get_schedules()

    return schedules


def __convert_operation_path_to_schedule_element_path(executing_thread_id: int, operation_path: List[Tuple[int, Operation]]) -> List[ScheduleElement]:
    schedule_elements: List[ScheduleElement] = []
    for parent_bb_id, operation in operation_path:
        schedule_elements.append(__convert_operation_to_schedule_element(operation, executing_thread_id, parent_bb_id))
    return schedule_elements


def __convert_operation_to_schedule_element(operation: Operation, executing_thread_id: int, parent_bb_id: int) -> ScheduleElement:
    schedule_element: ScheduleElement = ScheduleElement(executing_thread_id, parent_basic_block_id=parent_bb_id)
    # todo mode c (call)
    if operation.mode == "w":
        update_type = UpdateType.WRITE
    elif operation.mode == "r":
        update_type = UpdateType.READ
    else:
        raise ValueError("Unsupported mode: ", operation.mode)
    schedule_element.add_update(operation.target_name, update_type, operation=operation)
    return schedule_element
