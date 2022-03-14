import warnings
import random
import string

from typing import Tuple, List

from discopop_validation.data_race_prediction.behavior_modeller.classes.BehaviorModel import BehaviorModel
from discopop_validation.data_race_prediction.scheduler.classes.ScheduleElement import ScheduleElement
import networkx as nx  # type:ignore
import matplotlib.pyplot as plt  # type:ignore
import copy

from networkx.drawing.nx_agraph import graphviz_layout  # type:ignore


class SchedulingGraph(object):
    graph: nx.DiGraph
    root_node_identifier: Tuple[Tuple, int]
    lock_names: List[str] = []
    var_names: List[str] = []
    dimensions: List[int]
    fingerprint: str
    def __init__(self, dim: List[int], behavior_models: List[BehaviorModel]):
        self.dimensions = dim
        self.fingerprint = ''.join(random.choices(string.ascii_uppercase + string.digits, k=12))
        self.graph = nx.DiGraph()
        # add root node, id = (tuple of n zero´s, last executed thread id)
        self.root_node_identifier = (tuple(0 for _ in range(len(dim))), -1, self.fingerprint)
        self.graph.add_node((tuple(0 for _ in range(len(dim))), -1, self.fingerprint), data=None)
        if len(behavior_models) > 0:
            self.__old_add_nodes_rec((tuple(0 for _ in range(len(dim))), -1, self.fingerprint), dim.copy(), behavior_models)
            # determine lock and var names
            for behavior_model in behavior_models:
                for schedule_element in behavior_model.schedule_elements:
                    self.lock_names += schedule_element.lock_names
                    self.lock_names = list(set(self.lock_names))
                    self.var_names += schedule_element.var_names
                    self.var_names = list(set(self.var_names))

    def plot_graph(self):
        plt.subplot(121)
        pos = nx.fruchterman_reingold_layout(self.graph)
        nx.draw(self.graph, pos, with_labels=False, arrows=True, font_weight='bold')
        labels = {}
        for node in self.graph.nodes:
            labels[node] = str(node) + "\n" + str(self.graph.nodes[node]["data"])
        nx.draw_networkx_labels(self.graph, pos, labels)
        plt.show()


    def __old_add_nodes_rec(self, parent_node_identifier, dim, behavior_models: List[BehaviorModel]):
        for i in range(len(dim)):
            if dim[i] <= 0:
                continue
            parent_node_id, parent_last_thread_id, fingerprint = parent_node_identifier
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
            new_node_identifier = (new_node_id_tuple, last_thread_id, self.fingerprint)
            if new_node_identifier not in self.graph.nodes:
                # update thread id
                self.graph.add_node(new_node_identifier, data=behavior_models[i].schedule_elements[new_node_id_tuple[i] - 1])

            # add edge from parent_node_id to new_node_id
            if not (parent_node_identifier, new_node_identifier) in self.graph.edges:
                self.graph.add_edge(parent_node_identifier, new_node_identifier)
            # start recursion
            self.__old_add_nodes_rec(new_node_identifier, dim_copy, behavior_models)

    def get_leaf_node_identifiers(self):
        leaf_node_identifiers = []
        for node in self.graph.nodes:
            if len(self.graph.out_edges(node)) == 0:
                leaf_node_identifiers.append(node)
        return leaf_node_identifiers

    def get_root_node_identifier(self):
        return self.root_node_identifier


    def sequential_compose(self, other_graph):
        """add edges between leaf nodes of this and root node of other_graph."""
        if other_graph is None:
            return self
        # new dimensions are the component-wise maximum of both
        new_dimensions = []
        while len(self.dimensions) > 0 and len(other_graph.dimensions) > 0:
            new_dimensions.append(max(self.dimensions.pop(0), other_graph.dimensions.pop(0)))
        if len(self.dimensions) > 0:
            new_dimensions += self.dimensions
        elif len(other_graph.dimensions) > 0:
            new_dimensions += other_graph.dimensions
        self.dimensions = new_dimensions

        leaf_node_ids_buffer = self.get_leaf_node_identifiers()
        self.graph.add_nodes_from(other_graph.graph.nodes(data=True))
        self.graph.add_edges_from(other_graph.graph.edges(data=True))
        for leaf_node_id in leaf_node_ids_buffer:
            self.graph.add_edge(leaf_node_id, other_graph.get_root_node_identifier())

        self.lock_names += [ln for ln in other_graph.lock_names if ln not in self.lock_names]
        self.var_names += [vn for vn in other_graph.var_names if vn not in self.var_names]

        # fix node ids
        node_ids = copy.deepcopy(self.graph.nodes)
        for counter, node_id in enumerate(node_ids):
            in_edges = list(self.graph.in_edges(node_id))
            if len(in_edges) == 0:
                preceding_thread_id = -1
            else:
                preceding_schedule_element = self.graph.nodes[in_edges[0][0]]["data"]
                if preceding_schedule_element is None:
                    preceding_thread_id = -1
                else:
                    preceding_thread_id = preceding_schedule_element.thread_id
            mapping = {node_id : (counter, preceding_thread_id, node_id[2])}
            if node_id == self.root_node_identifier:
                self.root_node_identifier = mapping[node_id]
            self.graph = nx.relabel_nodes(self.graph, mapping, copy=False)

        return self


    def parallel_compose(self, other_graph):
        if other_graph is None:
            return self
        new_dimensions = self.dimensions + other_graph.dimensions
        self.dimensions = new_dimensions

        # set thread ids # TODO NICER
        warnings.warn("THREAD IDS NEED TO BE SET AUTOMATICALLY TO SUPPORT NESTING! TODO")
        for node in self.graph.nodes:
            schedule_element = self.graph.nodes[node]["data"]
            if schedule_element is None:
                continue
            schedule_element.thread_id = 1
            self.graph.nodes[node]["data"] = schedule_element

        for node in other_graph.graph.nodes:
            schedule_element = other_graph.graph.nodes[node]["data"]
            if schedule_element is None:
                continue
            schedule_element.thread_id = 0
            other_graph.graph.nodes[node]["data"] = schedule_element

        composed_graph = SchedulingGraph(new_dimensions, [])
        # add end node

        def construct_composed_graph(composed_graph_node_id, node_id_1, node_id_2, rec_depth=0):
            # node_id_1 -> self
            # node_id_2 -> other_graph

            # step on 1. graph
            # create copy of node_id_1 in composed_graph

            # construct new node number
            depth_1, depth_2 = composed_graph_node_id[0]

            # update depth value
            if type(depth_1) == int:
                depth_1 = tuple([depth_1])
            #updated_depth_1 = tuple(map(lambda x, y: x if x > y else y, depth_1, node_id_1[0]))
            updated_depth_1 = tuple(map(lambda x, y: x + y , depth_1, [1]))

            #modified_node_id_1 = ((updated_depth_1, depth_2), composed_graph_node_id[1], composed_graph_node_id[2])
            modified_node_id_1 = ((updated_depth_1, depth_2), node_id_1[1], composed_graph_node_id[2])
            # modified_node_id_1 = (node_id_1, rec_depth, 1)
            if modified_node_id_1 not in composed_graph.graph.nodes:
                composed_graph.graph.add_node(modified_node_id_1, data=self.graph.nodes[node_id_1]["data"])
            # connect composed_graph_node with newly created node
            if (composed_graph_node_id, modified_node_id_1) not in composed_graph.graph.edges:
                composed_graph.graph.add_edge(composed_graph_node_id, modified_node_id_1)
            # enter recursion
            for child_edge_source, child_edge_target in self.graph.out_edges(node_id_1):
                construct_composed_graph(modified_node_id_1, child_edge_target, node_id_2, rec_depth=rec_depth+1)


            # step on 2. graph
            # update depth value
            if type(depth_2) == int:
                depth_2 = tuple([depth_2])
            #updated_depth_2 = tuple(map(lambda x, y: x if x > y else y, depth_2, node_id_2[0]))
            updated_depth_2 = tuple(map(lambda x, y: x + y, depth_2, [1]))

            #modified_node_id_2 = ((depth_1, updated_depth_2), composed_graph_node_id[1], composed_graph_node_id[2])
            modified_node_id_2 = ((depth_1, updated_depth_2), node_id_2[1], composed_graph_node_id[2])
            # create copy of node_id_2 in composed_graph
            # modified_node_id_2 = (node_id_2, rec_depth, 2)
            if modified_node_id_2 not in composed_graph.graph.nodes:
                composed_graph.graph.add_node(modified_node_id_2, data=other_graph.graph.nodes[node_id_2]["data"])
            # connect composed_graph_node with newly created node
            if (composed_graph_node_id, modified_node_id_2) not in composed_graph.graph.edges:
                composed_graph.graph.add_edge(composed_graph_node_id, modified_node_id_2)
            # enter recursion
            for child_edge_source, child_edge_target in other_graph.graph.out_edges(node_id_2):
                construct_composed_graph(modified_node_id_2, node_id_1, child_edge_target, rec_depth=rec_depth+1)

        construct_composed_graph(composed_graph.get_root_node_identifier(), self.get_root_node_identifier(), other_graph.get_root_node_identifier())
#        composed_graph.plot_graph()


        print("PARALLEL COMPOSE")
        warnings.warn("TODO")
        return composed_graph
        #import sys
        #sys.exit(0)