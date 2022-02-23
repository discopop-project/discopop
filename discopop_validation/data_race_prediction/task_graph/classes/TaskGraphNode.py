from typing import List, Optional

from discopop_explorer import PETGraphX
from discopop_validation.classes.Configuration import Configuration
from discopop_validation.classes.OmpPragma import OmpPragma, PragmaType
from discopop_validation.data_race_prediction.behavior_modeller.classes.BehaviorModel import BehaviorModel
from discopop_validation.data_race_prediction.behavior_modeller.core import extract_postprocessed_behavior_models
from discopop_validation.data_race_prediction.simulation_preparation.core import prepare_for_simulation
from discopop_validation.data_race_prediction.target_code_sections.extraction import \
    identify_target_sections_from_pragma
from discopop_validation.data_race_prediction.task_graph.classes.EdgeType import EdgeType
from discopop_validation.data_race_prediction.task_graph.classes.TaskGraphNodeResult import TaskGraphNodeResult
import copy

from discopop_validation.data_race_prediction.task_graph.utils.NodeSpecificComputations import \
    perform_node_specific_result_computation


class TaskGraphNode(object):
    node_id: int
    result: TaskGraphNodeResult
    pragma: Optional[OmpPragma]
    behavior_models: List[BehaviorModel]

    def __init__(self, node_id, pragma=None):
        self.node_id = node_id
        self.result = TaskGraphNodeResult()
        self.pragma = pragma
        self.behavior_models = []

    def get_label(self):
        if self.node_id == 0:
            return "ROOT"
        label = "Bhv\n"
        if len(self.behavior_models) == 0:
            return label
        label += str(self.behavior_models[0].get_file_id()) + ":" + str(self.behavior_models[0].get_start_line()) + "-" + str(self.behavior_models[0].get_end_line())
        return label

    def get_color(self, mark_data_races: bool):
        color = "green"
        if mark_data_races:
            if len(self.result.data_races) > 0:
                color = "red"
        return color

    def compute_result(self, task_graph):
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
            if self.pragma.get_type() == PragmaType.FOR:
                self.result.push_new_fingerprint()
            if self.pragma.get_type() == PragmaType.PARALLEL:
                self.result.push_new_fingerprint()
        # modify behavior models to represent current fingerprint
        for model in self.behavior_models:
            model.use_fingerprint(self.result.get_current_fingerprint())

        # perform node-specific computation
        if self.__class__ == TaskGraphNode:
            # TaskGraphNode is generic and does not perform a specific computation
            pass
        else:
            perform_node_specific_result_computation(self, task_graph)

        # check if fingerprints need to be removed from the stack
        if self.pragma is not None:
            if self.pragma.get_type() == PragmaType.FOR:
                self.result.pop_fingerprint()
            if self.pragma.get_type() == PragmaType.PARALLEL:
                self.result.pop_fingerprint()

        # trigger result computation for each successor node
        for node, successor in task_graph.graph.out_edges(self.node_id):
            if task_graph.graph.edges[(node, successor)]["type"] == EdgeType.SEQUENTIAL:
                task_graph.graph.nodes[successor]["data"].compute_result(task_graph)

    def insert_behavior_model(self, run_configuration: Configuration, pet: PETGraphX, task_graph, omp_pragmas: List[OmpPragma]):
        if self.pragma is None:
            return
        self.pragma.apply_preprocessing()
        target_code_sections = identify_target_sections_from_pragma(task_graph, self.pragma)
        behavior_models: List[BehaviorModel] = []
        for tcs in target_code_sections:
             behavior_models += extract_postprocessed_behavior_models(run_configuration, pet, tcs,
                                                                                         self.pragma, omp_pragmas)
        # remove empty models
        behavior_models = [model for model in behavior_models if len(model.operations)>0]

        if run_configuration.verbose_mode:
            for model in behavior_models:
                print("Behavior Model (NodeID: ", self.node_id, "):")
                for op in model.operations:
                    print("\t", op)
        self.behavior_models = behavior_models

    def get_behavior_models(self, task_graph, result_obj):
        """returns a list of behavior models which represent the behavior of the subtree which starts at the current node.
        Should be overwritten by each node type."""
        print("TC TGN:", result_obj.get_current_thread_count())
        # set behavior_models.simulation_thread_count according to current request
        for model in self.behavior_models:
            model.simulation_thread_count = result_obj.get_current_thread_count()
        return self.behavior_models