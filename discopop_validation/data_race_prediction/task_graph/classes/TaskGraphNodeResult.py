from typing import List

from discopop_validation.data_race_prediction.vc_data_race_detector.classes.DataRace import DataRace
from discopop_validation.data_race_prediction.vc_data_race_detector.classes.State import State

class TaskGraphNodeResult(object):
    states: List[State]
    data_races: List[DataRace]
    saved_states_stack: List[List[State]]

    def __init__(self):
        self.states = []
        self.data_races = []
        self.saved_states_stack = []

    def combine(self, node_result):
        """update this result with the given node_result by combining the results"""
        # todo
        raise ValueError("TODO Implement")