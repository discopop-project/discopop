from .data_race_classes import State, DataRace
from ..interfaces.BBGraph import Operation
from typing import Dict, List, Tuple, Optional
from .vector_clock import get_updated_vc, increase, compare_vc
from .schedule import Schedule, ScheduleElement, UpdateType
from ..interfaces.discopop_explorer import is_loop_index


def check_sections(sections_to_schedules_dict: Dict[int, List[Schedule]]) -> List[DataRace]:
    """executes check_schedule for each Schedule of each section in the given dictionary.
    Returns an unfiltered list of found DataRaces (may contain duplicates!)."""
    found_data_races: List[DataRace] = []
    # execute VC Check
    for section_id in sections_to_schedules_dict:
        for schedule in sections_to_schedules_dict[section_id]:
            data_races = check_schedule(schedule)
            if len(data_races) != 0:
                for check_result in data_races:
                    # check not successful, data race detected
                    state: State = check_result[0]
                    schedule_element = check_result[1]
                    previous_writes = check_result[2]
                    data_race: DataRace = DataRace(section_id, schedule_element, previous_writes)
                    found_data_races.append(data_race)
    return found_data_races


def check_schedule(schedule: Schedule) -> List[Tuple[State, ScheduleElement, List[ScheduleElement]]]:
    """check the entire schedule.
    Return None, if no data race has been found.
    Returns (problematic_state, problematic_schedule_element, [previous ScheduleElements which write var])
    if a data race has been identified.
    TODO find proper output format (problematic statements)"""
    state = State(schedule.thread_count, schedule.lock_names, schedule.var_names)
    data_races: List[Tuple[State, ScheduleElement, List[ScheduleElement]]] = []
    for idx, schedule_element in enumerate(schedule.elements):
        try:
            state = goto_next_state(state, schedule_element)
        except ValueError:
            # find last write accesses to var, which are performed by other threads
            # search by traversing path in reverse
            seen_thread_ids = [schedule_element.thread_id]
            previous_writes = []
            elements_reverse = schedule.elements[:]
            elements_reverse.reverse()
            for offset in range(idx):
                previous_element = elements_reverse[offset+len(elements_reverse)-idx]
                if previous_element.thread_id in seen_thread_ids:
                    continue
                # check updates for write to var
                for update in previous_element.updates:
                    if update[0] == schedule_element.updates[0][0] and update[1] is UpdateType.WRITE:
                        # add previous_element.thread_id to seen_thread_ids
                        seen_thread_ids.append(previous_element.thread_id)
                        previous_writes.append(previous_element)
            # data races can only occur, if a previous write exists
            if len(previous_writes) > 0:
                data_races.append((state, schedule_element, previous_writes))
            break
    return data_races


def goto_next_state(state: State, schedule_element: ScheduleElement) -> State:
    """updates state according to the given ScheduleElement.
    Raises ValueError, if a data race has been detected."""
    for update in schedule_element.updates:
        state = __perform_update(state, schedule_element.thread_id, update)
    __check_state(state, schedule_element)
    return state


def __check_state(state: State, schedule_element: ScheduleElement):
    """checks the current state for data races.
    Raises ValueError, if a data race has been identified."""
    read_variables = []
    written_variables = []
    for update_var, update_type, _, _ in schedule_element.updates:
        if update_type is UpdateType.READ:
            read_variables.append(update_var)
        if update_type is UpdateType.WRITE:
            written_variables.append(update_var)
    read_variables = list(set(read_variables))
    written_variables = list(set(written_variables))
    for var in read_variables:
        if not compare_vc(state.var_write_clocks[var], state.thread_clocks[schedule_element.thread_id]):
            raise ValueError("Data Race detected!")
    for var in written_variables:
        if (not compare_vc(state.var_read_clocks[var], state.thread_clocks[schedule_element.thread_id])) or \
                (not compare_vc(state.var_write_clocks[var], state.thread_clocks[schedule_element.thread_id])):
            raise ValueError("Data Race detected!")


def __perform_update(state: State, thread_id: int, update: Tuple[str, UpdateType, List[int], Optional[Operation]]) -> State:
    """Performs single update as contained in ScheduleElement."""
    update_var, update_type, affected_thread_ids, operation = update

    if update_type is UpdateType.READ:
        # update variable read clock
        if state.var_read_clocks[update_var].clocks[thread_id] < state.thread_clocks[thread_id].clocks[thread_id]:
            state.var_read_clocks[update_var].clocks[thread_id] = state.thread_clocks[thread_id].clocks[thread_id]
    elif update_type is UpdateType.WRITE:
        # update variable write clock
        if state.var_write_clocks[update_var].clocks[thread_id] < state.thread_clocks[thread_id].clocks[thread_id]:
            state.var_write_clocks[update_var].clocks[thread_id] = state.thread_clocks[thread_id].clocks[thread_id]
    elif update_type is UpdateType.ENTERPARALLEL:
        for tid in affected_thread_ids:
            state.thread_clocks[tid] = get_updated_vc(state.thread_clocks[tid],
                                                      state.thread_clocks[thread_id])
        increase(state.thread_clocks[thread_id], thread_id)
    elif update_type is UpdateType.EXITPARALLEL:
        for tid in affected_thread_ids:
            state.thread_clocks[thread_id] = get_updated_vc(state.thread_clocks[thread_id],
                                                            state.thread_clocks[tid])
            increase(state.thread_clocks[tid], tid)
    elif update_type is UpdateType.LOCK:
        state.thread_clocks[thread_id] = get_updated_vc(state.thread_clocks[thread_id], state.lock_clocks[update_var])
    elif update_type is UpdateType.UNLOCK:
        state.lock_clocks[update_var] = get_updated_vc(state.lock_clocks[update_var], state.thread_clocks[thread_id])
        increase(state.thread_clocks[thread_id], thread_id)

    # todo check if constraints for multiple / nested parallel sections are met

    return state


def get_filtered_data_race_strings(unfiltered_data_races: List[DataRace]) -> List[DataRace]:
    """Takes a unfiltered list of found data races and returns a filtered list of strings.
    The filtering removes duplicates. Entries are duplicates, if another entry with
    the exact same string representation exists.
    The output of this functions is used only for outputting to the console."""
    filtered_data_race_strings: List[str] = []
    for dr in unfiltered_data_races:
        dr_str = str(dr)
        if dr_str not in [fdr_str for fdr_str in filtered_data_race_strings]:
            filtered_data_race_strings.append(dr_str)
    return filtered_data_race_strings


def apply_exception_rules(unfiltered_data_races: List[DataRace], pet) -> List[DataRace]:
    """apllies suggestion-type-specific exception rules and removes unnecessary / incorrect Data races."""
    filtered_data_races: List[DataRace] = []
    for data_race in unfiltered_data_races:
        dr_is_valid = False
        if data_race.get_parent_suggestion_type() == "do_all":
            dr_is_valid = __check_do_all_exception_rules(data_race, pet)

        if dr_is_valid:
            filtered_data_races.append(data_race)

    return filtered_data_races


def __check_do_all_exception_rules(data_race: DataRace, pet) -> bool:
    """Checks if the given data race is valid according to the do_all exception rules.
    Returns True, if the data race is valid and should be kept.
    Returns False, if the data race is invalid and should be removed."""
    is_valid = True
    is_valid = is_valid and __do_all_exception_rule_1(data_race, pet)
    return is_valid


def __do_all_exception_rule_1(data_race: DataRace, pet) -> bool:
    """exception 1: If at least one used index is loop index of parent suggestion loop, the data race can be removed."""
    for index in data_race.get_used_indices():
        print("INDEX: ", index)
        if is_loop_index(pet, pet.node_at(data_race.get_cu_id()), index):
            print("LOOP INDEX: ", index)
            return False
        else:
            print("NO LOOP INDEX")
    return True