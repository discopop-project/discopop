from discopop_validation.interfaces.discopop_explorer import is_loop_index
from discopop_validation.data_race_prediction.vc_data_race_detector.classes.DataRace import DataRace


# todo not included yet
def __check_parallel_for_exception_rules(data_race: DataRace, pet, parallelization_suggestions) -> bool:
    """Checks if the given data race is valid according to the parallel_for exception rules.
    Returns True, if the data race is valid and should be kept.
    Returns False, if the data race is invalid and should be removed."""
    is_valid = True
    is_valid = is_valid and __parallel_for_exception_rule_1(data_race, pet)
    is_valid = is_valid and __parallel_for_exception_rule_2(data_race, pet, parallelization_suggestions)
    return is_valid


def __parallel_for_exception_rule_1(data_race: DataRace, pet) -> bool:
    """exception 1: If only one index is used and it is a loop index of parent suggestion loop, the data race can be removed."""
    if len(data_race.get_used_indices()) > 1:
        return True
    else:
        for index in data_race.get_used_indices():
            if is_loop_index(pet, pet.node_at(data_race.get_cu_id()), index):
                print("IS LOOP INDEX:", index)
                return False
        return True


def __parallel_for_exception_rule_2(data_race: DataRace, pet, parallelization_suggestions) -> bool:
    """exception 1: If multiple loop indices are used and no inner index is shared, the data race can be removed.
    shared: either explicitly mentioned as shared, or not mentioned as private / firstprivate"""
    if len(data_race.get_used_indices()) <= 1:
        return True
    else:
        for ct, index in enumerate(data_race.get_used_indices()):
            # ignore first index
            if ct == 0:
                continue
            # check if shared inner index existst
            if is_loop_index(pet, pet.node_at(data_race.get_cu_id()), index):
                # get parallelization suggestions for root node
                for suggestion in parallelization_suggestions["do_all"]:
                    if suggestion["node_id"] == data_race.get_cu_id():
                        # check if index is shared (either in shared, or not in first_private + private
                        if index in suggestion["shared"] or index not in suggestion["first_private"] + suggestion["private"]:
                            # index is shared => data race can not be removed
                            print("IS SHARED INDEX:", index)
                            return True
        print("NO SHARED INDEX")
        return False