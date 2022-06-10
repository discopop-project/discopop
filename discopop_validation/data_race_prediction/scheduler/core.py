from typing import List, Tuple, Dict

from discopop_validation.data_race_prediction.behavior_modeller.classes.BehaviorModel import BehaviorModel
from discopop_validation.data_race_prediction.scheduler.utils.conversions import convert_bb_path_to_operations
from discopop_validation.data_race_prediction.scheduler.classes.SchedulingGraph import SchedulingGraph
from discopop_validation.data_race_prediction.behavior_modeller.classes.BBGraph import BBGraph
from discopop_validation.data_race_prediction.behavior_modeller.classes.BBNode import BBNode
from discopop_validation.data_race_prediction.behavior_modeller.classes.Operation import Operation
from discopop_validation.data_race_prediction.scheduler.classes.Schedule import Schedule
from discopop_validation.data_race_prediction.scheduler.classes.ScheduleElement import ScheduleElement
from discopop_validation.data_race_prediction.scheduler.classes.UpdateType import UpdateType
from discopop_validation.data_race_prediction.scheduler.utils.schedules import get_schedules



def create_scheduling_graph_from_behavior_models(behavior_models: List[BehaviorModel]) -> Tuple[SchedulingGraph, List[int]]:
    """creates a scheduling graph based on the given combination of BehaviorModels"""
    if len(behavior_models) == 0:
        return SchedulingGraph([], behavior_models), []
    # create conversion of BehaviorModel's operations to ScheduleElements
    for thread_id, behavior_model in enumerate(behavior_models):
        behavior_model.schedule_elements = __convert_operation_list_to_schedule_element_list(behavior_model.operations, thread_id)
    dimensions = [len(model.schedule_elements) for model in behavior_models]
    scheduling_graph = SchedulingGraph(dimensions, behavior_models)
    return scheduling_graph, dimensions


def __convert_operation_list_to_schedule_element_list(operation_list: List[Operation], thread_id: int) -> List[ScheduleElement]:
    schedule_elements: List[ScheduleElement] = []
    for operation in operation_list:
        schedule_elements.append(__convert_operation_to_schedule_element(operation, thread_id))
    return schedule_elements


def __convert_operation_to_schedule_element(operation: Operation, executing_thread_id: int) -> ScheduleElement:
    schedule_element: ScheduleElement = ScheduleElement(executing_thread_id)
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
