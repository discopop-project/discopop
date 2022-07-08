import os

import matplotlib.pyplot as plt  # type:ignore
import networkx as nx  # type:ignore
from typing import List, Dict, Tuple

from discopop_validation.data_race_prediction.behavior_modeller.classes.BBNode import BBNode
from discopop_validation.data_race_prediction.behavior_modeller.classes.FunctionMetaData import FunctionMetaData
from discopop_validation.data_race_prediction.behavior_modeller.classes.Operation import Operation


class BBGraph(object):
    graph: nx.DiGraph
    functions: List[FunctionMetaData]
    section_to_entry_point: Dict[int, BBNode]
    bb_path_to_operations_cache: Dict[Tuple[int, Tuple[BBNode, ...]], List[Tuple[int, Operation]]]

    def __init__(self, bb_information_file):
        """parses bb_information_file and constructs BBGraph accordingly.
        Raises ValueError, if bb_information_file could not be found"""
        self.graph = nx.MultiDiGraph()
        self.function_nodes = []
        self.section_to_entry_point = {}
        self.bb_path_to_operations_cache = {}

        # parse bb_information_file
        if not os.path.exists(bb_information_file):
            return ValueError("path to bb_information_file not found: ", bb_information_file)
        with open(bb_information_file, "r") as bb_file:
            # dummy function node
            current_function = FunctionMetaData("this_is_a_dummy_node")
            current_bb = BBNode(-42)
            for line in bb_file.readlines():
                line = line.replace("\n", "").split(";")
                # parse line
                if line[0] == "function":
                    current_function = FunctionMetaData(line[1])
                    self.function_nodes.append(current_function)
                elif line[0] == "fileName":
                    current_function.file_name = line[1]
                elif line[0] == "functionEntryBB":
                    current_function.function_entry_bb = line[1]
                elif line[0] == "bbIndex":
                    current_bb = BBNode(int(line[1]))
                    self.graph.add_node(current_bb.id, data=current_bb)
                elif line[0] == "successor":
                    self.graph.add_edge(current_bb.id, int(line[1]))
                elif line[0] == "operation":
                    # split operation target into name and indices, if any present
                    target_indices: List[str] = []
                    if "[" in line[5]:
                        target_name = line[5][0:line[5].index("[")]
                        line[5] = line[5][line[5].index("["):]
                        target_indices = [var_name for var_name in line[5].replace("[", "").split("]") if
                                          len(var_name) > 0]
                    else:
                        target_name = line[5]
                    current_bb.operations.append(
                        Operation(line[1], line[2], int(line[3]), line[4], target_name, int(line[6]), int(line[7]),
                                  int(line[8]), int(line[9]), target_indices=target_indices))
                    if not int(line[3]) in current_bb.contained_in_relevant_sections:
                        current_bb.contained_in_relevant_sections.append(int(line[3]))
                elif line[0] == "inSection":
                    section_id = int(line[1])
                    if section_id not in current_bb.contained_in_relevant_sections:
                        current_bb.contained_in_relevant_sections.append(section_id)
                    if section_id not in self.section_to_entry_point:
                        self.section_to_entry_point[section_id] = current_bb
                    else:
                        # section_to_entry_point might need to be updated
                        if (current_bb.start_pos[0] < self.section_to_entry_point[section_id].start_pos[0]) or \
                                ((current_bb.start_pos[0] == self.section_to_entry_point[section_id].start_pos[0]) and
                                 (current_bb.start_pos[1] < self.section_to_entry_point[section_id].start_pos[1])):
                            # section_to_entry_point needs an update
                            self.section_to_entry_point[section_id] = current_bb
                elif line[0] == "bbName":
                    current_bb.name = line[1]
                elif line[0] == "bbStart":
                    current_bb.start_pos = (int(line[1]), int(line[2]))
                elif line[0] == "bbEnd":
                    current_bb.end_pos = (int(line[1]), int(line[2]))
                elif line[0] == "bbFileId":
                    current_bb.file_id = int(line[1])
                else:
                    raise ValueError("Unknown keyword: ", line[0])

        # remove edges to bb's outside of relevant sections (automatically added by networkx)
        nodes_to_be_removed = [node for node in self.graph.nodes if "data" not in self.graph.nodes[node]]
        edges_to_be_removed = []
        for n in nodes_to_be_removed:
            edges_to_be_removed += self.graph.in_edges(n)
        for e in edges_to_be_removed:
            self.graph.remove_edge(e[0], e[1])
        for n in nodes_to_be_removed:
            self.graph.remove_node(n)

    def show(self):
        """open window and plot the graph"""
        pos = nx.spring_layout(self.graph)
        section_entrypoint_nodes = [bb.id for bb in self.section_to_entry_point.values()]
        nodes_without_operations = [node for node in self.graph.nodes if
                                    len(self.graph.nodes[node]["data"].operations) == 0]
        nodes_with_operations = [node for node in self.graph.nodes if node not in nodes_without_operations]
        normal_nodes_without_operations = [node for node in nodes_without_operations if
                                           node not in section_entrypoint_nodes]
        normal_nodes_with_operations = [node for node in nodes_with_operations if node not in section_entrypoint_nodes]
        entry_nodes_without_operations = [node for node in nodes_without_operations if node in section_entrypoint_nodes]
        entry_nodes_with_operations = [node for node in nodes_with_operations if node in section_entrypoint_nodes]
        # draw normal nodes w/o operations in grey
        nx.draw_networkx_nodes(self.graph, pos, nodelist=normal_nodes_without_operations, node_color="grey",
                               node_shape="o")
        # draw normal nodes with operations in blue
        nx.draw_networkx_nodes(self.graph, pos, nodelist=normal_nodes_with_operations, node_shape="o")
        # draw section entry nodes w/o operations in grey diamonds
        nx.draw_networkx_nodes(self.graph, pos, nodelist=entry_nodes_without_operations, node_color="grey",
                               node_shape="d")
        # draw section entry nodes with operations in blue diamonds
        nx.draw_networkx_nodes(self.graph, pos, nodelist=entry_nodes_with_operations, node_shape="d")
        nx.draw_networkx_edges(self.graph, pos)
        labels = {}
        for node in self.graph.nodes:
            labels[node] = str(self.graph.nodes[node]["data"].start_pos) + " - " + self.graph.nodes[node]["data"].name
            # labels[node] = str(self.graph.nodes[node]["data"].id) + " - " + self.graph.nodes[node]["data"].name
            # labels[node] = str(len(self.graph.nodes[node]["data"].operations))
            # labels[node] = str(self.graph.nodes[node]["data"].contained_in_relevant_sections)
        nx.draw_networkx_labels(self.graph, pos, labels)
        plt.show()
