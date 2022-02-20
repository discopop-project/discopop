from typing import List

from discopop_validation.data_race_prediction.behavior_modeller.classes.Operation import Operation
from discopop_validation.data_race_prediction.scheduler.classes.ScheduleElement import ScheduleElement


class BehaviorModel(object):
    operations: List[Operation]
    schedule_elements: List[ScheduleElement]

    def __init__(self, operations: List[Operation]):
        self.operations = operations

    def use_fingerprint(self, fingerprint: str):
        """appends the given fingerprints to all operations.
        When this function is called, schedule_elements has not yet been initialized."""
        # todo might be implemented in a more sophisticated way.
        # todo instead of modifying the var_name, consider adding a separate field for a fingerprint in State.
        for op in self.operations:
            op.target_name = op.target_name+"_"+fingerprint
