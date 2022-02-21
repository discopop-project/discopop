from discopop_validation.classes.OmpPragma import PragmaType
from discopop_validation.data_race_prediction.scheduler.core import create_scheduling_graph_from_behavior_models
from discopop_validation.data_race_prediction.vc_data_race_detector.core import get_data_races_and_successful_states
import warnings

def perform_node_specific_result_computation(node_obj):
    if node_obj.pragma.get_type() == PragmaType.PARALLEL_FOR:
        __parallel_for_result_computation(node_obj)
    elif node_obj.pragma.get_type() == PragmaType.PARALLEL:
        __parallel_result_computation(node_obj)
    elif node_obj.pragma.get_type() == PragmaType.BARRIER:
        __barrier_result_computation(node_obj)
    elif node_obj.pragma.get_type() == PragmaType.SINGLE:
        __single_result_computation(node_obj)
    else:
        warnings.warn("NOT SUPPORTED: " + str(node_obj.pragma))


def __parallel_result_computation(node_obj):
    # create scheduling graph from behavior models
    scheduling_graph, dimensions = create_scheduling_graph_from_behavior_models(node_obj.behavior_models)
    # check for data races and extract set of next states
    data_races, successful_states = get_data_races_and_successful_states(scheduling_graph, dimensions, node_obj.result)
    # store results
    node_obj.result.data_races = data_races
    node_obj.result.states = successful_states


def __parallel_for_result_computation(node_obj):
    # create scheduling graph from behavior models
    scheduling_graph, dimensions = create_scheduling_graph_from_behavior_models(node_obj.behavior_models)
    # check for data races and extract set of next states
    data_races, successful_states = get_data_races_and_successful_states(scheduling_graph, dimensions, node_obj.result)
    # store results
    node_obj.result.data_races = data_races
    node_obj.result.states = successful_states


def __barrier_result_computation(self):
    warnings.warn("TODO")
    pass


def __single_result_computation(self):
    warnings.warn("TODO")
    pass