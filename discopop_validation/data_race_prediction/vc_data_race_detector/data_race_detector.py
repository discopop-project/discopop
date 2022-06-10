from typing import List, Tuple, Optional, Union, cast

from discopop_validation.data_race_prediction.behavior_modeller.classes.Operation import Operation
from discopop_validation.data_race_prediction.scheduler.classes.Schedule import Schedule
from discopop_validation.data_race_prediction.scheduler.classes.ScheduleElement import ScheduleElement
from discopop_validation.data_race_prediction.scheduler.classes.UpdateType import UpdateType
from discopop_validation.data_race_prediction.vc_data_race_detector.classes.State import State
from discopop_validation.data_race_prediction.vc_data_race_detector.classes.VectorClock import get_updated_vc, increase, \
    compare_vc
from .classes.DataRace import DataRace


def check_schedule(schedule: Schedule, initial_state: Optional[State] = None) -> List[DataRace]:
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
            data_race: DataRace = cast(DataRace, result)
            return [data_race]
    return []


def goto_next_state(state: State, schedule_element: ScheduleElement, previous_writes: List[ScheduleElement]) -> Union[
    State, DataRace]:
    """updates state according to the given ScheduleElement.
    Raises ValueError, if a data race has been detected."""
    for update in schedule_element.updates:
        state = __perform_update(state, schedule_element.thread_id, update)
    return __check_state(state, schedule_element, previous_writes)


def __check_state(state: State, schedule_element: ScheduleElement, previous_writes: List[ScheduleElement]) -> Union[
    State, DataRace]:
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
    read_variables = list(dict.fromkeys(read_variables))
    written_variables = list(dict.fromkeys(written_variables))
    for var in read_variables:
        if not compare_vc(state.var_write_clocks[var], state.thread_clocks[schedule_element.thread_id]):
            data_race = DataRace(schedule_element, previous_writes, state, var_name=var)
            return data_race
    for var in written_variables:
        if (not compare_vc(state.var_read_clocks[var], state.thread_clocks[schedule_element.thread_id])) or \
                (not compare_vc(state.var_write_clocks[var], state.thread_clocks[schedule_element.thread_id])):
            data_race = DataRace(schedule_element, previous_writes, state, var_name=var)
            return data_race
    return state


def __perform_update(state: State, thread_id: int,
                     update: Tuple[str, UpdateType, List[int], Optional[Operation]]) -> State:
    """Performs single update as contained in ScheduleElement."""
    update_var, update_type, affected_thread_ids, operation = update
    # ensure that state has vector clocks for given variable
    state.add_var_entries_if_missing(update_var)

    thread_clock_index = state.thread_id_to_clock_position_dict[thread_id]

    if update_type is UpdateType.READ:
        # update variable read clock
        if state.var_read_clocks[update_var].clocks[thread_clock_index] < state.thread_clocks[thread_id].clocks[
            thread_clock_index]:
            state.var_read_clocks[update_var].clocks[thread_clock_index] = state.thread_clocks[thread_id].clocks[
                thread_clock_index]
    elif update_type is UpdateType.WRITE:
        # update variable write clock
        if state.var_write_clocks[update_var].clocks[thread_clock_index] < state.thread_clocks[thread_id].clocks[
            thread_clock_index]:
            state.var_write_clocks[update_var].clocks[thread_clock_index] = state.thread_clocks[thread_id].clocks[
                thread_clock_index]
    elif update_type is UpdateType.ENTERPARALLEL:
        for tid in affected_thread_ids:
            state.thread_clocks[tid] = get_updated_vc(state.thread_clocks[tid],
                                                      state.thread_clocks[thread_id])
        increase(state.thread_clocks[thread_id], thread_clock_index)
    elif update_type is UpdateType.EXITPARALLEL:
        for tid in affected_thread_ids:
            state.thread_clocks[thread_id] = get_updated_vc(state.thread_clocks[thread_id],
                                                            state.thread_clocks[tid])

            increase(state.thread_clocks[tid], state.thread_id_to_clock_position_dict[tid])
    elif update_type is UpdateType.LOCK:
        state.thread_clocks[thread_id] = get_updated_vc(state.thread_clocks[thread_id], state.lock_clocks[update_var])
    elif update_type is UpdateType.UNLOCK:
        state.lock_clocks[update_var] = get_updated_vc(state.lock_clocks[update_var], state.thread_clocks[thread_id])
        increase(state.thread_clocks[thread_id], thread_clock_index)

    # todo (check if constraints for multiple / nested parallel sections are met)

    return state


def get_filtered_data_race_strings(unfiltered_data_races: List[DataRace]) -> List[str]:
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
