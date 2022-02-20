from typing import Optional, List

from discopop_validation.classes.OmpPragma import OmpPragma, PragmaType
from discopop_validation.data_race_prediction.behavior_modeller.classes.BehaviorModel import BehaviorModel
from discopop_validation.data_race_prediction.scheduler.core import create_scheduling_graph_from_behavior_models
from discopop_validation.data_race_prediction.task_graph.classes.TaskGraphNode import TaskGraphNode
from discopop_validation.data_race_prediction.task_graph.classes.TaskGraphNodeResult import TaskGraphNodeResult
from discopop_validation.data_race_prediction.vc_data_race_detector.core import get_data_races_and_successful_states
import copy

class PragmaParallelForNode(TaskGraphNode):
    result : Optional[TaskGraphNodeResult]
    pragma: Optional[OmpPragma]
    behavior_models : List[BehaviorModel]

    def __init__(self, node_id, pragma=None):
        self.node_id = node_id
        self.result = None
        self.pragma = pragma
        self.behavior_models = []

    def __str__(self):
        return str(self.node_id)

    def get_label(self):
        if self.pragma is None:
            return "None"
        label = ""
        label += str(self.pragma.file_id) + ":" + str(self.pragma.start_line) + "-" + str(self.pragma.end_line)
        return label

    def get_color(self, mark_data_races: bool):
        color = "blue"
        if mark_data_races:
            if len(self.result.data_races) > 0:
                color = "red"
        return color

    def compute_result(self, task_graph):
        # copied from TaskGraphNode, since overwritten __node_specific_result_computation could not be invoked correctly
        predecessor_edges = list(task_graph.graph.in_edges(self.node_id))
        #if single predecessor exists, relay result of previous node
        if len(predecessor_edges) == 1:
            predecessor, _ = predecessor_edges[0]
            self.result = copy.deepcopy(task_graph.graph.nodes[predecessor]["data"].result)
        #if multiple predecessors exist, relay combination of results of previous nodes
        elif len(predecessor_edges) > 1:
            self.result = TaskGraphNodeResult()
            for pred, _ in predecessor_edges:
                self.result.combine(task_graph.graph.nodes[pred]["data"].result)
        #if no predecessor exists, create empty TaskGraphNodeResult
        else:
            self.result = TaskGraphNodeResult()

        # check if new fingerprints (for scoping) need to be generated
        if self.pragma is not None:
            if self.pragma.get_type() == PragmaType.PARALLEL_FOR:
                self.result.push_new_fingerprint()
            if self.pragma.get_type() == PragmaType.PARALLEL:
                self.result.push_new_fingerprint()
        # modify behavior models to represent current fingerprint
        for model in self.behavior_models:
            model.use_fingerprint(self.result.get_current_fingerprint())

        # perform node-specific computation
        self.__node_specific_result_computation()

        # check if fingerprints need to be removed from the stack
        if self.pragma is not None:
            if self.pragma.get_type() == PragmaType.PARALLEL_FOR:
                self.result.pop_fingerprint()
            if self.pragma.get_type() == PragmaType.PARALLEL:
                self.result.pop_fingerprint()

        # trigger result computation for each successor node
        for _, successor in task_graph.graph.out_edges(self.node_id):
            task_graph.graph.nodes[successor]["data"].compute_result(task_graph)

    def __node_specific_result_computation(self):
        # create scheduling graph from behavior models
        scheduling_graph, dimensions = create_scheduling_graph_from_behavior_models(self.behavior_models)
        # check for data races and extract set of next states
        data_races, successful_states = get_data_races_and_successful_states(scheduling_graph, dimensions, self.result)
        # store results
        self.result.data_races = data_races
        self.result.states = successful_states