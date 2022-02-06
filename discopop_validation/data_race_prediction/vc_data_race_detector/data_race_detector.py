from discopop_validation.data_race_prediction.vc_data_race_detector.classes.State import State
from .classes.DataRace import DataRace
from discopop_validation.data_race_prediction.behavior_modeller.classes.Operation import Operation
from typing import Dict, List, Tuple, Optional, Union
from discopop_validation.data_race_prediction.vc_data_race_detector.classes.VectorClock import get_updated_vc, increase, compare_vc
from discopop_validation.data_race_prediction.scheduler.classes.Schedule import Schedule
from discopop_validation.data_race_prediction.scheduler.classes.ScheduleElement import ScheduleElement
from discopop_validation.data_race_prediction.scheduler.classes.UpdateType import UpdateType


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
                    data_race: DataRace = DataRace(section_id, schedule, schedule_element, previous_writes)
                    found_data_races.append(data_race)
    return found_data_races


def check_schedule(schedule: Schedule, initial_state:Optional[State]=None) -> List[DataRace]:
    """check the entire schedule.
    Return None, if no data race has been found.
    Returns (problematic_state, problematic_schedule_element, [previous ScheduleElements which write var])
    if a data race has been identified."""
    if initial_state is None:
        state = State(schedule.thread_count, schedule.lock_names, schedule.var_names)
    else:
        state = initial_state
    previous_writes: List[ScheduleElement] = []
    for idx, schedule_element in enumerate(schedule.elements):
        result = goto_next_state(state, schedule_element, previous_writes)
        if type(result) is State:
            state = result
            if schedule_element.contains_write():
                previous_writes.append(schedule_element)
        else:
            data_race = result
            return [data_race]
    return []


def goto_next_state(state: State, schedule_element: ScheduleElement, previous_writes: List[ScheduleElement]) -> Union[State, DataRace]:
    """updates state according to the given ScheduleElement.
    Raises ValueError, if a data race has been detected."""
    for update in schedule_element.updates:
        state = __perform_update(state, schedule_element.thread_id, update)
    return __check_state(state, schedule_element, previous_writes)


def __check_state(state: State, schedule_element: ScheduleElement, previous_writes: List[ScheduleElement]) -> Union[State, DataRace]:
    """checks the current state for data races.
    Raises ValueError, if a data race has been identified.
    Returns state, if no data race has been identified."""
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
            data_race = DataRace(schedule_element, previous_writes, state)
            return data_race
    for var in written_variables:
        if (not compare_vc(state.var_read_clocks[var], state.thread_clocks[schedule_element.thread_id])) or \
                (not compare_vc(state.var_write_clocks[var], state.thread_clocks[schedule_element.thread_id])):
            data_race = DataRace(schedule_element, previous_writes, state)
            return data_race
    return state


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

    # todo (check if constraints for multiple / nested parallel sections are met)

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


