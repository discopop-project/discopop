from typing import List, Tuple

from discopop_validation.classes.Configuration import Configuration
from discopop_validation.data_race_prediction.behavior_modeller.classes.Operation import Operation
from discopop_validation.data_race_prediction.behavior_modeller.utils.bb_graph_modifications import \
    insert_critical_sections
from discopop_validation.data_race_prediction.behavior_modeller.utils.behavior_extraction import \
    execute_bb_graph_extraction
from discopop_validation.data_race_prediction.behavior_modeller.utils.utils import get_unmodified_operation_sequences, \
    modify_operation_sequences


def extract_behavior_model(run_configuration: Configuration, pet, tcs, parallelization_suggestions) -> List[List[Operation]]:
    if run_configuration.verbose_mode:
        print("extracting BB Graph...")
    bb_graph = execute_bb_graph_extraction([tcs], run_configuration.file_mapping, run_configuration.ll_file, run_configuration.dp_build_path)
    if run_configuration.verbose_mode:
        print("insering critical sections into BB Graph...")
    insert_critical_sections(bb_graph, parallelization_suggestions)
    unmodified_operation_sequences: List[List[Operation]] = get_unmodified_operation_sequences(bb_graph)
    modified_operation_sequences: List[List[Operation]] = modify_operation_sequences(unmodified_operation_sequences, tcs)
    return modified_operation_sequences

