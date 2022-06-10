import warnings
import random
import string

from typing import Tuple, List, Any

from discopop_validation.data_race_prediction.behavior_modeller.classes.BehaviorModel import BehaviorModel
from discopop_validation.data_race_prediction.scheduler.classes.ScheduleElement import ScheduleElement
import networkx as nx  # type:ignore
import matplotlib.pyplot as plt  # type:ignore
import copy

from networkx.drawing.nx_agraph import graphviz_layout  # type:ignore


class SchedulingGraph(object):
    graph: nx.DiGraph
    root_node_identifier: Tuple[Any, int, str]
    lock_names: List[str] = []
    var_names: List[str] = []
    dimensions: List[int]
    thread_count : int
    thread_ids: List[int]
    fingerprint: str
    def __init__(self, dim: List[int], behavior_models: List[BehaviorModel]):
        self.dimensions = dim
        self.thread_count = len(dim)
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
                    self.lock_names = list(dict.fromkeys(self.lock_names))
                    self.var_names += schedule_element.var_names
                    self.var_names = list(dict.fromkeys(self.var_names))
        # get contained thread id's
        self.thread_ids = []
        self.__update_contained_thread_ids()


    def __update_contained_thread_ids(self):
        for node_in in self.graph.nodes:
            schedule_element = self.graph.nodes[node_in]["data"]
            if schedule_element is not None:
                if schedule_element.thread_id not in self.thread_ids:
                    self.thread_ids.append(schedule_element.thread_id)


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
        # remove Emtpy nodes from both graphs
        self.remove_none_nodes()
        other_graph.remove_none_nodes()
        # remove useless, cyclic edges if present
        self.__remove_edges_from_to_source_node()
        other_graph.__remove_edges_from_to_source_node()

        # new dimensions are the component-wise maximum of both
        new_dimensions = []
        while len(self.dimensions) > 0 and len(other_graph.dimensions) > 0:
            new_dimensions.append(max(self.dimensions.pop(0), other_graph.dimensions.pop(0)))
        if len(self.dimensions) > 0:
            new_dimensions += self.dimensions
        elif len(other_graph.dimensions) > 0:
            new_dimensions += other_graph.dimensions
        self.dimensions = new_dimensions

        self.thread_count = max(self.thread_count, other_graph.thread_count)

        leaf_node_ids_buffer = self.get_leaf_node_identifiers()
        self.graph.add_nodes_from(other_graph.graph.nodes(data=True))
        self.graph.add_edges_from(other_graph.graph.edges(data=True))
        for leaf_node_id in leaf_node_ids_buffer:
            self.graph.add_edge(leaf_node_id, other_graph.get_root_node_identifier())

        self.lock_names += [ln for ln in other_graph.lock_names if ln not in self.lock_names]
        self.var_names += [vn for vn in other_graph.var_names if vn not in self.var_names]

        self.fix_node_ids()

        self.__update_contained_thread_ids()

        return self


    def parallel_compose(self, other_graph):
        if other_graph is None:
            return self
        # remove Emtpy nodes from both graphs
        self.remove_none_nodes()
        other_graph.remove_none_nodes()
        # remove useless, cyclic edges if present
        self.__remove_edges_from_to_source_node()
        other_graph.__remove_edges_from_to_source_node()


        new_dimensions = self.dimensions + other_graph.dimensions
        self.dimensions = new_dimensions
        thread_id_offset = self.thread_count # added to other_graphs thread ids to prevent conflicts


        # set correct thread id's
        # thread id's of self remain in current state
        # thread id's of other_graph are modified using thread_id_offset
        node_ids = copy.deepcopy(other_graph.graph.nodes)
        for node in node_ids:
            schedule_element = other_graph.graph.nodes[node]["data"]
            if schedule_element is None:
                continue
            schedule_element.thread_id = schedule_element.thread_id + thread_id_offset
            other_graph.graph.nodes[node]["data"] = schedule_element
            if node[1] == -1:
                previous_thread_id = -1
            else:
                previous_thread_id = node[1] + thread_id_offset
            mapping = {node : (node[0], previous_thread_id, node[2])}
            other_graph.graph = nx.relabel_nodes(other_graph.graph, mapping, copy=False)

        # create composed graph
        composed_graph = SchedulingGraph(new_dimensions, [])
        composed_graph.thread_count = self.thread_count + other_graph.thread_count

        def __construct_composed_graph(target_graph, first_graph, second_graph, first_graph_node, second_graph_node, previous_node_id, previous_thread_id, visited, first_graph_last_step=False, second_graph_last_step=False):
            if (first_graph_node, second_graph_node, previous_node_id) in visited:
                raise ValueError("ENDLESS RECURSION POSSIBLE! Already visited")
            visited.append((first_graph_node, second_graph_node, previous_node_id))
            if not first_graph_last_step:
                # step on first graph
                # construct new node id
                new_node_id = ((first_graph_node[0], second_graph_node[0]), previous_thread_id, first_graph_node[2])
                # create ScheduleElement in target_graph
                target_graph.graph.add_node(new_node_id, data=first_graph.graph.nodes[first_graph_node]["data"])
                # connect previous node with newly created node
                target_graph.graph.add_edge(previous_node_id, new_node_id)
                # enter recursion
                if len(first_graph.graph.out_edges(first_graph_node)) > 0:
                    for source, target in first_graph.graph.out_edges(first_graph_node):
                        if first_graph.graph.nodes[first_graph_node]["data"] is None:
                            tmp_previous_thread_id = -1
                        else:
                            tmp_previous_thread_id = first_graph.graph.nodes[first_graph_node]["data"].thread_id
                        if (target, second_graph_node, new_node_id) not in visited:
                            __construct_composed_graph(target_graph, first_graph, second_graph,
                                                       target, second_graph_node,
                                                       new_node_id, tmp_previous_thread_id, copy.deepcopy(visited), first_graph_last_step=first_graph_last_step, second_graph_last_step=second_graph_last_step)
                else:
                    if first_graph.graph.nodes[first_graph_node]["data"] is None:
                        tmp_previous_thread_id = -1
                    else:
                        tmp_previous_thread_id = first_graph.graph.nodes[first_graph_node]["data"].thread_id
                    if (first_graph_node, second_graph_node, new_node_id) not in visited:
                        __construct_composed_graph(target_graph, first_graph, second_graph,
                                                   first_graph_node, second_graph_node,
                                                   new_node_id, tmp_previous_thread_id, copy.deepcopy(visited), first_graph_last_step=True, second_graph_last_step=second_graph_last_step)


            if not second_graph_last_step:
                # step on second graph
                # construct new node id
                new_node_id = ((first_graph_node[0], second_graph_node[0]), previous_thread_id, second_graph_node[2])
                # create ScheduleElement in target_graph
                target_graph.graph.add_node(new_node_id, data=second_graph.graph.nodes[second_graph_node]["data"])
                # connect previous node with newly created node
                target_graph.graph.add_edge(previous_node_id, new_node_id)
                # enter recursion
                if len(second_graph.graph.out_edges(second_graph_node)) > 0:
                    for source, target in second_graph.graph.out_edges(second_graph_node):
                        if second_graph.graph.nodes[second_graph_node]["data"] is None:
                            tmp_previous_thread_id = -1
                        else:
                            tmp_previous_thread_id = second_graph.graph.nodes[second_graph_node]["data"].thread_id
                        if (first_graph_node, target, new_node_id) not in visited:
                            __construct_composed_graph(target_graph, first_graph, second_graph,
                                                       first_graph_node, target,
                                                       new_node_id, tmp_previous_thread_id, copy.deepcopy(visited), first_graph_last_step=first_graph_last_step, second_graph_last_step=second_graph_last_step)
                else:
                    if second_graph.graph.nodes[second_graph_node]["data"] is None:
                        tmp_previous_thread_id = -1
                    else:
                        tmp_previous_thread_id = second_graph.graph.nodes[second_graph_node]["data"].thread_id
                    if (first_graph_node, second_graph_node, new_node_id) not in visited:
                        __construct_composed_graph(target_graph, first_graph, second_graph,
                                                   first_graph_node, second_graph_node,
                                                   new_node_id, tmp_previous_thread_id, copy.deepcopy(visited), first_graph_last_step=first_graph_last_step, second_graph_last_step=True)

            return target_graph


        composed_graph = __construct_composed_graph(composed_graph, self, other_graph,
                                                    self.get_root_node_identifier(),
                                                    other_graph.get_root_node_identifier(),
                                                    composed_graph.get_root_node_identifier(), -1, [])

        composed_graph.fix_node_ids()
        composed_graph.__update_contained_thread_ids()

        return composed_graph


    def fix_node_ids(self):
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
            mapping = {node_id: (counter + 1, preceding_thread_id, node_id[2])}
            if node_id == self.root_node_identifier:
                self.root_node_identifier = mapping[node_id]
            self.graph = nx.relabel_nodes(self.graph, mapping, copy=False)

    def debug_check_for_cycles(self):
        try:
            cycles = nx.find_cycle(self.graph)
            print("CYLCES: ", cycles)
        except:
            print("NO CYCLE FOUND")

    def remove_none_nodes(self):
        to_be_removed = []
        for node in self.graph.nodes:
            if self.graph.nodes[node]["data"] is None:
                # remove non-root node
                if node != self.get_root_node_identifier():
                    to_be_removed.append(node)
                # remove root node, if only one successor exists
                if node == self.get_root_node_identifier() and len(self.graph.out_edges(node)) == 1:
                    # add node to to_be_removed
                    to_be_removed.append(node)
                    # set successor as new root
                    self.root_node_identifier = list(self.graph.out_edges(node))[0][1]

        for node in to_be_removed:
            # redirect incoming edges to successors
            in_edges = [edge for edge in self.graph.in_edges(node)]
            out_edges = [edge for edge in self.graph.out_edges(node)]
            edges_to_be_removed = in_edges + out_edges
            # remove duplicates
            edges_to_be_removed = list(dict.fromkeys(edges_to_be_removed))
            # remove all edges
            for s, t in edges_to_be_removed:
                self.graph.remove_edge(s, t)
            # remove node
            self.graph.remove_node(node)

            # reconnect predecessors and successors
            for predecessor, _ in in_edges:
                for _, successor in out_edges:
                    if predecessor == node or successor == node:
                        # ignore faulty edges (originated from cyclic edges)
                        continue
                    else:
                        self.graph.add_edge(predecessor, successor)

    def __remove_edges_from_to_source_node(self):
        to_be_removed = []
        for edge in self.graph.edges:
            if edge[0] == edge[1]:
                to_be_removed.append(edge)
        for source, target in to_be_removed:
            self.graph.remove_edge(source, target)
