from typing import List

from discopop_validation.data_race_prediction.old_scheduler.classes.ScheduleElement import ScheduleElement


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

    def __str__(self):
        return_string = "Schedule:\n"
        for elem in self.elements:
            return_string += "==> " + str(elem) + "\n"
        return return_string