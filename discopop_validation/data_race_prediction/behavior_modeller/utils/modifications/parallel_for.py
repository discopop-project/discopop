from typing import List

from discopop_validation.classes.OmpPragma import OmpPragma
from discopop_validation.data_race_prediction.behavior_modeller.classes.BehaviorModel import BehaviorModel
import random
import string

from discopop_validation.data_race_prediction.behavior_modeller.classes.OperationModifierType import \
    OperationModifierType


def apply_behavior_modification(unmodified_behavior_models: List[BehaviorModel], pragma: OmpPragma, omp_pragmas: List[OmpPragma]):
    modified_behavior_models: List[BehaviorModel] = []
    for model in unmodified_behavior_models:
        if len(pragma.get_variables_listed_as("reduction")) > 0:
            # current pragma contains a reduction
            modified_behavior_models.append(__apply_reduction_modification(model, pragma))
        else:
            # current pragma does not contain a reduction
            modified_behavior_models.append(model)
    return modified_behavior_models


def __apply_reduction_modification(behavior_model: BehaviorModel, pragma: OmpPragma) -> BehaviorModel:
    """search for the reduction operation and mark it by adding an entry to the list of modifiers"""
    # search for reduction operation (read + write to reduction variable at same source code location)
    reduction_variables = pragma.get_variables_listed_as("reduction")
    buffer = dict()  # buffer last access to reduction variables
    for operation in behavior_model.operations:
        if operation.target_name not in reduction_variables:
            continue
        # operation is potentially a reduction operation
        if operation.target_name not in buffer:
            # add entry in buffer
            buffer[operation.target_name] = operation
            continue
        # buffer entry exists
        if operation.file_id == buffer[operation.target_name].file_id and \
            operation.line == buffer[operation.target_name].line and \
            operation.col == buffer[operation.target_name].col:
            # line + col equal
            if operation.mode == buffer[operation.target_name].mode:
                # access mode equal -> ignore
                continue
            else:
                # access mode different -> reduction
                # add a random hash value to the modifier to allow matching between copied operations
                operation_id = ''.join(random.choices(string.ascii_uppercase + string.digits, k=32))
                operation.add_modifier(OperationModifierType.REDUCTION_OPERATION, operation_id)
                # add modifier to second reduction operation (read or write respectively
                buffer[operation.target_name].add_modifier(OperationModifierType.REDUCTION_OPERATION, operation_id)
        else:
            # line + col different -> no reduction, update buffer
            buffer[operation.target_name] = operation
    return behavior_model