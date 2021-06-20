from typing import Dict, List, Tuple, Optional, cast
from .vector_clock import VectorClock, get_updated_vc, increase, compare_vc
from .schedule import Schedule, ScheduleElement, UpdateType


class State(object):
    # represents a state of the data race detector. Updated by each element of schedule.
    thread_clocks: Dict[int, VectorClock] = dict()
    lock_clocks: Dict[str, VectorClock] = dict()
    var_read_clocks: Dict[str, VectorClock] = dict()
    var_write_clocks: Dict[str, VectorClock] = dict()

    def __init__(self, thread_count: int, lock_names: List[str], var_names: List[str]):
        self.thread_clocks = dict()
        self.lock_clocks = dict()
        self.var_read_clocks = dict()
        self.var_write_clocks = dict()
        for i in range(thread_count):
            self.thread_clocks[i] = VectorClock(thread_count)
            self.thread_clocks[i].clocks[i] = 1
        for l_name in lock_names:
            self.lock_clocks[l_name] = VectorClock(thread_count)
        for v_name in var_names:
            self.var_read_clocks[v_name] = VectorClock(thread_count)
            self.var_write_clocks[v_name] = VectorClock(thread_count)

    def __str__(self):
        return "Thread clocks: " + str(self.thread_clocks) + "\n" + \
               "Lock clocks: " + str(self.lock_clocks) + "\n" + \
               "Var Read clocks: " + str(self.var_read_clocks) + "\n" + \
               "Var Write clocks: " + str(self.var_write_clocks)


def check_schedule(schedule: Schedule) -> Optional[Tuple[State, ScheduleElement]]:
    """check the entire schedule.
    Return None, if no data race has been found.
    Returns (problematic_state, problematic_schedule_element) if a data race has been identified.
    TODO find proper output format (problematic statements)"""
    state = State(schedule.thread_count, schedule.lock_names, schedule.var_names)
    return_value: Optional[Tuple[State, ScheduleElement]] = None
    for schedule_element in schedule.elements:
        try:
            state = goto_next_state(state, schedule_element)
        except ValueError:
            return_value = (state, schedule_element)
            break
    return return_value


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
    for update_var, update_type, _ in schedule_element.updates:
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


def __perform_update(state: State, thread_id: int, update: Tuple[str, UpdateType, List[int]]) -> State:
    """Performs single update as contained in ScheduleElement."""
    update_var, update_type, affected_thread_ids = update

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
