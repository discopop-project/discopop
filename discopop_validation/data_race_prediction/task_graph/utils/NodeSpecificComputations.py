from typing import List

from discopop_validation.classes.OmpPragma import PragmaType
from discopop_validation.data_race_prediction.behavior_modeller.classes.BehaviorModel import BehaviorModel
from discopop_validation.data_race_prediction.scheduler.classes.SchedulingGraph import SchedulingGraph
from discopop_validation.data_race_prediction.scheduler.core import create_scheduling_graph_from_behavior_models
from discopop_validation.data_race_prediction.simulation_preparation.core import prepare_for_simulation
from discopop_validation.data_race_prediction.task_graph.classes.EdgeType import EdgeType
from discopop_validation.data_race_prediction.vc_data_race_detector.classes.DataRace import DataRace
from discopop_validation.data_race_prediction.vc_data_race_detector.classes.State import State
from discopop_validation.data_race_prediction.vc_data_race_detector.core import get_data_races_and_successful_states
import warnings
import copy
import networkx as nx

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
    behavior_model_sequence = ["SEQ"]
    for source, target in task_graph.graph.out_edges(node_obj.node_id):
        behavior_models = ["PAR"]
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
            behavior_models.append(task_graph.graph.nodes[target]["data"].get_behavior_models(task_graph, node_obj.result))
        if len(behavior_models) > 1:
            behavior_model_sequence.append(behavior_models)

    # todo recursive unpacking

    # todo move closest to computation to avoid double unpacking


    def __clean_behavior_model_sequence(sequence):
        result_sequence = []
        for elem in sequence:
            if type(elem) == list:
                if elem not in [["PAR"], ["SEQ"]]:
                    result_sequence.append(__clean_behavior_model_sequence(elem))
            else:
                result_sequence.append(elem)
        return result_sequence

    print(behavior_model_sequence)
    behavior_model_sequence = __clean_behavior_model_sequence(behavior_model_sequence)
    print()
    print(behavior_model_sequence)
    print()

    # todo: Why is line 30 read before 28 is written? should be suppressed by sequential composition


    def __unpack_behavior_models_to_successive_scheduling_graphs(behavior_information):
        graph_list: List[SchedulingGraph] = []
        if type(behavior_information) == BehaviorModel:
            # create Scheduling Graph from Behavior Model
            # modify behavior models to use current fingerprint
            behavior_information.use_fingerprint(node_obj.result.get_current_fingerprint())
            # prepare behavior models for simulation
            behavior_information = prepare_for_simulation([behavior_information])  # todo use global variables to save states regarding reduction removal etc.
            # create scheduling graph from behavior models
            scheduling_graph, dimensions = create_scheduling_graph_from_behavior_models(behavior_information)
            return [scheduling_graph]

        else:
            if type(behavior_information) == list:
                if len(behavior_information) == 0:
                    return None
                if len(behavior_information) == 1:
                    return __unpack_behavior_models_to_successive_scheduling_graphs(behavior_information[0])
                if behavior_information[0] in ["SEQ", "PAR"]:
                    scheduling_graphs = [None]
                    if behavior_information[0] == "SEQ":
                        # sequential composition
                        for elem in behavior_information[1:]:
                            if elem == "TASKWAIT":
                                # create a new, successive scheduling graph
                                scheduling_graphs.append(None)
                                continue
                            tmp_graphs = __unpack_behavior_models_to_successive_scheduling_graphs(elem)
                            if tmp_graphs is not None:
                                if scheduling_graphs[-1] is None:
                                    # shortcut to prevent unnecessary compositions and graph inflation
                                    scheduling_graphs[-1] = tmp_graphs[0]
                                else:
                                    scheduling_graphs[-1] = scheduling_graphs[-1].sequential_compose(tmp_graphs[0])
                                scheduling_graphs += tmp_graphs[1:]
                    else:
                        # parallel composition
                        for elem in behavior_information[1:]:
                            if elem == "TASKWAIT":
                                # create a new, successive scheduling graph
                                scheduling_graphs.append(None)
                                continue
                            tmp_graphs = __unpack_behavior_models_to_successive_scheduling_graphs(elem)
                            if tmp_graphs is not None:
                                if scheduling_graphs[-1] is None:
                                    # shortcut to prevent unnecessary compositions and graph inflation
                                    scheduling_graphs[-1] = tmp_graphs[0]
                                else:
                                    scheduling_graphs[-1] = scheduling_graphs[-1].parallel_compose(tmp_graphs[0])
                                scheduling_graphs += tmp_graphs[1:]
                    return scheduling_graphs

        raise ValueError("Unknown: ", behavior_information)



    scheduling_graphs = __unpack_behavior_models_to_successive_scheduling_graphs(behavior_model_sequence)
    for idx, graph in enumerate(scheduling_graphs):
        nx.drawing.nx_pydot.write_dot(graph.graph, "/home/lukas/graph"+str(idx)+".dot")

    # scheduling_graph.plot_graph()
    data_races: List[DataRace] = []
    successful_states = []
    for graph in scheduling_graphs:
        print("INIT: ")
        for state in successful_states:
            print()
            print(state)
        tmp_data_races, successful_states = get_data_races_and_successful_states(graph, graph.dimensions, successful_states)
        data_races += tmp_data_races
        # remove duplicates from successful states
        successful_states_wo_duplicates = []
        for state in successful_states:
            is_known = False
            for known_state in successful_states_wo_duplicates:
                if state == known_state:
                    is_known = True
                    break
            if not is_known:
                successful_states_wo_duplicates.append(state)
        successful_states = successful_states_wo_duplicates

    #data_races, successful_states = get_data_races_and_successful_states(scheduling_graph, scheduling_graph.dimensions)

    # store results
    node_obj.result.data_races = data_races
    node_obj.result.states = successful_states

    for dr in node_obj.result.data_races:
        print(dr)

    #for succ_states in node_obj.result.states:
    #    print(succ_states)


    # todo List[List[BehaviorModel]] to enable successive parallel and sequential sections
    # todo --> schedule each entry individually and pass states forward

    #for behavior_models in behavior_model_sequence:
    #    # create scheduling graph from behavior models
    #    scheduling_graph, dimensions = create_scheduling_graph_from_behavior_models(behavior_models)
    #    print(scheduling_graph)
    #    # check for data races and extract set of next states
    #    data_races, successful_states = get_data_races_and_successful_states(scheduling_graph, dimensions, node_obj.result)
    #    # store results
    #    node_obj.result.data_races = data_races
    #    node_obj.result.states = successful_states

    #for behavior_models in behavior_model_sequence:
    #    print("###")
    #    for model in behavior_models:
    #        print("\t###")
    #        for op in model.operations:
    #            print(op)


def __for_result_computation(node_obj):
    warnings.warn("TODO")
    pass


def __barrier_result_computation(self):
    warnings.warn("TODO")
    pass


def __single_result_computation(self):
    """"""
    warnings.warn("TODO")
    pass

def __task_result_computation(self):
    warnings.warn("TODO")
    pass

def __taskwait_result_computation(self):
    warnings.warn("TODO")
    pass