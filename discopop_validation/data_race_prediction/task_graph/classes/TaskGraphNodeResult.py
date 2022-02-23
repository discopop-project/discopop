from typing import List

from discopop_validation.data_race_prediction.vc_data_race_detector.classes.DataRace import DataRace
from discopop_validation.data_race_prediction.vc_data_race_detector.classes.State import State
import random
import string

class TaskGraphNodeResult(object):
    states: List[State]
    data_races: List[DataRace]
    fingerprint_stack: List[str]
    thread_count_stack: List[int]

    def __init__(self):
        self.states = []
        self.data_races = []
        self.fingerprint_stack = []
        self.thread_count_stack = [2]

    def combine(self, node_result):
        """combine the current states with the states of node_result, if fingerprint_stacks are equal"""
        if node_result is None:
            # necessary to catch root node
            return
        if self.fingerprint_stack == node_result.fingerprint_stack:
            self.states += [state for state in node_result.states if state not in self.states]
        else:
            raise ValueError("Fingerprint stacks not equal!")

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

    def get_current_thread_count(self):
        return self.thread_count_stack[-1]

    def push_thread_count(self, tc: int):
        self.thread_count_stack.append(tc)

    def pop_thread_count(self):
        buffer = self.get_current_thread_count()
        del self.thread_count_stack[-1]
        return buffer