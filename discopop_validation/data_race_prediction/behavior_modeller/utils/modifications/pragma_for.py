import random
import string

from typing import List, Dict, Tuple

from discopop_validation.classes.Configuration import Configuration
from discopop_validation.classes.OmpPragma import OmpPragma
from discopop_validation.data_race_prediction.behavior_modeller.classes.BehaviorModel import BehaviorModel
from discopop_validation.data_race_prediction.behavior_modeller.classes.OperationModifierType import \
    OperationModifierType


def apply_behavior_modification(unmodified_behavior_models: List[BehaviorModel], pragma: OmpPragma,
                                omp_pragmas: List[OmpPragma], run_configuration: Configuration):
    modified_behavior_models: List[BehaviorModel] = []
    for model in unmodified_behavior_models:
        if len(pragma.get_variables_listed_as("reduction")) > 0:
            # current pragma contains a reduction
            modified_behavior_models.append(__apply_reduction_modification(model, pragma, run_configuration))
        else:
            # current pragma does not contain a reduction
            modified_behavior_models.append(model)
    return modified_behavior_models


def __apply_reduction_modification(behavior_model: BehaviorModel, pragma: OmpPragma,
                                   run_configuration: Configuration) -> BehaviorModel:
    """search for the reduction operation and mark it by adding an entry to the list of modifiers"""
    if pragma is None:
        return behavior_model
    # get a list of reduction operations from reduction file
    reduction_line_information = []
    with open(run_configuration.reduction_file, "r") as reduction_file:
        for reduction_line in reduction_file.readlines():
            reduction_line = reduction_line.replace("\n", "")
            # remove unnecessary string parts
            reduction_line = reduction_line.replace("FileID", "").replace("Loop Line Number", "").replace(
                "Reduction Line Number", "")
            reduction_line = reduction_line.replace("Variable Name", "").replace("Operation Name", "")
            reduction_line = reduction_line.replace(" ", "")
            # unpack reduction lines
            split_line = reduction_line.split(":")
            file_id = split_line[1]
            loop_line_number = split_line[2]
            reduction_line_number = split_line[3]
            variable_name = split_line[4]
            operation_name = split_line[5]
            # save identified reduction operation
            reduction_line_information.append((file_id, reduction_line_number, variable_name))
    # search for reduction operations in behavior_models.operations and
    # mark reduction operations by adding a modifier (read + write if existent)
    pragma_reduction_variables = pragma.get_variables_listed_as("reduction")
    reduction_operation_id_buffer: Dict[Tuple[str, str, str], str] = dict()
    for operation in behavior_model.operations:
        if operation.target_name not in pragma_reduction_variables:
            continue
        # check if operation is a reduction operation
        if (str(operation.file_id), str(operation.line), operation.target_name) in reduction_line_information:
            # operation is a reduction operation
            # check if reduction_operation_id for current reduction exists
            if (str(operation.file_id), str(operation.line), operation.target_name) in reduction_operation_id_buffer:
                operation_id = reduction_operation_id_buffer[
                    (str(operation.file_id), str(operation.line), operation.target_name)]
            else:
                operation_id = ''.join(random.choices(string.ascii_uppercase + string.digits, k=32))
                reduction_operation_id_buffer[
                    (str(operation.file_id), str(operation.line), operation.target_name)] = operation_id
            operation.add_modifier(OperationModifierType.REDUCTION_OPERATION, operation_id)

    return behavior_model
