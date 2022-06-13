import os.path

import matplotlib.pyplot as plt  # type: ignore
import networkx as nx  # type: ignore
from graphviz import Source  # type: ignore
from networkx.drawing.nx_pydot import to_pydot  # type: ignore
from typing import List

from discopop_validation.data_race_prediction.task_graph.classes.EdgeType import EdgeType
from discopop_validation.data_race_prediction.task_graph.classes.ForkNode import ForkNode
from discopop_validation.data_race_prediction.task_graph.classes.JoinNode import JoinNode
from discopop_validation.data_race_prediction.task_graph.classes.PragmaBarrierNode import PragmaBarrierNode
from discopop_validation.data_race_prediction.task_graph.classes.PragmaParallelNode import PragmaParallelNode
from discopop_validation.data_race_prediction.task_graph.classes.TaskGraph import TaskGraph
from discopop_validation.data_race_prediction.task_graph.classes.TaskGraphNode import TaskGraphNode
from discopop_validation.memory_access_graph.PUStack import PUStack


class MemoryAccessGraph(object):
    graph: nx.MultiDiGraph
    next_free_parallel_frame_id: int

    def __init__(self, task_graph: TaskGraph):
        self.next_free_parallel_frame_id = 0
        self.graph = nx.MultiDiGraph()
        self.__construct_from_task_graph(task_graph)

    def __get_new_parallel_frame_id(self) -> int:
        buffer = self.next_free_parallel_frame_id
        self.next_free_parallel_frame_id += 1
        return buffer

    def plot_graph(self):
        dot_file_path = "/home/lukas/tmp.dot"
        if os.path.exists(dot_file_path):
            os.remove(dot_file_path)

        dot_g = to_pydot(self.graph)
        print(dot_g)
        dot_g.write_dot(dot_file_path)
        s = Source.from_file(dot_file_path)
        s.view()
        os.remove(dot_file_path)

    def __construct_from_task_graph(self, task_graph: TaskGraph):
        task_graph_root_node: TaskGraphNode = task_graph.graph.nodes[0]["data"]  # root node of task_graph
        pu_stack = PUStack()
        print("Current Node: ", task_graph_root_node.node_id)
        print("PU Stack: ", pu_stack)

        # traverse task graph in a depth-first manner
        # in doing so, traverse outgoing contains edges before sequential edges to analyze the effects of a node in the
        # correct order
        self.__visit_node(task_graph, task_graph_root_node, pu_stack)

        task_graph.plot_graph()
        # self.plot_graph()

    def __visit_node(self, task_graph: TaskGraph, task_graph_node: TaskGraphNode, pu_stack: PUStack):
        print("Visiting: ", task_graph_node.node_id, "   PU Stack: ", pu_stack)

        # modify the memory access graph according to the current node
        self.__modify_memory_access_graph(task_graph, task_graph_node, pu_stack)

        # visit children following contains edges which have no incoming sequential edges and thus are entry points
        children = task_graph.get_children_of_node(task_graph_node, [EdgeType.CONTAINS])
        for child in children:
            # ignore child if it has an incoming sequential edge
            in_sequential_edges = task_graph.get_incoming_edges_of_node(child, [EdgeType.SEQUENTIAL])
            if len(in_sequential_edges) == 0:
                self.__visit_node(task_graph, child, pu_stack)

        # visit children following sequential edges
        children = task_graph.get_children_of_node(task_graph_node, [EdgeType.SEQUENTIAL])
        for child in children:
            self.__visit_node(task_graph, child, pu_stack)
        print("Leaving: ", task_graph_node.node_id)


    def __modify_memory_access_graph(self, task_graph: TaskGraph, task_graph_node: TaskGraphNode, pu_stack: PUStack):
        # check if pu stack needs to be modified
        self.__modify_pu_stack(task_graph, task_graph_node, pu_stack)

        # apply modification of the memory access graph according to the current node
        #TODO
        pass

    def __modify_pu_stack(self, task_graph: TaskGraph, task_graph_node: TaskGraphNode, pu_stack: PUStack):
        # check if new entry has to be created and create a new one if so
        self.__create_new_pu_entry(task_graph, task_graph_node, pu_stack)

        # check if last entry needs to be removed and remove it if so
        self.__close_last_pu_entry(task_graph, task_graph_node, pu_stack)

    def __create_new_pu_entry(self, task_graph: TaskGraph, task_graph_node: TaskGraphNode, pu_stack: PUStack):
        """"create a new entry if any of the following node types is encountered:
            PARALLEL
            FORK
        """
        if type(task_graph_node) in [PragmaParallelNode, ForkNode]:
            pu_stack.push(self.__get_new_parallel_frame_id(), task_graph_node)

    def __close_last_pu_entry(self, task_graph: TaskGraph, task_graph_node: TaskGraphNode, pu_stack: PUStack):
        """closes the last entry in the stack if a node of one of the following types is encountered:
            BARRIER
            JOIN (if incoming belongs_to edge from origin node of the current parallel frame exists)
        """
        if type(task_graph_node) == PragmaBarrierNode:
            pu_stack.pop()
        if type(task_graph_node) == JoinNode:
            # check if belongs_to edge from origin node of parallel frame to the JOIN node exists
            pu_origin = pu_stack.peek().origin_task_graph_node
            incoming_belongs_to_edges = task_graph.get_incoming_edges_of_node(task_graph_node, [EdgeType.BELONGS_TO])
            sources = [source for (source, target) in incoming_belongs_to_edges]
            if pu_origin.node_id in sources:
                pu_stack.pop()
