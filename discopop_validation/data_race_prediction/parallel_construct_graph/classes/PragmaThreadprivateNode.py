from typing import Optional, List

from discopop_validation.classes.OmpPragma import OmpPragma
from discopop_validation.data_race_prediction.behavior_modeller.classes.BehaviorModel import BehaviorModel
from discopop_validation.data_race_prediction.parallel_construct_graph.classes.EdgeType import EdgeType
from discopop_validation.data_race_prediction.parallel_construct_graph.classes.ResultObject import ResultObject
from discopop_validation.data_race_prediction.parallel_construct_graph.classes.PCGraphNode import PCGraphNode


class PragmaThreadprivateNode(PCGraphNode):
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
        label = str(self.node_id) + " " + "Threadprivate\n"
        label += str(self.pragma.file_id) + ":" + str(self.pragma.start_line) + "-" + str(self.pragma.end_line)
        return label

    def get_color(self, mark_data_races: bool):
        color = "yellow"
        if mark_data_races:
            if len(self.data_races) > 0:
                color = "red"
        return color

    def get_behavior_models(self, pc_graph, result_obj) -> List[List[BehaviorModel]]:
        """gather behavior models of sequence-starting contained nodes (should only be 1 in case of a FOR pragma)"""
        outer_seq_behavior_models: List[List[BehaviorModel]] = ["SEQ"]  # type: ignore
        outer_par_behavior_models: List[List[BehaviorModel]] = ["PAR"]  # type: ignore
        # gather behavior models of contained nodes
        for source, target in pc_graph.graph.out_edges(self.node_id):
            inner_par_behavior_models = ["PAR"]
            if pc_graph.graph.edges[(source, target)]["type"] == EdgeType.CONTAINS:
                # check if contained node is at the beginning of a sequence
                incoming = 0
                for inner_source, inner_target in pc_graph.graph.in_edges(target):
                    if pc_graph.graph.edges[(inner_source, inner_target)]["type"] == EdgeType.SEQUENTIAL:
                        incoming += 1
                if incoming == 0:
                    # target is the beginning of a new sequence
                    inner_par_behavior_models.append(
                        pc_graph.graph.nodes[target]["data"].get_behavior_models(pc_graph, result_obj))
            if len(inner_par_behavior_models) > 1:
                outer_par_behavior_models.append(inner_par_behavior_models)  # type: ignore

        outer_seq_behavior_models.append(outer_par_behavior_models)  # type: ignore
        # gather behavior models of successor nodes
        for source, target in pc_graph.graph.out_edges(self.node_id):
            if pc_graph.graph.edges[(source, target)]["type"] == EdgeType.SEQUENTIAL:
                outer_seq_behavior_models.append(
                    pc_graph.graph.nodes[target]["data"].get_behavior_models(pc_graph, result_obj))
        return outer_seq_behavior_models
