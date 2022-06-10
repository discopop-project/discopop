from typing import Optional, List

from discopop_validation.classes.OmpPragma import OmpPragma
from discopop_validation.data_race_prediction.behavior_modeller.classes.BehaviorModel import BehaviorModel
from discopop_validation.data_race_prediction.task_graph.classes.ResultObject import ResultObject
from discopop_validation.data_race_prediction.task_graph.classes.TaskGraphNode import TaskGraphNode


class PragmaParallelNode(TaskGraphNode):
    result: Optional[ResultObject]
    pragma: Optional[OmpPragma]
    behavior_models: List[BehaviorModel]

    def __init__(self, node_id, pragma=None):
        super().__init__(node_id, pragma)

    def __str__(self):
        return str(self.node_id)

    def get_label(self):
        if self.pragma is None:
            return "None"
        label = str(self.node_id) + " " + "Par\n"
        label += str(self.pragma.file_id) + ":" + str(self.pragma.start_line) + "-" + str(self.pragma.end_line)
        return label

    def get_color(self, mark_data_races: bool):
        color = "orange"
        if mark_data_races:
            if len(self.data_races) > 0:
                color = "red"
        return color
