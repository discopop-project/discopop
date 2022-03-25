import warnings

from typing import List, Optional, Dict, Tuple
import copy
import networkx as nx  # type:ignore
import matplotlib.pyplot as plt  # type:ignore
from networkx.drawing.nx_agraph import graphviz_layout  # type:ignore

from discopop_explorer import PETGraphX
from discopop_explorer.PETGraphX import EdgeType as PETEdgeType
from discopop_validation.classes.Configuration import Configuration
from discopop_validation.classes.OmpPragma import OmpPragma, PragmaType
from discopop_validation.data_race_prediction.task_graph.classes.CalledFunctionNode import CalledFunctionNode
from discopop_validation.data_race_prediction.task_graph.classes.EdgeType import EdgeType
from discopop_validation.data_race_prediction.task_graph.classes.ForkNode import ForkNode
from discopop_validation.data_race_prediction.task_graph.classes.JoinNode import JoinNode
from discopop_validation.data_race_prediction.task_graph.classes.PragmaBarrierNode import PragmaBarrierNode
from discopop_validation.data_race_prediction.task_graph.classes.PragmaForNode import PragmaForNode
from discopop_validation.data_race_prediction.task_graph.classes.PragmaParallelNode import PragmaParallelNode
from discopop_validation.data_race_prediction.task_graph.classes.PragmaSingleNode import PragmaSingleNode
from discopop_validation.data_race_prediction.task_graph.classes.PragmaTaskNode import PragmaTaskNode
from discopop_validation.data_race_prediction.task_graph.classes.PragmaTaskwaitNode import PragmaTaskwaitNode
from discopop_validation.data_race_prediction.task_graph.classes.ResultObject import ResultObject
from discopop_validation.data_race_prediction.task_graph.classes.TaskGraphNode import TaskGraphNode
from discopop_validation.interfaces.discopop_explorer import check_reachability

from discopop_validation.data_race_prediction.task_graph.utils.NodeSpecificComputations import get_sequence_entry_points, \
    get_contained_exit_points


class TaskGraph(object):
    graph: nx.MultiDiGraph
    next_free_node_id: int
    pragma_to_node_id: Dict[OmpPragma, int]

    def __init__(self):
        self.graph = nx.DiGraph()
        # add root node, id = (tuple of n zero´s, last executed thread id)
        self.next_free_node_id = 0
        self.pragma_to_node_id = dict()
        self.graph.add_node(self.__get_new_node_id(), data=TaskGraphNode(0))

    def __get_new_node_id(self) -> int:
        buffer = self.next_free_node_id
        self.next_free_node_id += 1
        return buffer

    def plot_graph(self, mark_data_races=False):
        plt.subplot(121)
        pos = nx.fruchterman_reingold_layout(self.graph)
        colors = []
        for node in self.graph.nodes:
            colors.append(self.graph.nodes[node]["data"].get_color(mark_data_races))
        edge_color_map = {EdgeType.SEQUENTIAL: "black",
                          EdgeType.CONTAINS: "orange",
                          EdgeType.DEPENDS: "green",
                          EdgeType.DATA_RACE: "red",
                          EdgeType.CALLS: "violet"}
        edge_colors = [edge_color_map[self.graph[source][dest]['type']] for source,dest in self.graph.edges]
        nx.draw(self.graph, pos, with_labels=False, arrows=True, font_weight='bold', node_color=colors, edge_color=edge_colors)
        labels = {}
        for node in self.graph.nodes:
            labels[node] = str(self.graph.nodes[node]["data"].get_label())
        nx.draw_networkx_labels(self.graph, pos, labels)
        plt.show()

    def add_generic_child_node(self, parent_node_id_list: List[int], pragma=None) -> int:
        """adds a new node to the graph with incoming edges from each node specified in parent_node_id_list and
        returns the node_id of the newly created node."""
        new_node_id = self.__get_new_node_id()
        self.graph.add_node(new_node_id, data=TaskGraphNode(new_node_id))
        for parent_node_id in parent_node_id_list:
            self.graph.add_edge(parent_node_id, new_node_id)
        return new_node_id

    def add_pragma_node(self, pragma_obj: OmpPragma):
        """create a new node in the graph which represents the given pragma"""
        # get dependencies to previous nodes
        if pragma_obj.get_type() == PragmaType.FOR:
            node_id = self.__add_for_pragma(pragma_obj)
        elif pragma_obj.get_type() == PragmaType.PARALLEL:
            node_id = self.__add_parallel_pragma(pragma_obj)
        elif pragma_obj.get_type() == PragmaType.SINGLE:
            node_id = self.__add_single_pragma(pragma_obj)
        elif pragma_obj.get_type() == PragmaType.TASK:
            node_id = self.__add_task_pragma(pragma_obj)
        elif pragma_obj.get_type() == PragmaType.TASKWAIT:
            node_id = self.__add_taskwait_pragma(pragma_obj)
        elif pragma_obj.get_type() == PragmaType.BARRIER:
            node_id = self.__add_barrier_pragma(pragma_obj)
        else:
            raise ValueError("No Supported Pragma for: ", pragma_obj.pragma)
        # create entry in dictionary
        self.pragma_to_node_id[pragma_obj] = node_id

    def __add_single_pragma(self, pragma_obj: OmpPragma):
        new_node_id = self.__get_new_node_id()
        self.graph.add_node(new_node_id, data=PragmaSingleNode(new_node_id, pragma=pragma_obj))
        return new_node_id

    def __add_for_pragma(self, pragma_obj: OmpPragma):
        new_node_id = self.__get_new_node_id()
        self.graph.add_node(new_node_id, data=PragmaForNode(new_node_id, pragma=pragma_obj))
        return new_node_id

    def __add_parallel_pragma(self, pragma_obj: OmpPragma):
        new_node_id = self.__get_new_node_id()
        self.graph.add_node(new_node_id, data=PragmaParallelNode(new_node_id, pragma=pragma_obj))
        return new_node_id

    def __add_task_pragma(self, pragma_obj: OmpPragma):
        new_node_id = self.__get_new_node_id()
        self.graph.add_node(new_node_id, data=PragmaTaskNode(new_node_id, pragma=pragma_obj))
        return new_node_id

    def __add_taskwait_pragma(self, pragma_obj: OmpPragma):
        new_node_id = self.__get_new_node_id()
        self.graph.add_node(new_node_id, data=PragmaTaskwaitNode(new_node_id, pragma=pragma_obj))
        return new_node_id

    def __add_barrier_pragma(self, pragma_obj):
        new_node_id = self.__get_new_node_id()
        self.graph.add_node(new_node_id, data=PragmaBarrierNode(new_node_id, pragma=pragma_obj))
        return new_node_id

    def __add_fork_node(self):
        new_node_id = self.__get_new_node_id()
        self.graph.add_node(new_node_id, data=ForkNode(new_node_id))
        return new_node_id

    def __add_join_node(self):
        new_node_id = self.__get_new_node_id()
        self.graph.add_node(new_node_id, data=JoinNode(new_node_id))
        return new_node_id

    def insert_called_function_nodes_and_calls_edges(self, pet: PETGraphX, omp_pragmas: List[OmpPragma]):
        # copied from add_edges
        pragma_to_cuid: Dict[OmpPragma, str] = dict()
        for pragma in omp_pragmas:
            cu_id = self.__get_pet_node_id_from_source_code_lines(pet, pragma.file_id, pragma.start_line,
                                                                  pragma.end_line)
            pragma_to_cuid[pragma] = cu_id

        cuid_to_node_id_map = dict()
        for pragma in omp_pragmas:
            # check if function is called inside pragma
            seen_configurations = []
            def __include_called_functions(origin_node_id, root_cu_id, given_pragma):
                seen_configurations.append((origin_node_id, root_cu_id, given_pragma))
                for called_function_dict in pet.node_at(root_cu_id).node_calls:
                    called_file_id, called_atLine = called_function_dict["atLine"].split(":")
                    called_file_id = int(called_file_id)
                    called_atLine = int(called_atLine)
                    # check if function call is inside pragmas scope
                    if called_file_id != pragma.file_id or called_atLine < given_pragma.start_line or called_atLine > given_pragma.end_line:
                        continue
                    # create edge and node if not already present
                    if called_function_dict["cuid"] not in cuid_to_node_id_map:
                        called_cu_id = called_function_dict["cuid"]
                        new_node_id = self.__get_new_node_id()
                        cuid_to_node_id_map[called_cu_id] = new_node_id
                        function_name = pet.node_at(called_cu_id).name
                        function_file_id = pet.node_at(called_cu_id).file_id
                        function_start_line = pet.node_at(called_cu_id).start_line
                        function_end_line = pet.node_at(called_cu_id).end_line

                        self.graph.add_node(new_node_id, data=CalledFunctionNode(new_node_id, name=function_name,
                                                                                 file_id=function_file_id,
                                                                                 start_line=function_start_line,
                                                                                 end_line=function_end_line))
                        self.graph.add_edge(origin_node_id, new_node_id, type=EdgeType.CALLS)
                    else:
                        self.graph.add_edge(origin_node_id, cuid_to_node_id_map[called_function_dict["cuid"]], type=EdgeType.CALLS)
                # start recursion over all unseen children of root_cu_id

                for child_cu in pet.direct_children(pet.node_at(root_cu_id)):
                    if (origin_node_id, child_cu.id, given_pragma) not in seen_configurations:
                        __include_called_functions(origin_node_id, child_cu.id, given_pragma)

            __include_called_functions(self.pragma_to_node_id[pragma], pragma_to_cuid[pragma], pragma)


    def insert_function_contains_edges(self):
        for node in self.graph.nodes:
            if type(self.graph.nodes[node]["data"]) == CalledFunctionNode:
                for other_node in self.graph.nodes:
                    if node == other_node:
                        continue
                    if self.graph.nodes[other_node]["data"].pragma is None:
                        continue
                    # check if other_node contained in node
                    if self.graph.nodes[node]["data"].file_id != self.graph.nodes[other_node]["data"].pragma.file_id:
                        continue
                    if self.graph.nodes[node]["data"].start_line <= self.graph.nodes[other_node]["data"].pragma.start_line <= self.graph.nodes[node]["data"].end_line and \
                            self.graph.nodes[node]["data"].start_line <= self.graph.nodes[other_node]["data"].pragma.end_line <= self.graph.nodes[node]["data"].end_line:
                        # other_node contained in node
                        # create contains edge between node and other_node
                        self.graph.add_edge(node, other_node, type=EdgeType.CONTAINS)



    def compute_results(self):
        # trigger result computation for root node
        computed_result = self.graph.nodes[0]["data"].compute_result(self, ResultObject(), [0])
        # display detected data races
        for data_race in computed_result.data_races:
            print(data_race)
        return computed_result


    def insert_behavior_models(self, run_configuration: Configuration, pet: PETGraphX, omp_pragmas: List[OmpPragma]):
        for node_id in self.graph.nodes:
            self.graph.nodes[node_id]["data"].insert_behavior_model(run_configuration, pet, self, omp_pragmas)

    def add_edges(self, pet: PETGraphX, omp_pragmas: List[OmpPragma]):
        """extract dependencies between omp pragmas from the PET Graph and create edges in the TaskGraph accordingly."""
        pragma_to_cuid: Dict[OmpPragma, str] = dict()
        for pragma in omp_pragmas:
            cu_id = self.__get_pet_node_id_from_source_code_lines(pet, pragma.file_id, pragma.start_line, pragma.end_line)
            pragma_to_cuid[pragma] = cu_id

        # todo more efficient edge creation (potentially traverse upwards and find pragmas along each path instead of pairwise calculation)
        # add successor edges
        for pragma in omp_pragmas:
            for other_pragma in omp_pragmas:
                if pragma == other_pragma:
                    continue
                # check if pragma is reachable from other_pragma in pet graph using successor edges
                if check_reachability(pet, pet.node_at(pragma_to_cuid[pragma]), pet.node_at(pragma_to_cuid[other_pragma]), [PETEdgeType.SUCCESSOR]):
                    # pragma is a successor of other_pragma or based on same CU
                    # check if CUIDs are different
                    # pragma is a successor of other_pragma
                    # this check prevents cycles due to same CU Node
                    if other_pragma.start_line <= pragma.start_line and other_pragma.end_line <= pragma.start_line:
                        self.graph.add_edge(self.pragma_to_node_id[other_pragma], self.pragma_to_node_id[pragma], type=EdgeType.SEQUENTIAL)
                else:
                    # if not, check if both pragmas share a common parent and check if pragma succeeds other_pragma
                    pragma_parents = [source for source, target, data in pet.in_edges(pragma_to_cuid[pragma], PETEdgeType.CHILD)] + [pragma_to_cuid[pragma]]
                    # check if other_pragma is a direct child of parent
                    for parent in pragma_parents:
                        if pet.node_at(pragma_to_cuid[other_pragma]) in pet.direct_children(pet.node_at(parent)) + [pet.node_at(parent)]:
                            # pragma and other pragma share a common parent
                            # check if other_pragma is a successor of pragma
                            if other_pragma.start_line <= pragma.start_line and other_pragma.end_line <= pragma.start_line:
                                self.graph.add_edge(self.pragma_to_node_id[other_pragma], self.pragma_to_node_id[pragma], type=EdgeType.SEQUENTIAL)

        # add contains edges
        for pragma in omp_pragmas:
            for other_pragma in omp_pragmas:
                if pragma == other_pragma:
                    continue
                # if two pragmas are based on the same CU, the first appearing contains the second, if their source code lines overlap
                if pragma_to_cuid[pragma] == pragma_to_cuid[other_pragma]:
                    if pragma.start_line < other_pragma.start_line and pragma.end_line >= other_pragma.end_line:
                        # pragma contains other_pragma
                        self.graph.add_edge(self.pragma_to_node_id[pragma], self.pragma_to_node_id[other_pragma], type=EdgeType.CONTAINS)
                else:
                    # if cuid's are different, a contains edge shall exist if a CHILD-path from pragma to other_pragma exists
                    if check_reachability(pet, pet.node_at(pragma_to_cuid[other_pragma]), pet.node_at(pragma_to_cuid[pragma]), [PETEdgeType.CHILD]):
                        # todo maybe remove dead code
                        # ensure, that other_pragma lies within the boundary of pragma
                        #if pragma.start_line <= other_pragma.start_line and pragma.end_line >= other_pragma.end_line:
                        #    self.graph.add_edge(self.pragma_to_node_id[pragma], self.pragma_to_node_id[other_pragma], type=EdgeType.CONTAINS)
                        self.graph.add_edge(self.pragma_to_node_id[pragma], self.pragma_to_node_id[other_pragma], type=EdgeType.CONTAINS)

        # Fallback: add edge from root node to current node if no predecessor exists
        for node in self.graph.nodes:
            if len(self.graph.in_edges(node)) == 0 and node != 0:
                self.graph.add_edge(0, node, type=EdgeType.SEQUENTIAL)

    def __get_pet_node_id_from_source_code_lines(self, pet: PETGraphX, file_id: int, start_line: int, end_line: int):
        """Returns the ID of the pet-graph node which contains the given pragma"""
        potential_nodes = []
        for pet_node in pet.g.nodes:
            if file_id == pet.g.nodes[pet_node]["data"].file_id and \
                start_line >= pet.g.nodes[pet_node]["data"].start_line and \
                end_line <= pet.g.nodes[pet_node]["data"].end_line:
                potential_nodes.append(pet_node)
        if len(potential_nodes) == 0:
            raise ValueError("No valid CUID found for: ", str(file_id) + ":"+ str(start_line)+"-"+str(end_line))
        # find narrowest matching node
        narrowest_node_buffer = potential_nodes[0]
        for pet_node in potential_nodes:
            if pet.g.nodes[pet_node]["data"].start_line >= pet.g.nodes[narrowest_node_buffer]["data"].start_line and \
                pet.g.nodes[pet_node]["data"].end_line <= pet.g.nodes[narrowest_node_buffer]["data"].end_line:
                narrowest_node_buffer = pet_node
        return narrowest_node_buffer

    def remove_redundant_edges(self, edge_types: List[EdgeType]):
        # todo currently, only SEQUENTIAL edges are considered, rename?

        def __get_start_line(stl_target):
            if self.graph.nodes[stl_target]["data"].pragma is None:
                return self.graph.nodes[stl_target]["data"].behavior_models[0].get_start_line()
            else:
                return self.graph.nodes[stl_target]["data"].pragma.start_line

        # calculate code line distances and remove all but the shortest edge
        for node in self.graph.nodes:
            shortest_edge_source = None
            shortest_edge_distance = None
            for edge_source, edge_target in self.graph.in_edges(node):
                if self.graph.edges[(edge_source, edge_target)]["type"] not in edge_types:
                    continue
                try:
                    distance = __get_start_line(node) - __get_start_line(edge_source)
                except AttributeError:
                    continue
                except IndexError:
                    continue
                if distance < 0:
                    continue
                if shortest_edge_source is None:
                    shortest_edge_source = edge_source
                    shortest_edge_distance = distance
                    continue
                if distance < shortest_edge_distance:
                    shortest_edge_source = edge_source
                    shortest_edge_distance = distance
            if shortest_edge_distance is None:
                continue
            # remove unnecessary edges
            edge_remove_buffer = []
            for edge_source, edge_target in self.graph.in_edges(node):
                # only consider SEQUENTIAL edges
                if self.graph.edges[(edge_source, edge_target)]["type"] not in edge_types:
                    continue
                if self.graph.nodes[edge_source]["data"].pragma is None:
                    continue
                if edge_source == shortest_edge_source:
                    continue
                edge_remove_buffer.append((edge_source, node))
            for source, target in edge_remove_buffer:
                self.graph.remove_edge(source, target)
        pass

    def move_successor_edges_if_source_is_contained_in_pragma(self):
        """relocate successor edges to the outer most possible pragma in case that a edge source is contained in another pragma."""
        modification_found = True
        while modification_found:
            modification_found = False
            remove_edge = None
            add_edge = None
            for source, target in self.graph.edges:
                # check if edge is of type SEQUENTIAL
                if self.graph.edges[(source, target)]["type"] != EdgeType.SEQUENTIAL:
                    continue
                # edge is SEQUENTIAL type
                # check if source is contained in another pragma
                source_incoming_edges = self.graph.in_edges(source)
                # check if any of the incoming edges is a CONTAINS edge
                source_incoming_contains_edge = None
                for edge in source_incoming_edges:
                    if self.graph.edges[(edge[0], edge[1])]["type"] == EdgeType.CONTAINS:
                        source_incoming_contains_edge = edge
                        break
                # check if target is contained in another pragma
                target_incoming_edges = self.graph.in_edges(target)
                # check if any of the incoming edges is a CONTAINS edge
                target_incoming_contains_edge = None
                for edge in target_incoming_edges:
                    if self.graph.edges[(edge[0], edge[1])]["type"] == EdgeType.CONTAINS:
                        target_incoming_contains_edge = edge
                        break
                # if source and target are contained in the same pragma, ignore
                if source_incoming_contains_edge is not None and target_incoming_contains_edge is not None:
                    if source_incoming_contains_edge[0] == target_incoming_contains_edge[0]:
                        # source and target are contained in the same pragma
                        continue
                # if source_incoming_contains_edge exists, move successor edge to the source of the incoming contains edge
                if source_incoming_contains_edge is not None:
                    remove_edge = (source, target)
                    add_edge = (source_incoming_contains_edge[0], target)
                    break
            if remove_edge is not None and add_edge is not None:
                self.graph.remove_edge(remove_edge[0], remove_edge[1])
                self.graph.add_edge(add_edge[0], add_edge[1], type=EdgeType.SEQUENTIAL)
                modification_found = True
        pass

    def move_successor_edges_if_target_is_contained_in_pragma(self):
        """relocate successor edges to the outer most possible pragma in case that a edge target is contained in another pragma."""
        modification_found = True
        while modification_found:
            modification_found = False
            remove_edge = None
            add_edge = None
            for source, target in self.graph.edges:
                # check if edge is of type SEQUENTIAL
                if self.graph.edges[(source, target)]["type"] != EdgeType.SEQUENTIAL:
                    continue
                # edge is SEQUENTIAL type
                # check if source is contained in another pragma
                source_incoming_edges = self.graph.in_edges(source)
                # check if any of the incoming edges is a CONTAINS edge
                source_incoming_contains_edge = None
                for edge in source_incoming_edges:
                    if self.graph.edges[(edge[0], edge[1])]["type"] == EdgeType.CONTAINS:
                        source_incoming_contains_edge = edge
                        break
                # check if target is contained in another pragma
                target_incoming_edges = self.graph.in_edges(target)
                # check if any of the incoming edges is a CONTAINS edge
                target_incoming_contains_edge = None
                for edge in target_incoming_edges:
                    if self.graph.edges[(edge[0], edge[1])]["type"] == EdgeType.CONTAINS:
                        target_incoming_contains_edge = edge
                        break
                # if source and target are contained in the same pragma, ignore
                if source_incoming_contains_edge is not None and target_incoming_contains_edge is not None:
                    if source_incoming_contains_edge[0] == target_incoming_contains_edge[0]:
                        # source and target are contained in the same pragma
                        continue
                # if target_incoming_contains_edge exists, move successor edge to the target of the incoming contains edge
                if target_incoming_contains_edge is not None:
                    remove_edge = (source, target)
                    add_edge = (source, target_incoming_contains_edge[0])
                    break
            if remove_edge is not None and add_edge is not None:
                self.graph.remove_edge(remove_edge[0], remove_edge[1])
                self.graph.add_edge(add_edge[0], add_edge[1], type=EdgeType.SEQUENTIAL)
                modification_found = True
        pass

    def insert_implicit_barriers(self):
        """Insert implicit barriers. Currently supports: SINGLE"""
        add_barrier_buffer = []
        for node in self.graph.nodes():
            node_pragma = self.graph.nodes[node]["data"].pragma
            if node_pragma is None:
                continue
            # detect implicit barriers
            # single-pragma has an implicit barrier at the end
            # parallel-pragma has an implicit barrier at the end
            if node_pragma.get_type() in [PragmaType.SINGLE, PragmaType.PARALLEL]:
                add_barrier_buffer.append(node)

        # create barriers
        for new_barrier_source in add_barrier_buffer:
            barrier_node_id = self.__get_new_node_id()
            self.graph.add_node(barrier_node_id, data=PragmaBarrierNode(barrier_node_id,
                                                                        pragma=OmpPragma().init_with_values(
                                                                            self.graph.nodes[new_barrier_source]["data"].pragma.file_id, self.graph.nodes[new_barrier_source]["data"].pragma.end_line,
                                                                            self.graph.nodes[new_barrier_source]["data"].pragma.end_line, "barrier")))
            self.graph.add_edge(new_barrier_source, barrier_node_id, type=EdgeType.SEQUENTIAL)
            # create CONTAINS edge from parent of new_barrier_source if necessarry
            in_contains_edges = [edge for edge in self.graph.in_edges(new_barrier_source) if self.graph.edges[edge]["type"] == EdgeType.CONTAINS]
            for edge in in_contains_edges:
                self.graph.add_edge(edge[0], barrier_node_id, type=EdgeType.CONTAINS)

            # redirect outgoing SEQUENTIAL edges
            remove_edges = []
            add_edges = []
            for source, target in self.graph.out_edges(new_barrier_source):
                if target == barrier_node_id:
                    continue
                if self.graph.edges[(source, target)]["type"] == EdgeType.SEQUENTIAL:
                    remove_edges.append((source, target))
                    add_edges.append((barrier_node_id, target))
            for source, target in remove_edges:
                self.graph.remove_edge(source, target)
            for source, target in add_edges:
                self.graph.add_edge(source, target, type=EdgeType.SEQUENTIAL)
        pass

    def insert_behavior_storage_nodes(self):
        """creates TaskGraphNodes to store Behavior Models in the graph structure, rather than on each node"""
        create_nodes: List[Tuple[int, TaskGraphNode]] = []
        create_edges: List[Tuple[int, int, EdgeType]] = []
        bhv_storage_node_to_parent: Dict[int, int] = dict()
        for node in self.graph.nodes:
            # create contained BehaviorStorageNodes
            for model in self.graph.nodes[node]["data"].behavior_models:
                new_node_id = self.__get_new_node_id()
                behavior_storage_node = TaskGraphNode(new_node_id)
                behavior_storage_node.behavior_models.append(model)
                create_nodes.append((new_node_id, behavior_storage_node))
                create_edges.append((node, new_node_id, EdgeType.CONTAINS))
                bhv_storage_node_to_parent[new_node_id] = node

        # create identified nodes
        for node_id, graph_node_data in create_nodes:
            self.graph.add_node(node_id, data=graph_node_data)
        # create identified edges
        for source, target, edge_type in create_edges:
            self.graph.add_edge(source, target, type=edge_type)

        # connect created behavior storage nodes
        for bhv_storage_node, _ in create_nodes:
            # check if bhv_storage_node precedes or succedes contained sequence-start or sequences-end nodes
            for parent, target in self.graph.out_edges(bhv_storage_node_to_parent[bhv_storage_node]):
                if self.graph.edges[(parent, target)]["type"] != EdgeType.CONTAINS:
                    continue
                # get amount of incoming and outgoing SEQUENTIAL edges of target
                incoming = 0
                outgoing = 0
                for source, inner_target in self.graph.in_edges(target):
                    if self.graph.edges[(source, inner_target)]["type"] == EdgeType.SEQUENTIAL:
                        incoming += 1
                for source, inner_target in self.graph.out_edges(target):
                    if self.graph.edges[(source, inner_target)]["type"] == EdgeType.SEQUENTIAL:
                        outgoing += 1

                # if target has no incoming SEQUENTIAL edge, check if bhv_storage_node is a predecessor
                if incoming == 0:
                    if self.graph.nodes[target]["data"].pragma is None:
                        pass
                    elif self.graph.nodes[bhv_storage_node]["data"].behavior_models[0].get_file_id() == self.graph.nodes[target]["data"].pragma.file_id and \
                            self.graph.nodes[bhv_storage_node]["data"].behavior_models[0].get_start_line() <= self.graph.nodes[target]["data"].pragma.start_line and \
                            self.graph.nodes[bhv_storage_node]["data"].behavior_models[0].get_end_line() <= self.graph.nodes[target]["data"].pragma.start_line:
                        # bhv_storage_node is a predecessor of target
                        self.graph.add_edge(bhv_storage_node, target, type=EdgeType.SEQUENTIAL)
                        continue

                # if target has no outgoing SEQUENTIAL edge, check if bhv_storage_node is a successor
                if outgoing == 0:
                    if self.graph.nodes[target]["data"].pragma is None:
                        pass
                    elif self.graph.nodes[bhv_storage_node]["data"].behavior_models[0].get_file_id() == self.graph.nodes[target]["data"].pragma.file_id and \
                            self.graph.nodes[bhv_storage_node]["data"].behavior_models[0].get_start_line() >= self.graph.nodes[target]["data"].pragma.start_line and \
                            self.graph.nodes[bhv_storage_node]["data"].behavior_models[0].get_start_line() >= self.graph.nodes[target]["data"].pragma.end_line:
                        # bhv_storage_node is a successor of target
                        self.graph.add_edge(target, bhv_storage_node, type=EdgeType.SEQUENTIAL)
                        continue
                # bhv needs to be inserted into existing sequence
                if incoming == 0:
                    if bhv_storage_node == target:
                        continue
                    # target is sequence entry. From previous checks it is known, that bhv_storage_node is no predecessor of target
                    # search along each path for possible location
                    predecessor_queue = [target]
                    visited_predecessors = []
                    while len(predecessor_queue) > 0:
                        current_predecessor = predecessor_queue.pop(0)
                        visited_predecessors.append(current_predecessor)
                        add_edges: List[Tuple[int, int, EdgeType]] = []
                        remove_edges: List[Tuple[int, int]] = []
                        for inner_source, inner_target in self.graph.out_edges(current_predecessor):
                            if self.graph.edges[(inner_source, inner_target)]["type"] != EdgeType.SEQUENTIAL:
                                continue
                            # check if inner_target is a successor of bhv_storage_node
                            # separate treatment of regular and behavior storage nodes required due to missing pragmas
                            if self.graph.nodes[inner_target]["data"].pragma is None:
                                if self.graph.nodes[bhv_storage_node]["data"].behavior_models[0].get_start_line() <= self.graph.nodes[inner_target]["data"].behavior_models[0].get_start_line() and \
                                self.graph.nodes[bhv_storage_node]["data"].behavior_models[0].get_end_line() <= self.graph.nodes[inner_target]["data"].behavior_models[0].get_start_line():
                                    # inner_target is a successor of bhv_storage_node
                                    # insert bhv_storage_node inbetween current_predecessor and inner_target
                                    add_edges.append((current_predecessor, bhv_storage_node, EdgeType.SEQUENTIAL))
                                    add_edges.append((bhv_storage_node, inner_target, EdgeType.SEQUENTIAL))
                                    # remove edge from current_predecessor to inner_target
                                    remove_edges.append((current_predecessor, inner_target))
                                else:
                                    # inner_target is not a successor of bhv_storage_node
                                    # add inner_target to predecessor_queue
                                    if inner_target not in visited_predecessors:
                                        predecessor_queue.append(inner_target)
                            else:
                                if self.graph.nodes[bhv_storage_node]["data"].behavior_models[0].get_start_line() <= self.graph.nodes[inner_target]["data"].pragma.start_line and \
                                self.graph.nodes[bhv_storage_node]["data"].behavior_models[0].get_end_line() <= self.graph.nodes[inner_target]["data"].pragma.start_line:
                                    # inner_target is a successor of bhv_storage_node
                                    # insert bhv_storage_node inbetween current_predecessor and inner_target
                                    add_edges.append((current_predecessor, bhv_storage_node, EdgeType.SEQUENTIAL))
                                    add_edges.append((bhv_storage_node, inner_target, EdgeType.SEQUENTIAL))
                                    # remove edge from current_predecessor to inner_target
                                    remove_edges.append((current_predecessor, inner_target))
                                else:
                                    # inner_target is not a successor of bhv_storage_node
                                    # add inner_target to predecessor_queue
                                    if inner_target not in visited_predecessors:
                                        predecessor_queue.append(inner_target)
                        for s, t in remove_edges:
                            self.graph.remove_edge(s, t)
                        for s, t, ty in add_edges:
                            self.graph.add_edge(s, t, type=ty)

    def add_virtual_sequential_edges(self):
        """replace a sequential edge with a virtual sequential edge, if the target is a Taskwait node."""
        # todo maybe include barrier nodes aswell
        for edge in self.graph.edges:
            if self.graph.edges[edge]["type"] == EdgeType.SEQUENTIAL and type(self.graph.nodes[edge[0]]["data"]) == PragmaTaskNode:
                # check if target is Taskwait node
                target = edge[1]
                target_type = type(self.graph.nodes[target]["data"])
                if  target_type in [PragmaTaskwaitNode, PragmaBarrierNode]:
                    # replace edge type
                    self.graph.edges[edge]["type"] = EdgeType.VIRTUAL_SEQUENTIAL
        pass

    def redirect_tasks_successors(self):
        def __get_closest_successor_barrier_or_taskwait(node_id):
            queue = [node_id]
            visited = []
            while len(queue) > 0:
                current = queue.pop()
                visited.append(current)
                if type(self.graph.nodes[current]["data"]) in [PragmaTaskwaitNode, PragmaBarrierNode]:
                    return current
                # add successors of current to queue
                successors = [edge[1] for edge in self.graph.out_edges(current) if
                              self.graph.edges[edge]["type"] == EdgeType.SEQUENTIAL]
                queue += [s for s in successors if s not in visited]
            return None

        def __get_closest_parent_barrier_or_taskwait(node_id):
            queue = [node_id]
            visited = []
            while len(queue) > 0:
                current = queue.pop()
                visited.append(current)
                result = __get_closest_successor_barrier_or_taskwait(current)
                if result is not None:
                    return result
                for edge in self.graph.in_edges(current):
                    if self.graph.edges[edge]["type"] == EdgeType.CONTAINS:
                        queue.append(edge[0])

        for node in self.graph.nodes:
            if type(self.graph.nodes[node]["data"]) == PragmaTaskNode:
                # find next BARRIER or TASKWAIT
                next_barrier = __get_closest_successor_barrier_or_taskwait(node)
                if next_barrier is None:
                    # no barrier found in successors, search in parent node
                    next_barrier = __get_closest_parent_barrier_or_taskwait(node)

                out_seq_edges = [edge for edge in self.graph.out_edges(node) if self.graph.edges[edge]["type"] == EdgeType.SEQUENTIAL]
                in_seq_edges = [edge for edge in self.graph.in_edges(node) if
                                 self.graph.edges[edge]["type"] == EdgeType.SEQUENTIAL]
                # redirect incoming SEQUENTIAL edges to Successors
                for edge in in_seq_edges:
                    self.graph.remove_edge(edge[0], edge[1])
                    for out_edge in out_seq_edges:
                        self.graph.add_edge(edge[0], out_edge[1], type=EdgeType.SEQUENTIAL)
                # redirect outgoing SEQUENTIAL edge to barrier
                for edge in out_seq_edges:
                    self.graph.remove_edge(edge[0], edge[1])
                self.graph.add_edge(node, next_barrier, type=EdgeType.SEQUENTIAL)


    def add_fork_and_join_nodes(self):
        node_ids = copy.deepcopy(self.graph.nodes())
        for node in node_ids:
            if type(self.graph.nodes[node]["data"]) == PragmaParallelNode:
                contains_edges = [edge for edge in self.graph.out_edges(node) if self.graph.edges[edge]["type"] == EdgeType.CONTAINS]
                if len(contains_edges) > 0:
                    # create fork and join nodes
                    fork_node_id = self.__add_fork_node()
                    join_node_id = self.__add_join_node()
                    self.graph.add_edge(node, fork_node_id, type=EdgeType.CONTAINS)
                    self.graph.add_edge(node, join_node_id, type=EdgeType.CONTAINS)
                    # connect fork and join nodes to contained nodes
                    for _, child in contains_edges:
                        # add fork node before each child without incoming SEQUENTIAL edge
                        incoming_sequential_edges = [edge for edge in self.graph.in_edges(child) if
                                                     self.graph.edges[edge]["type"] == EdgeType.SEQUENTIAL]
                        if len(incoming_sequential_edges) == 0:
                            self.graph.add_edge(fork_node_id, child, type=EdgeType.SEQUENTIAL)
                        # add join node after each child without outgoing SEQUENTIAL edge
                        outgoing_sequential_edges = [edge for edge in self.graph.out_edges(child) if
                                                     self.graph.edges[edge]["type"] == EdgeType.SEQUENTIAL]
                        if len(outgoing_sequential_edges) == 0:
                            self.graph.add_edge(child, join_node_id, type=EdgeType.SEQUENTIAL)

    def add_join_nodes_before_barriers(self):
        node_ids = copy.deepcopy(self.graph.nodes)
        for node in node_ids:
            if type(self.graph.nodes[node]["data"]) in [PragmaBarrierNode, PragmaTaskwaitNode]:
                join_node_id = self.__add_join_node()
                # add SEQUENTIAL edge from join node to barrier node
                self.graph.add_edge(join_node_id, node, type=EdgeType.SEQUENTIAL)

                incoming_seq_edge = [edge for edge in self.graph.in_edges(node) if self.graph.edges[edge]["type"] == EdgeType.SEQUENTIAL and edge[0] != join_node_id]
                # redirect incoming edges
                for edge in incoming_seq_edge:
                    self.graph.add_edge(edge[0], join_node_id, type=EdgeType.SEQUENTIAL)
                    self.graph.remove_edge(edge[0], node)

    def replace_pragma_single_nodes(self):
        remove_nodes = []
        for node in self.graph.nodes:
            if type(self.graph.nodes[node]["data"]) == PragmaSingleNode:
                remove_nodes.append(node)
                # set simulation_thread_count to 1 for each contained node
                out_contains_edges = [edge for edge in self.graph.out_edges(node) if
                                  self.graph.edges[edge]["type"] == EdgeType.CONTAINS]
                for _, target in out_contains_edges:
                    self.graph.nodes[target]["data"].set_simulation_thread_count(1)

                # replace node with contained sequences
                in_seq_edges = [edge for edge in self.graph.in_edges(node) if
                                self.graph.edges[edge]["type"] == EdgeType.SEQUENTIAL]
                out_seq_edges = [edge for edge in self.graph.out_edges(node) if
                                  self.graph.edges[edge]["type"] == EdgeType.SEQUENTIAL]
                sequence_entry_points = get_sequence_entry_points(self, node)
                # redirect incoming edges
                for entry in sequence_entry_points:
                    for edge in in_seq_edges:
                        self.graph.add_edge(edge[0], entry, type=EdgeType.SEQUENTIAL)
                # redirect outgoing edges
                sequence_exit_points = get_contained_exit_points(self, node)
                for exit in sequence_exit_points:
                    for edge in out_seq_edges:
                        self.graph.add_edge(exit, edge[1], type=EdgeType.SEQUENTIAL)
        for node in remove_nodes:
            self.graph.remove_node(node)

    def __has_preceeding_task_node(self, root_node) -> bool:
        if type(self.graph.nodes[root_node]["data"]) == PragmaTaskNode:
            return True
        in_seq_edges = [edge for edge in self.graph.in_edges(root_node) if
                        self.graph.edges[edge]["type"] == EdgeType.SEQUENTIAL]
        for edge in in_seq_edges:
            if self.__has_preceeding_task_node(edge[0]):
                return True
        return False

    def remove_taskwait_without_prior_task(self):
        remove_nodes = []
        for node in self.graph.nodes:
            if type(self.graph.nodes[node]["data"]) == PragmaTaskwaitNode:
                if not self.__has_preceeding_task_node(node):
                    remove_nodes.append(node)

        for node in remove_nodes:
            in_seq_edges = [edge for edge in self.graph.in_edges(node) if
                            self.graph.edges[edge]["type"] == EdgeType.SEQUENTIAL]
            out_seq_edges = [edge for edge in self.graph.out_edges(node) if
                            self.graph.edges[edge]["type"] == EdgeType.SEQUENTIAL]
            for in_edge in in_seq_edges:
                for out_edge in out_seq_edges:
                    self.graph.add_edge(in_edge[0], out_edge[1], type=EdgeType.SEQUENTIAL)
            self.graph.remove_node(node)

    def skip_taskwait_if_no_prior_task_exists(self):
        for node in self.graph.nodes:
            out_seq_edges = [edge for edge in self.graph.out_edges(node) if
                            self.graph.edges[edge]["type"] == EdgeType.SEQUENTIAL]
            for _, target in out_seq_edges:
                # check if target is a TASKWAIT node
                if type(self.graph.nodes[target]["data"]) == PragmaTaskwaitNode:
                    # skip TASKWAIT, if no TASK is a predecessor of node
                    if not self.__has_preceeding_task_node(node):
                        # redirect successor edge
                        # remove edge from node to TASKWAIT
                        self.graph.remove_edge(node, target)
                        # add edges from node to all successors of TASKWAIT
                        taskwait_out_seq_edges = [edge for edge in self.graph.out_edges(target) if
                                                  self.graph.edges[edge]["type"] == EdgeType.SEQUENTIAL]
                        for edge in taskwait_out_seq_edges:
                            self.graph.add_edge(node, edge[1], type=EdgeType.SEQUENTIAL)

    def add_data_races_to_graph(self, computed_result):
        for node in self.graph.nodes:
            # only consider behavior nodes
            if type(self.graph.nodes[node]["data"]) != TaskGraphNode:
                continue
            node_behavior_models = self.graph.nodes[node]["data"].behavior_models
            if node_behavior_models is None:
                continue
            node_operations = []
            for model in node_behavior_models:
                for operation in model.operations:
                    node_operations.append(operation)


            for data_race in computed_result.data_races:
                # check if node is origin of data_race
                origin_node = None
                for _,_,_, operation in data_race.schedule_element.updates:
                    if operation is None:
                        continue
                    if operation in node_operations:
                        origin_node = node
                        break
                if origin_node is None:
                    continue
                # search for previous node and mark via DATA_RACE edge
                last_access_node = None
                if len(data_race.previous_accesses) > 0:
                    last_access_schedule_element = data_race.previous_accesses[-1]
                    loop_breaker = False
                    for _,_,_, last_access_operation in last_access_schedule_element.updates:
                        if loop_breaker:
                            break
                        if last_access_operation is None:
                            continue
                        # find node which contains last_access_operation
                        for inner_node in self.graph.nodes:
                            inner_node_behavior_models = self.graph.nodes[inner_node]["data"].behavior_models
                            if inner_node_behavior_models is None:
                                continue
                            inner_node_operations = []
                            for model in inner_node_behavior_models:
                                for operation in model.operations:
                                    inner_node_operations.append(operation)
                            # check if last_access_operation contained in inner_node_operations
                            if last_access_operation in inner_node_operations:
                                last_access_node = inner_node
                                loop_breaker = True
                                break
                # append data_race to origin_node
                self.graph.nodes[origin_node]["data"].data_races.append(data_race)
                # create DATA_RACE edge from last_access_node to origin_node
                if last_access_node is not None:
                    self.graph.add_edge(last_access_node, origin_node, type=EdgeType.DATA_RACE)







