from typing import List, Optional

import networkx as nx  # type:ignore
import matplotlib.pyplot as plt  # type:ignore
from networkx.drawing.nx_agraph import graphviz_layout  # type:ignore

from discopop_validation.classes.OmpPragma import OmpPragma, PragmaType
from discopop_validation.data_race_prediction.task_graph.classes.ConcurrentSimulationNode import ConcurrentSimulationNode
from discopop_validation.data_race_prediction.task_graph.classes.TaskGraphNode import TaskGraphNode


class TaskGraph(object):
    graph: nx.DiGraph
    next_free_node_id: int

    def __init__(self):
        self.graph = nx.DiGraph()
        # add root node, id = (tuple of n zero´s, last executed thread id)
        self.next_free_node_id = 0
        self.graph.add_node(self.__get_new_node_id(), data=TaskGraphNode(0))
        # todo remove
        self.add_generic_child_node([0])

    def __get_new_node_id(self) -> int:
        buffer = self.next_free_node_id
        self.next_free_node_id += 1
        return buffer

    def plot_graph(self):
        plt.subplot(121)
        pos = nx.fruchterman_reingold_layout(self.graph)
        colors = []
        for node in self.graph.nodes:
            colors.append(self.graph.nodes[node]["data"].get_color())
        nx.draw(self.graph, pos, with_labels=False, arrows=True, font_weight='bold', node_color=colors)
        labels = {}
        for node in self.graph.nodes:
            labels[node] = str(node) + "\n" + str(self.graph.nodes[node]["data"].get_label())
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

    def add_pragma(self, pragma_obj: OmpPragma):
        """create a new node in the graph which represents the given pragma"""
        # get dependencies to previous nodes
        depends_on = self.__get_pragma_dependences(pragma_obj)
        # if no dependencies have been identified, insert after newest node in graph (last added)
        if len(depends_on) == 0:
            depends_on = [self.next_free_node_id - 1]
        if pragma_obj.get_type() == PragmaType.PARALLEL_FOR:
            self.__add_parallel_for_pragma(depends_on, pragma_obj)

    def __add_parallel_for_pragma(self, depends_on, pragma_obj: OmpPragma):
        new_node_id = self.__get_new_node_id()
        self.graph.add_node(new_node_id, data=ConcurrentSimulationNode(new_node_id, pragma=pragma_obj))
        for parent_node_id in depends_on:
            self.graph.add_edge(parent_node_id, new_node_id)
        return new_node_id



    def __get_pragma_dependences(self, pragma_obj: OmpPragma):
        """returns a list of node identifiers which are predecessors of pragma_obj to represent dependences"""
        # search for dependency matches in PET Graph
        # todo

        return []

    def compute_results(self):
        # trigger result computation for root node
        self.graph.nodes[0]["data"].compute_result(self)

    def insert_behavior_models(self):
        for node_id in self.graph.nodes:
            print("node_id:", node_id)
            self.graph.nodes[node_id]["data"].insert_behavior_model()