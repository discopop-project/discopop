from typing import List

from discopop_validation.classes.OmpPragma import PragmaType
from discopop_validation.data_race_prediction.behavior_modeller.classes.BehaviorModel import BehaviorModel
from discopop_validation.data_race_prediction.scheduler.classes.ScheduleElement import ScheduleElement
from discopop_validation.data_race_prediction.scheduler.classes.SchedulingGraph import SchedulingGraph
from discopop_validation.data_race_prediction.scheduler.classes.UpdateType import UpdateType
from discopop_validation.data_race_prediction.scheduler.core import create_scheduling_graph_from_behavior_models
from discopop_validation.data_race_prediction.simulation_preparation.core import prepare_for_simulation
from discopop_validation.data_race_prediction.task_graph.classes.EdgeType import EdgeType
from discopop_validation.data_race_prediction.vc_data_race_detector.classes.DataRace import DataRace
from discopop_validation.data_race_prediction.vc_data_race_detector.classes.State import State
from discopop_validation.data_race_prediction.vc_data_race_detector.core import get_data_races_and_successful_states
import warnings
import copy
import networkx as nx

from discopop_validation.data_race_prediction.vc_data_race_detector.data_race_detector import goto_next_state


def perform_node_specific_result_computation(node_obj, task_graph, result_obj, thread_ids):
    if node_obj.pragma is None:
        if node_obj.get_label() == "Fork":
            return __fork_node_result_computation(node_obj, task_graph, result_obj, thread_ids)
        elif node_obj.get_label() == "Join":
            return __join_node_result_computation(node_obj, task_graph, result_obj, thread_ids)
        else:
            return __behavior_node_result_computation(node_obj, task_graph, result_obj, thread_ids)
    if node_obj.pragma.get_type() == PragmaType.FOR:
        return __for_result_computation(node_obj, task_graph, result_obj, thread_ids)
    elif node_obj.pragma.get_type() == PragmaType.PARALLEL:
        return __parallel_result_computation(node_obj, task_graph, result_obj, thread_ids)
    elif node_obj.pragma.get_type() == PragmaType.BARRIER:
        return __barrier_result_computation(node_obj, task_graph, result_obj, thread_ids)
    elif node_obj.pragma.get_type() == PragmaType.SINGLE:
        return __single_result_computation(node_obj, task_graph, result_obj, thread_ids)
    elif node_obj.pragma.get_type() == PragmaType.TASK:
        return __task_result_computation(node_obj, task_graph, result_obj, thread_ids)
    elif node_obj.pragma.get_type() == PragmaType.TASKWAIT:
        return __taskwait_result_computation(node_obj, task_graph, result_obj, thread_ids)

    else:
        warnings.warn("NOT SUPPORTED: " + str(node_obj.pragma))
        return result_obj


def get_sequence_entry_points(task_graph, root_id) -> List[int]:
    entry_points = []
    contained_nodes = [edge[1] for edge in task_graph.graph.out_edges(root_id) if
                       task_graph.graph.edges[edge]["type"] == EdgeType.CONTAINS]
    for node in contained_nodes:
        incoming_seq_edges = [edge for edge in task_graph.graph.in_edges(node) if
                              task_graph.graph.edges[edge]["type"] == EdgeType.SEQUENTIAL]
        if len(incoming_seq_edges) == 0:
            entry_points.append(node)
    return entry_points

def get_contained_exit_points(task_graph, root_id) -> List[int]:
    """returns nodeIds of exit points of root's contained sequences"""
    exit_points = []
    out_contained_edges = [edge for edge in task_graph.graph.out_edges(root_id)
                           if task_graph.graph.edges[edge]["type"] == EdgeType.CONTAINS]
    for _, target in out_contained_edges:
        target_out_seq_edges = [edge for edge in task_graph.graph.out_edges(target)
                                if task_graph.graph.edges[edge]["type"] == EdgeType.SEQUENTIAL and edge[0] != edge[1]]
        if len(target_out_seq_edges) == 0:
            # end of sequence found
            exit_points.append(target)
    return exit_points

def __join_node_result_computation(node_obj, task_graph, result_obj, thread_ids):
    # exit parallel section
    for idx, state in enumerate(result_obj.states):
        # Exit parallel section
        exit_parallel_sched_elem = ScheduleElement(0)
        affected_thread_ids = [tid for tid in state.thread_id_to_clock_position_dict.keys() if tid != 0]
        exit_parallel_sched_elem.add_update("", UpdateType.EXITPARALLEL,
                                             affected_thread_ids=affected_thread_ids)
        result_obj.states[idx] = goto_next_state(state, exit_parallel_sched_elem, [])
    return result_obj


def __fork_node_result_computation(node_obj, task_graph, result_obj, thread_ids):
    """construct scheduling graph until next join node. Connects Fork and join node with a SEQUENTIAL edge.
    Replaces outgoing SEQUENTIAL edges with contained edges"""
    # replace outgoing contains with sequential edges, if the target is not a JOIN node
    out_seq_edges = [edge for edge in task_graph.graph.out_edges(node_obj.node_id) if
                           task_graph.graph.edges[edge]["type"] == EdgeType.SEQUENTIAL]
    for edge in out_seq_edges:
        if task_graph.graph.nodes[edge[1]]["data"].get_label() == "Join":
            continue
        task_graph.graph.edges[edge]["type"] = EdgeType.CONTAINS

    out_contained_edges = [edge for edge in task_graph.graph.out_edges(node_obj.node_id) if
                           task_graph.graph.edges[edge]["type"] == EdgeType.CONTAINS]
    # construct paths to next join node in a BFS manner
    paths = []
    path_queue = []
    visited = []
    # todo: more intelligent calculation of successive_join_node (lookahead and find first join for all branches)
    successive_join_node = None
    for _, successor in out_contained_edges:
        path_queue.append(([], successor))
    while len(path_queue) > 0:
        current_path, current_node = path_queue.pop()
        visited.append((current_path, current_node))
        if task_graph.graph.nodes[current_node]["data"].get_label() == "Join":
            if successive_join_node is None:
                successive_join_node = current_node
            paths.append(current_path)
            continue

        if task_graph.graph.nodes[current_node]["data"].get_label() == "Fork":
            print("ENCOUNTERED FORK NODE: ", current_node)
            current_path.append(current_node)
            out_belongs_to_edges = [edge for edge in task_graph.graph.out_edges(current_node) if task_graph.graph.edges[edge]["type"] == EdgeType.BELONGS_TO]
            for _, related_join_node in out_belongs_to_edges:
                print("ADD SUCCESSORS OF RELATED JOIN: ", related_join_node, "TO QUEUE")
                join_out_seq_edges = [edge for edge in task_graph.graph.out_edges(related_join_node) if task_graph.graph.edges[edge]["type"] == EdgeType.SEQUENTIAL]
                for _, successor in join_out_seq_edges:
                    print("--> SUCC: ", successor)
                    path_queue.append((copy.deepcopy(current_path), successor))
        else:
            # current_node is a regular node type (not FORK)

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

    # connect FORK to JOIN node with SEQUENTIAL edge
    if successive_join_node is not None:
        task_graph.graph.add_edge(node_obj.node_id, successive_join_node, type=EdgeType.SEQUENTIAL)

    scheduling_graph = None
    print("PATHS: ", paths)
    for path in paths:
        path_scheduling_graph = None
        for elem in path:
            task_graph.graph.nodes[elem]["data"].seen_in_result_computation = True
            if task_graph.graph.nodes[elem]["data"].get_label() == "Fork":
                elem_scheduling_graph = task_graph.graph.nodes[elem]["data"].get_scheduling_graph_from_fork_node(task_graph, result_obj)
                print("CHECK fork ELEM_SCHEDULING_GRAPH")
                elem_scheduling_graph.debug_check_for_cycles()
            else:
                behavior_models = task_graph.graph.nodes[elem]["data"].behavior_models
                if len(behavior_models) == 0:
                    continue

                for model in behavior_models:
                    model.use_fingerprint(result_obj.get_current_fingerprint())

                behavior_models = prepare_for_simulation(behavior_models)
                elem_scheduling_graph, dimensions = create_scheduling_graph_from_behavior_models(behavior_models)
                print("CHECK new ELEM_SCHEDULING_GRAPH")
                elem_scheduling_graph.debug_check_for_cycles()
            if path_scheduling_graph is None:
                print("IF")
                path_scheduling_graph = elem_scheduling_graph
            else:
                print("ELSE")
                print("CHECK PATH_SCHEDULING_GRAPH 2")
                path_scheduling_graph.debug_check_for_cycles()
                print("CHECK ELEM SCHEDULING GRAPH 2")
                elem_scheduling_graph.debug_check_for_cycles()
                path_scheduling_graph = path_scheduling_graph.sequential_compose(elem_scheduling_graph)
                print("CHECK PATH_SCHEDULING_GRAPH 3")
                path_scheduling_graph.debug_check_for_cycles()

        if scheduling_graph is None:
            scheduling_graph = path_scheduling_graph
        else:
            print("CHECK SCHEDULING GRAPH")
            scheduling_graph.debug_check_for_cycles()
            print("CHECK PATH_SCHEDULING_GRAPH")
            path_scheduling_graph.debug_check_for_cycles()
            scheduling_graph = scheduling_graph.parallel_compose(path_scheduling_graph)

    # create new clocks if necessary
    for idx, state in enumerate(result_obj.states):
        ## create new thread clocks for state if necessary
        #if state.thread_count < scheduling_graph.thread_count:
        #    stc_buffer = state.thread_count
        #    state.fill_to_thread_count(scheduling_graph.thread_count)

        # create new thread clocks for state if necessary
        # check if all necessary thread_ids are contained in state
        for thread_id in scheduling_graph.thread_ids:
            if thread_id not in state.thread_clocks:
                # create new entry for thread_id in state
                state.create_new_entries(thread_id)

    # enter parallel
    for idx, state in enumerate(result_obj.states):
        # Enter parallel section
        enter_parallel_sched_elem = ScheduleElement(0)
        affected_thread_ids = [tid for tid in state.thread_id_to_clock_position_dict.keys() if tid != 0]
        enter_parallel_sched_elem.add_update("", UpdateType.ENTERPARALLEL,
                                             affected_thread_ids=affected_thread_ids)
        result_obj.states[idx] = goto_next_state(state, enter_parallel_sched_elem, [])

    result_obj.update(scheduling_graph)
    return result_obj


def __behavior_node_result_computation(node_obj, task_graph, result_obj, thread_ids):
    # get scheduling graph
    behavior_models = node_obj.behavior_models
    for model in behavior_models:
        model.use_fingerprint(result_obj.get_current_fingerprint())
    # todo include?: prepare behavior models for simulation
    #behavior_information = prepare_for_simulation([behavior_information])
    # create scheduling graph from behavior models
    scheduling_graph, dimensions = create_scheduling_graph_from_behavior_models(behavior_models)
    # update result_obj
    result_obj.update(scheduling_graph)
    # return result_obj
    return result_obj


def __parallel_result_computation(node_obj, task_graph, result_obj, thread_ids):
    # entering a parallel region creates a new scope
    result_obj.push_new_fingerprint()
    # parallel node has exactly one entry point (Fork node)
    entry_point = get_sequence_entry_points(task_graph, node_obj.node_id)[0]
    calculated_result = task_graph.graph.nodes[entry_point]["data"].compute_result(task_graph, copy.deepcopy(result_obj), thread_ids)
    # exiting a parallel region closes the current scope
    calculated_result.pop_fingerprint()
    return calculated_result


def __for_result_computation(node_obj, task_graph, result_obj, thread_ids):
    # FOR has no effect aside from storing behavior information
    entry_point = get_sequence_entry_points(task_graph, node_obj.node_id)[0]
    calculated_result = task_graph.graph.nodes[entry_point]["data"].compute_result(task_graph, copy.deepcopy(result_obj), thread_ids)
    return calculated_result


def __barrier_result_computation(node_obj, task_graph, result_obj, thread_ids):
    # at this point in time, BARRIER has no effect on it's own.
    return result_obj


def __single_result_computation(node_obj, task_graph, result_obj, thread_ids):
    """"""
    warnings.warn("TODO")
    pass


def __task_result_computation(node_obj, task_graph, result_obj, thread_ids):
    warnings.warn("TODO")
    pass


def __taskwait_result_computation(node_obj, task_graph, result_obj, thread_ids):
    # at this point in time, TASKWAIT has no effect on it's own.
    return result_obj


def __unused_parallel_result_computation(node_obj, task_graph):
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

    behavior_model_sequence = __clean_behavior_model_sequence(behavior_model_sequence)

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
                                scheduling_graphs.append("EXITPARALLEL")
                                scheduling_graphs.append("ENTERPARALLEL")
                                continue
                            if elem == "JOINNODE":
                                # create a new successive scheduling graph but omit the clock synchronization
                                scheduling_graphs.append(None)
                                continue
                            tmp_graphs = __unpack_behavior_models_to_successive_scheduling_graphs(elem)
                            if tmp_graphs is not None:
                                if scheduling_graphs[-1] is None:
                                    # shortcut to prevent unnecessary compositions and graph inflation
                                    scheduling_graphs[-1] = tmp_graphs[0]
                                elif type(scheduling_graphs[-1]) == str:
                                    scheduling_graphs.append(tmp_graphs[0])
                                else:
                                    scheduling_graphs[-1] = scheduling_graphs[-1].sequential_compose(tmp_graphs[0])
                                scheduling_graphs += tmp_graphs[1:]
                    else:
                        # parallel composition
                        for elem in behavior_information[1:]:
                            if elem == "TASKWAIT":
                                # create a new, successive scheduling graph and synchronize previous clocks
                                scheduling_graphs.append("EXITPARALLEL")
                                scheduling_graphs.append("ENTERPARALLEL")
                                continue
                            if elem == "JOINNODE":
                                # create a new successive scheduling graph but omit the clock synchronization
                                scheduling_graphs.append(None)
                                continue
                            tmp_graphs = __unpack_behavior_models_to_successive_scheduling_graphs(elem)
                            if tmp_graphs is not None:
                                if scheduling_graphs[-1] is None:
                                    # shortcut to prevent unnecessary compositions and graph inflation
                                    scheduling_graphs[-1] = tmp_graphs[0]
                                elif type(scheduling_graphs[-1]) == str:
                                    scheduling_graphs.append(tmp_graphs[0])
                                else:
                                    scheduling_graphs[-1] = scheduling_graphs[-1].parallel_compose(tmp_graphs[0])
                                scheduling_graphs += tmp_graphs[1:]
                    return scheduling_graphs

        raise ValueError("Unknown: ", behavior_information)



    scheduling_graphs = __unpack_behavior_models_to_successive_scheduling_graphs(behavior_model_sequence)
    for idx, graph in enumerate(scheduling_graphs):
        if type(graph) != str and graph is not None:
            nx.drawing.nx_pydot.write_dot(graph.graph, "/home/lukas/graph"+str(idx)+".dot")

    data_races: List[DataRace] = []
    successful_states = []
    for graph in scheduling_graphs:
        if graph == "ENTERPARALLEL":
            # modify successful states using a ENTERPARALLEL update
            for idx, state in enumerate(successful_states):
                enter_parallel_sched_elem = ScheduleElement(0)
                affected_thread_ids = range(1, state.thread_count)
                enter_parallel_sched_elem.add_update("", UpdateType.ENTERPARALLEL, affected_thread_ids=affected_thread_ids)
                successful_states[idx] = goto_next_state(state, enter_parallel_sched_elem, [])
        elif graph == "EXITPARALLEL":
            # modify successful states using a EXITPARALLEL update
            for idx, state in enumerate(successful_states):
                exit_parallel_sched_elem = ScheduleElement(0)
                affected_thread_ids = range(1, state.thread_count)
                exit_parallel_sched_elem.add_update("", UpdateType.EXITPARALLEL, affected_thread_ids=affected_thread_ids)
                successful_states[idx] = goto_next_state(state, exit_parallel_sched_elem, [])
        elif graph is None:
            # used as a separator
            continue
        else:
            # calculate new data races and successful states using the old successful states as initial states
            for idx, state in enumerate(successful_states):
                # create new thread clocks for state if necessary
                if state.thread_count < graph.thread_count:
                    stc_buffer = state.thread_count
                    state.fill_to_thread_count(graph.thread_count)
                    # synchronize threads
                    enter_parallel_sched_elem = ScheduleElement(0)
                    affected_thread_ids = range(1, state.thread_count)
                    enter_parallel_sched_elem.add_update("", UpdateType.ENTERPARALLEL,
                                                         affected_thread_ids=affected_thread_ids)
                    successful_states[idx] = goto_next_state(state, enter_parallel_sched_elem, [])

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
            if len(successful_states) == 0:
                raise ValueError("BLUB")

    #data_races, successful_states = get_data_races_and_successful_states(scheduling_graph, scheduling_graph.dimensions)

    # store results
    node_obj.result.data_races = data_races
    node_obj.result.states = successful_states

    for dr in node_obj.result.data_races:
        print(dr)

    #for succ_states in node_obj.result.states:
    #    print(succ_states)