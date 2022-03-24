import warnings

from typing import Optional, List

from discopop_validation.classes.OmpPragma import OmpPragma, PragmaType
from discopop_validation.data_race_prediction.behavior_modeller.classes.BehaviorModel import BehaviorModel
from discopop_validation.data_race_prediction.scheduler.core import create_scheduling_graph_from_behavior_models
from discopop_validation.data_race_prediction.task_graph.classes.EdgeType import EdgeType
from discopop_validation.data_race_prediction.task_graph.classes.TaskGraphNode import TaskGraphNode
from discopop_validation.data_race_prediction.task_graph.classes.ResultObject import ResultObject
from discopop_validation.data_race_prediction.vc_data_race_detector.core import get_data_races_and_successful_states
import copy

class CalledFunctionNode(TaskGraphNode):
    result : Optional[ResultObject]
    pragma: Optional[OmpPragma]
    behavior_models : List[BehaviorModel]
    name : str

    def __init__(self, node_id, pragma=None, name=None):
        super().__init__(node_id, pragma)
        self.name = name

    def __str__(self):
        return str(self.node_id)

    def get_label(self):
        if self.name is None:
            return "NONAME"
        label = str(self.node_id) + " " + self.name
        return label

    def get_color(self, mark_data_races: bool):
        color = "violet"
        if mark_data_races:
            if len(self.data_races) > 0:
                color = "red"
        return color