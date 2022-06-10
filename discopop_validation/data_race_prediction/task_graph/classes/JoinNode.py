from typing import Optional, List

from discopop_validation.classes.OmpPragma import OmpPragma
from discopop_validation.data_race_prediction.behavior_modeller.classes.BehaviorModel import BehaviorModel
from discopop_validation.data_race_prediction.task_graph.classes.ResultObject import ResultObject
from discopop_validation.data_race_prediction.task_graph.classes.TaskGraphNode import TaskGraphNode


class JoinNode(TaskGraphNode):
    result: Optional[ResultObject]
    pragma: Optional[OmpPragma]
    behavior_models: List[BehaviorModel]

    def __init__(self, node_id, pragma=None):
        super().__init__(node_id, pragma)

    def __str__(self):
        return str(self.node_id)

    def get_label(self):
        # must not be modified!
        return "Join"

    def get_color(self, mark_data_races: bool):
        color = "yellow"
        if mark_data_races:
            if len(self.data_races) > 0:
                color = "red"
        return color
