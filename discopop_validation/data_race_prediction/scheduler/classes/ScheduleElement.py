from typing import List, Tuple, Optional

from discopop_validation.data_race_prediction.behavior_modeller.classes.Operation import Operation
from discopop_validation.data_race_prediction.scheduler.classes.UpdateType import UpdateType


class ScheduleElement:
    parent_basic_block_id: int = -1
    thread_id: int = -1
    lock_names: List[str] = []
    var_names: List[str] = []
    updates: List[Tuple[str, UpdateType, List[int], Optional[Operation]]] = []
    # str represents variable identifier
    # inner List[int] represents affected thread_id´s, used for entry and exit of parallel regions
    # one ScheduleElement can contain multiple updates. example: x=x+y

    def __init__(self, executing_thread_id: int):
        self.thread_id = executing_thread_id
        self.lock_names = []
        self.var_names = []
        self.updates = []

    def __str__(self):
        return "Thread:" + str(self.thread_id) + " Operation:" + " ".join([" "+str(operation) for (var_name, update_type, _, operation) in self.updates])

    def get_location_str(self):
        """used for outputting data races to file"""
        result_str = " ".join([operation.get_location_str() for (var_name, update_type, _, operation) in self.updates])
        while result_str.startswith(" "):
            result_str = result_str[1:]
        return result_str

    def get_operation_lines(self) -> List[int]:
        lines = []
        for (_, _, _, operation) in self.updates:
            lines.append(operation.line)
        lines = list(dict.fromkeys(lines))
        return lines

    def get_file_ids(self):
        ids = []
        for (_, _, _, operation) in self.updates:
            ids.append(int(operation.file_id))
        ids = list(dict.fromkeys(ids))
        return ids

    def contains_write(self) -> bool:
        for _, update_type, _, _ in self.updates:
            if update_type == UpdateType.WRITE:
                return True
        return False

    def add_update(self, var_name: str, update_type: UpdateType, affected_thread_ids: Optional[List[int]] = None, operation: Optional[Operation] = None):
        """Add update of type update_type to var_name to the list of updates of the current ScheduleElement
        raises ValueError, if updateType is ENTERPARALLEL or EXITPARALLEL and affected_thread_ids is not set.
        :param var_name: name of updated variable
        :param update_type: type of update
        :param affected_thread_ids: Optional list of affected thread ids, used for entry and exit of parallel regions
        :param operation: equivalent operation in the BBGraph"""
        if update_type in [UpdateType.ENTERPARALLEL, UpdateType.EXITPARALLEL]:
            if affected_thread_ids is None:
                raise ValueError("affected_thread_ids not set!")
            self.updates.append((var_name, update_type, affected_thread_ids, operation))
        else:
            self.updates.append((var_name, update_type, [], operation))

        if update_type in [UpdateType.READ, UpdateType.WRITE]:
            if var_name not in self.var_names:
                self.var_names.append(var_name)
        elif update_type in [UpdateType.LOCK, UpdateType.UNLOCK]:
            if var_name not in self.lock_names:
                self.lock_names.append(var_name)