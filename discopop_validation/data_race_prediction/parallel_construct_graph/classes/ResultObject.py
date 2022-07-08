from typing import List

import random
import string

from typing import List

from discopop_validation.data_race_prediction.vc_data_race_detector.classes.DataRace import DataRace
from discopop_validation.data_race_prediction.vc_data_race_detector.classes.State import State
from discopop_validation.data_race_prediction.vc_data_race_detector.core import get_data_races_and_successful_states
from discopop_validation.data_race_prediction.vc_data_race_detector.exception_rules.application import \
    apply_exception_rules


class ResultObject(object):
    states: List[State]
    data_races: List[DataRace]
    fingerprint_stack: List[str]
    thread_count_stack: List[int]
    current_thread_count: int

    def __init__(self):
        self.states = []
        self.data_races = []
        self.fingerprint_stack = []
        self.thread_count_stack = []
        self.current_thread_count = 0

    def __str__(self):
        res_str = "ResultObject:\n"
        res_str += "\tstates: " + str(len(self.states)) + "\n"
        res_str += "\tdata_races: " + str(len(self.data_races)) + "\n"
        res_str += "\tfingerprints: " + " ".join(self.fingerprint_stack) + "\n"
        res_str += "\tthread count stack: " + " ".join(self.thread_count_stack) + "\n"
        return res_str

    def print_states(self):
        print("STATES:")
        for state in self.states:
            print(state)
            print()

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

    def update(self, scheduling_graph):
        if scheduling_graph is None:
            return
        data_races, successful_states = get_data_races_and_successful_states(scheduling_graph,
                                                                             scheduling_graph.dimensions, self.states)
        self.data_races += data_races
        # remove duplicates from successful states
        successful_states_wo_duplicates = []
        for state in successful_states:
            is_known = False
            for known_state in successful_states_wo_duplicates:
                if state == known_state:
                    is_known = True
                    break
            if not is_known:
                successful_states_wo_duplicates.append(state)
        self.states = successful_states_wo_duplicates

    def print_data_races(self):
        # display detected data races
        for data_race in self.data_races:
            print(data_race)

    def apply_exception_rules_to_data_races(self, pet, pc_graph):
        self.data_races = apply_exception_rules(self.data_races, pet, pc_graph)
