from typing import List, Dict, Tuple, Optional
import copy
import networkx as nx  # type:ignore
import matplotlib.pyplot as plt  # type:ignore
from networkx.drawing.nx_agraph import graphviz_layout  # type:ignore

from discopop_explorer import PETGraphX
from discopop_explorer.PETGraphX import EdgeType as PETEdgeType
from discopop_validation.data_race_prediction.utils import get_pet_node_id_from_source_code_lines
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
                          EdgeType.CALLS: "violet",
                          EdgeType.BELONGS_TO: "yellow"}
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
            cu_id = get_pet_node_id_from_source_code_lines(pet, pragma.file_id, pragma.start_line,
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
                        self.graph.add_edge(origin_node_id, new_node_id, type=EdgeType.CALLS, atLine=called_function_dict["atLine"])
                    else:
                        self.graph.add_edge(origin_node_id, cuid_to_node_id_map[called_function_dict["cuid"]], type=EdgeType.CALLS, atLine=called_function_dict["atLine"])
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


    def remove_incorrect_function_contains_edges(self):
        for node in self.graph.nodes:
            if type(self.graph.nodes[node]["data"]) == CalledFunctionNode:
                in_calls_edges = [edge for edge in self.graph.in_edges(node) if self.graph.edges[edge]["type"] == EdgeType.CALLS]
                # group edges by their atLine-value
                grouping_dict = dict()
                for edge in in_calls_edges:
                    atLine_value = self.graph.edges[edge]["atLine"]
                    if atLine_value in grouping_dict:
                        grouping_dict[atLine_value].append(edge)
                    else:
                        grouping_dict[atLine_value] = [edge]
                # if more than one entry for a key exists, remove all but the best fitting one
                for atLine in grouping_dict:
                    if len(grouping_dict[atLine]) <= 1:
                        continue
                    # get the best fitting parent node
                    current_best_node = None
                    current_difference_to_start = None
                    current_difference_to_end = None
                    for edge_source, _ in grouping_dict[atLine]:
                        if current_best_node is None:#
                            current_best_node = self.graph.nodes[edge_source]
                            current_difference_to_start = int(atLine.split(":")[1]) - self.graph.nodes[edge_source]["data"].pragma.start_line
                            current_difference_to_end = self.graph.nodes[edge_source]["data"].pragma.end_line - int(atLine.split(":")[1])
                        else:
                            # check if edge_source is a better fit than current_best_node
                            difference_to_start =  int(atLine.split(":")[1]) - self.graph.nodes[edge_source]["data"].pragma.start_line
                            difference_to_end = self.graph.nodes[edge_source]["data"].pragma.end_line - int(atLine.split(":")[1])

                            # check for improvement in line difference values
                            if difference_to_start <= current_difference_to_start and difference_to_end <= current_difference_to_end:
                                current_best_node = edge_source
                                current_difference_to_start = difference_to_start
                                current_difference_to_end = difference_to_end
                    # remove all but the edge from the best fitting parent node
                    edges_to_be_removed = [edge for edge in grouping_dict[atLine] if edge[0] != current_best_node]
                    for source, target in edges_to_be_removed:
                        self.graph.remove_edge(source, target)


    def compute_results(self) -> ResultObject:
        # trigger result computation for root node
        computed_result: ResultObject = self.graph.nodes[0]["data"].compute_result(self, ResultObject(), [0])
        return computed_result


    def insert_behavior_models(self, run_configuration: Configuration, pet: PETGraphX, omp_pragmas: List[OmpPragma]):
        for node_id in self.graph.nodes:
            self.graph.nodes[node_id]["data"].insert_behavior_model(run_configuration, pet, self, omp_pragmas)

    def add_edges(self, pet: PETGraphX, omp_pragmas: List[OmpPragma]):
        """extract dependencies between omp pragmas from the PET Graph and create edges in the TaskGraph accordingly."""
        pragma_to_cuid: Dict[OmpPragma, str] = dict()
        for pragma in omp_pragmas:
            cu_id = get_pet_node_id_from_source_code_lines(pet, pragma.file_id, pragma.start_line, pragma.end_line)
            pragma_to_cuid[pragma] = cu_id

        pragma_to_parent_function_dict: Dict[OmpPragma, Optional[int]] = dict()
        for pragma in omp_pragmas:
            pragma_to_parent_function_dict[pragma] = None
            in_contains_edges = [edge for edge in self.graph.in_edges(self.pragma_to_node_id[pragma]) if
                                 self.graph.edges[edge]["type"] == EdgeType.CONTAINS]
            for parent_function, _ in in_contains_edges:
                pragma_to_parent_function_dict[pragma] = parent_function

        # add contains edges
        for pragma in omp_pragmas:
            for other_pragma in omp_pragmas:
                if pragma == other_pragma:
                    continue
                # if two pragmas are based on the same CU, the first appearing contains the second, if their source code lines overlap
                if pragma_to_cuid[pragma] == pragma_to_cuid[other_pragma]:
                    if pragma.start_line < other_pragma.start_line and pragma.end_line >= other_pragma.end_line:
                        # pragma contains other_pragma
                        # only create edge, if both share a common parent
                        if pragma_to_parent_function_dict[pragma] == pragma_to_parent_function_dict[other_pragma]:
                            self.graph.add_edge(self.pragma_to_node_id[pragma], self.pragma_to_node_id[other_pragma],
                                                type=EdgeType.CONTAINS)
                else:
                    # if cuid's are different, a contains edge shall exist if a CHILD-path from pragma to other_pragma exists
                    if check_reachability(pet, pet.node_at(pragma_to_cuid[other_pragma]),
                                          pet.node_at(pragma_to_cuid[pragma]), [PETEdgeType.CHILD]):
                        # todo maybe remove dead code
                        # ensure, that other_pragma lies within the boundary of pragma
                        # if pragma.start_line <= other_pragma.start_line and pragma.end_line >= other_pragma.end_line:
                        #    self.graph.add_edge(self.pragma_to_node_id[pragma], self.pragma_to_node_id[other_pragma], type=EdgeType.CONTAINS)
                        self.graph.add_edge(self.pragma_to_node_id[pragma], self.pragma_to_node_id[other_pragma],
                                            type=EdgeType.CONTAINS)

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
                        # only create edge, if both share a common parent
                        if pragma_to_parent_function_dict[pragma] == pragma_to_parent_function_dict[other_pragma]:
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
                                # only create edge, if both share a common parent
                                if pragma_to_parent_function_dict[pragma] == pragma_to_parent_function_dict[other_pragma]:
                                    self.graph.add_edge(self.pragma_to_node_id[other_pragma], self.pragma_to_node_id[pragma], type=EdgeType.SEQUENTIAL)

        # remove all but the shortest outgoing sequential edges
        to_be_removed = []
        for node in self.graph.nodes:
            out_seq_edges = [edge for edge in self.graph.out_edges(node) if self.graph.edges[edge]["type"] == EdgeType.SEQUENTIAL]
            if len(out_seq_edges) == 0:
                continue
            edge_lengths = []
            for source, target in out_seq_edges:
                length = self.graph.nodes[target]["data"].pragma.start_line - self.graph.nodes[source]["data"].pragma.end_line
                edge_lengths.append((source, target, length))
            shortest_edge = min(edge_lengths, key=lambda x: x[2])
            to_be_removed = [(elem[0], elem[1]) for elem in edge_lengths if elem != shortest_edge]
            for source, target in to_be_removed:
                self.graph.remove_edge(source, target)


        # Fallback: add edge from root node to current node if no predecessor exists
        for node in self.graph.nodes:
            if len(self.graph.in_edges(node)) == 0 and node != 0:
                self.graph.add_edge(0, node, type=EdgeType.SEQUENTIAL)

    def remove_redundant_edges(self, edge_types: List[EdgeType]):

        def __get_start_line(stl_target):
            if self.graph.nodes[stl_target]["data"].pragma is None:
                return self.graph.nodes[stl_target]["data"].behavior_models[0].get_start_line()
            else:
                return self.graph.nodes[stl_target]["data"].pragma.start_line

        def __get_end_line(stl_target):
            if self.graph.nodes[stl_target]["data"].pragma is None:
                return self.graph.nodes[stl_target]["data"].behavior_models[0].get_end_line()
            else:
                return self.graph.nodes[stl_target]["data"].pragma.end_line

        # calculate code line distances and remove all but the shortest edge
        for node in self.graph.nodes:
            shortest_edge_source = None
            shortest_edge_distance = None
            for edge_source, edge_target in self.graph.in_edges(node):
                if self.graph.edges[(edge_source, edge_target)]["type"] not in edge_types:
                    continue
                try:
                    distance = __get_start_line(node) - __get_end_line(edge_source)
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

    def __get_insert_location(self, root, start_line):
        def __get_start_line(node_id):
            if self.graph.nodes[node_id]["data"].pragma is None:
                if len(self.graph.nodes[node_id]["data"].behavior_models) == 0:
                    return 0
                else:
                    return self.graph.nodes[node_id]["data"].behavior_models[0].get_start_line()
            else:
                return self.graph.nodes[node_id]["data"].pragma.start_line

        # search on path
        last_element = None
        queue = [root]
        while True:
            current = queue.pop(0)
            if start_line < __get_start_line(current):
                return "before", current
            current_out_seq_edge_targets = [edge[1] for edge in self.graph.out_edges(current) if self.graph.edges[edge]["type"] == EdgeType.SEQUENTIAL]
            if len(current_out_seq_edge_targets) == 0:
                return "after", current
            queue += current_out_seq_edge_targets





        pass

    def insert_behavior_storage_nodes(self):
        """creates TaskGraphNodes to store Behavior Models in the graph structure, rather than on each node"""
        modify_nodes: List[Tuple[str, int, TaskGraphNode]] = []
        modify_edges: List[Tuple[str, int, int, EdgeType]] = []
        edge_replacements = dict()

        bhv_storage_node_to_parent: Dict[int, int] = dict()
        buffer = copy.deepcopy(self.graph.nodes)
        for node in buffer:
            region_start = None
            region_end = None
            if self.graph.nodes[node]["data"].pragma is not None:
                region_start = self.graph.nodes[node]["data"].pragma.start_line
                region_end = self.graph.nodes[node]["data"].pragma.end_line

            # create contained BehaviorStorageNodes
            for model in self.graph.nodes[node]["data"].behavior_models:
                new_node_id = self.__get_new_node_id()
                behavior_storage_node = TaskGraphNode(new_node_id)
                behavior_storage_node.behavior_models.append(model)
                # set thread count to 1 if parent is PragmaSingleNode
                if type(self.graph.nodes[node]["data"]) == PragmaSingleNode:
                    behavior_storage_node.set_simulation_thread_count(1)

                self.graph.add_node(new_node_id, data=behavior_storage_node)
                bhv_storage_node_to_parent[new_node_id] = node
                # old version:
                self.graph.add_edge(node, new_node_id, type=EdgeType.CONTAINS)
                if region_start is None or region_end is None:
                    self.graph.add_edge(node, new_node_id, type=EdgeType.CONTAINS)
                    continue

                # new node is also contained in parent of node
                # mainly required to allow effects of SINGLE pragmas
                node_in_contained_edges = [edge for edge in self.graph.in_edges(node) if self.graph.edges[edge]["type"] == EdgeType.CONTAINS]
                for source, _ in node_in_contained_edges:
                    self.graph.add_edge(source, new_node_id, type=EdgeType.CONTAINS)

                # separate treatment of behavior nodes stemming from called functions vs nodes from the original scope
                if model.get_start_line() >= region_start and model.get_end_line() <= region_end:
                    # model is contained in the original pragma region of node
                    # insert behavior after each path
                    exit_points = get_contained_exit_points(self, node)
                    exit_points = [point for point in exit_points if point != new_node_id]
                    for point in exit_points:
                        self.graph.add_edge(point, new_node_id, type=EdgeType.SEQUENTIAL)

                    # if no exit points have been found, insert the behavior node right after node
                    if len(exit_points) == 0:
                        out_seq_edges = [edge for edge in self.graph.out_edges(node) if self.graph.edges[edge]["type"] == EdgeType.SEQUENTIAL]
                        for _, target in out_seq_edges:
                            self.graph.remove_edge(node, target)
                            self.graph.add_edge(node, new_node_id, type=EdgeType.SEQUENTIAL)
                            self.graph.add_edge(new_node_id, target, type=EdgeType.SEQUENTIAL)
                else:
                    # model originated from the body of a called function
                    # find optimal positioning for new node based on minimal location differences
                    out_calls_edges = [edge for edge in self.graph.out_edges(node) if self.graph.edges[edge]["type"] == EdgeType.CALLS]
                    for _, called_function_node_id in out_calls_edges:
                        called_function_node = self.graph.nodes[called_function_node_id]["data"]
                        if model.get_start_line() >= called_function_node.start_line and model.get_end_line() <= called_function_node.end_line:
                            # model stems from within the current function
                            # get a list of all nodes which are contained in this function plus their respective start lines
                            function_out_contained_edges = [edge for edge in self.graph.out_edges(called_function_node_id) if self.graph.edges[edge]["type"] == EdgeType.CONTAINS]
                            contained_nodes = []
                            for _, contained_node in function_out_contained_edges:
                                if self.graph.nodes[contained_node]["data"].pragma is None:
                                    continue
                                start_line = self.graph.nodes[contained_node]["data"].pragma.start_line
                                contained_nodes.append((contained_node, start_line))
                            # select insert position on each path / sequence
                            insert_locations = []
                            for sequence_entry in get_sequence_entry_points(self, node):
                                insert_locations.append(self.__get_insert_location(sequence_entry, model.get_start_line()))
                            # remove duplicated entries, possible in case of multiple merging sequences
                            insert_locations = list(set(insert_locations))
                            # remove entries which are in relation to the new node itself
                            insert_locations = [(mode, location) for mode, location in insert_locations if location != new_node_id]

                            # insert edges according to the identified locations
                            for mode, location in insert_locations:
                                if mode == "before":
                                    in_seq_edges = [edge for edge in self.graph.in_edges(location) if self.graph.edges[edge]["type"] == EdgeType.SEQUENTIAL]
                                    for source, _ in in_seq_edges:
                                        self.graph.remove_edge(source, location)
                                        self.graph.add_edge(source, new_node_id, type=EdgeType.SEQUENTIAL)
                                    self.graph.add_edge(new_node_id, location, type=EdgeType.SEQUENTIAL)
                                if mode == "after":
                                    out_seq_edges = [edge for edge in self.graph.out_edges(location) if self.graph.edges[edge]["type"] == EdgeType.SEQUENTIAL]
                                    for _, target in out_seq_edges:
                                        self.graph.remove_edge(location, target)
                                        self.graph.add_edge(new_node_id, target)
                                    self.graph.add_edge(location, new_node_id, type=EdgeType.SEQUENTIAL)




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

    def __get_closest_successor_barrier_or_taskwait(self, node_id):
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

    def redirect_tasks_successors(self):

        def __get_closest_parent_barrier_or_taskwait(node_id):
            queue = [node_id]
            visited = []
            while len(queue) > 0:
                current = queue.pop()
                visited.append(current)
                # Do not allow other Task pragmas other than the original one as a potential source for barriers or taskwaits
                if type(self.graph.nodes[current]["data"]) == PragmaTaskNode and current != node_id:
                    # skip task node as parent
                    result = None
                else:
                    result = self.__get_closest_successor_barrier_or_taskwait(current)
                if result is not None:
                    return result
                for edge in self.graph.in_edges(current):
                    if self.graph.edges[edge]["type"] == EdgeType.CONTAINS:
                        queue.append(edge[0])

        for node in self.graph.nodes:
            if type(self.graph.nodes[node]["data"]) == PragmaTaskNode:
                # find next BARRIER or TASKWAIT
                next_barrier = self.__get_closest_successor_barrier_or_taskwait(node)
                if next_barrier is None:
                    # no barrier found in successors, search in parent node
                    next_barrier = __get_closest_parent_barrier_or_taskwait(node)
                if next_barrier is None:
                    # still no barrier found, skip
                    continue

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

    def remove_single_incoming_join_node(self):
        """Remove a join node with only a single incoming SEQUENTIAL edge, if no path merging occured prior to it"""
        def path_merge_occured_prior(root):
            tmp_in_seq_edges = [edge for edge in self.graph.in_edges(root) if self.graph.edges[edge]["type"] == EdgeType.SEQUENTIAL]
            if len(tmp_in_seq_edges) > 1:
                return True
            if len(tmp_in_seq_edges) == 0:
                return False
            predecessor = tmp_in_seq_edges[0][0]
            return path_merge_occured_prior(predecessor)


        to_be_removed = []
        for node in self.graph.nodes:
            if type(self.graph.nodes[node]["data"]) == JoinNode:
                in_seq_edge = [edge for edge in self.graph.in_edges(node) if self.graph.edges[edge]["type"] == EdgeType.SEQUENTIAL]
                if len(in_seq_edge) < 2 and not path_merge_occured_prior(node):
                    to_be_removed.append(node)
        for node in to_be_removed:
            in_seq_edges = [edge for edge in self.graph.in_edges(node) if self.graph.edges[edge]["type"] == EdgeType.SEQUENTIAL]
            out_seq_edges = [edge for edge in self.graph.out_edges(node) if self.graph.edges[edge]["type"] == EdgeType.SEQUENTIAL]
            # if a barrier or taskwait node is a successor, do not remove the join
            skip_node = False
            for _, successor in out_seq_edges:
                if type(self.graph.nodes[successor]["data"]) in [PragmaBarrierNode, PragmaTaskwaitNode]:
                    skip_node = True
            if skip_node:
                continue

            for source, _ in in_seq_edges:
                for _, target in out_seq_edges:
                    self.graph.add_edge(source, target, type=EdgeType.SEQUENTIAL)
            self.graph.remove_node(node)



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

    def add_join_nodes_before_path_merge(self):
        node_ids = copy.deepcopy(self.graph.nodes)
        for node in node_ids:
            in_seq_edges = [edge for edge in self.graph.in_edges(node) if self.graph.edges[edge]["type"] == EdgeType.SEQUENTIAL]
            if len(in_seq_edges) > 1:
                join_node_id = self.__add_join_node()
                # add SEQUENTIAL edge from join node to node
                self.graph.add_edge(join_node_id, node, type=EdgeType.SEQUENTIAL)
                # redirect incoming sequential edges to join node
                for source, _ in in_seq_edges:
                    self.graph.remove_edge(source, node)
                    self.graph.add_edge(source, join_node_id, type=EdgeType.SEQUENTIAL)


            #if type(self.graph.nodes[node]["data"]) in [PragmaBarrierNode, PragmaTaskwaitNode]:
            #    join_node_id = self.__add_join_node()
            #    # add SEQUENTIAL edge from join node to barrier node
            #    self.graph.add_edge(join_node_id, node, type=EdgeType.SEQUENTIAL)
#
#                incoming_seq_edge = [edge for edge in self.graph.in_edges(node) if self.graph.edges[edge]["type"] == EdgeType.SEQUENTIAL and edge[0] != join_node_id]
#                # redirect incoming edges
#                for edge in incoming_seq_edge:
#                    self.graph.add_edge(edge[0], join_node_id, type=EdgeType.SEQUENTIAL)
#                    self.graph.remove_edge(edge[0], node)

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
                # redirect incoming to outgoing sequential edges
                for source, _ in in_seq_edges:
                    for _, target in out_seq_edges:
                        self.graph.add_edge(source, target, type=EdgeType.SEQUENTIAL)
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

    def remove_called_function_nodes(self):
        to_be_removed = []
        for node in self.graph.nodes:
            if type(self.graph.nodes[node]["data"]) == CalledFunctionNode:
                to_be_removed.append(node)
        for node in to_be_removed:
            self.graph.remove_node(node)

    def is_successor(self, root_node, target_node):
        if root_node == target_node:
            return True
        out_seq_edges = [edge for edge in self.graph.out_edges(root_node) if self.graph.edges[edge]["type"] == EdgeType.SEQUENTIAL]
        result = False
        for _, successor in out_seq_edges:
            result = result or self.is_successor(successor, target_node)
        return result


    def add_depends_edges(self):
        for node in self.graph.nodes:
            if type(self.graph.nodes[node]["data"]) != PragmaTaskNode:
                continue
            # check if node has dependencies
            node_depend_entries = self.graph.nodes[node]["data"].pragma.get_variables_listed_as("depend")
            if len(node_depend_entries) == 0:
                # no depends entries exist, skip current node
                continue
            node_depend_in_entries = [var for mode, var in [entry.split(":") for entry in node_depend_entries] if
                                      mode == "in"]
            node_depend_out_entries = [var for mode, var in [entry.split(":") for entry in node_depend_entries] if
                                       mode == "out"]
            node_depend_inout_entries = [var for mode, var in [entry.split(":") for entry in node_depend_entries] if
                                       mode == "inout"]

            node_depend_out_entries += node_depend_inout_entries
            node_depend_in_entries += node_depend_inout_entries

            # search counterpart
            for other_node in self.graph.nodes:
                if node == other_node:
                    continue
                if type(self.graph.nodes[other_node]["data"]) != PragmaTaskNode:
                    continue
                other_node_depend_entries = self.graph.nodes[other_node]["data"].pragma.get_variables_listed_as("depend")
                if len(other_node_depend_entries) == 0:
                    # no depend entries exist, skip this node
                    continue

                # node and other_node are different and both of type TASK with non-empty depend clauses
                # check if both share a common successive barrier / taskwait
                if self.__get_closest_successor_barrier_or_taskwait(node) != self.__get_closest_successor_barrier_or_taskwait(other_node):
                    continue
                # node and other_node share a common successive barrier
                # check if depends relation exists from node to other_node
                other_node_depend_in_entries = [var for mode, var in [entry.split(":") for entry in other_node_depend_entries] if mode == "in"]
                other_node_depend_out_entries = [var for mode, var in [entry.split(":") for entry in other_node_depend_entries] if mode == "out"]
                # check for matching entries
                # 1. check for out->in dependency
                for node_out in node_depend_out_entries:
                    if node_out in other_node_depend_in_entries:
                        self.graph.add_edge(other_node, node, type=EdgeType.DEPENDS)
                # 2. check for out->out dependency (occurs, if a SEQUENTIAL path between both TASKS exists
                for node_out in node_depend_out_entries:
                    if node_out in other_node_depend_out_entries:
                        # if SEQUENTIAL path from other_node to node exists, create a DEPENDS edge
                        if self.is_successor(other_node, node):
                            self.graph.add_edge(node, other_node, type=EdgeType.DEPENDS)


    def replace_depends_with_sequential_edges(self):
        add_edge_buffer = []
        for node in self.graph.nodes:
            if type(self.graph.nodes[node]["data"]) != PragmaTaskNode:
                continue
            out_dep_edges = [edge for edge in self.graph.out_edges(node) if self.graph.edges[edge]["type"] == EdgeType.DEPENDS]
            if len(out_dep_edges) == 0:
                continue
            for _, target in out_dep_edges:
                # insert node inbetween target and it's immediate successor (BARRIER or TASKWAIT, which is a successor of node aswell)
                target_out_seq_edges = [edge for edge in self.graph.out_edges(target) if self.graph.edges[edge]["type"] == EdgeType.SEQUENTIAL]
                for _, tmp_target in target_out_seq_edges:
                    # remove outgoing sequential edges (Edge to successive TASKWAIT or BARRIER
                    self.graph.remove_edge(target, tmp_target)
                # add a SEQUENTIAL edge to node
                # don't add immediately, to prevent removal in next loop iteration
                add_edge_buffer.append((target, node))
                # remove depends edge
                self.graph.remove_edge(node, target)

        add_edge_buffer = list(set(add_edge_buffer))
        # add TASKWAIT after node to represent the semantics of DEPEND
        taskwait_node = self.__add_taskwait_pragma(None)
        for source, target in add_edge_buffer:
            self.graph.add_edge(source, taskwait_node, type=EdgeType.SEQUENTIAL)
            self.graph.add_edge(taskwait_node, target, type=EdgeType.SEQUENTIAL)


    def add_fork_nodes_at_path_splits(self):
        buffer = copy.deepcopy(self.graph.nodes)
        for node in buffer:
            if type(self.graph.nodes[node]["data"]) == ForkNode:
                # exclude already existing FORK nodes from analysis
                continue
            out_seq_edges = [edge for edge in self.graph.out_edges(node) if self.graph.edges[edge]["type"] == EdgeType.SEQUENTIAL]
            if len(out_seq_edges) < 2:
                # no problem, skip
                continue
            # insert fork node after node
            new_node_id = self.__add_fork_node()
            for _, target in out_seq_edges:
                self.graph.remove_edge(node, target)
                self.graph.add_edge(new_node_id, target, type=EdgeType.SEQUENTIAL)
            self.graph.add_edge(node, new_node_id, type=EdgeType.SEQUENTIAL)


    def add_belongs_to_edges(self):
        for node in self.graph.nodes:
            if type(self.graph.nodes[node]["data"]) == ForkNode:
                out_seq_edges = [edge for edge in self.graph.out_edges(node) if
                                 self.graph.edges[edge]["type"] == EdgeType.SEQUENTIAL]
                # create list of SEQUENTIAL paths
                paths = []
                path_queue = []
                visited = []
                for _, successor in out_seq_edges:
                    path_queue.append(([], successor))
                while len(path_queue) > 0:
                    current_path, current_node = path_queue.pop()
                    visited.append((current_path, current_node))

                    current_out_seq_edges = [edge for edge in self.graph.out_edges(current_node) if
                                     self.graph.edges[edge]["type"] == EdgeType.SEQUENTIAL and edge[0] !=
                                     edge[1]]
                    # check if end of path reached
                    if len(current_out_seq_edges) == 0:
                        # end of path found, append current_node to current_path
                        # append current_path to paths
                        current_path.append(current_node)
                        paths.append(current_path)
                        continue
                    # add new queue entry for each successor
                    current_path.append(current_node)
                    for _, target in current_out_seq_edges:
                        if (current_path, target) not in visited:
                            path_queue.append((copy.deepcopy(current_path), target))

                contained_in_all_paths = None
                for path in paths:
                    if contained_in_all_paths is None:
                        contained_in_all_paths = set(path)
                    else:
                        contained_in_all_paths = contained_in_all_paths.intersection(set(path))
                if contained_in_all_paths is None:
                    continue
                contained_in_all_paths = list(contained_in_all_paths)

                # find JOIN node
                contained_in_all_paths = sorted(contained_in_all_paths, reverse=True)
                for elem in contained_in_all_paths:
                    if type(self.graph.nodes[elem]["data"]) == JoinNode:
                        # found the outer most JOIN node
                        self.graph.add_edge(node, elem, type=EdgeType.BELONGS_TO)
                        break



            #if type(self.graph.nodes[node]["data"]) == JoinNode:
            #    # search incoming SEQUENTIAL paths upwards for closest FORK nodes
            #    predecessors = [edge[0] for edge in self.graph.in_edges(node) if
            #                    self.graph.edges[edge]["type"] == EdgeType.SEQUENTIAL]
            #    queue = predecessors
            #    while len(queue) > 0:
            #        current = queue.pop()
            #        if type(self.graph.nodes[current]["data"]) == ForkNode:
            #            self.graph.add_edge(current, node, type=EdgeType.BELONGS_TO)
            #        if type(self.graph.nodes[current]["data"]) == JoinNode:
            #            continue
            #        # add predecessors to queue
            #        in_seq_edges = [edge for edge in self.graph.in_edges(current) if self.graph.edges[edge]["type"] == EdgeType.SEQUENTIAL]
            #        for source, _ in in_seq_edges:
            #            queue.append(source)


    def remove_behavior_models_from_nodes(self):
        for node in self.graph.nodes:
            if type(self.graph.nodes[node]["data"]) != TaskGraphNode:
                # remove behavior models from all but behavior storage nodes
                self.graph.nodes[node]["data"].behavior_models = []

    def replace_pragma_for_nodes(self):
        remove_nodes = []
        for node in self.graph.nodes:
            if type(self.graph.nodes[node]["data"]) == PragmaForNode:
                remove_nodes.append(node)
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
                # redirect incoming to outgoing sequential edges
                for source, _ in in_seq_edges:
                    for _, target in out_seq_edges:
                        self.graph.add_edge(source, target, type=EdgeType.SEQUENTIAL)
        for node in remove_nodes:
            self.graph.remove_node(node)

    def pass_shared_clauses_to_childnodes(self):
        re_run = True
        while re_run:
            re_run = False
            seen_nodes = []
            for node in self.graph.nodes:
                seen_nodes.append(node)
                if self.graph.nodes[node]["data"].pragma is None:
                    continue
                shared_vars = self.graph.nodes[node]["data"].pragma.get_variables_listed_as("shared")
                # check if shared variables contained in child node
                out_contains_edges = [edge for edge in self.graph.out_edges(node) if self.graph.edges[edge]["type"] == EdgeType.CONTAINS]
                for _, child in out_contains_edges:
                    if self.graph.nodes[child]["data"].pragma is None:
                        continue
                    known_variables = self.graph.nodes[child]["data"].pragma.get_known_variables()
                    missing_shared_variables = [var for var in shared_vars if var not in known_variables]
                    if len(missing_shared_variables) > 0 and child in seen_nodes:
                        re_run = True
                    for var in missing_shared_variables:
                        self.graph.nodes[child]["data"].pragma.add_to_shared(var)

    def mark_behavior_storage_nodes_covered_by_fork_nodes(self):
        for node in self.graph.nodes:
            if type(self.graph.nodes[node]["data"]) != ForkNode:
                continue
            out_sequential_edges = [edge for edge in self.graph.out_edges(node) if self.graph.edges[edge]["type"] == EdgeType.SEQUENTIAL]

            paths = []
            path_queue = []
            visited = []
            successive_join_node = None
            for _, successor in out_sequential_edges:
                path_queue.append(([], successor))
            while len(path_queue) > 0:
                current_path, current_node = path_queue.pop()
                visited.append((current_path, current_node))
                if self.graph.nodes[current_node]["data"].get_label() == "Join":
                    if successive_join_node is None:
                        successive_join_node = current_node
                    paths.append(current_path)
                    continue

                if self.graph.nodes[current_node]["data"].get_label() == "Fork":
                    current_path.append(current_node)
                    out_belongs_to_edges = [edge for edge in self.graph.out_edges(current_node) if
                                            self.graph.edges[edge]["type"] == EdgeType.BELONGS_TO]
                    for _, related_join_node in out_belongs_to_edges:
                        join_out_seq_edges = [edge for edge in self.graph.out_edges(related_join_node) if
                                              self.graph.edges[edge]["type"] == EdgeType.SEQUENTIAL]
                        for _, successor in join_out_seq_edges:
                            path_queue.append((copy.deepcopy(current_path), successor))
                else:
                    # current_node is a regular node type (not FORK)

                    out_seq_edges = [edge for edge in self.graph.out_edges(current_node) if
                                     self.graph.edges[edge]["type"] == EdgeType.SEQUENTIAL and edge[0] != edge[1]]
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
            # create contains edges from fork node to contained behavior storage nodes
            for path in paths:
                for elem in path:
                    if type(self.graph.nodes[elem]["data"]) == TaskGraphNode:
                        self.graph.nodes[elem]["data"].covered_by_fork_node = True

    def add_fork_and_join_around_behavior_storage_nodes(self):
        """add fork and join nodes around behavior storage nodes which are not already covered by a fork section"""
        buffer = copy.deepcopy(self.graph.nodes)
        for node in buffer:
            if type(self.graph.nodes[node]["data"]) == TaskGraphNode:
                # skip root node
                if node == 0:
                    continue
                if not self.graph.nodes[node]["data"].covered_by_fork_node:
                    in_seq_edges = [edge for edge in self.graph.in_edges(node) if
                                    self.graph.edges[edge]["type"] == EdgeType.SEQUENTIAL]
                    out_seq_edges = [edge for edge in self.graph.out_edges(node) if
                                    self.graph.edges[edge]["type"] == EdgeType.SEQUENTIAL]
                    in_contains_edges = [edge for edge in self.graph.in_edges(node) if
                                    self.graph.edges[edge]["type"] == EdgeType.CONTAINS]
                    # add fork node prior to node
                    fork_node_id = self.__add_fork_node()
                    for source, _ in in_seq_edges:
                        self.graph.remove_edge(source, node)
                        self.graph.add_edge(source, fork_node_id, type=EdgeType.SEQUENTIAL)
                    self.graph.add_edge(fork_node_id, node, type=EdgeType.SEQUENTIAL)

                    # let fork be contained in parents of node
                    for source, _, in in_contains_edges:
                        self.graph.add_edge(source, fork_node_id, type=EdgeType.CONTAINS)


                    # add join node after node
                    join_node_id = self.__add_join_node()
                    for _, target in out_seq_edges:
                        self.graph.remove_edge(node, target)
                        self.graph.add_edge(join_node_id, target, type=EdgeType.SEQUENTIAL)
                    self.graph.add_edge(node, join_node_id, type=EdgeType.SEQUENTIAL)

                    # add belongs_to edge between fork and join node
                    self.graph.add_edge(fork_node_id, join_node_id, type=EdgeType.BELONGS_TO)

    def remove_edges_between_fork_and_join(self):
        to_be_removed = []
        for edge in self.graph.edges:
            source, target = edge
            if type(self.graph.nodes[source]["data"]) == ForkNode:
                if type(self.graph.nodes[target]["data"]) == JoinNode:
                    to_be_removed.append(edge)
        for s, t in to_be_removed:
            self.graph.remove_edge(s, t)
