from typing import List

from discopop_validation.classes.OmpPragma import OmpPragma
from discopop_validation.data_race_prediction.behavior_modeller.classes.BehaviorModel import BehaviorModel


def apply_behavior_modification(unmodified_behavior_models: List[BehaviorModel], omp_pragmas: List[OmpPragma]):
    modified_behavior_models: List[BehaviorModel] = []
    for model in unmodified_behavior_models:
        modified_behavior_models.append(model)
    return modified_behavior_models