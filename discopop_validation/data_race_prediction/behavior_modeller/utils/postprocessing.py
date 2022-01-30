from typing import List

from discopop_validation.data_race_prediction.behavior_modeller.classes.BehaviorModel import BehaviorModel
from discopop_validation.data_race_prediction.behavior_modeller.classes.Operation import Operation


def apply_post_processing(behavior_models: List[BehaviorModel]) -> List[BehaviorModel]:
    behavior_models = group_successive_duplicate_operations(behavior_models)
    return behavior_models


def group_successive_duplicate_operations(behavior_models: List[BehaviorModel]) -> List[BehaviorModel]:
    for model in behavior_models:
        duplicated_found = True
        while duplicated_found:
            duplicated_found = False
            # detect duplicated successive operations
            prev_op = None
            to_be_removed: List[int] = []
            for idx, op in enumerate(model.operations):
                if prev_op is not None:
                    if prev_op == op:
                        to_be_removed.append(idx)
                        duplicated_found = True
                prev_op = op
            # remove found duplicates
            for idx in sorted(to_be_removed, reverse=True):
                del model.operations[idx]
    return behavior_models
