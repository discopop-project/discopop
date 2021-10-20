from typing import Dict, List, Tuple

from .schedule import ScheduleElement, Schedule
from .vector_clock import VectorClock


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


class DataRace(object):
    section_id: int
    schedule: Schedule
    schedule_element: ScheduleElement
    previous_writes: List[ScheduleElement]

    # represents a found data race for the output to the user
    def __init__(self, section_id: int, schedule: Schedule, schedule_element: ScheduleElement, previous_writes: List[ScheduleElement]):
        self.section_id: int = section_id
        self.schedule = schedule
        self.schedule_element: ScheduleElement = schedule_element
        self.previous_writes: List[ScheduleElement] = previous_writes

    def __str__(self):
        result_str = ""
        result_str += "##### DATA RACE IN SECTION: " + str(self.section_id) + " #####\n"
        for write in self.previous_writes:
            result_str += "prev: " + str(write) + "\n"
        result_str += "===> " + str(self.schedule_element) + "\n"
        result_str += "===> indices: " + " ".join(self.get_used_indices()) + "\n"

        result_str += "===> parent suggestion type: " + self.get_parent_suggestion_type() + "\n"
        return result_str

    def get_parent_suggestion_type(self) -> str:
        """returns the type of the suggestion which 'contains' the current DataRace."""
        for _, _, _, operation in self.schedule_element.updates:
            if operation.suggestion_type != "":
                return operation.suggestion_type
        return "UNDEF"

    def get_used_indices(self) -> List[str]:
        """returns the indices used in the operations in schedule_element."""
        indices: List[str] = []
        for _, _, _, operation in self.schedule_element.updates:
            if operation is None:
                continue
            indices += operation.target_indices
        indices = list(set(indices))
        return indices

    def get_cu_id(self) -> str:
        """returns the cu_id which is stored in the schedule element's operations."""
        for _, _, _, operation in self.schedule_element.updates:
            if operation.cu_id != "":
                return operation.cu_id
        return "UNDEF"

    def get_tuple(self) -> Tuple[int, ScheduleElement, List[ScheduleElement]]:
        """returns the stored information as a tuple.
        Used for duplicate filtering."""
        return self.section_id, self.schedule_element, self.previous_writes
