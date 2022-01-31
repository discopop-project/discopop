from typing import List

from discopop_validation.classes.OmpPragma import PragmaType
from discopop_validation.data_race_prediction.vc_data_race_detector.classes.DataRace import DataRace
from discopop_validation.data_race_prediction.vc_data_race_detector.exception_rules.parallel_for import __check_parallel_for_exception_rules


def apply_exception_rules(unfiltered_data_races: List[DataRace], pet, parallelization_suggestions) -> List[DataRace]:
    """apllies suggestion-type-specific exception rules and removes unnecessary / incorrect Data races."""
    filtered_data_races: List[DataRace] = []
    for data_race in unfiltered_data_races:
        dr_is_valid = False
        if str(data_race.get_parent_suggestion_type()) == str(PragmaType.PARALLEL_FOR):
            dr_is_valid = __check_parallel_for_exception_rules(data_race, pet, parallelization_suggestions)

        if dr_is_valid:
            filtered_data_races.append(data_race)

    return filtered_data_races