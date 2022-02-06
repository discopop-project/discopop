from typing import List

from discopop_validation.classes.OmpPragma import OmpPragma
from discopop_validation.data_race_prediction.behavior_modeller.classes.BehaviorModel import BehaviorModel


def apply_behavior_modification(unmodified_behavior_models: List[BehaviorModel], omp_pragmas: List[OmpPragma]):
    modified_behavior_models: List[BehaviorModel] = []
    for model in unmodified_behavior_models:
        print("model pre: ")
        for op in model.operations:
            print(op)
        print()
        modified_model = __remove_reduction_var_writes(model, omp_pragmas)

        print("model post:")
        for op in model.operations:
            print(op)
        print()
        modified_behavior_models.append(modified_model)
    return modified_behavior_models


def __remove_reduction_var_writes(behavior_model: BehaviorModel, omp_pragmas: List[OmpPragma]) -> BehaviorModel:
    """Assumption: OpenMP handles writes to reduction variables correctly. Thus, write accesses to reduction variables may be removed."""
    # filter operations
    operation_indices_to_be_removed: List[int] = []
    for omp_pragma in omp_pragmas:
        reduction_vars = omp_pragma.get_variables_listed_as("reduction")
        if len(reduction_vars) > 0:
            for red_var in reduction_vars:
                for idx, op in enumerate(behavior_model.operations):
                    if op.target_name == red_var and op.mode == "w":
                        # write to reduction var found, mark as removable
                        operation_indices_to_be_removed.append(idx)
    # remove identified write accesses to reduction variables
    for idx in sorted(operation_indices_to_be_removed, reverse=True):
        del behavior_model.operations[idx]

    return behavior_model