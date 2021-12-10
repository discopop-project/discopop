from typing import List, Tuple

from discopop_validation.data_race_prediction.old_scheduler.classes.Schedule import Schedule
from discopop_validation.data_race_prediction.old_scheduler.classes.ScheduleElement import ScheduleElement
from termcolor import colored

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
        result_str += colored("##### DATA RACE IN SECTION: " + str(self.section_id) + " #####\n", 'red', attrs=['bold'])
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