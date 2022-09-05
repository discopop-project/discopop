import copy
import os.path

import matplotlib.pyplot as plt  # type: ignore
import networkx as nx  # type: ignore
from graphviz import Source  # type: ignore
from networkx.drawing.nx_pydot import to_pydot  # type: ignore
from typing import Tuple, List, cast, Optional, Union

from discopop_explorer import PETGraphX
from discopop_explorer.PETGraphX import EdgeType as PETEdgeType, DepType
from discopop_validation.classes.Configuration import Configuration
from discopop_validation.data_race_prediction.behavior_modeller.classes.Operation import Operation
from discopop_validation.data_race_prediction.behavior_modeller.classes.OperationModifierType import \
    OperationModifierType
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
from discopop_validation.data_race_prediction.parallel_construct_graph.classes.PragmaTaskwaitNode import \
    PragmaTaskwaitNode
from discopop_validation.data_race_prediction.utils import get_pet_node_id_from_source_code_lines
from discopop_validation.memory_access_graph.AccessMetaData import AccessMetaData
from discopop_validation.memory_access_graph.MAGDataRace import MAGDataRace
from discopop_validation.memory_access_graph.PUStack import PUStack
from discopop_validation.memory_access_graph.ParallelUnit import ParallelUnit


class MemoryAccessGraph(object):
    graph: nx.MultiDiGraph
    next_free_parallel_frame_id: int
    run_configuration: Configuration

    def __init__(self, pc_graph: PCGraph, run_configuration: Configuration):
        self.next_free_parallel_frame_id = 0
        self.graph = nx.MultiDiGraph()
        self.run_configuration = run_configuration
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
        # create and initialize pu_stack
        pu_stack = PUStack(self.__get_new_parallel_frame_id(), pc_graph_root_node)
        current_path: List[PCGraphNode] = [pc_graph_root_node]

        # traverse task graph in a depth-first manner
        # in doing so, traverse outgoing contains edges before sequential edges to analyze the effects of a node in the
        # correct order
        self.__visit_node(pc_graph, pc_graph_root_node, pu_stack, current_path, [])

        #pc_graph.plot_graph()
        print("NODES: ", self.graph.nodes)
        print("Edges: ", self.graph.edges)
        #self.plot_graph()

    def __visit_node(self, pc_graph: PCGraph, pc_graph_node: PCGraphNode, pu_stack: PUStack, current_path: List[PCGraphNode], visited: List[PCGraphNode]) -> Tuple[List[PCGraphNode], List[List[PCGraphNode]]]:
        """returns a list of visited nodes and a list of all encountered paths"""
        #if self.run_configuration.verbose_mode:
        #     print("Visiting: ", pc_graph_node.node_id, "   PU Stack: ", pu_stack, "   Path: ", current_path)
        if pc_graph_node not in visited:
            visited.append(pc_graph_node)
        current_path.append(pc_graph_node)

        print("VISITING: ", pc_graph_node.node_id)
        print("PATH: ", [c.node_id for c in current_path])

        # modify the memory access graph according to the current node
        self.__modify_memory_access_graph(pc_graph, pc_graph_node, pu_stack, current_path)

        # visit children following contains edges which have no incoming sequential edges and thus are entry points
        children = pc_graph.get_children_of_node(pc_graph_node, [EdgeType.CONTAINS])
        print("\tchildren: ", [c.node_id for c in children])
        child_paths: List[List[PCGraphNode]] = []
        for child_idx, child in enumerate(children):
            if child in visited:
                continue
            # ignore child if it has an incoming sequential edge
            in_sequential_edges = pc_graph.get_incoming_edges_of_node(child, [EdgeType.SEQUENTIAL])
            if len(in_sequential_edges) == 0:
                tmp_visited, tmp_paths = self.__visit_node(pc_graph, child, copy.deepcopy(pu_stack), copy.deepcopy(current_path), visited)
                child_paths += tmp_paths
                visited += [n for n in tmp_visited if n not in visited]

        # if no child exists, copy the current_path
        if len(child_paths) == 0:
            child_paths = [current_path]

        # visit children following sequential edges
        children = pc_graph.get_children_of_node(pc_graph_node, [EdgeType.SEQUENTIAL])
        print("\tsuccessors: ", [c.node_id for c in children])
        # iterate over encountered child paths
        successor_paths: List[List[PCGraphNode]] = []
        successor_visited: List[PCGraphNode] = []
        for child_path in child_paths:
            for child_idx, child in enumerate(children):
                if child in visited:
                    continue
                tmp_visited, tmp_paths = self.__visit_node(pc_graph, child, copy.deepcopy(pu_stack), copy.deepcopy(child_path), visited)
                successor_paths += tmp_paths
                successor_visited += [n for n in tmp_visited if n not in successor_visited]
        visited += [n for n in successor_visited if n not in visited]
        return visited, successor_paths

    def __modify_memory_access_graph(self, pc_graph: PCGraph, pc_graph_node: PCGraphNode, pu_stack: PUStack, current_path: List[PCGraphNode]):
        # check if pu stack needs to be modified
        self.__modify_pu_stack(pc_graph, pc_graph_node, pu_stack)

        # apply modification of the memory access graph according to the current node
        self.__detect_and_include_memory_accesses_to_graph(pc_graph, pc_graph_node, pu_stack, current_path)

    def __detect_and_include_memory_accesses_to_graph(self, pc_graph: PCGraph, raw_pc_graph_node: PCGraphNode,
                                                      pu_stack: PUStack, current_path: List[PCGraphNode]):
        # add memory accesses from BehaviorModelNodes
        if type(raw_pc_graph_node) == BehaviorModelNode:
            bhv_node = cast(BehaviorModelNode, raw_pc_graph_node)
            model = bhv_node.single_behavior_model
            previous_node_id = str(bhv_node.node_id)
            for op_idx, op in enumerate(model.operations):
                operation_path_id = current_path + [op_idx]
                previous_node_id = self.__add_memory_access_to_graph(operation_path_id, op, bhv_node,
                                                                     previous_node_id, pu_stack.peek())

    def __add_memory_access_to_graph(self, operation_path_id: List[Union[BehaviorModelNode,int]], operation: Operation, bhv_node: BehaviorModelNode,
                                     previous_node_id: str, parallel_unit: ParallelUnit) -> str:
        # if self.run_configuration.verbose_mode:
        #    print("Adding: ", operation_path_id, "\t", operation.mode, "\t", operation.target_name, "\t", parallel_unit)
        if not previous_node_id in self.graph.nodes:
            # add previous node into MemoryAccessGraph (Dummy as source of the edge)
            self.graph.add_node(previous_node_id)

        if not operation.target_name in self.graph.nodes:
            # add node vor target_name into MemoryAccessGraph
            self.graph.add_node(operation.target_name)

        access_metadata = AccessMetaData(operation, operation.mode, operation_path_id, bhv_node, parallel_unit)

        if operation.mode == "r":
            self.graph.add_edge(previous_node_id, operation.target_name, data=access_metadata, style="dashed",
                                label=access_metadata.get_edge_label(),
                                color=access_metadata.parallel_unit.visualization_color)
        if operation.mode == "w":
            self.graph.add_edge(previous_node_id, operation.target_name, data=access_metadata,
                                label=access_metadata.get_edge_label(),
                                color=access_metadata.parallel_unit.visualization_color)

        return operation.target_name

    def __modify_pu_stack(self, pc_graph: PCGraph, pc_graph_node: PCGraphNode, pu_stack: PUStack):
        # check if new entry has to be created and create a new one if so
        self.__create_new_pu_entry(pc_graph, pc_graph_node, pu_stack)

        # check if last entry needs to be removed and remove it if so
        self.__close_last_pu_entry(pc_graph, pc_graph_node, pu_stack)

        # check if new entry needs to be created
        self.__push_substitute_pu_entry(pc_graph, pc_graph_node, pu_stack)

    def __create_new_pu_entry(self, pc_graph: PCGraph, pc_graph_node: PCGraphNode, pu_stack: PUStack):
        """"create a new entry if any of the following node types is encountered:
            PARALLEL
            FORK
        """
        if type(pc_graph_node) in [PragmaParallelNode, ForkNode]:
            pu_stack.push(self.__get_new_parallel_frame_id(), pc_graph_node)

    def __close_last_pu_entry(self, pc_graph: PCGraph, pc_graph_node: PCGraphNode, pu_stack: PUStack):
        """closes the last entry in the stack if a node of one of the following types is encountered:
            BARRIER
            JOIN (closes all pu entries up until the one which has been created by the FORK node which belongs to it
        """
        if type(pc_graph_node) in [PragmaBarrierNode, PragmaTaskwaitNode]:
            pu_stack.pop()
        if type(pc_graph_node) == JoinNode:
            incoming_belongs_to_edges = pc_graph.get_incoming_edges_of_node(pc_graph_node, [EdgeType.BELONGS_TO])
            # ignore JOIN without belonging fork
            if len(incoming_belongs_to_edges) > 0:
                sources = [source for (source, target) in incoming_belongs_to_edges]
                while len(pu_stack.contents) > 1:
                    # check if belongs_to edge from origin node of parallel frame to the JOIN node exists
                    pu_origin = pu_stack.peek().origin_pc_graph_node

                    if pu_origin.node_id in sources:
                        # pu_stack entry of related FORK node found. stop iteration
                        pu_stack.pop()
                        break
                    else:
                        # restart search
                        pu_stack.pop()

    def __push_substitute_pu_entry(self, pc_graph: PCGraph, pc_graph_node: PCGraphNode, pu_stack: PUStack):
        """pushes a new pu entry if it is required.
        Pushing a new PU Entry is required for:
        - BARRIER and TASKWAIT nodes."""
        if type(pc_graph_node) in [PragmaBarrierNode, PragmaTaskwaitNode]:
            pu_stack.push(self.__get_new_parallel_frame_id(), pc_graph_node)