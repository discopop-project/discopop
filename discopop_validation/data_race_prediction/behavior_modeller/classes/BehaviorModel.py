from typing import List

from discopop_validation.data_race_prediction.behavior_modeller.classes.Operation import Operation
from discopop_validation.data_race_prediction.scheduler.classes.ScheduleElement import ScheduleElement


class BehaviorModel(object):
    operations: List[Operation]
    scheduleElements: List[ScheduleElement]

    def __init__(self, operations: List[Operation]):
        self.operations = operations