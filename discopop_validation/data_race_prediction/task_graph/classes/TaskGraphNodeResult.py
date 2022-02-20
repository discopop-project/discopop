from typing import List

from discopop_validation.data_race_prediction.vc_data_race_detector.classes.DataRace import DataRace
from discopop_validation.data_race_prediction.vc_data_race_detector.classes.State import State
import random
import string

class TaskGraphNodeResult(object):
    states: List[State]
    data_races: List[DataRace]
    fingerprint_stack: List[str]

    def __init__(self):
        self.states = []
        self.data_races = []
        self.fingerprint_stack = []

    def combine(self, node_result):
        """update this result with the given node_result by combining the results"""
        # todo
        raise ValueError("TODO Implement")

    def push_new_fingerprint(self):
        """create and push a new fingerprint"""
        fingerprint = ''.join(random.choices(string.ascii_uppercase + string.digits, k=8))
        self.fingerprint_stack.append(fingerprint)

    def pop_fingerprint(self):
        """pop the last added fingerprint from the stack"""
        buffer = self.get_current_fingerprint()
        # remove clocks for the given fingerprint
        for state in self.states:
            state.remove_clocks_with_fingerprint(self.get_current_fingerprint())
        del self.fingerprint_stack[-1]
        return buffer

    def get_current_fingerprint(self):
        return self.fingerprint_stack[-1]