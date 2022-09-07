import copy
import random
import string
from typing import List

from discopop_validation.classes.Configuration import Configuration
from discopop_validation.classes.OmpPragma import OmpPragma
from discopop_validation.data_race_prediction.behavior_modeller.classes.BehaviorModel import BehaviorModel
from discopop_validation.data_race_prediction.behavior_modeller.classes.OperationModifierType import \
    OperationModifierType
from discopop_validation.data_race_prediction.behavior_modeller.utils.behavior_extraction import \
    execute_bb_graph_extraction
from discopop_validation.data_race_prediction.behavior_modeller.utils.modifications.core import modify_behavior_models
from discopop_validation.data_race_prediction.behavior_modeller.utils.modifications.insert_critical_sections import \
    insert_critical_sections
from discopop_validation.data_race_prediction.behavior_modeller.utils.postprocessing import apply_post_processing
from discopop_validation.data_race_prediction.behavior_modeller.utils.utils import get_paths


def extract_postprocessed_behavior_models(run_configuration: Configuration, pet, tcs, pragma: OmpPragma,
                                          omp_pragmas: List[OmpPragma]) -> List[BehaviorModel]:
    behavior_models = __extract_behavior_models(run_configuration, pet, tcs, pragma, omp_pragmas)
    postprocessed_behavior_models = apply_post_processing(behavior_models, pragma)
    return postprocessed_behavior_models


def __extract_behavior_models(run_configuration: Configuration, pet, tcs, pragma: OmpPragma,
                              omp_pragmas: List[OmpPragma]) -> List[BehaviorModel]:
    if run_configuration.verbose_mode:
        print("extracting BB Graph...")
    bb_graph = execute_bb_graph_extraction([tcs], run_configuration.file_mapping, run_configuration.ll_file,
                                           run_configuration.dp_build_path)
    if run_configuration.verbose_mode:
        print("insering critical sections into BB Graph...")
    insert_critical_sections(bb_graph, omp_pragmas)
    unmodified_behavior_models: List[BehaviorModel] = get_unmodified_behavior_models(run_configuration, bb_graph)
    modified_behavior_models: List[BehaviorModel] = modify_behavior_models(unmodified_behavior_models, tcs, pragma,
                                                                           omp_pragmas, run_configuration)
    return modified_behavior_models


def get_unmodified_behavior_models(run_configuration: Configuration, bb_graph) -> List[BehaviorModel]:
    paths = get_paths(bb_graph)
    # convert paths to read/write sequences
    behavior_models: List[BehaviorModel] = []
    for section_id in paths:
        # multiple paths result from different paths through the target source code
        # since paths are mutually exclusive, mark the resulting operations as such
        mutex_id = ''.join(random.choices(string.ascii_uppercase + string.digits, k=16))
        for path_id, path in enumerate(paths[section_id]):
            current_sequence = []
            for bb_node in path:
                # modify lines of operations according to run_configuration.line_mapping
                bb_node.apply_line_mapping_to_operations(run_configuration)
                tmp_operations = copy.deepcopy(bb_node.operations)
                # add mutex modifier
                for op in tmp_operations:
                    op.add_modifier(OperationModifierType.MUTEX, mutex_id + ":" + str(path_id))
                current_sequence += tmp_operations
            behavior_models.append(BehaviorModel(current_sequence))
    return behavior_models
