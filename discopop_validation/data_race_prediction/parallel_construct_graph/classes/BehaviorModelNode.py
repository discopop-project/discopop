import copy

from typing import List, Optional

from discopop_validation.classes.OmpPragma import OmpPragma
from discopop_validation.data_race_prediction.behavior_modeller.classes.BehaviorModel import BehaviorModel
from discopop_validation.data_race_prediction.parallel_construct_graph.classes.PCGraphNode import PCGraphNode
from discopop_validation.data_race_prediction.vc_data_race_detector.classes.DataRace import DataRace


class BehaviorModelNode(PCGraphNode):
    node_id: int
    pragma: Optional[OmpPragma]
    single_behavior_model: BehaviorModel
    seen_in_result_computation: bool
    data_races: List[DataRace]
    covered_by_fork_node: bool

    def __init__(self, pc_graph, parent_node: PCGraphNode, bhv_model: BehaviorModel):
        # overwrite model.simulation_thread_count to 1
        bhv_model.simulation_thread_count = 1

        self.node_id = pc_graph.get_new_node_id()
        self.pragma = parent_node.pragma
        self.single_behavior_model = bhv_model
        self.seen_in_result_computation = parent_node.seen_in_result_computation
        self.data_races = []
        self.covered_by_fork_node = parent_node.covered_by_fork_node

    def get_label(self):
        if self.node_id == 0:
            return "ROOT"
        label = str(self.node_id) + " " + "Bhv\n"
        label += str(self.single_behavior_model.get_file_id()) + ":" + str(
            self.single_behavior_model.get_start_line()) + "-" + str(self.single_behavior_model.get_end_line())
        return label

    def get_color(self, mark_data_races: bool):
        color = "green"
        if mark_data_races:
            if len(self.data_races) > 0:
                color = "red"
        return color