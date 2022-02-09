from typing import List
from copy import deepcopy
from discopop_validation.data_race_prediction.behavior_modeller.classes.BehaviorModel import BehaviorModel


def prepare_for_simulation(behavior_models: List[BehaviorModel], thread_count=2) -> List[BehaviorModel]:
    behavior_models = __simulate_multiple_threads(behavior_models, thread_count)
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