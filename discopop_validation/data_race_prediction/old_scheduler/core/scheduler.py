from typing import List, Tuple, Dict

from discopop_validation.data_race_prediction.old_scheduler.utils.conversions import convert_bb_path_to_operations
from discopop_validation.data_race_prediction.old_scheduler.classes.SchedulingGraph import SchedulingGraph
from discopop_validation.data_race_prediction.behavior_modeller.classes.BBGraph import BBGraph
from discopop_validation.data_race_prediction.behavior_modeller.classes.BBNode import BBNode
from discopop_validation.data_race_prediction.behavior_modeller.classes.Operation import Operation
from discopop_validation.data_race_prediction.old_scheduler.classes.Schedule import Schedule
from discopop_validation.data_race_prediction.old_scheduler.classes.ScheduleElement import ScheduleElement
from discopop_validation.data_race_prediction.old_scheduler.classes.UpdateType import UpdateType
from discopop_validation.data_race_prediction.old_scheduler.utils.schedules import get_schedules


def create_schedules_for_sections(bb_graph: BBGraph, sections_to_path_combinations_dict: Dict[int, List[List[List[BBNode]]]], verbose: bool = False) -> Dict[int, List[Schedule]]:
    """creates a mapping from sections to list of schedules to be checked based on the extracted behavior."""
    sections_to_schedules_dict: Dict[int, List[Schedule]] = {}
    verbose_progress_str = ""
    for s_idx, section_id in enumerate(sections_to_path_combinations_dict):
        comb_len = len(sections_to_path_combinations_dict[section_id])
        for c_idx, combination in enumerate(sections_to_path_combinations_dict[section_id]):
            if verbose:
                verbose_progress_str = "\t" + str(s_idx) + "-" + str(c_idx) + " / " + str(s_idx) + "-" + str(comb_len) + "\t" + "(" + str(s_idx) + " / " + str(len(sections_to_path_combinations_dict)) + ")"
                print(verbose_progress_str, end="\r")
            if section_id in sections_to_schedules_dict:
                sections_to_schedules_dict[section_id] += __create_schedules_from_path_combination(bb_graph, section_id, combination)
            else:
                sections_to_schedules_dict[section_id] = __create_schedules_from_path_combination(bb_graph, section_id, combination)
    if verbose:
        print(verbose_progress_str)
    return sections_to_schedules_dict



def __create_schedules_from_path_combination(bb_graph: BBGraph, section_id: int, path_combination: List[List[BBNode]]) -> List[Schedule]:
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
                                                                                              convert_bb_path_to_operations(
                                                                                                  bb_graph.bb_path_to_operations_cache,
                                                                                                  section_id, elem)))

    dimensions = [len(c) for c in schedule_element_combination]
    scheduling_graph = SchedulingGraph(dimensions, schedule_element_combination)
    schedules = get_schedules(scheduling_graph.graph, scheduling_graph.root_node_identifier)
    return schedules


def __convert_operation_path_to_schedule_element_path(executing_thread_id: int, operation_path: List[Tuple[int, Operation]]) -> List[ScheduleElement]:
    schedule_elements: List[ScheduleElement] = []
    for parent_bb_id, operation in operation_path:
        schedule_elements.append(__convert_operation_to_schedule_element(operation, executing_thread_id, parent_bb_id))
    return schedule_elements


def __convert_operation_to_schedule_element(operation: Operation, executing_thread_id: int, parent_bb_id: int) -> ScheduleElement:
    schedule_element: ScheduleElement = ScheduleElement(executing_thread_id, parent_basic_block_id=parent_bb_id)
    # w -> write; cw -> write inside called function
    # r -> read; cr -> read inside called function
    # note: variable amount of c's, each representing a function call layer
    # note: since e.g 'w' and 'cw' are treated equally, it is sufficient to unpack the last character of operation.mode and ignore the c's
    if operation.mode[-1] == "w":
        update_type = UpdateType.WRITE
    elif operation.mode[-1] == "r":
        update_type = UpdateType.READ
    elif operation.mode[-1] == "l":
        update_type = UpdateType.LOCK
    elif operation.mode[-1] == "u":
        update_type = UpdateType.UNLOCK
    else:
        raise ValueError("Unsupported mode: ", operation.mode)
    schedule_element.add_update(operation.target_name, update_type, operation=operation)
    return schedule_element
