import copy
import random
import string
import warnings

import matplotlib.pyplot as plt  # type:ignore
import networkx as nx  # type:ignore
from networkx.drawing.nx_agraph import graphviz_layout  # type:ignore
from typing import List, Dict, Tuple, Optional, cast

from discopop_explorer import PETGraphX
from discopop_explorer.PETGraphX import EdgeType as PETEdgeType, NodeType
from discopop_validation.classes.Configuration import Configuration
from discopop_validation.classes.OmpPragma import OmpPragma, PragmaType
from discopop_validation.data_race_prediction.behavior_modeller.classes.BehaviorModel import BehaviorModel
from discopop_validation.data_race_prediction.behavior_modeller.classes.OperationModifierType import \
    OperationModifierType
from discopop_validation.data_race_prediction.parallel_construct_graph.classes.BehaviorModelNode import \
    BehaviorModelNode
from discopop_validation.data_race_prediction.parallel_construct_graph.classes.FunctionNode import FunctionNode
from discopop_validation.data_race_prediction.parallel_construct_graph.classes.EdgeType import EdgeType
from discopop_validation.data_race_prediction.parallel_construct_graph.classes.ForkNode import ForkNode
from discopop_validation.data_race_prediction.parallel_construct_graph.classes.JoinNode import JoinNode
from discopop_validation.data_race_prediction.parallel_construct_graph.classes.PragmaBarrierNode import PragmaBarrierNode
from discopop_validation.data_race_prediction.parallel_construct_graph.classes.PragmaCriticalNode import \
    PragmaCriticalNode
from discopop_validation.data_race_prediction.parallel_construct_graph.classes.PragmaFlushNode import PragmaFlushNode
from discopop_validation.data_race_prediction.parallel_construct_graph.classes.PragmaForNode import PragmaForNode
from discopop_validation.data_race_prediction.parallel_construct_graph.classes.PragmaParallelNode import PragmaParallelNode
from discopop_validation.data_race_prediction.parallel_construct_graph.classes.PragmaSingleNode import PragmaSingleNode
from discopop_validation.data_race_prediction.parallel_construct_graph.classes.PragmaTaskNode import PragmaTaskNode
from discopop_validation.data_race_prediction.parallel_construct_graph.classes.PragmaTaskloopNode import \
    PragmaTaskloopNode
from discopop_validation.data_race_prediction.parallel_construct_graph.classes.PragmaTaskwaitNode import PragmaTaskwaitNode
from discopop_validation.data_race_prediction.parallel_construct_graph.classes.PragmaThreadprivateNode import \
    PragmaThreadprivateNode
from discopop_validation.data_race_prediction.parallel_construct_graph.classes.ResultObject import ResultObject
from discopop_validation.data_race_prediction.parallel_construct_graph.classes.PCGraphNode import PCGraphNode
from discopop_validation.data_race_prediction.parallel_construct_graph.utils.NodeSpecificComputations import \
    get_sequence_entry_points, \
    get_contained_exit_points
from discopop_validation.data_race_prediction.utils import get_pet_node_id_from_source_code_lines
from discopop_validation.interfaces.discopop_explorer import check_reachability, get_called_functions


class PCGraph(object):
    graph: nx.MultiDiGraph
    next_free_node_id: int
    pragma_to_node_id: Dict[OmpPragma, int]

    def __init__(self):
        self.graph = nx.DiGraph()
        # add root node, id = (tuple of n zero´s, last executed thread id)
        self.next_free_node_id = 0
        self.pragma_to_node_id = dict()
        self.graph.add_node(self.get_new_node_id(), data=PCGraphNode(0))

    def get_new_node_id(self) -> int:
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
                          EdgeType.CALLS_RECURSIVE: "blue",
                          EdgeType.BELONGS_TO: "yellow"}
        edge_colors = [edge_color_map[self.graph[source][dest]['type']] for source, dest in self.graph.edges]
        nx.draw(self.graph, pos, with_labels=False, arrows=True, font_weight='bold', node_color=colors,
                edge_color=edge_colors)
        labels = {}
        for node in self.graph.nodes:
            labels[node] = str(self.graph.nodes[node]["data"].get_label())
        nx.draw_networkx_labels(self.graph, pos, labels)
        plt.show()

    def get_children_of_node(self, node: PCGraphNode, edge_types: List[EdgeType]) -> List[PCGraphNode]:
        out_edges = [edge for edge in self.graph.out_edges(node.node_id) if
                    self.graph.edges[edge]["type"] in edge_types]
        children = [self.get_node_from_id(target) for source, target in out_edges]
        return children

    def get_node_from_id(self, node_id) -> PCGraphNode:
        return self.graph.nodes[node_id]["data"]

    def get_incoming_edges_of_node(self, node: PCGraphNode, edge_types: List[EdgeType]) -> List[Tuple[int, int]]:
        in_edges = [edge for edge in self.graph.in_edges(node.node_id) if self.graph.edges[edge]["type"] in edge_types]
        return in_edges

    def add_generic_child_node(self, parent_node_id_list: List[int], pragma=None) -> int:
        """adds a new node to the graph with incoming edges from each node specified in parent_node_id_list and
        returns the node_id of the newly created node."""
        new_node_id = self.get_new_node_id()
        self.graph.add_node(new_node_id, data=PCGraphNode(new_node_id))
        for parent_node_id in parent_node_id_list:
            self.graph.add_edge(parent_node_id, new_node_id)
        return new_node_id

    def add_pragma_node(self, pragma_obj: OmpPragma) -> int:
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
        elif pragma_obj.get_type() == PragmaType.TASKLOOP:
            node_id = self.__add_taskloop_pragma(pragma_obj)
        elif pragma_obj.get_type() == PragmaType.BARRIER:
            node_id = self.__add_barrier_pragma(pragma_obj)
        elif pragma_obj.get_type() == PragmaType.CRITICAL:
            node_id = self.__add_critical_pragma(pragma_obj)
        elif pragma_obj.get_type() == PragmaType.FLUSH:
            warnings.warn("CURRENTLY IGNORED PRAGMA: Flush")
            node_id = self.__add_flush_pragma(pragma_obj)
        elif pragma_obj.get_type() == PragmaType.THREADPRIVATE:
            node_id = self.__add_threadprivate_pragma(pragma_obj)
        else:
            raise ValueError("No Supported Pragma for: ", pragma_obj.pragma)
        # create entry in dictionary
        self.pragma_to_node_id[pragma_obj] = node_id
        return node_id

    def __add_threadprivate_pragma(self, pragma_obj: OmpPragma):
        new_node_id = self.get_new_node_id()
        self.graph.add_node(new_node_id, data=PragmaThreadprivateNode(new_node_id, pragma=pragma_obj))
        return new_node_id

    def __add_critical_pragma(self, pragma_obj: OmpPragma):
        new_node_id = self.get_new_node_id()
        self.graph.add_node(new_node_id, data=PragmaCriticalNode(new_node_id, pragma=pragma_obj))
        return new_node_id

    def __add_flush_pragma(self, pragma_obj: OmpPragma):
        new_node_id = self.get_new_node_id()
        self.graph.add_node(new_node_id, data=PragmaFlushNode(new_node_id, pragma=pragma_obj))
        return new_node_id

    def __add_single_pragma(self, pragma_obj: OmpPragma):
        new_node_id = self.get_new_node_id()
        self.graph.add_node(new_node_id, data=PragmaSingleNode(new_node_id, pragma=pragma_obj))
        return new_node_id

    def __add_for_pragma(self, pragma_obj: OmpPragma):
        new_node_id = self.get_new_node_id()
        self.graph.add_node(new_node_id, data=PragmaForNode(new_node_id, pragma=pragma_obj))
        return new_node_id

    def __add_parallel_pragma(self, pragma_obj: OmpPragma):
        new_node_id = self.get_new_node_id()
        self.graph.add_node(new_node_id, data=PragmaParallelNode(new_node_id, pragma=pragma_obj))
        return new_node_id

    def __add_task_pragma(self, pragma_obj: OmpPragma):
        new_node_id = self.get_new_node_id()
        self.graph.add_node(new_node_id, data=PragmaTaskNode(new_node_id, pragma=pragma_obj))
        return new_node_id

    def __add_taskloop_pragma(self, pragma_obj: OmpPragma):
        new_node_id = self.get_new_node_id()
        self.graph.add_node(new_node_id, data=PragmaTaskloopNode(new_node_id, pragma=pragma_obj))
        return new_node_id

    def __add_taskwait_pragma(self, pragma_obj: OmpPragma):
        new_node_id = self.get_new_node_id()
        self.graph.add_node(new_node_id, data=PragmaTaskwaitNode(new_node_id, pragma=pragma_obj))
        return new_node_id

    def __add_barrier_pragma(self, pragma_obj):
        new_node_id = self.get_new_node_id()
        self.graph.add_node(new_node_id, data=PragmaBarrierNode(new_node_id, pragma=pragma_obj))
        return new_node_id

    def __add_fork_node(self):
        new_node_id = self.get_new_node_id()
        self.graph.add_node(new_node_id, data=ForkNode(new_node_id))
        return new_node_id

    def __add_join_node(self):
        new_node_id = self.get_new_node_id()
        self.graph.add_node(new_node_id, data=JoinNode(new_node_id))
        return new_node_id

    def insert_function_nodes(self, pet: PETGraphX):
        for node in pet.all_nodes():
            if node.type == NodeType.FUNC:
                new_node_id = self.get_new_node_id()
                pet_cu_id = node.id
                function_name = node.name
                function_file_id = node.file_id
                function_start_line = node.start_line
                function_end_line = node.end_line

                self.graph.add_node(new_node_id, data=FunctionNode(new_node_id, pet_cu_id, name=function_name,
                                                                   file_id=function_file_id,
                                                                   start_line=function_start_line,
                                                                   end_line=function_end_line))
                print("Inserted Function -", function_name, "- with CUID -", pet_cu_id, "- at NodeId -", new_node_id, "-")

    def remove_bhv_nodes_if_not_contained_in_parallel_pragma(self):
        pragma_parallel_nodes: List[PCGraphNode] = []
        for node in self.graph.nodes:
            node_obj = self.graph.nodes[node]["data"]
            if type(node_obj) == PragmaParallelNode:
                pragma_parallel_nodes.append(node)

        to_be_removed = []
        for node in self.graph.nodes:
            if node == 0:  # do not remove ROOT-node
                continue
            node_obj = self.graph.nodes[node]["data"]
            if type(node_obj) == PCGraphNode:
                # check if node is reachable from any PragmaParallelNode
                is_reachable = False
                for pp_node in pragma_parallel_nodes:
                    if self.check_reachability(pp_node, node, EdgeType.CONTAINS, []):
                        is_reachable = True
                if not is_reachable:
                    to_be_removed.append(node)
        for node in to_be_removed:
            in_seq_edges = [edge for edge in self.graph.in_edges(node) if
                            self.graph.edges[edge]["type"] == EdgeType.SEQUENTIAL]
            out_seq_edges = [edge for edge in self.graph.out_edges(node) if
                            self.graph.edges[edge]["type"] == EdgeType.SEQUENTIAL]
            for source, _ in in_seq_edges:
                for _, target in out_seq_edges:
                    if source != target:
                        self.graph.add_edge(source, target, type=EdgeType.SEQUENTIAL)
            self.graph.remove_node(node)


    def insert_calls_edges(self, pet: PETGraphX, omp_pragmas: List[OmpPragma]):
        # copied from add_edges
        pragma_to_cuid: Dict[OmpPragma, str] = dict()
        for pragma in omp_pragmas:
            cu_id = get_pet_node_id_from_source_code_lines(pet, pragma.file_id, pragma.start_line,
                                                           pragma.end_line)
            pragma_to_cuid[pragma] = cu_id

        for node in self.graph.nodes:
            if type(self.graph.nodes[node]["data"]) == FunctionNode:
                continue
            pragma = self.graph.nodes[node]["data"].pragma
            if pragma is None:
                continue
            cu_id = pragma_to_cuid[pragma]
            # get called functions
            for called_function in get_called_functions(pet, pet.node_at(cu_id)):
                called_cu_id = called_function["cuid"]
                called_file_id = int(called_function["atLine"].split(":")[0])
                called_at_line = int(called_function["atLine"].split(":")[1])
                if called_file_id != pragma.file_id or called_at_line < pragma.start_line or called_at_line > pragma.end_line:
                    continue
                # only consider calls which originated inside a target code section of the current pragma
                target_code_sections = self.graph.nodes[node]["data"].target_code_sections
                is_valid_call = False
                for tcs in target_code_sections:
                    if int(tcs[1]) != called_file_id:
                        continue
                    lines = [int(l) for l in tcs[2].split(",") if len(l) > 0]
                    if called_at_line in lines:
                        is_valid_call = True
                        break
                if not is_valid_call:
                    continue

                # find called function node in pc_graph
                for inner_node in self.graph.nodes:
                    if type(self.graph.nodes[inner_node]["data"]) != FunctionNode:
                        continue
                    if self.graph.nodes[inner_node]["data"].pet_cu_id == called_cu_id:
                        # check if call is recursive (contained edge from inner_node to node exists)
                        if (inner_node, node) in self.graph.edges:
                            # potentially recursive. check edge type
                            if self.graph.edges[(inner_node, node)]["type"] == EdgeType.CONTAINS:
                                # recursive
                                self.graph.add_edge(node, inner_node, type=EdgeType.CALLS_RECURSIVE)
                            else:
                                # not recursive
                                self.graph.add_edge(node, inner_node, type=EdgeType.CALLS)
                        else:
                            # not recursive
                            self.graph.add_edge(node, inner_node, type=EdgeType.CALLS)
        # remove redundant calls edges
        self.remove_redundant_calls_edges()

    def include_uncalled_functions(self):
        for node in copy.deepcopy(self.graph.nodes):
            if type(self.graph.nodes[node]["data"]) == FunctionNode:
                in_calls_edges = [edge for edge in self.graph.in_edges(node) if
                                  self.graph.edges[edge]["type"] == EdgeType.CALLS]
                if len(in_calls_edges) == 0:
                    self.graph.add_edge(0, node, type=EdgeType.SEQUENTIAL)

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
                        new_node_id = self.get_new_node_id()
                        cuid_to_node_id_map[called_cu_id] = new_node_id
                        function_name = pet.node_at(called_cu_id).name
                        function_file_id = pet.node_at(called_cu_id).file_id
                        function_start_line = pet.node_at(called_cu_id).start_line
                        function_end_line = pet.node_at(called_cu_id).end_line

                        self.graph.add_node(new_node_id, data=FunctionNode(new_node_id, name=function_name,
                                                                           file_id=function_file_id,
                                                                           start_line=function_start_line,
                                                                           end_line=function_end_line))
                        self.graph.add_edge(origin_node_id, new_node_id, type=EdgeType.CALLS,
                                            atLine=called_function_dict["atLine"])
                    else:
                        self.graph.add_edge(origin_node_id, cuid_to_node_id_map[called_function_dict["cuid"]],
                                            type=EdgeType.CALLS, atLine=called_function_dict["atLine"])
                # start recursion over all unseen children of root_cu_id

                for child_cu in pet.direct_children(pet.node_at(root_cu_id)):
                    if (origin_node_id, child_cu.id, given_pragma) not in seen_configurations:
                        __include_called_functions(origin_node_id, child_cu.id, given_pragma)

            __include_called_functions(self.pragma_to_node_id[pragma], pragma_to_cuid[pragma], pragma)

    def insert_function_contains_edges(self):
        for node in self.graph.nodes:
            if type(self.graph.nodes[node]["data"]) == FunctionNode:
                for other_node in self.graph.nodes:
                    if node == other_node:
                        continue
                    if self.graph.nodes[other_node]["data"].pragma is None:
                        continue
                    # check if other_node contained in node
                    if self.graph.nodes[node]["data"].file_id != self.graph.nodes[other_node]["data"].pragma.file_id:
                        continue
                    if self.graph.nodes[node]["data"].start_line <= self.graph.nodes[other_node][
                        "data"].pragma.start_line <= self.graph.nodes[node]["data"].end_line and \
                            self.graph.nodes[node]["data"].start_line <= self.graph.nodes[other_node][
                        "data"].pragma.end_line <= self.graph.nodes[node]["data"].end_line:
                        # other_node contained in node
                        # create contains edge between node and other_node
                        self.graph.add_edge(node, other_node, type=EdgeType.CONTAINS)

    def remove_incorrect_function_contains_edges(self):
        for node in self.graph.nodes:
            if type(self.graph.nodes[node]["data"]) == FunctionNode:
                in_calls_edges = [edge for edge in self.graph.in_edges(node) if
                                  self.graph.edges[edge]["type"] == EdgeType.CALLS]
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
                        if current_best_node is None:  #
                            current_best_node = self.graph.nodes[edge_source]
                            current_difference_to_start = int(atLine.split(":")[1]) - self.graph.nodes[edge_source][
                                "data"].pragma.start_line
                            current_difference_to_end = self.graph.nodes[edge_source]["data"].pragma.end_line - int(
                                atLine.split(":")[1])
                        else:
                            # check if edge_source is a better fit than current_best_node
                            difference_to_start = int(atLine.split(":")[1]) - self.graph.nodes[edge_source][
                                "data"].pragma.start_line
                            difference_to_end = self.graph.nodes[edge_source]["data"].pragma.end_line - int(
                                atLine.split(":")[1])

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
                         if pragma.start_line <= other_pragma.start_line and pragma.end_line >= other_pragma.end_line:
                            self.graph.add_edge(self.pragma_to_node_id[pragma], self.pragma_to_node_id[other_pragma], type=EdgeType.CONTAINS)
                        #self.graph.add_edge(self.pragma_to_node_id[pragma], self.pragma_to_node_id[other_pragma],
                        #                    type=EdgeType.CONTAINS)
                    else:
                        # Fallback: check for contained relations based on source code lines
                        if pragma.start_line <= other_pragma.start_line and pragma.end_line >= other_pragma.end_line:
                            self.graph.add_edge(self.pragma_to_node_id[pragma], self.pragma_to_node_id[other_pragma],
                                                type=EdgeType.CONTAINS)

        # todo more efficient edge creation (potentially traverse upwards and find pragmas along each path instead of pairwise calculation)
        # add successor edges
        for pragma in omp_pragmas:
            for other_pragma in omp_pragmas:
                if pragma == other_pragma:
                    continue
                # check if pragma is reachable from other_pragma in pet graph using successor edges
                if check_reachability(pet, pet.node_at(pragma_to_cuid[pragma]),
                                      pet.node_at(pragma_to_cuid[other_pragma]), [PETEdgeType.SUCCESSOR]):
                    # pragma is a successor of other_pragma or based on same CU
                    # check if CUIDs are different
                    # pragma is a successor of other_pragma
                    # this check prevents cycles due to same CU Node
                    if other_pragma.start_line <= pragma.start_line and other_pragma.end_line < pragma.start_line:
                        # only create edge, if both share a common parent
                        if pragma_to_parent_function_dict[pragma] == pragma_to_parent_function_dict[other_pragma]:
                            self.graph.add_edge(self.pragma_to_node_id[other_pragma], self.pragma_to_node_id[pragma],
                                                type=EdgeType.SEQUENTIAL)
                else:
                    # if not, check if both pragmas share a common parent and check if pragma succeeds other_pragma
                    pragma_parents = [source for source, target, data in
                                      pet.in_edges(pragma_to_cuid[pragma], PETEdgeType.CHILD)] + [
                                         pragma_to_cuid[pragma]]
                    # check if other_pragma is a direct child of parent
                    for parent in pragma_parents:
                        if pet.node_at(pragma_to_cuid[other_pragma]) in pet.direct_children(pet.node_at(parent)) + [
                            pet.node_at(parent)]:
                            # pragma and other pragma share a common parent
                            # check if other_pragma is a successor of pragma
                            if other_pragma.start_line <= pragma.start_line and other_pragma.end_line < pragma.start_line:
                                # only create edge, if both share a common parent
                                if pragma_to_parent_function_dict[pragma] == pragma_to_parent_function_dict[
                                    other_pragma]:
                                    self.graph.add_edge(self.pragma_to_node_id[other_pragma],
                                                        self.pragma_to_node_id[pragma], type=EdgeType.SEQUENTIAL)

        # remove all but the shortest outgoing sequential edges
        to_be_removed = []
        for node in self.graph.nodes:
            out_seq_edges = [edge for edge in self.graph.out_edges(node) if
                             self.graph.edges[edge]["type"] == EdgeType.SEQUENTIAL]
            if len(out_seq_edges) == 0:
                continue
            edge_lengths = []
            for source, target in out_seq_edges:
                length = self.graph.nodes[target]["data"].pragma.start_line - self.graph.nodes[source][
                    "data"].pragma.end_line
                edge_lengths.append((source, target, length))
            shortest_edge = min(edge_lengths, key=lambda x: x[2])
            to_be_removed = [(elem[0], elem[1]) for elem in edge_lengths if elem != shortest_edge]
            for source, target in to_be_removed:
                self.graph.remove_edge(source, target)

        # Fallback: add edge from root node to current node if no predecessor exists
#        for node in self.graph.nodes:
#            in_seq_edges = [edge for edge in self.graph.in_edges(node) if
#                             self.graph.edges[edge]["type"] == EdgeType.SEQUENTIAL]
#            if len(in_seq_edges) == 0 and node != 0 and type(self.graph.nodes[node]["data"]) == PragmaParallelNode:
#                self.graph.add_edge(0, node, type=EdgeType.SEQUENTIAL)

        # Add edge from ROOT to main function node
        for node in self.graph.nodes:
            if type(self.graph.nodes[node]["data"]) != FunctionNode:
                continue
            if self.graph.nodes[node]["data"].name == "main":
                self.graph.add_edge(0, node, type=EdgeType.SEQUENTIAL)


    def remove_redundant_contains_edges(self):
        """simplifies the contains relations."""
        for node in self.graph.nodes:
            in_contains_edges = [edge for edge in self.graph.in_edges(node) if self.graph.edges[edge]["type"] == EdgeType.CONTAINS]
            to_be_removed = []
            contains_sources = [source for source, _ in in_contains_edges]
            # check if contains relation between sources exists
            parent_relations = []
            for potential_parent in copy.deepcopy(contains_sources):
                parent_out_contains_edges = [edge for edge in self.graph.out_edges(potential_parent) if self.graph.edges[edge]["type"] == EdgeType.CONTAINS]
                children = [target for _, target in parent_out_contains_edges]
                children = [child for child in children if child in contains_sources]
                for child in children:
                    parent_relations.append((potential_parent, child))
                    if (potential_parent, node) not in to_be_removed:
                        to_be_removed.append((potential_parent, node))
            for source, target in to_be_removed:
                self.graph.remove_edge(source, target)


    def remove_redundant_sequential_edges(self, target_nodes):
        """simplifies the contains relations."""
        for node in target_nodes:
            in_seq_edges = [edge for edge in self.graph.in_edges(node) if self.graph.edges[edge]["type"] == EdgeType.SEQUENTIAL]
            to_be_removed = []
            sequential_sources = [source for source, _ in in_seq_edges]
            # check if sequential relation between sources exists
            parent_relations = []
            for potential_parent in copy.deepcopy(sequential_sources):
                parent_out_seq_edges = [edge for edge in self.graph.out_edges(potential_parent) if self.graph.edges[edge]["type"] == EdgeType.CONTAINS]
                children = [target for _, target in parent_out_seq_edges]
                children = [child for child in children if child in sequential_sources]
                for child in children:
                    parent_relations.append((potential_parent, child))
                    if (potential_parent, node) not in to_be_removed:
                        to_be_removed.append((potential_parent, node))
            for source, target in to_be_removed:
                self.graph.remove_edge(source, target)

    def remove_redundant_calls_edges(self):
        """simplifies the contains relations."""
        for node in self.graph.nodes:
            in_calls_edges = [edge for edge in self.graph.in_edges(node) if
                              self.graph.edges[edge]["type"] == EdgeType.CALLS]
            to_be_removed = []
            call_sources = [source for source, _ in in_calls_edges]
            # check if contains relation between sources exists
            parent_relations = []
            for potential_parent in copy.deepcopy(call_sources):
                parent_out_contains_edges = [edge for edge in self.graph.out_edges(potential_parent) if self.graph.edges[edge]["type"] == EdgeType.CONTAINS]
                children = [target for _, target in parent_out_contains_edges]
                children = [child for child in children if child in call_sources]
                for child in children:
                    parent_relations.append((potential_parent, child))
                    if (potential_parent, node) not in to_be_removed:
                        to_be_removed.append((potential_parent, node))
            for source, target in to_be_removed:
                self.graph.remove_edge(source, target)




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
            if node_pragma.get_type() in [PragmaType.PARALLEL]:  # PragmaType.SINGLE,
                add_barrier_buffer.append(node)

        # create barriers
        for new_barrier_source in add_barrier_buffer:
            barrier_node_id = self.get_new_node_id()
            self.graph.add_node(barrier_node_id, data=PragmaBarrierNode(barrier_node_id,
                                                                        pragma=OmpPragma().init_with_values(
                                                                            self.graph.nodes[new_barrier_source][
                                                                                "data"].pragma.file_id,
                                                                            self.graph.nodes[new_barrier_source][
                                                                                "data"].pragma.end_line,
                                                                            self.graph.nodes[new_barrier_source][
                                                                                "data"].pragma.end_line, "barrier")))
            self.graph.add_edge(new_barrier_source, barrier_node_id, type=EdgeType.SEQUENTIAL)
            # create CONTAINS edge from parent of new_barrier_source if necessarry
            in_contains_edges = [edge for edge in self.graph.in_edges(new_barrier_source) if
                                 self.graph.edges[edge]["type"] == EdgeType.CONTAINS]
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
            current_out_seq_edge_targets = [edge[1] for edge in self.graph.out_edges(current) if
                                            self.graph.edges[edge]["type"] == EdgeType.SEQUENTIAL]
            if len(current_out_seq_edge_targets) == 0:
                return "after", current
            queue += current_out_seq_edge_targets

        pass

    def new_insert_behavior_storage_nodes(self):
        """creates TaskGraphNodes to store Behavior Models in the graph structure, rather than on each node"""
        for node in copy.deepcopy(self.graph.nodes):
            node_obj: PCGraphNode = self.graph.nodes[node]["data"]
            if type(node_obj) is PCGraphNode:
                continue
            for model in node_obj.behavior_models:
                new_node_id = self.get_new_node_id()
                behavior_storage_node = PCGraphNode(new_node_id)
                behavior_storage_node.behavior_models.append(model)
                self.graph.add_node(new_node_id, data=behavior_storage_node)
                self.graph.add_edge(node, new_node_id, type=EdgeType.CONTAINS)



    def insert_behavior_storage_nodes(self):
        """creates TaskGraphNodes to store Behavior Models in the graph structure, rather than on each node"""
        modify_nodes: List[Tuple[str, int, PCGraphNode]] = []
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
                new_node_id = self.get_new_node_id()
                behavior_storage_node = PCGraphNode(new_node_id)
                behavior_storage_node.behavior_models.append(model)
                # set thread count to 1 if parent is PragmaSingleNode
                if type(self.graph.nodes[node]["data"]) == PragmaSingleNode:
                    behavior_storage_node.set_simulation_thread_count(1)

                self.graph.add_node(new_node_id, data=behavior_storage_node)
                bhv_storage_node_to_parent[new_node_id] = node
                # old version:
                self.graph.add_edge(node, new_node_id, type=EdgeType.CONTAINS)
                if region_start is None or region_end is None:
                    continue

                # new node is also contained in parent of node
                # mainly required to allow effects of SINGLE pragmas
                node_in_contained_edges = [edge for edge in self.graph.in_edges(node) if
                                           self.graph.edges[edge]["type"] == EdgeType.CONTAINS]
                for source, _ in node_in_contained_edges:
                    self.graph.add_edge(source, new_node_id, type=EdgeType.CONTAINS)

                # separate treatment of behavior nodes stemming from called functions vs nodes from the original scope
                if model.get_start_line() >= region_start and model.get_end_line() <= region_end:
                    # model is contained in the original pragma region of node

#                    # insert behavior after each path
#                    exit_points = get_contained_exit_points(self, node)
#                    exit_points = [point for point in exit_points if point != new_node_id]
#                    for point in exit_points:
#                        self.graph.add_edge(point, new_node_id, type=EdgeType.SEQUENTIAL)

                    # find insertion points in sequence for behavior_storage_node
                    # select insert position on each path / sequence
                    insert_locations = []
                    for sequence_entry in get_sequence_entry_points(self, node):
                        insert_locations.append(
                            self.__get_insert_location(sequence_entry, model.get_start_line()))
                    # remove duplicated entries, possible in case of multiple merging sequences
                    insert_locations = list(dict.fromkeys(insert_locations))
                    # remove entries which are in relation to the new node itself
                    insert_locations = [(mode, location) for mode, location in insert_locations if
                                        location != new_node_id]

                    # insert edges according to the identified locations
                    for mode, location in insert_locations:
                        if mode == "before":
                            in_seq_edges = [edge for edge in self.graph.in_edges(location) if
                                            self.graph.edges[edge]["type"] == EdgeType.SEQUENTIAL]
                            for source, _ in in_seq_edges:
                                self.graph.remove_edge(source, location)
                                self.graph.add_edge(source, new_node_id, type=EdgeType.SEQUENTIAL)
                            self.graph.add_edge(new_node_id, location, type=EdgeType.SEQUENTIAL)
                        if mode == "after":
                            out_seq_edges = [edge for edge in self.graph.out_edges(location) if
                                             self.graph.edges[edge]["type"] == EdgeType.SEQUENTIAL]
                            for _, target in out_seq_edges:
                                self.graph.remove_edge(location, target)
                                self.graph.add_edge(new_node_id, target)
                            self.graph.add_edge(location, new_node_id, type=EdgeType.SEQUENTIAL)

                    # if no exit points have been found, insert the behavior node right after node
#                    if len(insert_locations) == 0:
#                        out_seq_edges = [edge for edge in self.graph.out_edges(node) if
#                                         self.graph.edges[edge]["type"] == EdgeType.SEQUENTIAL]
#                        for _, target in out_seq_edges:
#                            self.graph.remove_edge(node, target)
#                            self.graph.add_edge(node, new_node_id, type=EdgeType.SEQUENTIAL)
#                            self.graph.add_edge(new_node_id, target, type=EdgeType.SEQUENTIAL)
                else:
                    # model originated from the body of a called function
                    # find optimal positioning for new node based on minimal location differences
                    out_calls_edges = [edge for edge in self.graph.out_edges(node) if
                                       self.graph.edges[edge]["type"] == EdgeType.CALLS]
                    for _, called_function_node_id in out_calls_edges:
                        called_function_node = self.graph.nodes[called_function_node_id]["data"]
                        if model.get_start_line() >= called_function_node.start_line and model.get_end_line() <= called_function_node.end_line:
                            # model stems from within the current function
                            # get a list of all nodes which are contained in this function plus their respective start lines
                            function_out_contained_edges = [edge for edge in
                                                            self.graph.out_edges(called_function_node_id) if
                                                            self.graph.edges[edge]["type"] == EdgeType.CONTAINS]
                            contained_nodes = []
                            for _, contained_node in function_out_contained_edges:
                                if self.graph.nodes[contained_node]["data"].pragma is None:
                                    continue
                                start_line = self.graph.nodes[contained_node]["data"].pragma.start_line
                                contained_nodes.append((contained_node, start_line))
                            # select insert position on each path / sequence
                            insert_locations = []
                            for sequence_entry in get_sequence_entry_points(self, node):
                                insert_locations.append(
                                    self.__get_insert_location(sequence_entry, model.get_start_line()))
                            # remove duplicated entries, possible in case of multiple merging sequences
                            insert_locations = list(dict.fromkeys(insert_locations))
                            # remove entries which are in relation to the new node itself
                            insert_locations = [(mode, location) for mode, location in insert_locations if
                                                location != new_node_id]

                            # insert edges according to the identified locations
                            for mode, location in insert_locations:
                                if mode == "before":
                                    in_seq_edges = [edge for edge in self.graph.in_edges(location) if
                                                    self.graph.edges[edge]["type"] == EdgeType.SEQUENTIAL]
                                    for source, _ in in_seq_edges:
                                        self.graph.remove_edge(source, location)
                                        self.graph.add_edge(source, new_node_id, type=EdgeType.SEQUENTIAL)
                                    self.graph.add_edge(new_node_id, location, type=EdgeType.SEQUENTIAL)
                                if mode == "after":
                                    out_seq_edges = [edge for edge in self.graph.out_edges(location) if
                                                     self.graph.edges[edge]["type"] == EdgeType.SEQUENTIAL]
                                    for _, target in out_seq_edges:
                                        self.graph.remove_edge(location, target)
                                        self.graph.add_edge(new_node_id, target)
                                    self.graph.add_edge(location, new_node_id, type=EdgeType.SEQUENTIAL)



    def add_virtual_sequential_edges(self):
        """replace a sequential edge with a virtual sequential edge, if the target is a Taskwait node."""
        # todo maybe include barrier nodes aswell
        for edge in self.graph.edges:
            if self.graph.edges[edge]["type"] == EdgeType.SEQUENTIAL and type(
                    self.graph.nodes[edge[0]]["data"]) == PragmaTaskNode:
                # check if target is Taskwait node
                target = edge[1]
                target_type = type(self.graph.nodes[target]["data"])
                if target_type in [PragmaTaskwaitNode, PragmaBarrierNode]:
                    # replace edge type
                    self.graph.edges[edge]["type"] = EdgeType.VIRTUAL_SEQUENTIAL
        pass

    def __barr_and_node_share_parent(self, node_id, barr_node_id) -> bool:
        node_in_contains_edges = [edge for edge in self.graph.in_edges(node_id) if
                                  self.graph.edges[edge]["type"] == EdgeType.CONTAINS]
        node_parents = [source for source, _ in node_in_contains_edges]
        barr_in_contains_edges = [edge for edge in self.graph.in_edges(barr_node_id) if
                                  self.graph.edges[edge]["type"] == EdgeType.CONTAINS]
        barr_parents = [source for source, _ in barr_in_contains_edges]
        shared_parents = [parent for parent in node_parents if parent in barr_parents]
        if len(shared_parents) > 0:
            return True
        return False

    def get_closest_successor_barrier_or_taskwait(self, node_id, ignore_depend_clauses=True, ignore_this_node=None):
        queue = [node_id]
        visited = []
        while len(queue) > 0:
            current = queue.pop(0)
            visited.append(current)
            if type(self.graph.nodes[current]["data"]) in [PragmaTaskwaitNode, PragmaBarrierNode] and not current == ignore_this_node:
# outdated
#                # check if found barrier and node share a common parent
#                if not self.__arr_and_node_share_parent(node_id, current):
#                    continue

                if ignore_depend_clauses:
                    return current
                else:
                    # check if found barrier is a valid option due to depend-clauses
                    if self.graph.nodes[current]["data"].pragma is None:
                        return current

                    barr_depend_entries = self.graph.nodes[current]["data"].pragma.get_variables_listed_as("depend")
                    barr_depend_in_entries = [var for mode, var in [entry.split(":") for entry in barr_depend_entries]
                                              if mode == "in"]
                    barr_depend_inout_entries = [var for mode, var in
                                                 [entry.split(":") for entry in barr_depend_entries] if
                                                 mode == "inout"]
                    barr_depend_in_entries += barr_depend_inout_entries
                    barr_depend_in_entries = [var.replace(" ", "") for var in barr_depend_in_entries]
                    if len(barr_depend_in_entries) == 0:
                        return current
                    # check if node_id satisfies in_deps
                    # if pragma of node is None, it can not have any dependences
                    if self.graph.nodes[node_id]["data"].pragma is not None:
                        node_depend_entries = self.graph.nodes[node_id]["data"].pragma.get_variables_listed_as("depend")
                        node_depend_out_entries = [var for mode, var in [entry.split(":") for entry in node_depend_entries]
                                                  if mode == "out"]
                        node_depend_inout_entries = [var for mode, var in
                                                     [entry.split(":") for entry in node_depend_entries] if
                                                     mode == "inout"]
                        node_depend_out_entries += node_depend_inout_entries
                        node_depend_out_entries = [var.replace(" ", "") for var in node_depend_out_entries]
                    else:
                        # no dependences can exist
                        node_depend_out_entries = []
                    if len([var for var in node_depend_out_entries if var in barr_depend_in_entries]) > 0:
                        return current
                    # no dependency between barrier and node, ignore

            # add successors of current to queue
            successors = [edge[1] for edge in self.graph.out_edges(current) if
                          self.graph.edges[edge]["type"] == EdgeType.SEQUENTIAL]
            queue += [s for s in successors if s not in visited and s not in queue]
            # add contained nodes of parent to queue
            parents = [edge[0] for edge in self.graph.in_edges(current) if
                       self.graph.edges[edge]["type"] == EdgeType.CONTAINS]
            for parent in parents:
                parents_children = [edge[1] for edge in self.graph.out_edges(parent) if
                                    self.graph.edges[edge]["type"] == EdgeType.CONTAINS]
                queue += [c for c in parents_children if c not in visited and c not in queue]
            queue += [p for p in parents if p not in visited and p not in queue]
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
                    result = self.get_closest_successor_barrier_or_taskwait(current, ignore_depend_clauses=False)
                if result is not None:
                    return result
                for edge in self.graph.in_edges(current):
                    if self.graph.edges[edge]["type"] == EdgeType.CONTAINS:
                        queue.append(edge[0])

        for node in self.graph.nodes:
            if type(self.graph.nodes[node]["data"]) == PragmaTaskNode:
                # find next BARRIER or TASKWAIT considering depend-clauses.
                next_barrier = self.get_closest_successor_barrier_or_taskwait(node, ignore_depend_clauses=False)
                if next_barrier is None:
                    # no barrier found in successors, search in parent node
                    next_barrier = __get_closest_parent_barrier_or_taskwait(node)
                if next_barrier is None:
                    # still no barrier found, skip
                    continue

                out_seq_edges = [edge for edge in self.graph.out_edges(node) if
                                 self.graph.edges[edge]["type"] == EdgeType.SEQUENTIAL]
                in_seq_edges = [edge for edge in self.graph.in_edges(node) if
                                self.graph.edges[edge]["type"] == EdgeType.SEQUENTIAL]
                # check if dependencies to other tasks exist
                to_be_removed = []
                for s, t in out_seq_edges:
                    if (t, s) in self.graph.edges:
                        if self.graph.edges[(t, s)]["type"] == EdgeType.DEPENDS:
                            to_be_removed.append((s, t))
                out_seq_edges = [e for e in out_seq_edges if e not in to_be_removed]

                to_be_removed = []
                for s, t in in_seq_edges:
                    if (t, s) in self.graph.edges:
                        if self.graph.edges[(t, s)]["type"] == EdgeType.DEPENDS:
                            to_be_removed.append((s, t))
                in_seq_edges = [e for e in in_seq_edges if e not in to_be_removed]

                modification_found = False
                # redirect incoming SEQUENTIAL edges to Successors
                for edge in in_seq_edges:
#                    self.graph.remove_edge(edge[0], edge[1])
                    for out_edge in out_seq_edges:
                        self.graph.add_edge(edge[0], out_edge[1], type=EdgeType.SEQUENTIAL)
                        modification_found = True
                # redirect outgoing SEQUENTIAL edge to barrier
                for edge in out_seq_edges:
                    self.graph.remove_edge(edge[0], edge[1])
                    modification_found = True
                # if no outgoing sequential edge existed, create edge to barrier
                if len(out_seq_edges) == 0:
                    modification_found = True

                if modification_found:
                    self.graph.add_edge(node, next_barrier, type=EdgeType.SEQUENTIAL)

    def remove_single_incoming_join_node(self):
        """Remove a join node with only a single incoming SEQUENTIAL edge, if no path merging occured prior to it"""

        def path_merge_occured_prior(root):
            tmp_in_seq_edges = [edge for edge in self.graph.in_edges(root) if
                                self.graph.edges[edge]["type"] == EdgeType.SEQUENTIAL]
            if len(tmp_in_seq_edges) > 1:
                return True
            if len(tmp_in_seq_edges) == 0:
                return False
            predecessor = tmp_in_seq_edges[0][0]
            return path_merge_occured_prior(predecessor)

        to_be_removed = []
        for node in self.graph.nodes:
            if type(self.graph.nodes[node]["data"]) == JoinNode:
                in_seq_edge = [edge for edge in self.graph.in_edges(node) if
                               self.graph.edges[edge]["type"] == EdgeType.SEQUENTIAL]
                if len(in_seq_edge) < 2 and not path_merge_occured_prior(node):
                    to_be_removed.append(node)
        for node in to_be_removed:
            in_seq_edges = [edge for edge in self.graph.in_edges(node) if
                            self.graph.edges[edge]["type"] == EdgeType.SEQUENTIAL]
            out_seq_edges = [edge for edge in self.graph.out_edges(node) if
                             self.graph.edges[edge]["type"] == EdgeType.SEQUENTIAL]
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

    def make_contained_nodes_part_of_sequence(self, node):
        # every node should have one or 0 entry nodes
        contained_entry_points = get_sequence_entry_points(self, node)
        out_seq_edges = []
        if len(contained_entry_points) == 0:
            pass
        elif len(contained_entry_points) == 1:
            # make contained sequence part of the sequence
            # enter recursion
            last_contained_seq_node = self.make_contained_nodes_part_of_sequence(contained_entry_points[0])
            # add contained sequence to outer sequence of node
            out_seq_edges = [edge for edge in self.graph.out_edges(node) if
                             self.graph.edges[edge]["type"] == EdgeType.SEQUENTIAL]
            for _, target in out_seq_edges:
                self.graph.remove_edge(node, target)
                self.graph.add_edge(node, contained_entry_points[0], type=EdgeType.SEQUENTIAL)
                self.graph.add_edge(last_contained_seq_node, target, type=EdgeType.SEQUENTIAL)
        else:
            raise ValueError("Node should not have more than one entry point! Node:", node, self.plot_graph())

        # start method for successor
        successors = out_seq_edges
        if len(successors) == 0:
            # end of sequence reached
            # return id of last node
            return node
        if len(successors) == 1:
            # start method for successors
            return self.make_contained_nodes_part_of_sequence(successors[0])
        else:
            if type(self.graph.nodes[node]["data"]) == ForkNode:
                # endpoint should be equal for all successors
                endpoints = []
                for succ in successors:
                    endpoints.append(self.make_contained_nodes_part_of_sequence(succ))
                endpoints = list(set(endpoints))
                if len(endpoints) > 1:
                    raise ValueError("More than one endpoint encountered! Node:", node)
                return endpoints[0]
            else:
                raise ValueError("Node should not have more than one successor! Node:", node, " Type: ", type(self.graph.nodes[node]["data"]), self.plot_graph())

    def add_fork_and_join_nodes_at_parallel_pragmas(self):
        node_ids = copy.deepcopy(self.graph.nodes())
        for node in node_ids:
            if type(self.graph.nodes[node]["data"]) == PragmaParallelNode:
                contains_edges = [edge for edge in self.graph.out_edges(node) if
                                  self.graph.edges[edge]["type"] == EdgeType.CONTAINS]
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
            in_seq_edges = [edge for edge in self.graph.in_edges(node) if
                            self.graph.edges[edge]["type"] == EdgeType.SEQUENTIAL]
            if len(in_seq_edges) > 1:
                join_node_id = self.__add_join_node()
                # add SEQUENTIAL edge from join node to node
                self.graph.add_edge(join_node_id, node, type=EdgeType.SEQUENTIAL)
                # redirect incoming sequential edges to join node
                for source, _ in in_seq_edges:
                    self.graph.remove_edge(source, node)
                    self.graph.add_edge(source, join_node_id, type=EdgeType.SEQUENTIAL)

            # if type(self.graph.nodes[node]["data"]) in [PragmaBarrierNode, PragmaTaskwaitNode]:
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

                incoming_seq_edge = [edge for edge in self.graph.in_edges(node) if
                                     self.graph.edges[edge]["type"] == EdgeType.SEQUENTIAL and edge[0] != join_node_id]
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
                # if no sequence entry points exist, connect incoming with outgoing edges
                if len(sequence_exit_points) == 0:
                    # redirect incoming to outgoing sequential edges
                    for source, _ in in_seq_edges:
                        for _, target in out_seq_edges:
                            self.graph.add_edge(source, target, type=EdgeType.SEQUENTIAL)
        for node in remove_nodes:
            self.graph.remove_node(node)

    def apply_pragma_single_nodes(self):
        for node in self.graph.nodes:
            if type(self.graph.nodes[node]["data"]) == PragmaSingleNode:
                # set simulation_thread_count to 1 for each contained node
                out_contains_edges = [edge for edge in self.graph.out_edges(node) if
                                      self.graph.edges[edge]["type"] == EdgeType.CONTAINS]
                for _, target in out_contains_edges:
                    self.graph.nodes[target]["data"].set_simulation_thread_count(1)


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
            if type(self.graph.nodes[node]["data"]) != PCGraphNode:
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
                for _, _, _, operation in data_race.schedule_element.updates:
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
                    for _, _, _, last_access_operation in last_access_schedule_element.updates:
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

    def remove_function_nodes(self):
        to_be_removed = []
        for node in self.graph.nodes:
            if type(self.graph.nodes[node]["data"]) == FunctionNode:
                to_be_removed.append(node)
        for node in to_be_removed:
            self.graph.remove_node(node)

    def is_successor(self, root_node, target_node):
        if root_node == target_node:
            return True
        out_seq_edges = [edge for edge in self.graph.out_edges(root_node) if
                         self.graph.edges[edge]["type"] == EdgeType.SEQUENTIAL]
        result = False
        for _, successor in out_seq_edges:
            result = result or self.is_successor(successor, target_node)
        return result


    def is_successor_with_encountered_barrier_or_taskwait(self, root_node, target_node, visited, encountered_barrier=False):
        visited.append(root_node)
        if type(self.graph.nodes[root_node]["data"]) in [PragmaBarrierNode, PragmaTaskwaitNode]:
            encountered_barrier = True
        if root_node == target_node:
            return True and encountered_barrier
        result = False
        # search in sucessors
        out_seq_edges = [edge for edge in self.graph.out_edges(root_node) if
                         self.graph.edges[edge]["type"] == EdgeType.SEQUENTIAL]
        for _, successor in out_seq_edges:
            if successor in visited:
                continue
            result = result or self.is_successor_with_encountered_barrier_or_taskwait(successor, target_node, visited,
                                                                                      encountered_barrier=encountered_barrier)
        # search in contained nodes
        out_cont_edges = [edge for edge in self.graph.out_edges(root_node) if
                         self.graph.edges[edge]["type"] == EdgeType.CONTAINS]
        for _, contained in out_cont_edges:
            if contained in visited:
                continue
            result = result or self.is_successor_with_encountered_barrier_or_taskwait(contained, target_node, visited,
                                                                                      encountered_barrier=encountered_barrier)
        # extend search to the successors of the parent of root node
        in_contains_edges = [edge for edge in self.graph.in_edges(root_node) if
                             self.graph.edges[edge]["type"] == EdgeType.CONTAINS]
        for parent, _ in in_contains_edges:
            if parent in visited:
                continue
            # since outgoing edges of FORK nodes can not be successors, ignore FORK Nodes
            if type(self.graph.nodes[parent]["data"]) == ForkNode:
                continue
            # ignore successors of barrier or taskwait nodes
            if type(self.graph.nodes[parent]["data"]) in [PragmaTaskwaitNode, PragmaBarrierNode]:
                continue
            # search in successors of parent
            parent_successors = [edge[1] for edge in self.graph.out_edges(parent) if
                                 self.graph.edges[edge]["type"] == EdgeType.SEQUENTIAL]
            # remove root node from successors
            parent_successors = [s for s in parent_successors if s != root_node]
            for p_s in parent_successors:
                if p_s in visited:
                    continue
                result = result or self.is_successor_with_encountered_barrier_or_taskwait(p_s, target_node, visited, encountered_barrier=encountered_barrier)
        return result

    def check_and_fix_dependences_to_barriers(self):
        modification_found = True
        while modification_found:
            modification_found = False
            for node in self.graph.nodes:
                if type(self.graph.nodes[node]["data"]) in [PragmaBarrierNode, PragmaTaskwaitNode]:
                    continue
                # get successor barriers
                succ_barriers = [edge[1] for edge in self.graph.out_edges(node) if
                                 self.graph.edges[edge]["type"] == EdgeType.SEQUENTIAL and
                                 type(self.graph.nodes[edge[1]]["data"]) in [PragmaBarrierNode, PragmaTaskwaitNode]]
                for barr in succ_barriers:
                    if self.graph.nodes[barr]["data"].pragma is None:
                        # requirements trivially satisfied
                        continue
                    barr_depend_entries = self.graph.nodes[barr]["data"].pragma.get_variables_listed_as("depend")
                    barr_depend_in_entries = [var for mode, var in [entry.split(":") for entry in barr_depend_entries]
                                              if mode == "in"]
                    barr_depend_inout_entries = [var for mode, var in
                                                 [entry.split(":") for entry in barr_depend_entries] if
                                                 mode == "inout"]
                    barr_depend_in_entries += barr_depend_inout_entries
                    barr_depend_in_entries = [var.replace(" ", "") for var in barr_depend_in_entries]
                    if len(barr_depend_in_entries) == 0:
                        # nothing to be checked
                        continue
                    # check if node satisfies in-dependencies of barrier
                    if self.graph.nodes[node]["data"].pragma is None:
                        # requirements can not be satisfied
                        missing_deps = ["dummy"]
                    else:
                        node_depend_entries = self.graph.nodes[node]["data"].pragma.get_variables_listed_as("depend")
                        node_depend_out_entries = [var for mode, var in [entry.split(":") for entry in node_depend_entries] if
                                                   mode == "out"]
                        node_depend_inout_entries = [var for mode, var in [entry.split(":") for entry in node_depend_entries] if
                                                     mode == "inout"]
                        node_depend_out_entries += node_depend_inout_entries
                        node_depend_out_entries = [var.replace(" ", "") for var in node_depend_out_entries]
                        missing_deps = [var for var in barr_depend_in_entries if var not in node_depend_out_entries]

                    if len(missing_deps) == 0:
                        # requirements satisfied
                        continue
                    else:
                        # requirements not met. Connect node to next barrier
                        next_barrier = self.get_closest_successor_barrier_or_taskwait(barr, ignore_this_node=barr)
                        self.graph.remove_edge(node, barr)
                        self.graph.add_edge(node, next_barrier, type=EdgeType.SEQUENTIAL)
                        modification_found = True
                        break
                if modification_found:
                    break



    def add_depends_edges(self):
        for node in self.graph.nodes:
            if self.graph.nodes[node]["data"].pragma is None:
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
                if self.graph.nodes[other_node]["data"].pragma is None:
                    continue

                other_node_depend_entries = self.graph.nodes[other_node]["data"].pragma.get_variables_listed_as(
                    "depend")
                if len(other_node_depend_entries) == 0:
                    # no depend entries exist, skip this node
                    continue

                # node and other_node are different and both of type TASK with non-empty depend clauses
                # check if both share a common successive barrier / taskwait
#                if self.get_closest_successor_barrier_or_taskwait(
#                        node) != self.get_closest_successor_barrier_or_taskwait(other_node):
#                    continue
                # node and other_node share a common successive barrier
                # check if depends relation exists from node to other_node
                other_node_depend_in_entries = [var for mode, var in
                                                [entry.split(":") for entry in other_node_depend_entries] if
                                                mode == "in"]
                other_node_depend_out_entries = [var for mode, var in
                                                 [entry.split(":") for entry in other_node_depend_entries] if
                                                 mode == "out"]
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


    def fix_sibling_task_barrier_affiliation(self):
        task_nodes = []
        for node in self.graph.nodes:
            if type(self.graph.nodes[node]["data"]) == PragmaTaskNode:
                task_nodes.append(node)

        for task_1 in task_nodes:
            for task_2 in task_nodes:
                if task_1 == task_2:
                    continue
                # check if node_1 is contained in another task
                if self.check_reachability(task_2, task_1, EdgeType.CONTAINS, []):
                    # task_1 is contained in task_2
                    #
                    # check if task_1 and task_2 share a successor barrier
                    task_1_barr = None
                    task_2_barr = None
                    task_1_belongs_successors = [edge[1] for edge in self.graph.out_edges(task_1) if
                                                 self.graph.edges[edge]["type"] == EdgeType.BELONGS_TO]
                    task_2_belongs_successors = [edge[1] for edge in self.graph.out_edges(task_2) if
                                                 self.graph.edges[edge]["type"] == EdgeType.BELONGS_TO]
                    if len(task_1_belongs_successors) == 1:
                        task_1_barr = task_1_belongs_successors[0]
                    if len(task_2_belongs_successors) == 1:
                        task_2_barr = task_2_belongs_successors[0]
                    if task_1_barr is None:
                        task_1_barr = self.get_closest_successor_barrier_or_taskwait(task_1, ignore_depend_clauses=False)
                    if task_2_barr is None:
                        task_2_barr = self.get_closest_successor_barrier_or_taskwait(task_2, ignore_depend_clauses=False)
                    if task_1_barr != task_2_barr:
                        # nothing to do
                        continue
                    # get next barrier from task_2_barr
                    new_barr = self.get_closest_successor_barrier_or_taskwait(task_2_barr, ignore_depend_clauses=False,
                                                                              ignore_this_node=task_2_barr)
                    if new_barr is not None:
                        # relocate task_1 to next successive barrier
                        if (task_1, task_1_barr) in self.graph.edges:
                            self.graph.remove_edge(task_1, task_1_barr)
                        self.graph.add_edge(task_1, new_barr, type=EdgeType.BELONGS_TO)
                        # delete incoming contains edge of task_1
                        in_contains_edges = [edge for edge in self.graph.in_edges(task_1) if
                                             self.graph.edges[edge]["type"] == EdgeType.CONTAINS]
                        for source, target in in_contains_edges:
                            self.graph.remove_edge(source, target)





    def replace_depends_with_sequential_edges(self):
        add_edge_buffer = []
        for node in self.graph.nodes:
            out_dep_edges = [edge for edge in self.graph.out_edges(node) if
                             self.graph.edges[edge]["type"] == EdgeType.DEPENDS]
            if len(out_dep_edges) == 0:
                continue
            for _, target in out_dep_edges:
                # insert node inbetween target and it's immediate successor (BARRIER or TASKWAIT, which is a successor of node aswell)
                target_out_seq_edges = [edge for edge in self.graph.out_edges(target) if
                                        self.graph.edges[edge]["type"] == EdgeType.SEQUENTIAL]
                for _, tmp_target in target_out_seq_edges:
                    # remove outgoing sequential edges (Edge to successive TASKWAIT or BARRIER
                    self.graph.remove_edge(target, tmp_target)
                # add a SEQUENTIAL edge to node
                # don't add immediately, to prevent removal in next loop iteration
                add_edge_buffer.append((target, node))
                # remove depends edge
                self.graph.remove_edge(node, target)

        add_edge_buffer = list(dict.fromkeys(add_edge_buffer))
        # add TASKWAIT after node to represent the semantics of DEPEND
        taskwait_node = self.__add_taskwait_pragma(None)
        for source, target in add_edge_buffer:
            self.graph.add_edge(source, taskwait_node, type=EdgeType.SEQUENTIAL)
            self.graph.add_edge(taskwait_node, target, type=EdgeType.SEQUENTIAL)

    def remove_sequential_edges_between_tasks(self):
        for node_1 in self.graph.nodes:
            if type(self.graph.nodes[node_1]["data"]) != PragmaTaskNode:
                continue
            out_seq_edges = [edge for edge in self.graph.out_edges(node_1) if
                             self.graph.edges[edge]["type"] == EdgeType.SEQUENTIAL]
            for _, target in out_seq_edges:
                if type(self.graph.nodes[target]["data"]) == PragmaTaskNode:
                    self.graph.remove_edge(node_1, target)

    def add_fork_nodes_between_multiple_entry_points(self):
        for node in copy.deepcopy(self.graph.nodes):
            entry_points = get_sequence_entry_points(self, node)
            if len(entry_points) <= 1:
                continue
            # add fork node inbetween node and entry points
            out_contains_edges = [edge for edge in self.graph.out_edges(node) if
                                  self.graph.edges[edge]["type"] == EdgeType.CONTAINS]
            fork_node_id = self.__add_fork_node()
            for _, target in out_contains_edges:
                self.graph.remove_edge(node, target)
                self.graph.add_edge(fork_node_id, target, type=EdgeType.CONTAINS)
            self.graph.add_edge(node, fork_node_id, type=EdgeType.CONTAINS)


    def add_fork_nodes_at_path_splits(self):
        buffer = copy.deepcopy(self.graph.nodes)
        for node in buffer:
            if type(self.graph.nodes[node]["data"]) == ForkNode:
                # exclude already existing FORK nodes from analysis
                continue
            out_seq_edges = [edge for edge in self.graph.out_edges(node) if
                             self.graph.edges[edge]["type"] == EdgeType.SEQUENTIAL]
            if len(out_seq_edges) < 2:
                # no problem, skip
                continue
            # insert fork node after node
            new_node_id = self.__add_fork_node()
            for _, target in out_seq_edges:
                self.graph.remove_edge(node, target)
                self.graph.add_edge(new_node_id, target, type=EdgeType.SEQUENTIAL)
            self.graph.add_edge(node, new_node_id, type=EdgeType.SEQUENTIAL)

    def mark_barrier_affiliations(self):
        """create belongs_to edges between each node and it's immediate successiv Barrier"""
        for node in self.graph.nodes:
            if type(self.graph.nodes[node]["data"]) in [PragmaBarrierNode, PragmaTaskwaitNode]:
                closest_barrier = self.get_closest_successor_barrier_or_taskwait(node, ignore_depend_clauses=False, ignore_this_node=node)
            else:
                closest_barrier = self.get_closest_successor_barrier_or_taskwait(node, ignore_depend_clauses=False)
            if closest_barrier is not None:
                if node != closest_barrier:
                    self.graph.add_edge(node, closest_barrier, type=EdgeType.BELONGS_TO)

    def insert_fork_nodes(self):
        """traverse graph upwards, starting from barriers without outgoing belongs_to edges and insert fork nodes
        in order to represent the parallel executions made possible by the barriers."""
        # get exit_barriers (barriers without outgoing belongs_to edges)
        exit_barriers: List[PCGraphNode] = []
        for node in self.graph.nodes:
            if type(self.graph.nodes[node]["data"]) not in [PragmaBarrierNode, PragmaTaskwaitNode]:
                continue
            out_belongs_to_edges = [edge for edge in self.graph.out_edges(node) if
                                    self.graph.edges[edge]["type"] == EdgeType.BELONGS_TO]
            if len(out_belongs_to_edges) == 0 or True:
                exit_barriers.append(node)
        for barrier in exit_barriers:
            # create a fork node
            fork_node = self.__add_fork_node()
            raw_belonging_nodes = [edge[0] for edge in self.graph.in_edges(barrier) if
                               self.graph.edges[edge]["type"] == EdgeType.BELONGS_TO]
            self.graph.add_edge(fork_node, barrier, type=EdgeType.BELONGS_TO)
            # get contained nodes for all belonging_nodes
            contained_nodes_dict = self.get_contained_nodes_dict(raw_belonging_nodes)
            # remove nodes from belonging nodes if they are contained in another node
            to_be_removed = []
            for node in raw_belonging_nodes:
                for key in contained_nodes_dict:
                    if node in contained_nodes_dict[key]:
                        to_be_removed.append(node)
            belonging_nodes = copy.deepcopy(raw_belonging_nodes)
            for node in to_be_removed:
                try:
                    belonging_nodes.remove(node)
                except ValueError:
                    pass
            # check if sequential sequence between belonging nodes exists
            reachable: List[Tuple[int, int]] = []
            for node_1 in belonging_nodes:
                for node_2 in belonging_nodes:
                    if node_1 == node_2:
                        continue
                    if self.check_reachability(node_1, node_2, EdgeType.SEQUENTIAL, []):
                        reachable.append((node_1, node_2))
            reached_targets = [pair[1] for pair in reachable]

            # connect fork and belonging nodes
            for node in [n for n in belonging_nodes if n not in reached_targets]:
                self.graph.add_edge(fork_node, node, type=EdgeType.SEQUENTIAL)

            # connect belonging nodes with barrier if node is the end of a sequence
            for node in belonging_nodes:
                out_seq_edges = [edge for edge in self.graph.out_edges(node) if
                                 self.graph.edges[edge]["type"] == EdgeType.SEQUENTIAL]
                if len(out_seq_edges) == 0:
                    self.graph.add_edge(node, barrier, type=EdgeType.SEQUENTIAL)
#            # get barriers from raw_belonging_nodes
            belonging_barriers = [node for node in raw_belonging_nodes if
                                  type(self.graph.nodes[node]["data"]) in [PragmaTaskwaitNode, PragmaBarrierNode]]
#            # connect belonging barriers to fork node
#            for bel_barr in belonging_barriers:
#                if (fork_node, bel_barr) not in self.graph.edges:
#                    self.graph.add_edge(bel_barr, fork_node, type=EdgeType.SEQUENTIAL)

            #self.plot_graph()


    def check_reachability(self, root, target, edge_type, visited) -> bool:
        if root == target:
            return True
        visited.append(root)
        next_roots = [edge[1] for edge in self.graph.out_edges(root) if
                      self.graph.edges[edge]["type"] == edge_type and
                      edge[1] not in visited]
        for next_root in next_roots:
            if self.check_reachability(next_root, target, edge_type, copy.deepcopy(visited)):
                return True
        return False


    def get_contained_nodes_dict(self, target_nodes) -> Dict[int, List[int]]:
        result_dict: Dict[int, List[int]] = dict()
        for key in target_nodes:
            contained_nodes: List[int] = []
            queue: List[int] = [edge[1] for edge in self.graph.out_edges(key) if
                                self.graph.edges[edge]["type"] == EdgeType.CONTAINS]
            visited: List[int] = []
            while len(queue) > 0:
                current = queue.pop(0)
                visited.append(current)
                contained_nodes.append(current)
                queue += [edge[1] for edge in self.graph.out_edges(current) if
                                    self.graph.edges[edge]["type"] == EdgeType.CONTAINS and edge[1] not in visited and
                                    edge[1] not in queue]
            result_dict[key] = contained_nodes
        return result_dict

    def remove_function_nodes(self):
        for node in copy.deepcopy(self.graph.nodes):
            if type(self.graph.nodes[node]["data"]) == FunctionNode:
                self.graph.remove_node(node)

    def prepare_root_for_MAGraph_creation(self):
        """remove edges between ROOT and successors and create edges between ROOT and FORK nodes without incoming edges"""
        out_edges = [edge for edge in self.graph.out_edges(0)]
        for _, target in out_edges:
            self.graph.remove_edge(0, target)
        entry_fork_nodes = [node for node in self.graph.nodes if type(self.graph.nodes[node]["data"]) == ForkNode and
                            len(self.graph.in_edges(node)) == 0]
        for node in entry_fork_nodes:
            self.graph.add_edge(0, node, type=EdgeType.SEQUENTIAL)

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
                    if current_node in current_path:
                        # cycle detected, break
                        continue
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

            # if type(self.graph.nodes[node]["data"]) == JoinNode:
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
            if type(self.graph.nodes[node]["data"]) != PCGraphNode:
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

    def mark_loop_body_operations(self):
        for node in self.graph.nodes():
            node_obj = self.graph.nodes[node]["data"]
            if type(node_obj) == PragmaForNode:
                loop_id = ''.join(random.choices(string.ascii_uppercase + string.digits, k=32))
                for model in node_obj.behavior_models:
                    for op in model.operations:
                        #  modifier_type: OperationModifierType, value_string: str):
                        op.add_modifier(OperationModifierType.LOOP_OPERATION, loop_id)

    def new_replace_pragma_for_nodes(self):
        remove_nodes = []
        for node in copy.deepcopy(self.graph.nodes):
            if type(self.graph.nodes[node]["data"]) == PragmaForNode:
                remove_nodes.append(node)
                # replace node with contained sequences
                in_edges = [edge for edge in self.graph.in_edges(node)]
                out_edges = [edge for edge in self.graph.out_edges(node)]

                # move stored behavior to two separate nodes
                for_node_obj: PCGraphNode = self.graph.nodes[node]["data"]
                pcgn_id_1 = self.get_new_node_id()
                pcgn_id_2 = self.get_new_node_id()
                pcgn_obj_1 = PCGraphNode(pcgn_id_1)
                pcgn_obj_2 = PCGraphNode(pcgn_id_2)
                pcgn_obj_1.behavior_models = copy.deepcopy(for_node_obj.behavior_models)
                pcgn_obj_2.behavior_models = copy.deepcopy(for_node_obj.behavior_models)
                self.graph.add_node(pcgn_id_1, data=pcgn_obj_1)
                self.graph.add_node(pcgn_id_2, data=pcgn_obj_2)

                # connect nodes to incoming / outgoing edges of for node
                for source, target in in_edges:
                    self.graph.add_edge(source, pcgn_id_1, type=self.graph.edges[(source, target)]["type"])
                    self.graph.add_edge(source, pcgn_id_2, type=self.graph.edges[(source, target)]["type"])
                for source, target in out_edges:
                    self.graph.add_edge(pcgn_id_1, target, type=self.graph.edges[(source, target)]["type"])
                    self.graph.add_edge(pcgn_id_2, target, type=self.graph.edges[(source, target)]["type"])

                # remove for node
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
                out_contains_edges = [edge for edge in self.graph.out_edges(node) if
                                      self.graph.edges[edge]["type"] == EdgeType.CONTAINS]
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
            out_sequential_edges = [edge for edge in self.graph.out_edges(node) if
                                    self.graph.edges[edge]["type"] == EdgeType.SEQUENTIAL]

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
                    if type(self.graph.nodes[elem]["data"]) == PCGraphNode:
                        self.graph.nodes[elem]["data"].covered_by_fork_node = True

    def add_fork_and_join_around_behavior_storage_nodes(self):
        """add fork and join nodes around behavior storage nodes which are not already covered by a fork section"""
        buffer = copy.deepcopy(self.graph.nodes)
        for node in buffer:
            if type(self.graph.nodes[node]["data"]) == PCGraphNode:
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


    def replace_PCGraphNodes_with_BehaviorModelNodes(self):
        buffer = copy.deepcopy(self.graph.nodes)
        for node in buffer:
            if type(self.graph.nodes[node]["data"]) == PCGraphNode:
                # skip root node
                if node == 0:
                    continue
                self.graph.nodes[node]["data"].replace_with_BehaviorModelNodes(self)

    def insert_behavior_model_node(self, parent: PCGraphNode, model: BehaviorModel):
        # create BehaviorModelNode
        # model.simulation_thread_count is set to 1 in the course of this method
        bhv_model = BehaviorModelNode(self, parent, copy.deepcopy(model))

        # create node in PCGraph
        self.graph.add_node(bhv_model.node_id, data=bhv_model)

        # connect created node with edges
        in_edges = [edge for edge in self.graph.in_edges(parent.node_id)]
        out_edges = [edge for edge in self.graph.out_edges(parent.node_id)]
        for source, target in in_edges:
            self.graph.add_edge(source, bhv_model.node_id, type=self.graph.edges[(source, target)]["type"])
        for source, target in out_edges:
            self.graph.add_edge(bhv_model.node_id, target, type=self.graph.edges[(source, target)]["type"])


    def apply_and_remove_threadprivate_pragma(self):
        buffer = copy.deepcopy(self.graph.nodes)
        for node in buffer:
            if type(self.graph.nodes[node]["data"]) == PragmaThreadprivateNode:
                # search for nodes with equal parents as node
                in_contains_edges = [edge for edge in self.graph.in_edges(node) if
                                     self.graph.edges[edge]["type"] == EdgeType.CONTAINS]

                tp_variables = self.graph.nodes[node]["data"].pragma.get_variables_listed_as("threadprivate")

                siblings: List[int] = []
                for other_node in [n for n in buffer if (n != node and n != 0)]:  # exclude root node
                    other_node_in_contains_edges = [edge for edge in self.graph.in_edges(other_node) if
                                                    self.graph.edges[edge]["type"] == EdgeType.CONTAINS]
                    if other_node_in_contains_edges == in_contains_edges:
                        siblings.append(other_node)
                for sibling in siblings:
                    # create a pragma string if not already present (for functions nodes etc.)
                    sibling_node: PCGraphNode = self.graph.nodes[sibling]["data"]
                    if sibling_node.pragma is None:
                        sibling_node.pragma = OmpPragma().init_with_values(sibling_node.get_file_id(),
                                                                           sibling_node.get_start_line(),
                                                                           sibling_node.get_end_line(), "dummy")
                    # add threadprivate variables to pragma of sibling
                    for tp_var in tp_variables:
                        # remove tp_var from shared
                        sibling_node.pragma.remove_from_shared(tp_var)
                        # add tp_var to private
                        sibling_node.pragma.add_to_private(tp_var)
                self.graph.remove_node(node)


    def propagate_data_sharing_clauses(self):
        def __propagate_variable(target, var_type, var_name, other_var_types) -> bool:
            print("Prop: ", var_name, var_type)
            target_node: PCGraphNode = self.graph.nodes[target]["data"]
            if target_node.pragma is None:
                return False
            target_vars = target_node.pragma.get_variables_listed_as(var_type, remove_implicit_markings=False)

            mod_found = False

            # check if var_name is implicit
            if "%%implicit" in var_name:
                # if implicit or explicit version of var_name is contained in target_vars, do nothing
                if var_name in target_vars or var_name.replace("%%implicit", "") in target_vars:
                    pass
                else:
                    # add var_name to target_vars
                    target_node.pragma.add_to_variable_type(var_name, var_type)
                    mod_found = True
            else:
                # var_name is explicit
                # if var_name in target_vars, do nothing
                if var_name in target_vars:
                    pass
                # elif implicit version of var_name in target_vars, replace implicit with explicit version
                elif var_name+"%%implicit" in target_vars:
                    target_node.pragma.remove_from_var_type(var_name+"%%implicit", var_type)
                    target_node.pragma.add_to_variable_type(var_name, var_type)
                    mod_found = True
                # else: add var_name to target_vars
                else:
                    target_node.pragma.add_to_variable_type(var_name, var_type)
                    mod_found = True

            # check if other variable types can be overwritten
            # only overwrite, if var_name is explicit and other_var_name is implicit
            if "%%implicit" not in var_name:
                # var_name is explicit
                for other_var_type in other_var_types:
                    target_vars = target_node.pragma.get_variables_listed_as(other_var_type, remove_implicit_markings=False)
                    # if implicit var_name is contained in target_vars, remove the occurrence
                    if var_name+"%%implicit" in target_vars:
                        target_node.pragma.remove_from_var_type(var_name+"%%implicit", other_var_type)

            return mod_found

        modification_found = True
        visited_root_nodes = []
        while modification_found:
            modification_found = False
            for node in self.graph.nodes:
                if node in visited_root_nodes:
                    continue
                visited_root_nodes.append(node)
                node_obj: PCGraphNode = self.graph.nodes[node]["data"]
                if node_obj.pragma is None:
                    continue
                out_contains_edges = [edge for edge in self.graph.out_edges(node) if
                                       self.graph.edges[edge]["type"] == EdgeType.CONTAINS]
                contained_nodes = [edge[1] for edge in out_contains_edges]

                fp = node_obj.pragma.get_variables_listed_as("firstprivate", remove_implicit_markings=False)
                p = node_obj.pragma.get_variables_listed_as("private", remove_implicit_markings=False)
                lp = node_obj.pragma.get_variables_listed_as("lastprivate", remove_implicit_markings=False)
                s = node_obj.pragma.get_variables_listed_as("shared", remove_implicit_markings=False)

                for target in contained_nodes:
                    # propagate firstprivate
                    for var in fp:
                        modification_found = modification_found or __propagate_variable(target, "firstprivate", var,
                                                                                        ["private", "lastprivate",
                                                                                         "shared"])
                    # propagate private
                    for var in p:
                        modification_found = modification_found or __propagate_variable(target, "private", var,
                                                                                        ["firstprivate", "lastprivate", "shared"])
                    # propagate lastprivate
                    for var in lp:
                        modification_found = modification_found or __propagate_variable(target, "lastprivate", var, ["firstprivate", "private", "shared"])
                    # propagate shared
                    for var in s:
                        modification_found = modification_found or __propagate_variable(target, "shared", var, ["firstprivate", "private", "lastprivate"])
                if modification_found:
                    break




    def old_apply_and_remove_threadprivate_pragma(self):
        buffer = copy.deepcopy(self.graph.nodes)
        for node in buffer:
            if type(self.graph.nodes[node]["data"]) == PragmaThreadprivateNode:
                in_seq_edges = [edge for edge in self.graph.in_edges(node) if
                                self.graph.edges[edge]["type"] == EdgeType.SEQUENTIAL]
                out_contained_edges = [edge for edge in self.graph.out_edges(node) if
                                       self.graph.edges[edge]["type"] == EdgeType.CONTAINS]

                tp_variables = self.graph.nodes[node]["data"].pragma.get_variables_listed_as("threadprivate")
                if len(tp_variables) > 0:
                    # add tp_variables to all contained pragmas
                    for _, contained_pragma_node in out_contained_edges:
                        # overwrite shared variables as private if contained in tp_var
                        # reason: unspecified variables are assumed to be shared in a prior processing step (extracting
                        #   from pet graph)
                        for tp_var in tp_variables:
                            # remove tp_var from shared
                            self.graph.nodes[contained_pragma_node]["data"].pragma.remove_from_shared(tp_var)
                            # add tp_var to private
                            self.graph.nodes[contained_pragma_node]["data"].pragma.add_to_private(tp_var)

                # connect predecessor with contained entry node (only contained in threadprivate node)
                for predecessor, _ in in_seq_edges:
                    for _, successor in out_contained_edges:
                        # if successor has only one incoming contained edge, connect it to predecessor
                        successor_in_contained_edges = [edge for edge in self.graph.in_edges(successor) if
                                                        self.graph.edges[edge]["type"] == EdgeType.CONTAINS]
                        if len(successor_in_contained_edges) == 1:
                            self.graph.add_edge(predecessor, successor, type=EdgeType.SEQUENTIAL)
                # remove nodeinsert_parallel_sections_for_called_functions(pet)
                self.graph.remove_node(node)
        pass


    def insert_parallel_sections_for_called_functions(self):
        for source, target in copy.deepcopy(self.graph.edges):
            # only consider CALLS edges
            if self.graph.edges[(source, target)]["type"] != EdgeType.CALLS:
                continue
            # get called function node
            called_function_node: FunctionNode = cast(FunctionNode, self.graph.nodes[target]["data"])
            # add new parallel section node and Single node
            parallel_pragma = OmpPragma()
            parallel_pragma.init_with_values(str(called_function_node.file_id), str(called_function_node.start_line),
                                             str(called_function_node.end_line), "parallel")
            #parallel_node_id = self.__add_parallel_pragma(parallel_pragma)
            parallel_node_id = self.add_pragma_node(parallel_pragma)
            single_pragma = OmpPragma()
            single_pragma.init_with_values(str(called_function_node.file_id), str(called_function_node.start_line),
                                            str(called_function_node.end_line), "single")
            single_node_id = self.add_pragma_node(single_pragma)
            #single_node_id = self.__add_single_pragma(single_pragma)


            # connect body of called function to single pragma
            out_contains_edge = [edge for edge in self.graph.out_edges(target) if
                                 self.graph.edges[edge]["type"] == EdgeType.CONTAINS]
            for _, body_node in out_contains_edge:
                self.graph.add_edge(single_node_id, body_node, type=EdgeType.CONTAINS)
            # add contains edge between original calling node and newly created parallel section
            self.graph.add_edge(source, parallel_node_id, type=EdgeType.CONTAINS)
            # add contains edge between newly created parallel section and single node
            self.graph.add_edge(parallel_node_id, single_node_id, type=EdgeType.CONTAINS)
            # add shared variables of contained nodes to single node
            single_out_contains_edges = [edge for edge in self.graph.out_edges(single_node_id) if
                                         self.graph.edges[edge]["type"] == EdgeType.CONTAINS]
            for _, target in single_out_contains_edges:
                target_pragma = self.graph.nodes[target]["data"].pragma
                if target_pragma is None:
                    continue
                shared_vars = target_pragma.get_variables_listed_as("shared")
                for var in shared_vars:
                    if var not in single_pragma.get_known_variables():
                        single_pragma.add_to_shared(var)

    def create_sequence_for_contained_nodes(self):
        for node in self.graph.nodes:
            out_contained_edges = [edge for edge in self.graph.out_edges(node) if
                                   self.graph.edges[edge]["type"] == EdgeType.CONTAINS]
            contained_nodes = [target for _, target in out_contained_edges]
            successor_relations = dict()
            for node_1 in contained_nodes:
                for node_2 in contained_nodes:
                    if node_1 == node_2:
                        continue
                    graph_node_1: PCGraphNode = self.graph.nodes[node_1]["data"]
                    graph_node_2: PCGraphNode = self.graph.nodes[node_2]["data"]
                    if graph_node_1.get_start_line() >= graph_node_2.get_end_line():
                        if node_2 in successor_relations:
                            successor_relations[node_2].append(node_1)
                        else:
                            successor_relations[node_2] = [node_1]
            # remove unnecessary (transitive) relations
            for key in successor_relations:
                transitive_successors = []
                for successor in successor_relations[key]:
                    if successor not in successor_relations:
                        continue
                    transitive_successors += [t_suc for t_suc in successor_relations[successor] if t_suc not in transitive_successors]
                # remove transitive successors from successor_relations
                for t_suc in transitive_successors:
                    if t_suc in successor_relations[key]:
                        successor_relations[key].remove(t_suc)
            # add sequential edges for successor relations
            for key in successor_relations:
                for succ in successor_relations[key]:
                    # create edge if inverse edge does not exist already (in case of equal scopes)
                    if (succ, key) not in self.graph.edges:
                        self.graph.add_edge(key, succ, type=EdgeType.SEQUENTIAL)

    def new_create_sequence_for_contained_nodes(self):
        for node in self.graph.nodes:
            out_contained_edges = [edge for edge in self.graph.out_edges(node) if
                                   self.graph.edges[edge]["type"] == EdgeType.CONTAINS]
            contained_nodes = [target for _, target in out_contained_edges]
            entry_points = get_sequence_entry_points(self, node)
            # get ranges of contained sequences
            sequence_ranges = [(entry, self.__get_sequence_range(entry)) for entry in entry_points]
            for tuple_1 in sequence_ranges:
                for tuple_2 in sequence_ranges:
                    if tuple_1 == tuple_2:
                        continue
                    # check if tuple_1 is a predecessor of tuple_2
                    if tuple_1[1][1] <= tuple_2[1][0]:
                        # tuple_1 is a predecessor of tuple_2
                        self.graph.add_edge(tuple_1[0], tuple_2[0], type=EdgeType.SEQUENTIAL)

                    # ignore overlaps

    def insert_pcg_nodes_inbetween_pragmas(self):
        for node in copy.deepcopy(self.graph.nodes):
            if node == 0:  # skip root node
                continue
            node_obj: PCGraphNode = self.graph.nodes[node]["data"]
            contained_nodes = [edge[1] for edge in self.graph.out_edges(node) if
                               self.graph.edges[edge]["type"] == EdgeType.CONTAINS]

            # determine "holes" in line coverage
            # determine shared variables of contained nodes
            coverage_holes = list(range(self.graph.nodes[node]["data"].get_start_line(),
                                        self.graph.nodes[node]["data"].get_end_line() + 1))
            shared_vars = []
            for contained in contained_nodes:
                contained_obj = self.graph.nodes[contained]["data"]
                covered_lines = range(contained_obj.get_start_line(),
                                        contained_obj.get_end_line() + 1)
                coverage_holes = [hole for hole in coverage_holes if hole not in covered_lines]
                if contained_obj.pragma is not None:
                    shared_vars += [var for var in contained_obj.pragma.get_variables_listed_as("shared")
                                    if var not in shared_vars]
            # check if coverage holes are filled by the pragma of the current node
            if node_obj.pragma is not None:
                covered_lines = range(node_obj.get_start_line(),
                                        node_obj.get_end_line() + 1)
                coverage_holes = [hole for hole in coverage_holes if hole not in covered_lines]
            # combine holes to uncovered regions
            uncovered_regions: List[int, int] = []  # [(start_line, end_line)]
            last_line = None
            start_line = None
            # write all but the last uncovered region
            while len(coverage_holes) > 0:
                current = coverage_holes.pop(0)
                if start_line is None:
                    start_line = current
                    last_line = current
                    continue
                # check if region is continued
                if current == last_line + 1:
                    # region is continued
                    last_line = current
                    continue
                else:
                    # region is not continued
                    uncovered_regions.append((start_line, last_line))
                    start_line = current
                    last_line = current
            # write last uncovered region
            if start_line is not None:
                uncovered_regions.append((start_line, last_line))

            # create PCGraphNodes for uncovered regions and store target code sections
            for start_line, end_line in uncovered_regions:
                new_node_id = self.get_new_node_id()
                new_pcgraph_node = PCGraphNode(new_node_id)
                target_lines = ",".join([str(line) for line in range(start_line, end_line + 1)])
                if not target_lines.endswith(","):
                    target_lines += ","
                target_vars = ",".join(shared_vars)
                if not target_vars.endswith(","):
                    target_vars += ","
                target_code_section = ('0', str(node_obj.get_file_id()), target_lines, target_vars, 'BHV')
                new_pcgraph_node.target_code_sections.append(target_code_section)
                # fill fields of the newly created node
                # add node to graph and create contains edge between 'node' and the new PCGraphNode
                self.graph.add_node(new_node_id, data=new_pcgraph_node)
                self.graph.add_edge(node, new_node_id, type=EdgeType.CONTAINS)


    def remove_empty_pcgraph_nodes(self):
        to_be_removed = []
        for node in self.graph.nodes:
            if node == 0:  # skip ROOT node
                continue
            node_obj: PCGraphNode = self.graph.nodes[node]["data"]
            if type(node_obj) == PCGraphNode:
                if len(node_obj.behavior_models) == 0:
                    to_be_removed.append(node)
        for node in to_be_removed:
            in_seq_edges = [edge for edge in self.graph.in_edges(node) if
                            self.graph.edges[edge]["type"] == EdgeType.SEQUENTIAL]
            out_seq_edges = [edge for edge in self.graph.out_edges(node) if
                            self.graph.edges[edge]["type"] == EdgeType.SEQUENTIAL]
            # connect all predecessors with all successors
            for predecessor, _ in in_seq_edges:
                for _, successor in out_seq_edges:
                    self.graph.add_edge(predecessor, successor, type=EdgeType.SEQUENTIAL)
            self.graph.remove_node(node)


    def draw_sequence_edges_for_contained_nodes(self):
        for node in self.graph.nodes:
            node_obj: PCGraphNode = self.graph.nodes[node]["data"]
            # get the list of contained nodes
            contained_nodes = [edge[1] for edge in self.graph.out_edges(node) if
                               self.graph.edges[edge]["type"] == EdgeType.CONTAINS]
            # get the ranges for each contained node
            ranges = []
            for contained in contained_nodes:
                contained_obj = self.graph.nodes[contained]["data"]
                ranges.append((contained, contained_obj.get_start_line(), contained_obj.get_end_line()))
            for entry_1 in ranges:
                for entry_2 in ranges:
                    if entry_1 == entry_2:
                        continue
                    # check if entry_2 is a direct successor of entry_1
                    if entry_1[2] + 1 == entry_2[1]:
                        # direct successors
                        self.graph.add_edge(entry_1[0], entry_2[0], type=EdgeType.SEQUENTIAL)
                        self.graph.nodes[entry_1[0]]["data"].added_to_sequence = True
                        self.graph.nodes[entry_2[0]]["data"].added_to_sequence = True

    def draw_sequence_edges_for_contained_nodes_2(self):
        for node in self.graph.nodes:
            node_obj: PCGraphNode = self.graph.nodes[node]["data"]
            # get the list of contained nodes
            contained_nodes_without_sequence = [edge[1] for edge in self.graph.out_edges(node) if
                               self.graph.edges[edge]["type"] == EdgeType.CONTAINS and \
                                                self.graph.nodes[edge[1]]["data"].added_to_sequence == False]
            for node_1 in contained_nodes_without_sequence:
                for node_2 in contained_nodes_without_sequence:
                    if node_1 == node_2:
                        continue
                    # check if node_1 is a predecessor of node_2
                    if self.graph.nodes[node_1]["data"].get_end_line() < self.graph.nodes[node_2]["data"].get_start_line():
                        # node_1 is a predecessor of node_2
                        self.graph.add_edge(node_1, node_2, type=EdgeType.SEQUENTIAL)



    def draw_node_contains_edges(self):
        for node in self.graph.nodes:
            node_obj = self.graph.nodes[node]["data"]
            # get the list of contained nodes
            contained_nodes = [edge[1] for edge in self.graph.out_edges(node) if
                               self.graph.edges[edge]["type"] == EdgeType.CONTAINS]
            # pairwise check contained relation
            for node_1 in contained_nodes:
                for node_2 in contained_nodes:
                    if node_1 == node_2:
                        continue
                    node_1_obj = self.graph.nodes[node_1]["data"]
                    node_2_obj = self.graph.nodes[node_2]["data"]
                    # check if node_2 is contained in node_1
                    if node_1_obj.get_start_line() <= node_2_obj.get_start_line() and \
                        node_1_obj.get_end_line() >= node_2_obj.get_end_line():
                        # node_2 contained in node_1
                        self.graph.add_edge(node_1, node_2, type=EdgeType.CONTAINS)
        # remove redundant contains edges
#        self.remove_redundant_contains_edges()


    def __get_sequence_range(self, entry_point) -> Tuple[int, int]:
        queue = [entry_point]
        visited = []
        start = self.graph.nodes[entry_point]["data"].get_start_line()
        if start == -1:  # -1 is used in case no line number could be determined
            start = self.graph.nodes[entry_point]["data"].get_end_line()
        end = self.graph.nodes[entry_point]["data"].get_end_line()
        while len(queue) > 0:
            current = queue.pop()
            visited.append(current)
            node_obj = self.graph.nodes[current]["data"]
            if node_obj.get_start_line() < start and node_obj.get_start_line() != -1:  # -1 is used in case no line number could be determined
                start = node_obj.get_start_line()
            if node_obj.get_end_line() > end:
                end = node_obj.get_end_line()
            out_seq_edges = [edge for edge in self.graph.out_edges(current) if
                             self.graph.edges[edge]["type"] == EdgeType.SEQUENTIAL]
            queue += [target for _, target in out_seq_edges if target not in visited]
        return start, end


    def combined_out_sequential_edges_into_single_sequence(self):
        modification_found = True
        while modification_found:
            modification_found = False
            for node in self.graph.nodes:
                out_seq_edges = [edge for edge in self.graph.out_edges(node) if
                                 self.graph.edges[edge]["type"] == EdgeType.SEQUENTIAL]
                if len(out_seq_edges) <= 1:
                    continue
                successors_and_start_lines = [self.graph.nodes[target]["data"] for _, target in out_seq_edges]
                successors_and_start_lines = [(node, node.get_start_line()) for node in successors_and_start_lines]
                sorted_successors = sorted(successors_and_start_lines, key=lambda x: x[1])
                sorted_successors = [succ[0] for succ in sorted_successors]  # remove start line

                for succ in sorted_successors:
                    self.graph.remove_edge(node, succ.node_id)
                self.graph.add_edge(node, sorted_successors[0].node_id, type=EdgeType.SEQUENTIAL)
                for idx in range(0, len(sorted_successors) - 1):
                    self.graph.add_edge(sorted_successors[idx].node_id, sorted_successors[idx+1].node_id, type=EdgeType.SEQUENTIAL)


    def restore_sequence_order(self):
        modification_found = True
        while modification_found:
            modification_found = False
            for node in copy.deepcopy(self.graph.nodes):
                # check if node has exactly one predecessor
                predecessors = [edge[0] for edge in self.graph.in_edges(node) if
                                self.graph.edges[edge]["type"] == EdgeType.SEQUENTIAL]
                if len(predecessors) != 1:
                    continue

                node_obj: PCGraphNode = self.graph.nodes[node]["data"]
                predecessor_obj: PCGraphNode = self.graph.nodes[predecessors[0]]["data"]

                node_start_line = node_obj.get_start_line()
                node_end_line = node_obj.get_end_line()
                node_file_id = node_obj.get_file_id()
                pred_start_line = predecessor_obj.get_start_line()
                pred_end_line = predecessor_obj.get_end_line()
                pred_file_id = predecessor_obj.get_file_id()

                if node_file_id != pred_file_id:
                    continue
                # if location of node is after location of predecessor, do nothing
                if node_start_line >= pred_end_line:
                    continue
                elif node_end_line <= pred_start_line:
                    # switch positions
                    # else, switch positions
                    node_out_edges = [edge for edge in self.graph.out_edges(node)]
                    pred_in_edges = [edge for edge in self.graph.in_edges(predecessors[0])]

                    for source, target in pred_in_edges:
                        self.graph.add_edge(source, node, type=self.graph.edges[(source, target)]["type"])
                    for source, target in node_out_edges:
                        self.graph.add_edge(predecessors[0], target, type=self.graph.edges[(source, target)]["type"])

                    for source, target in pred_in_edges:
                        self.graph.remove_edge(source, target)
                    for source, target in node_out_edges:
                        self.graph.remove_edge(source, target)

                    self.graph.remove_edge(predecessors[0], node)
                    self.graph.add_edge(node, predecessors[0], type=EdgeType.SEQUENTIAL)

                    modification_found = True
                    break
                else:
                    # do nothing
                    continue
