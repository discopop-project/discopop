import networkx as nx  # type:ignore
import os
from typing import Optional, List
import matplotlib.pyplot as plt


class Operation:
    mode: str
    target_name: str
    line: int
    col: int

    def __init__(self, mode, target_name, line, col):
        self.mode = mode
        self.target_name = target_name
        self.line = line
        self.col = col


class BBNode:
    id: int
    operations: List[Operation]

    def __init__(self, node_id):
        self.id = node_id
        self.operations = []


class FunctionMetaData:
    name: str
    file_name: str
    function_entry_bb: int

    # stores meta data regarding a function and points to it's root BB node
    def __init__(self, fn_name):
        self.name = fn_name


class BBGraph(object):
    graph: nx.MultiDiGraph
    functions: List[FunctionMetaData]

    def __init__(self, bb_information_file):
        """parses bb_information_file and constructs BBGraph accordingly.
        Raises ValueError, if bb_information_file could not be found"""
        self.graph = nx.MultiDiGraph()
        self.function_nodes = []

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
                    current_bb.operations.append(Operation(line[1], line[2], int(line[3]), int(line[4])))
                else:
                    raise ValueError("Unknown keyword: ", line[0])
                print(line)

        # show graph
        self.show()

    def show(self):
        """open window and plot the graph"""
        pos = nx.spring_layout(self.graph)
        nodes_without_operations = [node for node in self.graph.nodes if len(self.graph.nodes[node]["data"].operations) == 0]
        nodes_with_operations = [node for node in self.graph.nodes if node not in nodes_without_operations]
        # draw nodes w/o operations in grey
        nx.draw_networkx_nodes(self.graph, pos, nodelist=nodes_without_operations, node_color="grey", node_shape="o")
        # draw nodes with operations in blue
        nx.draw_networkx_nodes(self.graph, pos, nodelist=nodes_with_operations, node_shape="o")
        nx.draw_networkx_edges(self.graph, pos)
        labels = {}
        for node in self.graph.nodes:
            # todo re-enable
            # labels[node] = str(self.graph.nodes[node]["data"].id)
            labels[node] = str(len(self.graph.nodes[node]["data"].operations))
        nx.draw_networkx_labels(self.graph, pos, labels)
        plt.show()
