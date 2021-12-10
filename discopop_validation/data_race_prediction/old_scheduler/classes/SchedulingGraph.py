from typing import Tuple, List

from discopop_validation.data_race_prediction.old_scheduler.classes.ScheduleElement import ScheduleElement
import networkx as nx  # type:ignore
import matplotlib.pyplot as plt  # type:ignore

from networkx.drawing.nx_agraph import graphviz_layout  # type:ignore


class SchedulingGraph(object):
    graph: nx.DiGraph
    root_node_identifier: Tuple[Tuple, int]
    def __init__(self, dim: List[int], schedule_element_combinations: List[List[ScheduleElement]]):
        self.graph = nx.DiGraph()
        # add root node, id = (tuple of n zero´s, last executed thread id)
        self.root_node_identifier = (tuple(0 for _ in range(len(dim))), -1)
        self.graph.add_node((tuple(0 for _ in range(len(dim))), -1), data=None)
        self.__add_nodes_rec((tuple(0 for _ in range(len(dim))), -1), dim.copy(), schedule_element_combinations)

    def plot_graph(self):
        plt.subplot(121)
        pos = nx.fruchterman_reingold_layout(self.graph)
        nx.draw(self.graph, pos, with_labels=False, arrows=True, font_weight='bold')
        labels = {}
        for node in self.graph.nodes:
            labels[node] = str(node) + "\n" + str(self.graph.nodes[node]["data"])
        nx.draw_networkx_labels(self.graph, pos, labels)
        plt.show()

    def __add_nodes_rec(self, parent_node_identifier, dim, schedule_element_combinations: List[List[ScheduleElement]]):
        for i in range(len(dim)):
            if dim[i] <= 0:
                continue
            parent_node_id, parent_last_thread_id = parent_node_identifier
            dim_copy = dim.copy()
            dim_copy[i] -= 1
            # add new node if not already contained in graph
            new_node_id = list(parent_node_id)
            new_node_id[i] += 1
            new_node_id_tuple = tuple(new_node_id)
            # check for root node
            if self.graph.nodes[parent_node_identifier]["data"] is None:
                # root node
                last_thread_id = -1
            else:
                # not root node
                last_thread_id = self.graph.nodes[parent_node_identifier]["data"].thread_id
            new_node_identifier = (new_node_id_tuple, last_thread_id)
            if new_node_identifier not in self.graph.nodes:
                self.graph.add_node(new_node_identifier, data=schedule_element_combinations[i][new_node_id_tuple[i]-1])
            # add from parent_node_id to new_node_id
            if not (parent_node_identifier, new_node_identifier) in self.graph.edges:
                self.graph.add_edge(parent_node_identifier, new_node_identifier)
            # start recursion
            self.__add_nodes_rec(new_node_identifier, dim_copy, schedule_element_combinations)

