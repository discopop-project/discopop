import copy
import os.path

import matplotlib.pyplot as plt  # type: ignore
import networkx as nx  # type: ignore
from graphviz import Source  # type: ignore
from networkx.drawing.nx_pydot import to_pydot  # type: ignore
from typing import Tuple, List, cast, Optional

from discopop_validation.data_race_prediction.behavior_modeller.classes.Operation import Operation
from discopop_validation.data_race_prediction.parallel_construct_graph.classes.BehaviorModelNode import \
    BehaviorModelNode
from discopop_validation.data_race_prediction.parallel_construct_graph.classes.EdgeType import EdgeType
from discopop_validation.data_race_prediction.parallel_construct_graph.classes.ForkNode import ForkNode
from discopop_validation.data_race_prediction.parallel_construct_graph.classes.JoinNode import JoinNode
from discopop_validation.data_race_prediction.parallel_construct_graph.classes.PCGraph import PCGraph
from discopop_validation.data_race_prediction.parallel_construct_graph.classes.PCGraphNode import PCGraphNode
from discopop_validation.data_race_prediction.parallel_construct_graph.classes.PragmaBarrierNode import \
    PragmaBarrierNode
from discopop_validation.data_race_prediction.parallel_construct_graph.classes.PragmaParallelNode import \
    PragmaParallelNode
from discopop_validation.data_race_prediction.parallel_construct_graph.classes.PragmaTaskwaitNode import \
    PragmaTaskwaitNode
from discopop_validation.memory_access_graph.AccessMetaData import AccessMetaData
from discopop_validation.memory_access_graph.MAGDataRace import MAGDataRace
from discopop_validation.memory_access_graph.PUStack import PUStack
from discopop_validation.memory_access_graph.ParallelUnit import ParallelUnit


class MemoryAccessGraph(object):
    graph: nx.MultiDiGraph
    next_free_parallel_frame_id: int

    def __init__(self, pc_graph: PCGraph):
        self.next_free_parallel_frame_id = 0
        self.graph = nx.MultiDiGraph()
        self.__construct_from_pc_graph(pc_graph)

    def __get_new_parallel_frame_id(self) -> int:
        buffer = self.next_free_parallel_frame_id
        self.next_free_parallel_frame_id += 1
        return buffer

    def plot_graph(self):
        dot_file_path = "/home/lukas/tmp.dot"
        if os.path.exists(dot_file_path):
            os.remove(dot_file_path)

        dot_g = to_pydot(self.graph)
        dot_g.write_dot(dot_file_path)
        s = Source.from_file(dot_file_path)
        s.view()
        os.remove(dot_file_path)

    def __construct_from_pc_graph(self, pc_graph: PCGraph):
        pc_graph_root_node: PCGraphNode = pc_graph.graph.nodes[0]["data"]  # root node of parallel_construct_graph
        # create and initialize pu_stack
        pu_stack = PUStack(self.__get_new_parallel_frame_id(), pc_graph_root_node)
        current_path: List[int] = [0]

        # traverse task graph in a depth-first manner
        # in doing so, traverse outgoing contains edges before sequential edges to analyze the effects of a node in the
        # correct order
        self.__visit_node(pc_graph, pc_graph_root_node, pu_stack, current_path)

        #pc_graph.plot_graph()
        self.plot_graph()

    def __visit_node(self, pc_graph: PCGraph, pc_graph_node: PCGraphNode, pu_stack: PUStack, current_path: List[int]):
        print("Visiting: ", pc_graph_node.node_id, "   PU Stack: ", pu_stack, "   Path: ", current_path)

        # modify the memory access graph according to the current node
        self.__modify_memory_access_graph(pc_graph, pc_graph_node, pu_stack, current_path)

        # visit children following contains edges which have no incoming sequential edges and thus are entry points
        children = pc_graph.get_children_of_node(pc_graph_node, [EdgeType.CONTAINS])
        for child_idx, child in enumerate(children):
            # ignore child if it has an incoming sequential edge
            in_sequential_edges = pc_graph.get_incoming_edges_of_node(child, [EdgeType.SEQUENTIAL])
            if len(in_sequential_edges) == 0:
                self.__visit_node(pc_graph, child, copy.deepcopy(pu_stack), copy.deepcopy(current_path + [child_idx]))

        # increment last digit of current_path
        incremented_path = copy.deepcopy(current_path)
        incremented_path[-1] = incremented_path[-1] + 1

        # visit children following sequential edges
        children = pc_graph.get_children_of_node(pc_graph_node, [EdgeType.SEQUENTIAL])
        for child_idx, child in enumerate(children):
            self.__visit_node(pc_graph, child, copy.deepcopy(pu_stack), copy.deepcopy(incremented_path + [child_idx]))

    def __modify_memory_access_graph(self, pc_graph: PCGraph, pc_graph_node: PCGraphNode, pu_stack: PUStack, current_path: List[int]):
        # check if pu stack needs to be modified
        self.__modify_pu_stack(pc_graph, pc_graph_node, pu_stack)

        # apply modification of the memory access graph according to the current node
        self.__detect_and_include_memory_accesses_to_graph(pc_graph, pc_graph_node, pu_stack, current_path)

    def __detect_and_include_memory_accesses_to_graph(self, pc_graph: PCGraph, raw_pc_graph_node: PCGraphNode,
                                                      pu_stack: PUStack, current_path: List[int]):
        # add memory accesses from BehaviorModelNodes
        if type(raw_pc_graph_node) == BehaviorModelNode:
            bhv_node = cast(BehaviorModelNode, raw_pc_graph_node)
            model = bhv_node.single_behavior_model
            previous_node_id = str(bhv_node.node_id)
            for op_idx, op in enumerate(model.operations):
                operation_path_id = current_path + [op_idx]
                previous_node_id = self.__add_memory_access_to_graph(operation_path_id, op, bhv_node,
                                                                     previous_node_id, pu_stack.peek())

    def __add_memory_access_to_graph(self, operation_path_id: List[int], operation: Operation, bhv_node: BehaviorModelNode,
                                     previous_node_id: str, parallel_unit: ParallelUnit) -> str:
        print("Adding: ", operation_path_id, "\t", operation.mode, "\t", operation.target_name, "\t", parallel_unit)
        if not previous_node_id in self.graph.nodes:
            # add previous node into MemoryAccessGraph (Dummy as source of the edge)
            self.graph.add_node(previous_node_id)

        if not operation.target_name in self.graph.nodes:
            # add node vor target_name into MemoryAccessGraph
            self.graph.add_node(operation.target_name)

        access_metadata = AccessMetaData(operation, operation.mode, operation_path_id, bhv_node, parallel_unit)

        if operation.mode == "r":
            self.graph.add_edge(previous_node_id, operation.target_name, data=access_metadata, style="dashed",
                                label=access_metadata.get_edge_label(),
                                color=access_metadata.parallel_unit.visualization_color)
        if operation.mode == "w":
            self.graph.add_edge(previous_node_id, operation.target_name, data=access_metadata,
                                label=access_metadata.get_edge_label(),
                                color=access_metadata.parallel_unit.visualization_color)

        return operation.target_name

    def __modify_pu_stack(self, pc_graph: PCGraph, pc_graph_node: PCGraphNode, pu_stack: PUStack):
        # check if new entry has to be created and create a new one if so
        self.__create_new_pu_entry(pc_graph, pc_graph_node, pu_stack)

        # check if last entry needs to be removed and remove it if so
        self.__close_last_pu_entry(pc_graph, pc_graph_node, pu_stack)

    def __create_new_pu_entry(self, pc_graph: PCGraph, pc_graph_node: PCGraphNode, pu_stack: PUStack):
        """"create a new entry if any of the following node types is encountered:
            PARALLEL
            FORK
        """
        if type(pc_graph_node) in [PragmaParallelNode, ForkNode]:
            pu_stack.push(self.__get_new_parallel_frame_id(), pc_graph_node)

    def __close_last_pu_entry(self, pc_graph: PCGraph, pc_graph_node: PCGraphNode, pu_stack: PUStack):
        """closes the last entry in the stack if a node of one of the following types is encountered:
            BARRIER
            JOIN (closes all pu entries up until the one which has been created by the FORK node which belongs to it
        """
        if type(pc_graph_node) == PragmaBarrierNode:
            pu_stack.pop()
        if type(pc_graph_node) == JoinNode:
            incoming_belongs_to_edges = pc_graph.get_incoming_edges_of_node(pc_graph_node, [EdgeType.BELONGS_TO])
            # ignore JOIN without belonging fork
            if len(incoming_belongs_to_edges) > 0:
                sources = [source for (source, target) in incoming_belongs_to_edges]
                while len(pu_stack.contents) > 1:
                    # check if belongs_to edge from origin node of parallel frame to the JOIN node exists
                    pu_origin = pu_stack.peek().origin_pc_graph_node

                    if pu_origin.node_id in sources:
                        # pu_stack entry of related FORK node found. stop iteration
                        pu_stack.pop()
                        print("POP END")
                        break
                    else:
                        # restart search
                        pu_stack.pop()
                        print("POP")


    def __path_predecessor_relation_exists(self, path_1: List[int], path_2: List[int]) -> bool:
        """checks whether a predecessor relation between path_1 and path_2 exists.
        The check considers both orderings.
        Returns True, if a predecessor relation exists.
        Returns False, otherwise."""

        def check_precedence(inner_path_1: List[int], inner_path_2: List[int]) -> bool:
            for idx, elem in enumerate(inner_path_1):
                if idx == len(inner_path_1) -1 :
                    # last element of the list
                    # the last element of the list is the only one which may not be matching -> no check required
                    return True
                else:
                    # regular list element

                    # check if element with index idx exists in inner_path_2.
                    # If not, inner_path_2 is a predecessor of inner_path_1
                    if idx > len(inner_path_2):
                        return True

                    # check if elements at index idx in both lists are equivalent
                    if inner_path_1[idx] != inner_path_2[idx]:
                        return False

        # consider both potential precedence relations
        if check_precedence(path_1, path_2) or check_precedence(path_2, path_1):
            return True
        return False


    def detect_data_races(self, pc_graph: PCGraph):
        """starts the detection of data races for each node of the graph"""
        print("#########")
        print("Detecting data races...")
        print("#########")
        data_races: List[MAGDataRace] = []
        # start data race detection for each node in the graph
        for node in self.graph.nodes:
            print("NODE: ", node)
            # get the set of incoming access edges for node
            incoming_accesses = self.graph.in_edges(node, keys=True)
            # create all possible pairs of incoming edges
            incoming_edge_pairs = ((i, j) for i in incoming_accesses for j in incoming_accesses if i != j)
            # check each pair for present data races
            for edge_1, edge_2 in incoming_edge_pairs:
                data_race_found = self.__data_race_in_edge_pair(edge_1, edge_2, pc_graph)
                if data_race_found:
                    op_1: Operation = self.graph.edges[edge_1]["data"].operation
                    op_2: Operation = self.graph.edges[edge_2]["data"].operation
                    print("\tDATA RACE FOUND!")
                    print("\t\t", op_1)
                    print("\t\t\t", self.graph.edges[edge_1]["data"].operation_path_id)
                    print("\t\t", op_2)
                    print("\t\t\t", self.graph.edges[edge_2]["data"].operation_path_id)
                    print()
                    # todo do anything useful with identified data races
                    data_race_object = MAGDataRace(node, op_1, op_2)
                    data_races.append(data_race_object)
        return data_races


    def __pcgraph_predecessor_relation(self, amd_1: AccessMetaData, amd_2: AccessMetaData, pc_graph: PCGraph):
        """Check if a Taskwait or Barrier is encountered on the path from amd_1.origin_bhv_node
        to amd_2.origin_bhv_node or vice versa.
        Returns True, if a Taskwait or Barrier lies between both origin_bhv_nodes.
        Reutrns False, else
        """
        # check both directions
        result = False
        result = result or pc_graph.is_successor_with_encountered_barrier_or_taskwait(amd_1.origin_bhv_node.node_id,
                                                                                      amd_2.origin_bhv_node.node_id)

        result = result or pc_graph.is_successor_with_encountered_barrier_or_taskwait(amd_2.origin_bhv_node.node_id,
                                                                                      amd_1.origin_bhv_node.node_id)
        return result


    def __data_race_in_edge_pair(self, edge_1: Tuple[str, str, int], edge_2: Tuple[str, str, int], pc_graph: PCGraph):
        """checks the given pair of edges for data races.
        Returns True, if a data race has been found.
        Else, returns False.
        """
        # retrieve AccessMetaData objects of edges
        amd_1: AccessMetaData = self.graph.edges[edge_1]["data"]
        amd_2: AccessMetaData = self.graph.edges[edge_2]["data"]

        # requirement 1: both accesses happen within the same parallel unit
        # todo might require: both accesses happen within nested parallel units
        if amd_1.parallel_unit != amd_2.parallel_unit:
            return False

        # requirement 2: at least of the accesses must be a write
        if (not amd_1.access_mode == "w") and (not amd_2.access_mode == "w"):
            return False

        # requirement 3: edge_1 not a predecessor of edge_2 or vice-versa
        if self.__path_predecessor_relation_exists(amd_1.operation_path_id, amd_2.operation_path_id):
            # predecessor relation exists
            return False

        # requirement 4: check for PCGraph predecessor relations
        if self.__pcgraph_predecessor_relation(amd_1, amd_2, pc_graph):
            print("ASDF")
            return False

        return True

