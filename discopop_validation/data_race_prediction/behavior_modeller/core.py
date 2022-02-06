from typing import List

from discopop_validation.classes.Configuration import Configuration
from discopop_validation.classes.OmpPragma import OmpPragma
from discopop_validation.data_race_prediction.behavior_modeller.classes.BehaviorModel import BehaviorModel
from discopop_validation.data_race_prediction.behavior_modeller.utils.modifications.insert_critical_sections import \
    insert_critical_sections
from discopop_validation.data_race_prediction.behavior_modeller.utils.behavior_extraction import \
    execute_bb_graph_extraction
from discopop_validation.data_race_prediction.behavior_modeller.utils.postprocessing import apply_post_processing
from discopop_validation.data_race_prediction.behavior_modeller.utils.modifications.core import modify_behavior_models
from discopop_validation.data_race_prediction.behavior_modeller.utils.utils import get_paths


def extract_postprocessed_behavior_models(run_configuration: Configuration, pet, tcs, omp_pragmas: List[OmpPragma]) -> List[BehaviorModel]:
    behavior_models = __extract_behavior_models(run_configuration, pet, tcs, omp_pragmas)
    postprocessed_behavior_models = apply_post_processing(behavior_models)
    return postprocessed_behavior_models


def __extract_behavior_models(run_configuration: Configuration, pet, tcs, omp_pragmas: List[OmpPragma]) -> List[BehaviorModel]:
    if run_configuration.verbose_mode:
        print("extracting BB Graph...")
    bb_graph = execute_bb_graph_extraction([tcs], run_configuration.file_mapping, run_configuration.ll_file, run_configuration.dp_build_path)
    if run_configuration.verbose_mode:
        print("insering critical sections into BB Graph...")
    insert_critical_sections(bb_graph, omp_pragmas)
    unmodified_behavior_models: List[BehaviorModel] = get_unmodified_behavior_models(bb_graph)
    modified_behavior_models: List[BehaviorModel] = modify_behavior_models(unmodified_behavior_models, tcs, omp_pragmas)
    return modified_behavior_models


def get_unmodified_behavior_models(bb_graph) -> List[BehaviorModel]:
    paths = get_paths(bb_graph)
    # convert paths to read/write sequences
    behavior_models: List[BehaviorModel] = []
    for section_id in paths:
        for path in paths[section_id]:
            current_sequence = []
            for bb_node in path:
                current_sequence += bb_node.operations
            behavior_models.append(BehaviorModel(current_sequence))
    return behavior_models