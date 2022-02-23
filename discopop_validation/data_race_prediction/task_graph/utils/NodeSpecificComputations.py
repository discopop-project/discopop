from typing import List

from discopop_validation.classes.OmpPragma import PragmaType
from discopop_validation.data_race_prediction.behavior_modeller.classes.BehaviorModel import BehaviorModel
from discopop_validation.data_race_prediction.scheduler.core import create_scheduling_graph_from_behavior_models
from discopop_validation.data_race_prediction.simulation_preparation.core import prepare_for_simulation
from discopop_validation.data_race_prediction.task_graph.classes.EdgeType import EdgeType
from discopop_validation.data_race_prediction.vc_data_race_detector.core import get_data_races_and_successful_states
import warnings

def perform_node_specific_result_computation(node_obj, task_graph):
    if node_obj.pragma.get_type() == PragmaType.FOR:
        __for_result_computation(node_obj)
    elif node_obj.pragma.get_type() == PragmaType.PARALLEL:
        __parallel_result_computation(node_obj, task_graph)
    elif node_obj.pragma.get_type() == PragmaType.BARRIER:
        __barrier_result_computation(node_obj)
    elif node_obj.pragma.get_type() == PragmaType.SINGLE:
        __single_result_computation(node_obj)
    elif node_obj.pragma.get_type() == PragmaType.TASK:
        __task_result_computation(node_obj)
    elif node_obj.pragma.get_type() == PragmaType.TASKWAIT:
        __taskwait_result_computation(node_obj)

    else:
        warnings.warn("NOT SUPPORTED: " + str(node_obj.pragma))


def __parallel_result_computation(node_obj, task_graph):
    # collect behavior models from all contained nodes without incoming SEQUENTIAL edge
    behavior_models: List[BehaviorModel] = []
    for source, target in task_graph.graph.out_edges(node_obj.node_id):
        if task_graph.graph.edges[(source, target)]["type"] == EdgeType.CONTAINS:
            # check if target has incoming SEQUENTIAL edge
            target_has_incoming_seq_edge = False
            for inner_source, inner_target in task_graph.graph.in_edges(target):
                if task_graph.graph.edges[(inner_source, inner_target)]["type"] == EdgeType.SEQUENTIAL:
                    target_has_incoming_seq_edge = True
                    break
            if target_has_incoming_seq_edge:
                continue
            # target is the beginning of a contained sequence -> collect behavior model
            behavior_models += task_graph.graph.nodes[target]["data"].get_behavior_models(task_graph)

    # modify behavior models to use current fingerprint
    for model in behavior_models:
        model.use_fingerprint(node_obj.result.get_current_fingerprint())

    # prepare behavior models for simulation
    behavior_models = prepare_for_simulation(behavior_models)

    # create scheduling graph from behavior models
    scheduling_graph, dimensions = create_scheduling_graph_from_behavior_models(behavior_models)
    # check for data races and extract set of next states
    data_races, successful_states = get_data_races_and_successful_states(scheduling_graph, dimensions, node_obj.result)
    # store results
    node_obj.result.data_races = data_races
    node_obj.result.states = successful_states


def __for_result_computation(node_obj):
    warnings.warn("TODO")
    pass


def __barrier_result_computation(self):
    warnings.warn("TODO")
    pass


def __single_result_computation(self):
    warnings.warn("TODO")
    pass

def __task_result_computation(self):
    warnings.warn("TODO")
    pass

def __taskwait_result_computation(self):
    warnings.warn("TODO")
    pass