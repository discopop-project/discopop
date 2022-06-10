from termcolor import colored
from typing import List, Tuple, Optional, cast

from discopop_explorer import PETGraphX
from discopop_validation.data_race_prediction.behavior_modeller.classes.Operation import Operation
from discopop_validation.data_race_prediction.scheduler.classes.Schedule import Schedule
from discopop_validation.data_race_prediction.scheduler.classes.ScheduleElement import ScheduleElement
from discopop_validation.data_race_prediction.utils import get_pet_node_id_from_source_code_lines
from discopop_validation.data_race_prediction.vc_data_race_detector.classes.State import State


class DataRace(object):
    schedule: Schedule
    schedule_element: ScheduleElement
    previous_accesses: List[ScheduleElement]
    state: State
    var_name: Optional[str]

    # represents a found data race for the output to the user
    def __init__(self, schedule_element: ScheduleElement, previous_writes: List[ScheduleElement], state: State,
                 var_name: str = None):
        self.schedule_element: ScheduleElement = schedule_element
        self.previous_accesses: List[ScheduleElement] = previous_writes
        self.state = state
        self.var_name = var_name

    def __str__(self):
        result_str = ""
        result_str += colored("##### DATA RACE: #####\n", 'red', attrs=['bold'])
        if self.var_name is None:
            for access in self.previous_accesses:
                result_str += "prev: " + str(access) + "\n"
        else:
            # filter reported accesses
            for access in self.previous_accesses:
                # check if access is relevant considering self.var_name
                is_relevant = False
                for (var_name, update_type, _, operation) in access.updates:
                    if operation.get_target_name_without_fingerprint() == self.get_var_name_without_fingerprint():
                        is_relevant = True
                        break
                if is_relevant:
                    result_str += "prev: " + str(access) + "\n"

        result_str += "===> " + str(self.schedule_element) + "\n"
        if self.var_name is not None:
            result_str += "===> var_name: " + self.get_var_name_without_fingerprint() + "\n"
        result_str += "===> indices: " + " ".join(self.get_used_indices()) + "\n"

        result_str += "===> parent pragma type: " + self.get_parent_suggestion_type() + "\n"
        result_str += "=== State ===" + "\n"
        result_str += str(self.state)
        return result_str

    def get_location_str(self):
        return self.schedule_element.get_location_str()

    def get_var_name_without_fingerprint(self):
        # fingerprint length of 8 characters assumed
        return self.var_name[:-9]

    def get_parent_suggestion_type(self) -> str:
        """returns the type of the suggestion which 'contains' the current DataRace."""
        for _, _, _, operation_potentially_none in self.schedule_element.updates:
            operation = cast(Operation, operation_potentially_none)
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
        indices = list(dict.fromkeys(indices))
        return indices

    def get_cu_id(self, pet: PETGraphX) -> str:
        """returns the cu_id which is stored in the schedule element's operations."""
        for _, _, _, operation_potentially_none in self.schedule_element.updates:
            operation = cast(Operation, operation_potentially_none)
            if operation.pet_cu_id != "":
                return operation.pet_cu_id
            else:
                operation.pet_cu_id = get_pet_node_id_from_source_code_lines(pet, int(operation.file_id),
                                                                             int(operation.line), int(operation.line))
                return operation.pet_cu_id
        return "UNDEF"

    def get_tuple(self) -> Tuple[ScheduleElement, List[ScheduleElement]]:
        """returns the stored information as a tuple.
        Used for duplicate filtering."""
        return self.schedule_element, self.previous_accesses

    def get_relevant_previous_access_lines(self):
        lines = []
        if self.var_name is None:
            for access in self.previous_accesses:
                lines += access.get_operation_lines()
        else:
            # filter reported accesses
            for access in self.previous_accesses:
                # check if access is relevant considering self.var_name
                is_relevant = False
                for (var_name, update_type, _, operation) in access.updates:
                    if operation.get_target_name_without_fingerprint() == self.get_var_name_without_fingerprint():
                        is_relevant = True
                        break
                if is_relevant:
                    lines += access.get_operation_lines()
        lines = list(dict.fromkeys(lines))
        return lines
