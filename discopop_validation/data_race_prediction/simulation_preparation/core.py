from typing import List
from copy import deepcopy
from discopop_validation.data_race_prediction.behavior_modeller.classes.BehaviorModel import BehaviorModel
from discopop_validation.data_race_prediction.behavior_modeller.classes.OperationModifierType import \
    OperationModifierType


def prepare_for_simulation(behavior_models: List[BehaviorModel], thread_count=2) -> List[BehaviorModel]:
    behavior_models = __simulate_multiple_threads(behavior_models, thread_count)
    behavior_models = __remove_multiples_of_reduction_operations(behavior_models)
    return behavior_models


def __simulate_multiple_threads(behavior_models: List[BehaviorModel], thread_count) -> List[BehaviorModel]:
    # simulation for thread_count threads
    # -> duplicate every entry in the list of behavior models for each thread which has to be simulated
    prepared_list: List[BehaviorModel] = []
    for model in behavior_models:
        prepared_list.append(model)
        for i in range(0, thread_count - 1):
            prepared_list.append(deepcopy(model))
    return prepared_list


def __remove_multiples_of_reduction_operations(behavior_models: List[BehaviorModel]) -> List[BehaviorModel]:
    """removes all but one copy of any identified reduction operation.
    Suppresses the creation of data races by a reduction operation
    while allowing the detection of data races between the reduction operation and other operations."""
    reduction_operation_buffer = []  # buffers the id's of already seen reduction operations to allow the deletion of duplicates
    for model in behavior_models:
        removable_operation_indices: List[int] = []
        for operation_idx, operation in enumerate(model.operations):
            for modifier_type, modifier_id in operation.modifiers:
                if modifier_type == OperationModifierType.REDUCTION_OPERATION:
                    # operation is a reduction operation. Check if ID is known.
                    if modifier_id in reduction_operation_buffer:
                        # operation is known and can be deleted
                        removable_operation_indices.append(operation_idx)
                    else:
                        # operation is unknown, add ID to buffer
                        reduction_operation_buffer.append(modifier_id)
        for idx in sorted(removable_operation_indices, reverse=True):
            del model.operations[idx]
    return behavior_models
