from typing import List, Tuple

from discopop_validation.classes.Configuration import Configuration
from discopop_validation.classes.OmpPragma import PragmaType, OmpPragma
from discopop_validation.data_race_prediction.behavior_modeller.classes.BehaviorModel import BehaviorModel

import discopop_validation.data_race_prediction.behavior_modeller.utils.modifications.parallel_for as parallel_for


def modify_behavior_models(unmodified_behavior_models: List[BehaviorModel],
                           target_code_section: Tuple[str, str, str, str, str, str],
                           pragma: OmpPragma,
                           omp_pragmas: List[OmpPragma],
                           run_configuration: Configuration):
    """modify the given operation sequences to represent the behavior of the given target code section,
    considering the respective parallelization suggestion"""
    pragma_type = target_code_section[5]
    # todo currently, only parallel_for is supported
    if pragma_type == str(PragmaType.PARALLEL_FOR):
        return parallel_for.apply_behavior_modification(unmodified_behavior_models, pragma, omp_pragmas, run_configuration)
    else:
        import warnings
        warnings.warn("TODO: Pragma type: "+pragma_type+ " not supported!")
        return unmodified_behavior_models