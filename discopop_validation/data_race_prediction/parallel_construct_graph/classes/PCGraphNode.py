import copy

from typing import List, Optional, Tuple

from discopop_explorer import PETGraphX
from discopop_validation.classes.Configuration import Configuration
from discopop_validation.classes.OmpPragma import OmpPragma
from discopop_validation.data_race_prediction.behavior_modeller.classes.BehaviorModel import BehaviorModel
from discopop_validation.data_race_prediction.behavior_modeller.core import extract_postprocessed_behavior_models
from discopop_validation.data_race_prediction.target_code_sections.extraction import \
    identify_target_sections_from_pragma
from discopop_validation.data_race_prediction.parallel_construct_graph.classes.EdgeType import EdgeType
from discopop_validation.data_race_prediction.parallel_construct_graph.utils.NodeSpecificComputations import \
    perform_node_specific_result_computation
from discopop_validation.data_race_prediction.target_code_sections.utils import \
    modify_tcs_according_to_inverse_line_mapping
from discopop_validation.data_race_prediction.vc_data_race_detector.classes.DataRace import DataRace


class PCGraphNode(object):
    node_id: int
    pragma: Optional[OmpPragma]
    behavior_models: List[BehaviorModel]
    seen_in_result_computation: bool
    data_races: List[DataRace]
    covered_by_fork_node: bool

    def __init__(self, node_id, pragma=None):
        self.node_id = node_id
        self.pragma = pragma
        self.behavior_models = []
        self.seen_in_result_computation = False
        self.data_races = []
        self.covered_by_fork_node = False

    def get_label(self):
        if self.node_id == 0:
            return "ROOT"
        label = str(self.node_id) + " " + "PCGN\n"
        if len(self.behavior_models) == 0:
            return label
        label += str(self.behavior_models[0].get_file_id()) + ":" + str(
            self.behavior_models[0].get_start_line()) + "-" + str(self.behavior_models[0].get_end_line())
        return label

    def get_color(self, mark_data_races: bool):
        color = "green"
        if mark_data_races:
            if len(self.data_races) > 0:
                color = "red"
        return color

    def compute_result(self, pc_graph, result_obj, thread_ids: List[int]):
        """compute_result is used to calculate the result following a path consisting of SEQUENTIAL edges.
        """
        # modify result obj according to current node
        if not self.seen_in_result_computation:
            result_obj = perform_node_specific_result_computation(self, pc_graph, result_obj, thread_ids)

        # pass result obj to successive nodes
        successors = [edge[1] for edge in pc_graph.graph.out_edges(self.node_id) if
                      pc_graph.graph.edges[edge]["type"] == EdgeType.SEQUENTIAL if edge[0] != edge[1]]
        if len(successors) == 1:
            result_obj = pc_graph.graph.nodes[successors[0]]["data"].compute_result(pc_graph,
                                                                                    copy.deepcopy(result_obj),
                                                                                    thread_ids)
            return result_obj
        elif len(successors) == 0:
            # if no children exist, print current state
            # todo handle and store results for further use
            return result_obj
        elif len(successors) > 1 and self.get_label() == "Fork":
            # fork nodes are the only ones allowed to have multiple sequential children
            # todo handle and store results for further use
            return result_obj
        else:
            raise ValueError(
                "Invalid number of successors: " + str(len(successors)) + " at node_id: " + str(self.node_id))

    def set_simulation_thread_count(self, new_thread_count: int):
        # todo: note: may be required to execute recursively on contained nodes aswell
        for model in self.behavior_models:
            model.simulation_thread_count = new_thread_count

    def insert_behavior_model(self, run_configuration: Configuration, pet: PETGraphX, pc_graph,
                              omp_pragmas: List[OmpPragma]):
        if self.pragma is None:
            return
        self.pragma.apply_preprocessing()
        target_code_sections = identify_target_sections_from_pragma(pc_graph, self.pragma, self.node_id)
        # modify target code sections according to the inversed line mapping to
        # get the correct output for potentially modified source codes
        target_code_sections = modify_tcs_according_to_inverse_line_mapping(target_code_sections, run_configuration)

        # modify target code sections so that no overlap with pragmas inside a called function exist
        target_code_sections = self.__tcs_remove_overlap_with_pragmas_in_called_function(target_code_sections, pc_graph)

        if run_configuration.verbose_mode:
            for tcs in target_code_sections:
                print("TCS: ", tcs)

        behavior_models: List[BehaviorModel] = []
        for tcs in target_code_sections:
            behavior_models += extract_postprocessed_behavior_models(run_configuration, pet, tcs,
                                                                     self.pragma, omp_pragmas)
        # remove empty models
        behavior_models = [model for model in behavior_models if len(model.operations) > 0]

        if run_configuration.verbose_mode:
            print("Pragma: ", self.pragma)
            for model in behavior_models:
                print("Behavior Model (NodeID: ", self.node_id, "):")
                for op in model.operations:
                    print("\t", op)
        self.behavior_models = behavior_models

    def __tcs_remove_overlap_with_pragmas_in_called_function(self, target_code_sections, pc_graph) \
            -> List[Tuple[str, str, str, str, str]]:
        out_calls_edges = [edge for edge in pc_graph.graph.out_edges(self.node_id) if pc_graph.graph.edges[edge]["type"] == EdgeType.CALLS]
        modified_tcs = []
        for tcs in target_code_sections:
            target_file_id = int(tcs[1])
            target_lines = [int(line) for line in tcs[2].split(",")[:-1]]  # remove last entry, as it will always be empty as a result of the trailing ','
            for _, called_function in out_calls_edges:
                contained_nodes = [target for source, target in pc_graph.graph.out_edges(called_function) if pc_graph.graph.edges[(source, target)]["type"] == EdgeType.CONTAINS]
                for contained in contained_nodes:
                    if contained == self.node_id:
                        # only pragma itself is allowed to keep the lines
                        continue
                    contained_file_id = pc_graph.graph.nodes[contained]["data"].pragma.file_id
                    if target_file_id != contained_file_id:
                        continue
                    contained_start_line = pc_graph.graph.nodes[contained]["data"].pragma.start_line
                    contained_end_line = pc_graph.graph.nodes[contained]["data"].pragma.end_line
                    contained_lines = range(contained_start_line, contained_end_line + 1)
                    # remove overlapping lines from original tcs
                    target_lines = [line for line in target_lines if line not in contained_lines]
            # convert target_lines to strings for joining
            target_lines = [str(line) for line in target_lines]
            # overwrite tcs with modified target_lines
            modified_tcs.append((tcs[0], tcs[1], ",".join(target_lines), tcs[3], tcs[4]))

        # alles entfernen was bereits durch ein pragma in der aufgerufenen funktion abgedeckt ist
        # wenn ein zyklus existiert, und die anweisungen bereits durch das pragma selbst abgedeckt wäre, nichts entfernen.

        return modified_tcs


    def get_behavior_models(self, pc_graph, result_obj):
        """returns a list of behavior models which represent the behavior of the subtree which starts at the current node.
        Should be overwritten by each node type."""
        # set behavior_models.simulation_thread_count according to current request
        for model in self.behavior_models:
            model.simulation_thread_count = result_obj.get_current_thread_count()
        # if more than one incoming sequential edge exists, issue a JOINNODE command
        counter = 0
        for edge in pc_graph.graph.in_edges(self.node_id):
            if pc_graph.graph.edges[edge]["type"] == EdgeType.SEQUENTIAL:
                counter += 1
        if counter > 1:
            result = ["SEQ", "JOINNODE", ["PAR", self.behavior_models]]
        else:
            result = ["SEQ", ["PAR", self.behavior_models]]
        # add sucesseors to the result
        out_edges = pc_graph.graph.out_edges(self.node_id)
        relevant_edges = [edge for edge in out_edges if edge[0] != edge[1]]
        if len(relevant_edges) > 0:
            # add targets of relevant edges to parallel section
            parallel_section = ["PAR"]
            if len(relevant_edges) > 1:
                # todo replace with marker to create new scheduling graph
                parallel_section.append("TASKWAIT")
            for edge in relevant_edges:
                print("Adding: ", pc_graph.graph.nodes[edge[1]]["data"].get_behavior_models(pc_graph, result_obj))
                parallel_section.append(
                    pc_graph.graph.nodes[edge[1]]["data"].get_behavior_models(pc_graph, result_obj))
            result.append(parallel_section)

        return result

    def replace_with_BehaviorModelNodes(self, pc_graph):
        """replaces this PCGraphNode with an equivalent set of BehaviorModelNodes and removes the PCGraphNode
        afterwards."""
        for model in self.behavior_models:
            for idx in range(0, model.simulation_thread_count):
                # insert and connect BehaviorModelNode
                pc_graph.insert_behavior_model_node(self, model)

        # delete PCGraphNode
        pc_graph.graph.remove_node(self.node_id)


