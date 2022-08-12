from typing import List, Tuple

import discopop_validation.data_race_prediction.behavior_modeller.utils.modifications.pragma_for as pragma_for
from discopop_validation.classes.Configuration import Configuration
from discopop_validation.classes.OmpPragma import PragmaType, OmpPragma
from discopop_validation.data_race_prediction.behavior_modeller.classes.BehaviorModel import BehaviorModel


def modify_behavior_models(unmodified_behavior_models: List[BehaviorModel],
                           target_code_section: Tuple[str, str, str, str, str],
                           pragma: OmpPragma,
                           omp_pragmas: List[OmpPragma],
                           run_configuration: Configuration):
    """modify the given operation sequences to represent the behavior of the given target code section,
    considering the respective parallelization suggestion"""
    pragma_type = target_code_section[4]
    # todo currently, only FOR is supported
    if pragma_type == str(PragmaType.FOR):
        return pragma_for.apply_behavior_modification(unmodified_behavior_models, pragma, omp_pragmas,
                                                      run_configuration)
    else:
        return unmodified_behavior_models
