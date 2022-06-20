import copy
import os.path

import matplotlib.pyplot as plt  # type: ignore
import networkx as nx  # type: ignore
from graphviz import Source  # type: ignore
from networkx.drawing.nx_pydot import to_pydot  # type: ignore
from typing import Tuple

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
from discopop_validation.memory_access_graph.AccessMetaData import AccessMetaData
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
        pu_stack = PUStack()
        print("Current Node: ", pc_graph_root_node.node_id)
        print("PU Stack: ", pu_stack)

        # traverse task graph in a depth-first manner
        # in doing so, traverse outgoing contains edges before sequential edges to analyze the effects of a node in the
        # correct order
        self.__visit_node(pc_graph, pc_graph_root_node, pu_stack)

        #pc_graph.plot_graph()
        self.plot_graph()

    def __visit_node(self, pc_graph: PCGraph, pc_graph_node: PCGraphNode, pu_stack: PUStack):
        print("Visiting: ", pc_graph_node.node_id, "   PU Stack: ", pu_stack)

        # modify the memory access graph according to the current node
        self.__modify_memory_access_graph(pc_graph, pc_graph_node, pu_stack)

        # visit children following contains edges which have no incoming sequential edges and thus are entry points
        children = pc_graph.get_children_of_node(pc_graph_node, [EdgeType.CONTAINS])
        for child in children:
            # ignore child if it has an incoming sequential edge
            in_sequential_edges = pc_graph.get_incoming_edges_of_node(child, [EdgeType.SEQUENTIAL])
            if len(in_sequential_edges) == 0:
                self.__visit_node(pc_graph, child, copy.deepcopy(pu_stack))

        # visit children following sequential edges
        children = pc_graph.get_children_of_node(pc_graph_node, [EdgeType.SEQUENTIAL])
        for child in children:
            self.__visit_node(pc_graph, child, copy.deepcopy(pu_stack))
        print("Leaving: ", pc_graph_node.node_id)

    def __modify_memory_access_graph(self, pc_graph: PCGraph, pc_graph_node: PCGraphNode, pu_stack: PUStack):
        # check if pu stack needs to be modified
        self.__modify_pu_stack(pc_graph, pc_graph_node, pu_stack)

        # apply modification of the memory access graph according to the current node
        self.__detect_and_include_memory_accesses_to_graph(pc_graph, pc_graph_node, pu_stack)

    def __detect_and_include_memory_accesses_to_graph(self, pc_graph: PCGraph, pc_graph_node: PCGraphNode,
                                                      pu_stack: PUStack):
        # add memory accesses from BehaviorModelNodes
        if type(pc_graph_node) == BehaviorModelNode:
            for model_idx, model in enumerate(pc_graph_node.behavior_models):
                print("Thread_Count: ", model.simulation_thread_count)
                for thread_idx in range(0, model.simulation_thread_count):
                    previous_node_id = "" + str(pc_graph_node.node_id) + "-" + str(model_idx) + "-" + str(thread_idx)
                    for op_idx, op in enumerate(model.operations):
                        operation_idx = (pc_graph_node.node_id, model_idx, thread_idx, op_idx)
                        previous_node_id = self.__add_memory_access_to_graph(operation_idx, op.mode, op.target_name,
                                                                             previous_node_id, pu_stack.peek())

    def __add_memory_access_to_graph(self, operation_idx: Tuple[int, int, int, int], access_mode: str, target_name: str,
                                     previous_node_id: str, parallel_unit: ParallelUnit) -> str:
        print("Adding: ", operation_idx, "\t", access_mode, "\t", target_name, "\t", parallel_unit)
        if not previous_node_id in self.graph.nodes:
            # add previous node into MemoryAccessGraph (Dummy as source of the edge)
            self.graph.add_node(previous_node_id)

        if not target_name in self.graph.nodes:
            # add node vor target_name into MemoryAccessGraph
            self.graph.add_node(target_name)

        access_metadata = AccessMetaData(access_mode, operation_idx, parallel_unit)

        if access_mode == "r":
            self.graph.add_edge(previous_node_id, target_name, data=access_metadata, style="dashed",
                                label=access_metadata.get_edge_label(),
                                color=access_metadata.parallel_unit.visualization_color)
        if access_mode == "w":
            self.graph.add_edge(previous_node_id, target_name, data=access_metadata,
                                label=access_metadata.get_edge_label(),
                                color=access_metadata.parallel_unit.visualization_color)

        return target_name

    def __modify_pu_stack(self, pc_graph: PCGraph, pc_graph_node: PCGraphNode, pu_stack: PUStack):
        # check if new entry has to be created and create a new one if so
        self.__create_new_pu_entry(pc_graph, pc_graph_node, pu_stack)

        # check if last entry needs to be removed and remove it if so
        self.__close_last_pu_entry(pc_graph, pc_graph_node, pu_stack)

    def __create_new_pu_entry(self, pc_graph: PCGraph, pc_graph_node: PCGraphNode, pu_stack: PUStack):
        """"create a new entry if any of the following node types is encountered:
            PARALLEL
        """
        if type(pc_graph_node) in [PragmaParallelNode]:
            pu_stack.push(self.__get_new_parallel_frame_id(), pc_graph_node)

    def __close_last_pu_entry(self, pc_graph: PCGraph, pc_graph_node: PCGraphNode, pu_stack: PUStack):
        """closes the last entry in the stack if a node of one of the following types is encountered:
            BARRIER
        """
        if type(pc_graph_node) == PragmaBarrierNode:
            pu_stack.pop()
