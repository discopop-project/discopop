import warnings

from typing import Optional, List

from discopop_validation.classes.OmpPragma import OmpPragma, PragmaType
from discopop_validation.data_race_prediction.behavior_modeller.classes.BehaviorModel import BehaviorModel
from discopop_validation.data_race_prediction.scheduler.core import create_scheduling_graph_from_behavior_models
from discopop_validation.data_race_prediction.task_graph.classes.EdgeType import EdgeType
from discopop_validation.data_race_prediction.task_graph.classes.TaskGraphNode import TaskGraphNode
from discopop_validation.data_race_prediction.task_graph.classes.TaskGraphNodeResult import TaskGraphNodeResult
from discopop_validation.data_race_prediction.vc_data_race_detector.core import get_data_races_and_successful_states
import copy

class PragmaSingleNode(TaskGraphNode):
    result : Optional[TaskGraphNodeResult]
    pragma: Optional[OmpPragma]
    behavior_models : List[BehaviorModel]

    def __init__(self, node_id, pragma=None):
        super().__init__(node_id, pragma)

    def __str__(self):
        return str(self.node_id)

    def get_label(self):
        if self.pragma is None:
            return "None"
        label = "Sin\n"
        label += str(self.pragma.file_id) + ":" + str(self.pragma.start_line) + "-" + str(self.pragma.end_line)
        return label

    def get_color(self, mark_data_races: bool):
        color = "yellow"
        if mark_data_races:
            if len(self.result.data_races) > 0:
                color = "red"
        return color

    def get_behavior_models(self, task_graph, result_obj):
        """returns a list of behavior models which represent the behavior of the subtree which starts at the current node.
        updates results thread count entry."""
        result_obj.push_thread_count(1)
        gathered_behavior_models: List[BehaviorModel] = []
        for source, target in task_graph.graph.out_edges(self.node_id):
            if task_graph.graph.edges[(source, target)]["type"] == EdgeType.CONTAINS:
                # check if contained node is at the beginning of a sequence
                incoming = 0
                for inner_source, inner_target in task_graph.graph.in_edges(target):
                    if task_graph.graph.edges[(inner_source, inner_target)]["type"] == EdgeType.SEQUENTIAL:
                        incoming += 1
                if incoming == 0:
                    # target is the beginning of a new sequence
                    gathered_behavior_models += task_graph.graph.nodes[target]["data"].get_behavior_models(task_graph, result_obj)

        result_obj.pop_thread_count()
        return gathered_behavior_models