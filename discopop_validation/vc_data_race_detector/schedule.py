import pytest
from typing import List, Tuple, Optional
from enum import IntEnum, Enum


class UpdateType(Enum):
    READ = 0
    WRITE = 1
    LOCK = 2
    UNLOCK = 3
    ENTERPARALLEL = 4
    EXITPARALLEL = 5


class ScheduleElement:
    thread_id: int = -1
    lock_names: List[str] = []
    var_names: List[str] = []
    updates: List[Tuple[str, UpdateType, List[int]]] = []
    # str represents variable identifier
    # inner List[int] represents affected thread_id´s, used for entry and exit of parallel regions
    # one ScheduleElement can contain multiple updates. example: x=x+y

    def __init__(self, executing_thread_id: int):
        self.thread_id = executing_thread_id
        self.lock_names = []
        self.var_names = []
        self.updates = []

    def add_update(self, var_name: str, update_type: UpdateType, affected_thread_ids: Optional[List[int]] = None):
        """Add update of type update_type to var_name to the list of updates of the current ScheduleElement
        raises ValueError, if updateType is ENTERPARALLEL or EXITPARALLEL and affected_thread_ids is not set.
        :param var_name: name of updated variable
        :param update_type: type of update
        :param affected_thread_ids: Optional list of affected thread ids, used for entry and exit of parallel regions"""
        if update_type in [UpdateType.ENTERPARALLEL, UpdateType.EXITPARALLEL]:
            if affected_thread_ids is None:
                raise ValueError("affected_thread_ids not set!")
            self.updates.append((var_name, update_type, affected_thread_ids))
        else:
            self.updates.append((var_name, update_type, []))

        if update_type in [UpdateType.READ, UpdateType.WRITE]:
            if var_name not in self.var_names:
                self.var_names.append(var_name)
        elif update_type in [UpdateType.LOCK, UpdateType.UNLOCK]:
            if var_name not in self.lock_names:
                self.lock_names.append(var_name)


class Schedule(object):
    thread_count: int = -1
    lock_names: List[str] = []
    var_names: List[str] = []
    elements: List[ScheduleElement] = []

    def __init__(self):
        self.lock_names = []
        self.var_names = []
        self.elements = []

    def add_element(self, element: ScheduleElement):
        """appends element to the list of ScheduleElements of the current Schedule.
        :param element: ScheduleElement to be appended to current Schedule"""
        self.elements.append(element)
        if element.thread_id >= self.thread_count:
            self.thread_count = element.thread_id + 1
        self.lock_names = list(set(self.lock_names + element.lock_names))
        self.var_names = list(set(self.var_names + element.var_names))
