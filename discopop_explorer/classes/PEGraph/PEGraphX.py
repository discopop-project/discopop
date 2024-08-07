# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

from __future__ import annotations

import copy
import itertools
from typing import Dict, List, Sequence, Tuple, Set, Optional, Type, TypeVar, cast, Union, overload, Any

import jsonpickle  # type:ignore
import matplotlib.pyplot as plt  # type:ignore
import networkx as nx  # type:ignore
from alive_progress import alive_bar  # type: ignore
from lxml.objectify import ObjectifiedElement  # type: ignore

from discopop_explorer.classes.PEGraph.NodeT import NodeT
from discopop_explorer.functions.PEGraph.properties.is_loop_index import is_loop_index
from discopop_explorer.functions.PEGraph.properties.is_readonly_inside_loop_body import is_readonly_inside_loop_body
from discopop_explorer.functions.PEGraph.queries.edges import in_edges, out_edges
from discopop_explorer.functions.PEGraph.queries.nodes import all_nodes
from discopop_explorer.functions.PEGraph.queries.subtree import subtree_of_type
from discopop_explorer.functions.PEGraph.queries.variables import get_variables
from discopop_explorer.functions.PEGraph.traversal.children import direct_children, direct_children_or_called_nodes
from discopop_explorer.functions.PEGraph.traversal.parent import get_parent_function
from discopop_explorer.functions.PEGraph.traversal.successors import direct_successors
from discopop_library.HostpotLoader.HotspotNodeType import HotspotNodeType
from discopop_library.HostpotLoader.HotspotType import HotspotType  # type:ignore
from discopop_explorer.aliases.LineID import LineID
from discopop_explorer.aliases.MemoryRegion import MemoryRegion
from discopop_explorer.aliases.NodeID import NodeID
from discopop_explorer.classes.PEGraph.CUNode import CUNode
from discopop_explorer.classes.PEGraph.Dependency import Dependency
from discopop_explorer.classes.PEGraph.DummyNode import DummyNode
from discopop_explorer.classes.PEGraph.FunctionNode import FunctionNode
from discopop_explorer.classes.PEGraph.LoopNode import LoopNode
from discopop_explorer.classes.PEGraph.Node import Node
from discopop_explorer.enums.DepType import DepType
from discopop_explorer.enums.EdgeType import EdgeType
from discopop_explorer.enums.NodeType import NodeType

from discopop_explorer.utilities.PEGraphConstruction.parser import readlineToCUIdMap, writelineToCUIdMap
from discopop_explorer.utilities.PEGraphConstruction.classes.LoopData import LoopData
from discopop_explorer.utilities.PEGraphConstruction.classes.DependenceItem import DependenceItem
from discopop_explorer.utilities.PEGraphConstruction.PEGraphConstructionUtilities import parse_dependency, parse_cu
from discopop_explorer.classes.variable import Variable

global_pet = None

# unused
# node_props = [
#    ("BasicBlockID", "string", "''"),
#    ("pipeline", "float", "0"),
#    ("doAll", "bool", "False"),
#    ("geomDecomp", "bool", "False"),
#    ("reduction", "bool", "False"),
#    ("mwType", "int", "2"),
#    ("localVars", "object", "[]"),
#    ("globalVars", "object", "[]"),
#    ("args", "object", "[]"),
#    ("recursiveFunctionCalls", "object", "[]"),
# ]

# edge_props = [
#    ("type", "string"),
#    ("source", "string"),
#    ("sink", "string"),
#    ("var", "string"),
#    ("dtype", "string"),
# ]


#        # check format of newly created MemoryRegion
#        try:
#            int(id_string)
#        except ValueError:
#            raise ValueError("Mal-formatted MemoryRegion identifier: ", id_string)


class PEGraphX(object):
    g: nx.MultiDiGraph
    reduction_vars: List[Dict[str, str]]
    main: Node
    pos: Dict[Any, Any]

    def __init__(self, g: nx.MultiDiGraph, reduction_vars: List[Dict[str, str]], pos: Dict[Any, Any]):
        self.g = g
        self.reduction_vars = reduction_vars
        for _, node in g.nodes(data="data"):
            if node.name == "main":
                self.main = node
        self.pos = pos

    @classmethod
    def from_parsed_input(
        cls,
        cu_dict: Dict[str, ObjectifiedElement],
        dependencies_list: List[DependenceItem],
        loop_data: Dict[str, LoopData],
        reduction_vars: List[Dict[str, str]],
    ) -> PEGraphX:
        """Constructor for making a PETGraphX from the output of parser.parse_inputs()"""
        g = nx.MultiDiGraph()
        print("\tCreating graph...")

        for id, node in cu_dict.items():
            n = parse_cu(node)
            g.add_node(id, data=n)

        print("\tAdded nodes...")

        for node_id, node in cu_dict.items():
            source = node_id
            if "successors" in dir(node) and "CU" in dir(node.successors):
                for successor in [n.text for n in node.successors.CU]:
                    if successor not in g:
                        print(f"WARNING: no successor node {successor} found")
                    # do not allow "self-successor" edges (incorrect, but not critical. might occur in Data.xml)
                    if source != successor:
                        g.add_edge(source, successor, data=Dependency(EdgeType.SUCCESSOR))

            if "callsNode" in dir(node) and "nodeCalled" in dir(node.callsNode):
                for nodeCalled in [n.text for n in node.callsNode.nodeCalled]:
                    if nodeCalled not in g:
                        print(f"WARNING: no nodeCalled {nodeCalled} found")
                    g.add_edge(source, nodeCalled, data=Dependency(EdgeType.CALLSNODE))

            if "childrenNodes" in dir(node):
                for child in [n.text for n in node.childrenNodes]:
                    if child not in g:
                        print(f"WARNING: no child node {child} found")
                    if not (source, child) in g.edges:
                        g.add_edge(source, child, data=Dependency(EdgeType.CHILD))

        print("\tAdded edges...")

        for _, node in g.nodes(data="data"):
            if isinstance(node, LoopNode):
                node.loop_data = loop_data.get(node.start_position(), None)
                # TODO remove loop_iterations property, was kept for backwards compatibility only
                if node.loop_data is not None:
                    # node.loop_iterations = node.loop_data.total_iteration_count
                    node.loop_iterations = node.loop_data.average_iteration_count

        print("\tAdded loop data...")

        # calculate position before dependencies affect them
        try:
            pos = nx.planar_layout(g)  # good
        except nx.exception.NetworkXException:
            try:
                # fallback layouts
                pos = nx.shell_layout(g)  # maybe
            except nx.exception.NetworkXException:
                pos = nx.random_layout(g)
        print("\tCalculated positions...")
        for idx, dep in enumerate(dependencies_list):
            if dep.type == "INIT":
                sink = readlineToCUIdMap[dep.sink]
                if len(sink) > 0:
                    for s in sink:
                        g.add_edge(s, s, data=parse_dependency(dep))
                else:
                    # check for write lines
                    sink = writelineToCUIdMap[dep.sink]
                    for s in sink:
                        g.add_edge(s, s, data=parse_dependency(dep))
                continue

            sink_cu_ids = readlineToCUIdMap[dep.sink]
            source_cu_ids = writelineToCUIdMap[dep.source]

            for idx_1, sink_cu_id in enumerate(sink_cu_ids):
                for idx_2, source_cu_id in enumerate(source_cu_ids):
                    sink_node = g.nodes[sink_cu_id]["data"]
                    source_node = g.nodes[source_cu_id]["data"]
                    vars_in_sink_node = set()
                    vars_in_source_node = set()
                    if type(sink_node) == CUNode:
                        for var in itertools.chain(sink_node.local_vars, sink_node.global_vars):
                            vars_in_sink_node.add(var.name)
                    if type(source_node) == CUNode:
                        for var in itertools.chain(source_node.local_vars, source_node.global_vars):
                            vars_in_source_node.add(var.name)

                    if dep.var_name not in vars_in_sink_node and dep.var_name not in vars_in_source_node:
                        continue
                    if sink_cu_id and source_cu_id:
                        g.add_edge(sink_cu_id, source_cu_id, data=parse_dependency(dep))
        print("\tAdded dependencies...")
        return cls(g, reduction_vars, pos)

    def map_static_and_dynamic_dependencies(self) -> None:
        print("\tMapping static to dynamic dependencies...")
        print("\t\tIdentifying mappings between static and dynamic memory regions...", end=" ")
        mem_reg_mappings: Dict[MemoryRegion, Set[MemoryRegion]] = dict()
        # initialize mappings
        for node_id in [n.id for n in all_nodes(self, CUNode)]:
            out_deps = [(s, t, d) for s, t, d in out_edges(self, node_id) if d.etype == EdgeType.DATA]

            # for outgoing dependencies, the scope must be equal
            # as a result, comparing variable names to match memory regions is valid
            for _, _, d1 in out_deps:
                for _, _, d2 in out_deps:
                    if d1.var_name == d2.var_name:
                        if d1.memory_region != d2.memory_region:
                            if d1.memory_region is None or d2.memory_region is None:
                                continue
                            if d1.memory_region.startswith("GEPRESULT_") or d2.memory_region.startswith("GEPRESULT_"):
                                continue
                            if d1.memory_region not in mem_reg_mappings:
                                mem_reg_mappings[d1.memory_region] = set()
                            if d2.memory_region not in mem_reg_mappings:
                                mem_reg_mappings[d2.memory_region] = set()
                            mem_reg_mappings[d1.memory_region].add(d2.memory_region)
                            mem_reg_mappings[d2.memory_region].add(d1.memory_region)
        print("Done.")

        print("\t\tInstantiating static dependencies...", end=" ")
        # create copies of static dependency edges for all dynamic mappings
        for node_id in [n.id for n in all_nodes(self, CUNode)]:
            out_deps = [(s, t, d) for s, t, d in out_edges(self, node_id) if d.etype == EdgeType.DATA]
            for s, t, d in out_deps:
                if d.memory_region is None:
                    continue
                if d.memory_region.startswith("S"):
                    # Static dependency found
                    # check if mappings exist
                    if d.memory_region in mem_reg_mappings:
                        # create instances for all dynamic mappings
                        for dynamic_mapping in [
                            mapping for mapping in mem_reg_mappings[d.memory_region] if not mapping.startswith("S")
                        ]:
                            edge_data = copy.deepcopy(d)
                            edge_data.memory_region = dynamic_mapping
                            self.g.add_edge(s, t, data=edge_data)

        print("Done.")

    def calculateFunctionMetadata(
        self,
        hotspot_information: Optional[Dict[HotspotType, List[Tuple[int, int, HotspotNodeType, str, float]]]] = None,
        func_nodes: Optional[List[FunctionNode]] = None,
    ) -> None:
        # store id of parent function in each node
        # and store in each function node a list of all children ids
        if func_nodes is None:
            func_nodes = all_nodes(self, FunctionNode)

            if hotspot_information is not None:
                all_hotspot_functions: Set[Tuple[int, str]] = set()
                for key in hotspot_information:
                    for entry in hotspot_information[key]:
                        if entry[2] == HotspotNodeType.FUNCTION:
                            all_hotspot_functions.add((entry[0], entry[3]))

                filtered_func_nodes = [
                    func_node
                    for func_node in func_nodes
                    if (func_node.file_id, func_node.name) in all_hotspot_functions
                ]
                func_nodes = filtered_func_nodes

        print("Calculating local metadata results for functions...")
        import tqdm  # type: ignore
        from multiprocessing import Pool
        from discopop_explorer.parallel_utils import (
            pet_function_metadata_initialize_worker,
            pet_function_metadata_parse_func,
        )

        param_list = func_nodes
        with Pool(initializer=pet_function_metadata_initialize_worker, initargs=(self,)) as pool:
            tmp_result = list(
                tqdm.tqdm(pool.imap_unordered(pet_function_metadata_parse_func, param_list), total=len(param_list))
            )
        # calculate global result
        print("Calculating global result...")
        global_reachability_dict: Dict[NodeID, Set[NodeID]] = dict()
        for local_result in tmp_result:
            parsed_function_id, local_reachability_dict, local_children_ids = local_result
            # set reachability values to function nodes
            cast(FunctionNode, self.node_at(parsed_function_id)).reachability_pairs = local_reachability_dict
            # set parent function for visited nodes
            for child_id in local_children_ids:
                self.node_at(child_id).parent_function_id = parsed_function_id

        print("\tMetadata calculation done.")

        # cleanup dependencies (remove dependencies, if it is overwritten by a more specific Intra-iteration dependency
        # note: this can introduce false positives! Keep the analysis pessimistic to ensure correctness
        if False:
            print("Cleaning duplicated dependencies...")
            to_be_removed = []
            for cu_node in all_nodes(self, CUNode):
                out_deps = out_edges(self, cu_node.id, EdgeType.DATA)
                for dep_1 in out_deps:
                    for dep_2 in out_deps:
                        if dep_1 == dep_2:
                            continue
                        if (
                            dep_1[2].dtype == dep_2[2].dtype
                            and dep_1[2].etype == dep_2[2].etype
                            and dep_1[2].memory_region == dep_2[2].memory_region
                            and dep_1[2].sink_line == dep_2[2].sink_line
                            and dep_1[2].source_line == dep_2[2].source_line
                            and dep_1[2].var_name == dep_2[2].var_name
                        ):
                            if not dep_1[2].intra_iteration and dep_2[2].intra_iteration:
                                # dep_2 is a more specific duplicate of dep_1
                                # remove dep_1
                                to_be_removed.append(dep_1)

            to_be_removed_with_keys = []
            for dep in to_be_removed:
                graph_edges = self.g.out_edges(dep[0], keys=True, data="data")

                for s, t, key, data in graph_edges:
                    if dep[0] == s and dep[1] == t and dep[2] == data:
                        to_be_removed_with_keys.append((s, t, key))
            for edge in set(to_be_removed_with_keys):
                self.g.remove_edge(edge[0], edge[1], edge[2])
            print("Cleaning dependencies done.")

        # cleanup dependencies II : only consider the Intra-iteration dependencies with the highest level
        print("Cleaning duplicated dependencies II...")
        to_be_removed = []
        for cu_node in all_nodes(self, CUNode):
            out_deps = out_edges(self, cu_node.id, EdgeType.DATA)
            for dep_1 in out_deps:
                for dep_2 in out_deps:
                    if dep_1 == dep_2:
                        continue
                    if (
                        dep_1[2].dtype == dep_2[2].dtype
                        and dep_1[2].etype == dep_2[2].etype
                        and dep_1[2].memory_region == dep_2[2].memory_region
                        and dep_1[2].sink_line == dep_2[2].sink_line
                        and dep_1[2].source_line == dep_2[2].source_line
                        and dep_1[2].var_name == dep_2[2].var_name
                        and dep_1[2].intra_iteration
                        and dep_2[2].intra_iteration
                    ):
                        if dep_1[2].intra_iteration_level < dep_2[2].intra_iteration_level:
                            # dep_2 originated from a deeper nesting level. Remove less specific duplicate dep_1.
                            to_be_removed.append(dep_1)

        to_be_removed_with_keys = []
        for dep in to_be_removed:
            graph_edges = self.g.out_edges(dep[0], keys=True, data="data")

            for s, t, key, data in graph_edges:
                if dep[0] == s and dep[1] == t and dep[2] == data:
                    to_be_removed_with_keys.append((s, t, key))
        for edge in set(to_be_removed_with_keys):
            self.g.remove_edge(edge[0], edge[1], edge[2])
        print("Cleaning dependencies II done.")

    def calculateLoopMetadata(self) -> None:
        print("Calculating loop metadata")

        # calculate loop indices
        print("Calculating loop indices")
        loop_nodes = all_nodes(self, LoopNode)
        for loop in loop_nodes:
            subtree = subtree_of_type(self, loop, CUNode)
            # get variables used in loop
            candidates: Set[Variable] = set()
            for node in subtree:
                candidates.update(node.global_vars + node.local_vars)
            # identify loop indices
            loop_indices: Set[Variable] = set()
            for v in candidates:
                if is_loop_index(self, v.name, [loop.start_position()], subtree):
                    loop_indices.add(v)
            loop.loop_indices = [v.name for v in loop_indices]
        print("\tDone.")

        print("Calculating loop metadata done.")

    def show(self) -> None:
        """Plots the graph

        :return:
        """
        # print("showing")
        plt.plot()  # type: ignore
        pos = self.pos

        # draw nodes
        nx.draw_networkx_nodes(
            self.g,
            pos=pos,
            node_size=200,
            node_color="#2B85FD",
            node_shape="o",
            nodelist=[n for n in self.g.nodes if isinstance(self.node_at(n), CUNode)],
        )
        nx.draw_networkx_nodes(
            self.g,
            pos=pos,
            node_size=200,
            node_color="#ff5151",
            node_shape="d",
            nodelist=[n for n in self.g.nodes if isinstance(self.node_at(n), LoopNode)],
        )
        nx.draw_networkx_nodes(
            self.g,
            pos=pos,
            node_size=200,
            node_color="grey",
            node_shape="s",
            nodelist=[n for n in self.g.nodes if isinstance(self.node_at(n), DummyNode)],
        )
        nx.draw_networkx_nodes(
            self.g,
            pos=pos,
            node_size=200,
            node_color="#cf65ff",
            node_shape="s",
            nodelist=[n for n in self.g.nodes if isinstance(self.node_at(n), FunctionNode)],
        )
        nx.draw_networkx_nodes(
            self.g,
            pos=pos,
            node_color="yellow",
            node_shape="h",
            node_size=250,
            nodelist=[n for n in self.g.nodes if self.node_at(n).name == "main"],
        )
        # id as label
        labels = {}
        for n in self.g.nodes:
            labels[n] = str(self.g.nodes[n]["data"])
        nx.draw_networkx_labels(self.g, pos, labels, font_size=7)

        nx.draw_networkx_edges(
            self.g,
            pos,
            edgelist=[e for e in self.g.edges(data="data") if e[2].etype == EdgeType.CHILD],
        )
        nx.draw_networkx_edges(
            self.g,
            pos,
            edge_color="green",
            edgelist=[e for e in self.g.edges(data="data") if e[2].etype == EdgeType.SUCCESSOR],
        )
        nx.draw_networkx_edges(
            self.g,
            pos,
            edge_color="red",
            edgelist=[e for e in self.g.edges(data="data") if e[2].etype == EdgeType.DATA],
        )
        nx.draw_networkx_edges(
            self.g,
            pos,
            edge_color="yellow",
            edgelist=[e for e in self.g.edges(data="data") if e[2].etype == EdgeType.CALLSNODE],
        )
        nx.draw_networkx_edges(
            self.g,
            pos,
            edge_color="orange",
            edgelist=[e for e in self.g.edges(data="data") if e[2].etype == EdgeType.PRODUCE_CONSUME],
        )

        plt.show()
        plt.savefig("graphX.svg")

    def node_at(self, node_id: NodeID) -> Node:
        """Gets node data by node id

        :param node_id: id of the node
        :return: Node
        """
        return cast(Node, self.g.nodes[node_id]["data"])

    def __cu_equal__(self, cu_1: Node, cu_2: Node) -> bool:
        """Alternative to CUNode.__eq__, bypasses the isinstance-check and relies on MyPy for type safety.
        :param cu_1: CUNode 1
        :param cu_2: CUNode 2
        :return: True, if cu_1 == cu_2. False, else"""
        if cu_1.file_id == cu_2.file_id and cu_1.node_id == cu_2.node_id:
            return True
        return False

    def get_node_parent_id(self, node: Node) -> Optional[NodeID]:
        """Returns the id of the FunctionNode which is the parent of the given node"""
        parents = [s for s, t, d in in_edges(self, node.id, EdgeType.CHILD)]
        if len(parents) == 0:
            return None
        elif len(parents) == 1:
            return parents[0]
        else:
            # it is possible that a node has a function-type and e.g. loop type parent
            # in this case, return the non-function type parent, since it will be a child of the function itself.
            if len(parents) > 2:
                raise ValueError("Node: ", node.id, "has too many parents!")
            else:
                for parent in parents:
                    if type(self.node_at(parent)) != FunctionNode:
                        return parent
        return None

    def get_dep(self, node: Node, dep_type: DepType, reversed: bool) -> List[Tuple[NodeID, NodeID, Dependency]]:
        """Searches all dependencies of specified type

        :param node: node
        :param dep_type: type of dependency
        :param reversed: if true the it looks for incoming dependencies
        :return: list of dependencies
        """
        return [
            e
            for e in (in_edges(self, node.id, EdgeType.DATA) if reversed else out_edges(self, node.id, EdgeType.DATA))
            if e[2].dtype == dep_type
        ]

    def path(self, source: Node, target: Node) -> List[Node]:
        """DFS from source to target over edges of child type

        :param source: source node
        :param target: target node
        :return: list of nodes from source to target
        """
        return self.__path_rec(source, target, set())

    def __path_rec(self, source: Node, target: Node, visited: Set[Node]) -> List[Node]:
        """DFS from source to target over edges of child type

        :param source: source node
        :param target: target node
        :return: list of nodes from source to target
        """
        visited.add(source)
        if source == target:
            return [source]

        for child in [c for c in direct_children_or_called_nodes(self, source) if c not in visited]:
            path = self.__path_rec(child, target, visited)
            if path:
                path.insert(0, source)
                return path
        return []
