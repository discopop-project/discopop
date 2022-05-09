from typing import List, Optional

from discopop_validation.data_race_prediction.behavior_modeller.classes.Operation import Operation
from discopop_validation.data_race_prediction.scheduler.classes.ScheduleElement import ScheduleElement


class BehaviorModel(object):
    operations: List[Operation]
    schedule_elements: List[ScheduleElement]
    simulation_thread_count: int

    def __init__(self, operations: List[Operation]):
        self.operations = operations
        self.simulation_thread_count = 2

    def get_file_id(self) -> Optional[int]:
        if len(self.operations) == 0:
            return None
        return int(self.operations[0].file_id)

    def get_start_line(self) -> Optional[int]:
        if len(self.operations) == 0:
            return None
        return self.operations[0].line

    def get_end_line(self) -> Optional[int]:
        if len(self.operations) == 0:
            return None
        return self.operations[-1].line

    def use_fingerprint(self, fingerprint: str):
        """appends the given fingerprints to all operations.
        When this function is called, schedule_elements has not yet been initialized."""
        # todo might be implemented in a more sophisticated way.
        # todo instead of modifying the var_name, consider adding a separate field for a fingerprint in State.
        for op in self.operations:
            if not op.target_name.endswith(fingerprint):
                op.target_name = op.target_name+"_"+fingerprint