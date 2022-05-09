import warnings

from typing import Optional, List

from discopop_validation.classes.OmpPragma import OmpPragma, PragmaType
from discopop_validation.data_race_prediction.behavior_modeller.classes.BehaviorModel import BehaviorModel
from discopop_validation.data_race_prediction.scheduler.core import create_scheduling_graph_from_behavior_models
from discopop_validation.data_race_prediction.simulation_preparation.core import prepare_for_simulation
from discopop_validation.data_race_prediction.task_graph.classes.EdgeType import EdgeType
from discopop_validation.data_race_prediction.task_graph.classes.TaskGraphNode import TaskGraphNode
from discopop_validation.data_race_prediction.task_graph.classes.ResultObject import ResultObject
from discopop_validation.data_race_prediction.vc_data_race_detector.core import get_data_races_and_successful_states
import copy

class ForkNode(TaskGraphNode):
    result : Optional[ResultObject]
    pragma: Optional[OmpPragma]
    behavior_models : List[BehaviorModel]

    def __init__(self, node_id, pragma=None):
        super().__init__(node_id, pragma)

    def __str__(self):
        return str(self.node_id)

    def get_label(self):
        # must not be modified!
        return "Fork"

    def get_color(self, mark_data_races: bool):
        color = "yellow"
        if mark_data_races:
            if len(self.data_races) > 0:
                color = "red"
        return color

    def get_scheduling_graph_from_fork_node(self, task_graph, result_obj):
        """Creates and returns a scheduling graph representation of the current Fork node, repsectively it's successive nodes."""
        out_seq_edges = [edge for edge in task_graph.graph.out_edges(self.node_id) if task_graph.graph.edges[edge]["type"] == EdgeType.SEQUENTIAL]
        out_belongs_to_edges = [edge for edge in task_graph.graph.out_edges(self.node_id) if
                                task_graph.graph.edges[edge]["type"] == EdgeType.BELONGS_TO]

        # collect successor paths to join nodes
        paths = []
        path_queue = []
        visited = []
        for _, successor in out_seq_edges:
            path_queue.append(([], successor))
        while len(path_queue) > 0:
            current_path, current_node = path_queue.pop()
            visited.append((current_path, current_node))
            if task_graph.graph.nodes[current_node]["data"].get_label() == "Join":
                #paths.append(current_path)
                #continue
                # only consider join nodes which belong to the fork node
                if current_node in [target for _, target in out_belongs_to_edges]:
                    paths.append(current_path)
                    continue

            out_seq_edges = [edge for edge in task_graph.graph.out_edges(current_node) if
                             task_graph.graph.edges[edge]["type"] == EdgeType.SEQUENTIAL and edge[0] != edge[1]]
            # check if end of path reached
            if len(out_seq_edges) == 0:
                # end of path found, append current_node to current_path
                # append current_path to paths
                current_path.append(current_node)
                paths.append(current_path)
                continue
            # add new queue entry for each successor
            current_path.append(current_node)
            for _, target in out_seq_edges:
                if (current_path, target) not in visited:
                    path_queue.append((copy.deepcopy(current_path), target))


        scheduling_graph = None
        for path in paths:
            path_scheduling_graph = None
            for elem in path:
                task_graph.graph.nodes[elem]["data"].seen_in_result_computation = True
                if task_graph.graph.nodes[elem]["data"].get_label() == "Fork":
                    elem_scheduling_graph = task_graph.graph.nodes[elem]["data"].get_scheduling_graph_from_fork_node(task_graph, result_obj)
                else:
                    behavior_models = task_graph.graph.nodes[elem]["data"].behavior_models
                    for model in behavior_models:
                        model.use_fingerprint(result_obj.get_current_fingerprint())

                    behavior_models = prepare_for_simulation(behavior_models)
                    elem_scheduling_graph, dimensions = create_scheduling_graph_from_behavior_models(behavior_models)
                if path_scheduling_graph is None:
                    path_scheduling_graph = elem_scheduling_graph
                else:
                    path_scheduling_graph = path_scheduling_graph.sequential_compose(elem_scheduling_graph)

            if scheduling_graph is None:
                scheduling_graph = path_scheduling_graph
            else:
                scheduling_graph = scheduling_graph.parallel_compose(path_scheduling_graph)
        return scheduling_graph