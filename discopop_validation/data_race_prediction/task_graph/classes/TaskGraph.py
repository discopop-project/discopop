from typing import List, Optional, Dict

import networkx as nx  # type:ignore
import matplotlib.pyplot as plt  # type:ignore
from networkx.drawing.nx_agraph import graphviz_layout  # type:ignore

from discopop_explorer import PETGraphX
from discopop_explorer.PETGraphX import EdgeType as PETEdgeType
from discopop_validation.classes.Configuration import Configuration
from discopop_validation.classes.OmpPragma import OmpPragma, PragmaType
from discopop_validation.data_race_prediction.task_graph.classes.EdgeType import EdgeType
from discopop_validation.data_race_prediction.task_graph.classes.PragmaParallelForNode import PragmaParallelForNode
from discopop_validation.data_race_prediction.task_graph.classes.PragmaParallelNode import PragmaParallelNode
from discopop_validation.data_race_prediction.task_graph.classes.PragmaSingleNode import PragmaSingleNode
from discopop_validation.data_race_prediction.task_graph.classes.TaskGraphNode import TaskGraphNode
from discopop_validation.interfaces.discopop_explorer import check_reachability


class TaskGraph(object):
    graph: nx.DiGraph
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
        edge_color_map = {EdgeType.SUCCESSOR: "black",
                          EdgeType.CONTAINS: "orange",
                          EdgeType.DEPENDS: "red"}
        edge_colors = [edge_color_map[self.graph[source][dest]['type']] for source,dest in self.graph.edges]
        nx.draw(self.graph, pos, with_labels=False, arrows=True, font_weight='bold', node_color=colors, edge_color=edge_colors)
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

    def add_pragma_node(self, pragma_obj: OmpPragma):
        """create a new node in the graph which represents the given pragma"""
        # get dependencies to previous nodes
        if pragma_obj.get_type() == PragmaType.PARALLEL_FOR:
            node_id = self.__add_parallel_for_pragma(pragma_obj)
        if pragma_obj.get_type() == PragmaType.PARALLEL:
            node_id = self.__add_parallel_pragma(pragma_obj)
        if pragma_obj.get_type() == PragmaType.SINGLE:
            node_id = self.__add_single_pragma(pragma_obj)
        # create entry in dictionary
        self.pragma_to_node_id[pragma_obj] = node_id

    def __add_single_pragma(self, pragma_obj: OmpPragma):
        new_node_id = self.__get_new_node_id()
        self.graph.add_node(new_node_id, data=PragmaSingleNode(new_node_id, pragma=pragma_obj))
        return new_node_id

    def __add_parallel_for_pragma(self, pragma_obj: OmpPragma):
        new_node_id = self.__get_new_node_id()
        self.graph.add_node(new_node_id, data=PragmaParallelForNode(new_node_id, pragma=pragma_obj))
        return new_node_id

    def __add_parallel_pragma(self, pragma_obj: OmpPragma):
        new_node_id = self.__get_new_node_id()
        self.graph.add_node(new_node_id, data=PragmaParallelNode(new_node_id, pragma=pragma_obj))
        return new_node_id

    def compute_results(self):
        # trigger result computation for root node
        self.graph.nodes[0]["data"].compute_result(self)

    def insert_behavior_models(self, run_configuration: Configuration, pet: PETGraphX, omp_pragmas: List[OmpPragma]):
        for node_id in self.graph.nodes:
            self.graph.nodes[node_id]["data"].insert_behavior_model(run_configuration, pet, omp_pragmas)

    def add_edges(self, pet: PETGraphX, omp_pragmas: List[OmpPragma]):
        """extract dependencies between omp pragmas from the PET Graph and create edges in the TaskGraph accordingly."""
        pragma_to_cuid: Dict[OmpPragma, str] = dict()
        for pragma in omp_pragmas:
            cu_id = self.__get_pet_node_id_from_pragma(pet, pragma)
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
                    if pragma_to_cuid[other_pragma] != pragma_to_cuid[pragma]:
                        # pragma is a successor of other_pragma
                        # this check prevents cycles due to same CU Node
                        self.graph.add_edge(self.pragma_to_node_id[other_pragma], self.pragma_to_node_id[pragma], type=EdgeType.SUCCESSOR)
                else:
                    # if not, check if both pragmas share a common parent and check if pragma succeeds other_pragma
                    pragma_parents = [source for source, target, data in pet.in_edges(pragma_to_cuid[pragma], PETEdgeType.CHILD)]
                    # check if other_pragma is a direct child of parent
                    for parent in pragma_parents:
                        if pet.node_at(pragma_to_cuid[other_pragma]) in pet.direct_children(pet.node_at(parent)):
                            # pragma and other pragma share a common parent
                            # check if other_pragma is a successor of pragma
                            if other_pragma.start_line <= pragma.start_line and other_pragma.end_line <= pragma.start_line:
                                self.graph.add_edge(self.pragma_to_node_id[other_pragma], self.pragma_to_node_id[pragma], type=EdgeType.SUCCESSOR)
                                print("V1")

        # add contains edges
        for pragma in omp_pragmas:
            for other_pragma in omp_pragmas:
                if pragma == other_pragma:
                    continue
                # if two pragmas are based on the same CU, the first appearing contains the second
                if pragma_to_cuid[pragma] == pragma_to_cuid[other_pragma]:
                    if pragma.start_line < other_pragma.start_line:
                        # pragma contains other_pragma
                        self.graph.add_edge(self.pragma_to_node_id[pragma], self.pragma_to_node_id[other_pragma], type=EdgeType.CONTAINS)

        # Fallback: add edge from root node to current node if no predecessor exists
        for node in self.graph.nodes:
            if len(self.graph.in_edges(node)) == 0 and node != 0:
                self.graph.add_edge(0, node, type=EdgeType.SUCCESSOR)

    def __get_pet_node_id_from_pragma(self, pet: PETGraphX, pragma: OmpPragma):
        """Returns the ID of the pet-graph node which contains the given pragma"""
        potential_nodes = []
        for pet_node in pet.g.nodes:
            if pragma.file_id == pet.g.nodes[pet_node]["data"].file_id and \
                pragma.start_line >= pet.g.nodes[pet_node]["data"].start_line and \
                pragma.end_line <= pet.g.nodes[pet_node]["data"].end_line:
                potential_nodes.append(pet_node)
        if len(potential_nodes) == 0:
            raise ValueError("No valid CUID found for pragma: ", pragma)
        # find narrowest matching node
        narrowest_node_buffer = potential_nodes[0]
        for pet_node in potential_nodes:
            if pet.g.nodes[pet_node]["data"].start_line >= pet.g.nodes[narrowest_node_buffer]["data"].start_line and \
                pet.g.nodes[pet_node]["data"].end_line <= pet.g.nodes[narrowest_node_buffer]["data"].end_line:
                narrowest_node_buffer = pet_node
        print("Pragma: ", pragma)
        print("--> CUID: ", narrowest_node_buffer)
        return narrowest_node_buffer

    def remove_redundant_successor_edges(self):
        # calculate code line distances and remove all but the shortest edge
        for node in self.graph.nodes:
            shortest_edge_source = None
            shortest_edge_distance = None
            for edge_source, _ in self.graph.in_edges(node):
                if self.graph.nodes[edge_source]["data"].pragma is None:
                    continue
                distance = self.graph.nodes[node]["data"].pragma.start_line - self.graph.nodes[edge_source]["data"].pragma.start_line
                if shortest_edge_source is None:
                    shortest_edge_source = edge_source
                    shortest_edge_distance = distance
                    continue
                if distance < shortest_edge_distance:
                    shortest_edge_source = edge_source
                    shortest_edge_distance = distance
            # remove unnecessary edges
            edge_remove_buffer = []
            for edge_source, _ in self.graph.in_edges(node):
                if self.graph.nodes[edge_source]["data"].pragma is None:
                    continue
                if edge_source == shortest_edge_source:
                    continue
                edge_remove_buffer.append((edge_source, node))
            for source, target in edge_remove_buffer:
                self.graph.remove_edge(source, target)

        pass
