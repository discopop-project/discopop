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
from discopop_validation.data_race_prediction.task_graph.classes.ResultObject import ResultObject
import copy

from discopop_validation.data_race_prediction.task_graph.utils.NodeSpecificComputations import \
    perform_node_specific_result_computation


class TaskGraphNode(object):
    node_id: int
    pragma: Optional[OmpPragma]
    behavior_models: List[BehaviorModel]
    seen_in_result_computation: bool

    def __init__(self, node_id, pragma=None):
        self.node_id = node_id
        self.pragma = pragma
        self.behavior_models = []
        self.seen_in_result_computation = False

    def get_label(self):
        if self.node_id == 0:
            return "ROOT"
        label = str(self.node_id) +" " +  "Bhv\n"
        if len(self.behavior_models) == 0:
            return label
        label += str(self.behavior_models[0].get_file_id()) + ":" + str(self.behavior_models[0].get_start_line()) + "-" + str(self.behavior_models[0].get_end_line())
        return label

    def get_color(self, mark_data_races: bool):
        color = "green"
        return color

    def compute_result(self, task_graph, result_obj, thread_ids: List[int]):
        """compute_result is used to calculate the result following a path consisting of SEQUENTIAL edges.
        """
        print("COMPUTE: ", self.node_id)
        print("\tthreads: ", thread_ids)
        # modify result obj according to current node
        if not self.seen_in_result_computation:
            result_obj = perform_node_specific_result_computation(self, task_graph, result_obj, thread_ids)
        else:
            print("ALREADY SEEN")

        # pass result obj to successive nodes
        successors = [edge[1] for edge in task_graph.graph.out_edges(self.node_id) if task_graph.graph.edges[edge]["type"] == EdgeType.SEQUENTIAL]
        if len(successors) == 1:
            result_obj = task_graph.graph.nodes[successors[0]]["data"].compute_result(task_graph, copy.deepcopy(result_obj), thread_ids)
            return result_obj
        elif len(successors) == 0:
            # if no children exist, print current state
            # todo handle and store results for further use
            print(result_obj)
            return result_obj
        else:
            raise ValueError("Invalid number of successors: " +  str(len(successors)) + " at node_id: " + str(self.node_id))







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
        # set behavior_models.simulation_thread_count according to current request
        for model in self.behavior_models:
            model.simulation_thread_count = result_obj.get_current_thread_count()
        # if more than one incoming sequential edge exists, issue a JOINNODE command
        counter = 0
        for edge in task_graph.graph.in_edges(self.node_id):
            if task_graph.graph.edges[edge]["type"] == EdgeType.SEQUENTIAL:
                counter += 1
        if counter > 1:
            result = ["SEQ", "JOINNODE", ["PAR", self.behavior_models]]
        else:
            result = ["SEQ", ["PAR", self.behavior_models]]
        # add sucesseors to the result
        out_edges = task_graph.graph.out_edges(self.node_id)
        relevant_edges = [edge for edge in out_edges if edge[0] != edge[1]]
        if len(relevant_edges) > 0:
            # add targets of relevant edges to parallel section
            parallel_section = ["PAR"]
            if len(relevant_edges) > 1:
                # todo replace with marker to create new scheduling graph
                parallel_section.append("TASKWAIT")
            for edge in relevant_edges:
                print("Adding: ", task_graph.graph.nodes[edge[1]]["data"].get_behavior_models(task_graph, result_obj))

                parallel_section.append(task_graph.graph.nodes[edge[1]]["data"].get_behavior_models(task_graph, result_obj))
            result.append(parallel_section)

        return result