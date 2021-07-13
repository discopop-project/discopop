from itertools import chain, combinations
from itertools import compress, product
import networkx as nx  # type:ignore
import os
from typing import Optional, List, Tuple, Dict, cast
import matplotlib.pyplot as plt  # type:ignore
from sys import maxsize
from itertools import combinations

class Operation:
    mode: str
    target_name: str
    line: int
    col: int
    # origin line and col will only be different from line / col if Operation occured inside a called function
    origin_line: int
    origin_col: int
    section_id: int

    def __init__(self, section_id, mode, target_name, line, col, origin_line, origin_col):
        self.mode = mode
        self.target_name = target_name
        self.line = line
        self.col = col
        self.origin_line = origin_line
        self.origin_col = origin_col
        self.section_id = section_id

    def __str__(self):
        # if operation occurs inside called function, report origin line and col additionally
        return_str = "" + str(self.section_id) + ";" + str(self.line) + ":" + str(self.col) + ";" + self.mode + "->" + self.target_name
        if self.mode.startswith("c"):
            return_str += " Origin: " + str(self.origin_line) + ":" + str(self.origin_col)
        return return_str

        # todo add file id


class BBNode:
    id: int
    operations: List[Operation]
    contained_in_relevant_sections: List[int]
    name: str
    start_pos: Tuple[int, int]
    end_pos: Tuple[int, int]

    def __init__(self, node_id):
        self.id = node_id
        self.operations = []
        self.contained_in_relevant_sections = []
        self.name = ""
        self.start_pos = (maxsize, maxsize)
        self.end_pos = (-maxsize, -maxsize)


class FunctionMetaData:
    name: str
    file_name: str
    function_entry_bb: int

    # stores meta data regarding a function and points to it's root BB node
    def __init__(self, fn_name):
        self.name = fn_name


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
                line = line.replace("\n", "").split(":")
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
                    current_bb.operations.append(Operation(int(line[1]), line[2], line[3], int(line[4]), int(line[5]), int(line[6]), int(line[7])))
                    if not int(line[1]) in current_bb.contained_in_relevant_sections:
                        current_bb.contained_in_relevant_sections.append(int(line[1]))
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
        nodes_without_operations = [node for node in self.graph.nodes if len(self.graph.nodes[node]["data"].operations) == 0]
        nodes_with_operations = [node for node in self.graph.nodes if node not in nodes_without_operations]
        normal_nodes_without_operations = [node for node in nodes_without_operations if node not in section_entrypoint_nodes]
        normal_nodes_with_operations = [node for node in nodes_with_operations if node not in section_entrypoint_nodes]
        entry_nodes_without_operations = [node for node in nodes_without_operations if node in section_entrypoint_nodes]
        entry_nodes_with_operations = [node for node in nodes_with_operations if node in section_entrypoint_nodes]
        # draw normal nodes w/o operations in grey
        nx.draw_networkx_nodes(self.graph, pos, nodelist=normal_nodes_without_operations, node_color="grey", node_shape="o")
        # draw normal nodes with operations in blue
        nx.draw_networkx_nodes(self.graph, pos, nodelist=normal_nodes_with_operations, node_shape="o")
        # draw section entry nodes w/o operations in grey diamonds
        nx.draw_networkx_nodes(self.graph, pos, nodelist=entry_nodes_without_operations, node_color="grey", node_shape="d")
        # draw section entry nodes with operations in blue diamonds
        nx.draw_networkx_nodes(self.graph, pos, nodelist=entry_nodes_with_operations, node_shape="d")
        nx.draw_networkx_edges(self.graph, pos)
        labels = {}
        for node in self.graph.nodes:
            labels[node] = str(self.graph.nodes[node]["data"].id) + " - " + self.graph.nodes[node]["data"].name
            #labels[node] = str(len(self.graph.nodes[node]["data"].operations))
            #labels[node] = str(self.graph.nodes[node]["data"].contained_in_relevant_sections)
        nx.draw_networkx_labels(self.graph, pos, labels)
        plt.show()

    def compress(self):
        """compresses the bb graph iteratively until no further optimization can be found."""
        modification_found = True
        while modification_found:
            modification_found = False
            for node in self.graph.nodes:
                # remove, if node has no operations, exactly one successor with no operations is part of same
                # relevant sections as its successor.
                if len(self.graph.nodes[node]["data"].operations) == 0 and self.graph.out_degree(node) == 1 and \
                        self.graph.in_degree(node) != 0:
                    # redirect incoming edges
                    edges_to_be_removed = []
                    for successor_edge in self.graph.out_edges(node):
                        successor = successor_edge[1]
                        # check if relevant sections are equal
                        if self.graph.nodes[node]["data"].contained_in_relevant_sections != \
                                self.graph.nodes[successor]["data"].contained_in_relevant_sections:
                            continue
                        # check if successor has operation
                        if len(self.graph.nodes[successor]["data"].operations) != 0:
                            continue
                        for ie in self.graph.in_edges(node):
                            edges_to_be_removed.append(ie)
                            predecessor = ie[0]
                            if not self.graph.has_edge(predecessor, successor):  # prevent duplicating edges
                                self.graph.add_edge(predecessor, successor)
                            modification_found = True
                    for e in edges_to_be_removed:
                        self.graph.remove_edge(e[0], e[1])
                    if modification_found:
                        self.graph.remove_node(node)
                    break

        # test
        to_be_removed = []
        for node in self.graph.nodes:
            if len(self.graph.nodes[node]["data"].contained_in_relevant_sections) == 0:
                to_be_removed.append(node)
        for i in to_be_removed:
            self.graph.remove_node(i)

    def __get_paths_for_sections(self):
        """constructs and returns a dictionary containing a mapping from section ids to a list of lists containing all
        possible paths for the given section"""
        path_dict: Dict[int, List[List[BBNode]]] = {}

        def __rec_construct_pathlist(root_bb_node: BBNode, entry_point_bb: BBNode) -> List[List[BBNode]]:
            if root_bb_node.id not in self.graph.nodes:
                return []
            children_paths: List[List[BBNode]] = []
            for out_edge in self.graph.out_edges(root_bb_node.id):
                # todo disable looping by checking for entry point
                child_bb_node: BBNode = self.graph.nodes[out_edge[1]]["data"]
                if child_bb_node is entry_point_bb:
                    continue
                children_paths += __rec_construct_pathlist(child_bb_node, entry_point_bb)
            # recursion condition
            if len(children_paths) == 0:
                result_paths = [[root_bb_node]]
            else:
                # insert root_bb_node at beginning of each element in children_paths
                result_paths = []
                for path in children_paths:
                    path.insert(0, root_bb_node)
                    result_paths.append(path)
            return result_paths

        for section_id in self.section_to_entry_point:
            entry_point = self.section_to_entry_point[section_id]
            paths = __rec_construct_pathlist(entry_point, entry_point)
            path_dict[section_id] = paths
        return path_dict

    def get_possible_path_combinations_for_sections(self) -> Dict[int, List[List[List[BBNode]]]]:
        """constructs a dictionary containing a mapping from section id to a list of lists of lists.
        The outermost list contains a list of path combinations.
        The second list contains one combination, ie. a list of paths.
        The innermost list contains BBNodes which belong to one path."""
        path_dict = self.__get_paths_for_sections()
        result_dict: Dict[int, List[List[List[BBNode]]]] = {}

        def get_powerset(iterable):
            s = list(iterable)  # allows duplicate elements
            list_of_tuples = list(chain.from_iterable(combinations(s, r) for r in range(len(s) + 1)))
            list_of_lists = []
            for e in list_of_tuples:
                cur_list = []
                for i in range(0, len(e)):
                    cur_list.append(e[i])
                list_of_lists.append(cur_list)
            return list_of_lists

        for section_id in path_dict:
            path_combinations = get_powerset(path_dict[section_id])
            result_dict[section_id] = path_combinations
        return result_dict

    def convert_bb_path_to_operations(self, section_id: int, bb_path: List[BBNode]) -> List[Tuple[int, Operation]]:
        """Converts a given list of BB Nodes which represent a path in the BB graph into a list of tuples containing
        the id of the parent BB node and an Operation."""
        cache_tuple = (section_id, tuple(bb_path))
        if cache_tuple in self.bb_path_to_operations_cache:
            return self.bb_path_to_operations_cache[cache_tuple]
        op_path: List[Tuple[int, Operation]] = []
        for bb_node in bb_path:
            for op in bb_node.operations:
                # only consider the relevant section id
                if op.section_id == section_id:
                    op_path.append((bb_node.id, op))
        self.bb_path_to_operations_cache[cache_tuple] = op_path
        return op_path


