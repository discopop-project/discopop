# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

from __future__ import annotations

import copy
import sys
from typing import Dict, List, Sequence, Tuple, Set, Optional, Type, TypeVar, cast, Union, overload
from enum import IntEnum, Enum
import itertools

import jsonpickle  # type:ignore
import matplotlib.pyplot as plt  # type:ignore
import networkx as nx  # type:ignore
from lxml.objectify import ObjectifiedElement  # type:ignore

from .parser import readlineToCUIdMap, writelineToCUIdMap, DependenceItem
from .variable import Variable

node_props = [
    ("BasicBlockID", "string", "''"),
    ("pipeline", "float", "0"),
    ("doAll", "bool", "False"),
    ("geomDecomp", "bool", "False"),
    ("reduction", "bool", "False"),
    ("mwType", "int", "2"),
    ("localVars", "object", "[]"),
    ("globalVars", "object", "[]"),
    ("args", "object", "[]"),
    ("recursiveFunctionCalls", "object", "[]"),
]

edge_props = [
    ("type", "string"),
    ("source", "string"),
    ("sink", "string"),
    ("var", "string"),
    ("dtype", "string"),
]


def parse_id(node_id: str) -> Tuple[int, int]:
    split = node_id.split(":")
    return int(split[0]), int(split[1])


class EdgeType(Enum):
    CHILD = 0
    SUCCESSOR = 1
    DATA = 2
    CALLSNODE = 3
    PRODUCE_CONSUME = 4


class DepType(Enum):
    RAW = 0
    WAR = 1
    WAW = 2
    INIT = 3


class NodeType(IntEnum):
    CU = 0
    FUNC = 1
    LOOP = 2
    DUMMY = 3


class MWType(Enum):
    NONE = 0
    ROOT = 1
    FORK = 2
    WORKER = 3
    BARRIER = 4
    BARRIER_WORKER = 5


class NodeID(str):
    # simpler but still strong typing alternative:
    # NodeID = NewType("NodeID", str) or remove __init__
    def __init__(self, id_string: str):
        # check format of newly created NodeID's
        if ":" not in id_string:
            raise ValueError("Mal-formatted NodeID: ", id_string)
        split_id: List[str] = id_string.split(":")
        if len(split_id) != 2:
            raise ValueError("Mal-formatted NodeID: ", id_string)
        try:
            int(split_id[0])
            int(split_id[1])
        except ValueError:
            raise ValueError("Mal-formatted NodeID: ", id_string)


class LineID(str):
    # simpler but still strong typing alternative:
    # LineID = NewType("LineID", str) or remove __init__
    def __init__(self, id_string: str):
        # check format of newly created LineID's
        if ":" not in id_string:
            raise ValueError("Mal-formatted LineID: ", id_string)
        split_id: List[str] = id_string.split(":")
        if len(split_id) != 2:
            raise ValueError("Mal-formatted LineID: ", id_string)
        try:
            int(split_id[0])
            int(split_id[1])
        except ValueError:
            raise ValueError("Mal-formatted LineID: ", id_string)


class MemoryRegion(str):
    # simpler but still strong typing alternative:
    def __init__(self, id_string: str):
        super().__init__()
        pass


#        # check format of newly created MemoryRegion
#        try:
#            int(id_string)
#        except ValueError:
#            raise ValueError("Mal-formatted MemoryRegion identifier: ", id_string)


class Dependency:
    etype: EdgeType
    dtype: Optional[DepType] = None
    var_name: Optional[str] = None
    memory_region: Optional[MemoryRegion] = None
    source_line: Optional[LineID] = None
    sink_line: Optional[LineID] = None
    intra_iteration: bool = False

    def __init__(self, type: EdgeType):
        self.etype = type

    def __str__(self):
        return self.var_name if self.var_name is not None else str(self.etype)


# TODO make the Node class abstract
class Node:
    # properties of every Node
    id: NodeID
    file_id: int
    node_id: int
    start_line: int
    end_line: int
    type: NodeType
    name: str
    parent_function_id: Optional[
        NodeID
    ] = None  # metadata to speedup some calculations (TODO FunctionNodes have themselves as parent)

    # properties of CU Nodes
    node_calls: List[Dict[str, str]] = []
    recursive_function_calls: List[str] = []

    # properties related to pattern analysis
    reduction: bool = False
    do_all: bool = False
    geometric_decomposition: bool = False
    pipeline: float = -1
    tp_contains_task: bool = False
    tp_contains_taskwait: bool = False
    tp_omittable: bool = False
    mw_type = MWType.FORK

    def __init__(self, node_id: NodeID):
        self.id = node_id
        self.file_id, self.node_id = parse_id(node_id)

    @classmethod
    def from_kwargs(cls, node_id: NodeID, **kwargs):
        node = cls(node_id)
        for key, value in kwargs.items():
            setattr(node, key, value)
        return node

    def start_position(self) -> LineID:
        """Start position file_id:line
        e.g. 23:45

        :return:
        """

        return LineID(f"{self.file_id}:{self.start_line}")

    def end_position(self) -> LineID:
        """End position file_id:line
        e.g. 23:45

        :return:
        """
        return LineID(f"{self.file_id}:{self.end_line}")

    def contains_line(self, other_line) -> bool:
        if other_line == "GlobalVar":
            return False
        other_file_id = int(other_line.split(":")[0])
        other_line_num = int(other_line.split(":")[1])
        if other_file_id != self.file_id:
            return False
        if other_line_num >= self.start_line and other_line_num <= self.end_line:
            return True
        return False

    def __str__(self):
        return self.id

    def __eq__(self, other):
        return (
            isinstance(other, Node)
            and other.file_id == self.file_id
            and other.node_id == self.node_id
        )

    def __hash__(self):
        return hash(self.id)

    def get_parent_id(self, pet: PETGraphX) -> Optional[NodeID]:
        parents = [s for s, t, d in pet.in_edges(self.id, EdgeType.CHILD)]
        if len(parents) == 0:
            return None
        elif len(parents) == 1:
            return parents[0]
        else:
            # it is possible that a node has a function-type and e.g. loop type parent
            # in this case, return the non-function type parent, since it will be a child of the function itself.
            if len(parents) > 2:
                raise ValueError("Node: ", self.id, "has too many parents!")
            else:
                for parent in parents:
                    if type(pet.node_at(parent)) != FunctionNode:
                        return parent
        return None


# Data.xml: type="0"
class CUNode(Node):
    # instructions_count: int = -1
    basic_block_id = ""
    return_instructions_count: int = -1
    local_vars: List[Variable] = []
    global_vars: List[Variable] = []
    performs_file_io: bool = False

    def __init__(self, node_id: NodeID):
        super().__init__(node_id)
        self.type = NodeType.CU


# Data.xml: type="2"
class LoopNode(Node):
    loop_iterations: int = -1

    def __init__(self, node_id: NodeID):
        super().__init__(node_id)
        self.type = NodeType.LOOP


# Data.xml: type="3"
class DummyNode(Node):
    args: List[Variable] = []

    def __init__(self, node_id: NodeID):
        super().__init__(node_id)
        self.type = NodeType.DUMMY


# Data.xml: type="1"
class FunctionNode(Node):
    args: List[Variable] = []
    children_cu_ids: Optional[List[NodeID]] = None  # metadata to speedup some calculations
    reachability_pairs: Dict[NodeID, Set[NodeID]]
    immediate_post_dominators: Dict[NodeID, NodeID]
    immediate_post_dominators_present: bool

    def __init__(self, node_id: NodeID):
        super().__init__(node_id)
        self.type = NodeType.FUNC
        self.reachability_pairs = dict()
        self.immediate_post_dominators_present = False

    def get_entry_cu_id(self, pet: PETGraphX) -> NodeID:

        for child_cu_id in [t for s, t, d in pet.out_edges(self.id, EdgeType.CHILD)]:
            if len(pet.in_edges(child_cu_id, EdgeType.SUCCESSOR)) == 0:
                return child_cu_id
        raise ValueError("Mal-formatted function: ", self.id, " - No entry CU found!")

    def get_exit_cu_ids(self, pet: PETGraphX) -> Set[NodeID]:
        exit_cu_ids: Set[NodeID] = set()
        if self.children_cu_ids is not None:
            for child_cu_id in cast(List[NodeID], self.children_cu_ids):
                if (
                    len(pet.out_edges(child_cu_id, EdgeType.SUCCESSOR)) == 0
                    and len(pet.in_edges(child_cu_id, EdgeType.SUCCESSOR)) != 0
                ):
                    exit_cu_ids.add(child_cu_id)
        return exit_cu_ids

    def calculate_reachability_pairs(self, pet: PETGraphX):
        # create graph copy and remove all but successor edges
        copied_graph = pet.g.copy()

        # remove all but successor edges
        to_be_removed = set()
        for edge in copied_graph.edges:
            edge_data = cast(Dependency, copied_graph.edges[edge]["data"])
            if edge_data.etype != EdgeType.SUCCESSOR:
                to_be_removed.add(edge)
        for edge in to_be_removed:
            copied_graph.remove_edge(edge[0], edge[1])

        # calculate dfs successors for children CUs
        for node_id in cast(List[NodeID], self.children_cu_ids):
            self.reachability_pairs[node_id] = {node_id}
            successors = [t for s, t in nx.dfs_tree(copied_graph, node_id).edges()]
            self.reachability_pairs[node_id].update(successors)
        pass

    def get_immediate_post_dominators(self, pet: PETGraphX) -> Dict[NodeID, NodeID]:
        if self.immediate_post_dominators_present:
            import sys

            print("METADATA HIT! ", self.node_id, file=sys.stderr)
            return self.immediate_post_dominators
        else:
            # copy graph since edges need to be removed
            copied_graph = pet.g.copy()
            exit_cu_ids = self.get_exit_cu_ids(pet)
            # remove all but successor edges
            to_be_removed = set()
            for edge in copied_graph.edges:
                edge_data = cast(Dependency, copied_graph.edges[edge]["data"])
                if edge_data.etype != EdgeType.SUCCESSOR:
                    to_be_removed.add(edge)
            for edge in to_be_removed:
                copied_graph.remove_edge(edge[0], edge[1])

            # reverse edges
            immediate_post_dominators: Set[Tuple[NodeID, NodeID]] = set()
            for exit_cu_id in exit_cu_ids:
                immediate_post_dominators.update(
                    nx.immediate_dominators(copied_graph.reverse(), exit_cu_id).items()
                )

            immediate_post_dominators_dict = dict(immediate_post_dominators)

            # find post dominator outside parent, if type(parent) != function
            self.immediate_post_dominators = dict()
            for node_id in cast(List[NodeID], self.children_cu_ids):
                if type(pet.node_at(node_id)) != CUNode:
                    continue
                # initialize search with immediate post dominator
                if node_id not in immediate_post_dominators_dict:
                    immediate_post_dominators_dict[node_id] = node_id
                post_dom_id = immediate_post_dominators_dict[node_id]
                visited = set()
                use_original = False
                while (
                    pet.node_at(node_id).get_parent_id(pet)
                    == pet.node_at(post_dom_id).get_parent_id(pet)
                    and type(pet.node_at(cast(NodeID, pet.node_at(post_dom_id).get_parent_id(pet))))
                    != FunctionNode
                ):
                    if post_dom_id in visited:
                        # cycle detected!
                        use_original = True
                        break

                    visited.add(post_dom_id)
                    new_post_dom_id = immediate_post_dominators_dict[post_dom_id]
                    import sys

                    print("Post dom: ", post_dom_id, file=sys.stderr)
                    print("New post dom: ", new_post_dom_id, file=sys.stderr)
                    print(file=sys.stderr)
                    if post_dom_id == new_post_dom_id:
                        break
                    post_dom_id = new_post_dom_id
                if not use_original:
                    # found post dom
                    self.immediate_post_dominators[node_id] = post_dom_id
            self.immediate_post_dominators_present = True
            return self.immediate_post_dominators


def parse_cu(node: ObjectifiedElement) -> Node:
    node_id = node.get("id")
    node_type = NodeType(int(node.get("type")))

    n: Node
    # CU Node
    if node_type == NodeType.CU:
        n = CUNode(node_id)
        if hasattr(node.localVariables, "local"):
            n.local_vars = [
                Variable(
                    v.get("type"),
                    v.text,
                    v.get("defLine"),
                    v.get("accessMode"),
                    int(v.get("sizeInByte")),
                )
                for v in node.localVariables.local
            ]
        if hasattr(node.globalVariables, "global"):
            n.global_vars = [
                Variable(
                    v.get("type"),
                    v.text,
                    v.get("defLine"),
                    v.get("accessMode"),
                    int(v.get("sizeInByte")),
                )
                for v in getattr(node.globalVariables, "global")
            ]
        if hasattr(node, "BasicBlockID"):
            n.basic_block_id = getattr(node, "BasicBlockID")
        if hasattr(node, "returnInstructions"):
            n.return_instructions_count = int(getattr(node, "returnInstructions").get("count"))
        if hasattr(node.callsNode, "nodeCalled"):
            n.node_calls = [
                {"cuid": v.text, "atLine": v.get("atLine")}
                for v in getattr(node.callsNode, "nodeCalled")
                if v.get("atLine") is not None
            ]
        if hasattr(node, "callsNode") and hasattr(node.callsNode, "recursiveFunctionCall"):
            n.recursive_function_calls = [n.text for n in node.callsNode.recursiveFunctionCall]
        if hasattr(node, "performsFileIO"):
            n.performs_file_io = True if int(getattr(node, "performsFileIO")) == 1 else False
        # n.instructions_count = node.get("instructionsCount", 0)

    # FUNC or DUMMY NODE
    elif node_type == NodeType.DUMMY or node_type == NodeType.FUNC:
        dummy_or_func: Union[DummyNode, FunctionNode]
        if node_type == NodeType.DUMMY:
            dummy_or_func = DummyNode(node_id)
        else:
            dummy_or_func = FunctionNode(node_id)
        if hasattr(node, "funcArguments") and hasattr(node.funcArguments, "arg"):
            dummy_or_func.args = [
                Variable(
                    v.get("type"), v.text, v.get("defLine"), sizeInByte=int(v.get("sizeInByte"))
                )
                for v in node.funcArguments.arg
            ]
        n = dummy_or_func

    # LOOP Node
    elif node_type == NodeType.LOOP:
        n = LoopNode(node_id)
    else:
        assert False, "invalid NodeType"

    _, n.start_line = parse_id(node.get("startsAtLine"))
    _, n.end_line = parse_id(node.get("endsAtLine"))
    n.name = node.get("name")

    return n


def parse_dependency(dep: DependenceItem) -> Dependency:
    d = Dependency(EdgeType.DATA)
    d.source_line = dep.source
    d.sink_line = dep.sink
    # check for intra-iteration dependencies
    if dep.type.endswith("_II"):
        d.intra_iteration = True
        d.dtype = DepType[dep.type[0:-3]]  # remove _II tag
    else:
        d.dtype = DepType[dep.type]
    d.var_name = dep.var_name
    d.memory_region = dep.memory_region
    return d


class PETGraphX(object):
    g: nx.MultiDiGraph
    reduction_vars: List[Dict[str, str]]
    main: Node
    pos: Dict

    def __init__(self, g: nx.MultiDiGraph, reduction_vars: List[Dict[str, str]], pos):
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
        loop_data: Dict[str, int],
        reduction_vars: List[Dict[str, str]],
    ):
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
                node.loop_iterations = loop_data.get(node.start_position(), 0)

        print("\tAdded iterations...")

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
                    for var in itertools.chain(sink_node.local_vars, sink_node.global_vars):
                        vars_in_sink_node.add(var.name)
                    for var in itertools.chain(source_node.local_vars, source_node.global_vars):
                        vars_in_source_node.add(var.name)

                    if (
                        dep.var_name not in vars_in_sink_node
                        and dep.var_name not in vars_in_source_node
                    ):
                        continue
                    if sink_cu_id and source_cu_id:
                        g.add_edge(sink_cu_id, source_cu_id, data=parse_dependency(dep))
        return cls(g, reduction_vars, pos)

    def calculateFunctionMetadata(self) -> None:
        # store id of parent function in each node
        # and store in each function node a list of all children ids
        func_nodes = self.all_nodes(FunctionNode)
        for idx, func_node in enumerate(func_nodes):
            print("Calculating metadata for function: ", idx, " / ", len(func_nodes))
            stack: List[Node] = self.direct_children(func_node)
            func_node.children_cu_ids = [node.id for node in stack]

            while stack:
                child = stack.pop()
                child.parent_function_id = func_node.id
                children = self.direct_children(child)
                func_node.children_cu_ids.extend([node.id for node in children])
                stack.extend(children)

            func_node.calculate_reachability_pairs(self)
        print("Metadata calculation done.")

    def show(self):
        """Plots the graph

        :return:
        """
        # print("showing")
        plt.plot()
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
            edgelist=[
                e for e in self.g.edges(data="data") if e[2].etype == EdgeType.PRODUCE_CONSUME
            ],
        )

        # plt.show()
        plt.savefig("graphX.svg")

    def node_at(self, node_id: NodeID) -> Node:
        """Gets node data by node id

        :param node_id: id of the node
        :return: Node
        """
        return self.g.nodes[node_id]["data"]

    # generic type for subclasses of Node
    NodeT = TypeVar("NodeT", bound=Node)

    @overload
    def all_nodes(self) -> List[Node]:
        ...

    @overload
    def all_nodes(self, type: Union[Type[NodeT], Tuple[Type[NodeT], ...]]) -> List[NodeT]:
        ...

    def all_nodes(self, type=Node):
        """List of all nodes of specified type

        :param type: type(s) of nodes
        :return: List of all nodes
        """
        return [n[1] for n in self.g.nodes(data="data") if isinstance(n[1], type)]

    def out_edges(
        self, node_id: NodeID, etype: Optional[Union[EdgeType, List[EdgeType]]] = None
    ) -> List[Tuple[NodeID, NodeID, Dependency]]:
        """Get outgoing edges of node of specified type

        :param node_id: id of the source node
        :param etype: type of edges
        :return: list of outgoing edges
        """
        if etype is None:
            return [t for t in self.g.out_edges(node_id, data="data")]
        elif type(etype) == list:
            return [t for t in self.g.out_edges(node_id, data="data") if t[2].etype in etype]
        else:
            return [t for t in self.g.out_edges(node_id, data="data") if t[2].etype == etype]

    def in_edges(
        self, node_id: NodeID, etype: Optional[Union[EdgeType, List[EdgeType]]] = None
    ) -> List[Tuple[NodeID, NodeID, Dependency]]:
        """Get incoming edges of node of specified type

        :param node_id: id of the target node
        :param etype: type of edges
        :return: list of incoming edges
        """
        if etype is None:
            return [t for t in self.g.in_edges(node_id, data="data")]
        elif type(etype) == list:
            return [t for t in self.g.in_edges(node_id, data="data") if t[2].etype in etype]
        else:
            return [t for t in self.g.in_edges(node_id, data="data") if t[2].etype == etype]

    @overload
    def subtree_of_type(self, root: Node) -> List[Node]:
        ...

    @overload
    def subtree_of_type(
        self, root: Node, type: Union[Type[NodeT], Tuple[Type[NodeT], ...]]
    ) -> List[NodeT]:
        ...

    def subtree_of_type(self, root, type=Node):
        """Gets all nodes in subtree of specified type including root

        :param root: root node
        :param type: type of children, None is equal to a wildcard
        :return: list of nodes in subtree
        """
        return self.subtree_of_type_rec(root, set(), type)

    @overload
    def subtree_of_type_rec(self, root: Node, visited: Set[Node]) -> List[Node]:
        ...

    @overload
    def subtree_of_type_rec(
        self, root: Node, visited: Set[Node], type: Union[Type[NodeT], Tuple[Type[NodeT], ...]]
    ) -> List[NodeT]:
        ...

    def subtree_of_type_rec(self, root, visited, type=Node):
        """recursive helper function for subtree_of_type"""
        # check if root is of type target
        res = []
        if isinstance(root, type):
            res.append(root)

        # append root to visited
        visited.add(root)

        # enter recursion
        for _, target, _ in self.out_edges(root.id, [EdgeType.CHILD, EdgeType.CALLSNODE]):
            # prevent cycles
            if self.node_at(target) in visited:
                continue
            res += self.subtree_of_type_rec(self.node_at(target), visited, type)

        return res

    def __cu_equal__(self, cu_1: Node, cu_2: Node):
        """Alternative to CUNode.__eq__, bypasses the isinstance-check and relies on MyPy for type safety.
        :param cu_1: CUNode 1
        :param cu_2: CUNode 2
        :return: True, if cu_1 == cu_2. False, else"""
        if cu_1.file_id == cu_2.file_id and cu_1.node_id == cu_2.node_id:
            return True
        return False

    def direct_successors(self, root: Node) -> List[Node]:
        """Gets only direct successors of any type

        :param root: root node
        :return: list of direct successors
        """
        return [self.node_at(t) for s, t, d in self.out_edges(root.id, EdgeType.SUCCESSOR)]

    def direct_children_or_called_nodes(self, root: Node) -> List[Node]:
        """Gets direct children of any type. Also includes nodes of called functions

        :param root: root node
        :return: list of direct children
        """
        return [
            self.node_at(t)
            for s, t, d in self.out_edges(root.id, [EdgeType.CHILD, EdgeType.CALLSNODE])
        ]

    def direct_children(self, root: Node) -> List[Node]:
        """Gets direct children of any type. This includes called nodes!

        :param root: root node
        :return: list of direct children
        """
        return [self.node_at(t) for s, t, d in self.out_edges(root.id, EdgeType.CHILD)]

    def direct_children_or_called_nodes_of_type(self, root: Node, type: Type[NodeT]) -> List[NodeT]:
        """Gets only direct children of specified type. This includes called nodes!

        :param root: root node
        :param type: type of children
        :return: list of direct children
        """
        nodes = [
            self.node_at(t)
            for s, t, d in self.out_edges(root.id, [EdgeType.CHILD, EdgeType.CALLSNODE])
        ]

        return [t for t in nodes if isinstance(t, type)]

    def is_reduction_var(self, line: LineID, name: str) -> bool:
        """Determines, whether or not the given variable is reduction variable

        :param line: loop line number
        :param name: variable name
        :return: true if is reduction variable
        """
        return any(
            rv for rv in self.reduction_vars if rv["loop_line"] == line and rv["name"] == name
        )

    def depends_ignore_readonly(self, source: Node, target: Node, root_loop: Node) -> bool:
        """Detects if source node or one of it's children has a RAW dependency to target node or one of it's children
        The loop index and readonly variables are ignored.

        :param source: source node for dependency detection (later occurrence in the source code)
        :param target: target of dependency (prior occurrence in the source code)
        :param root_loop: root loop
        :return: true, if there is RAW dependency"""
        if source == target:
            return False

        # get recursive children of source and target
        source_children_ids = [node.id for node in self.subtree_of_type(source, CUNode)]
        target_children_ids = [node.id for node in self.subtree_of_type(target, CUNode)]

        # get required metadata
        loop_start_lines: List[LineID] = []
        root_children = self.subtree_of_type(root_loop, (CUNode, LoopNode))
        root_children_cus = [cu for cu in root_children if isinstance(cu, CUNode)]
        root_children_loops = [cu for cu in root_children if isinstance(cu, LoopNode)]
        for v in root_children_loops:
            loop_start_lines.append(v.start_position())

        # check for RAW dependencies between any of source_children and any of target_children
        for source_child_id in source_children_ids:
            # get a list of filtered dependencies, outgoing from source_child
            out_deps = self.out_edges(source_child_id, EdgeType.DATA)
            out_raw_deps = [dep for dep in out_deps if dep[2].dtype == DepType.RAW]
            filtered_deps = [
                elem
                for elem in out_raw_deps
                if not self.is_readonly_inside_loop_body(
                    elem[2],
                    root_loop,
                    root_children_cus,
                    root_children_loops,
                    loops_start_lines=loop_start_lines,
                )
            ]
            filtered_deps = [
                elem
                for elem in filtered_deps
                if not self.is_loop_index(elem[2].var_name, loop_start_lines, root_children_cus)
            ]
            # get a list of dependency targets
            dep_targets = [t for _, t, _ in filtered_deps]
            # check if overlap between dependency targets and target_children exists.
            overlap = [node_id for node_id in dep_targets if node_id in target_children_ids]
            if len(overlap) > 0:
                # if so, a RAW dependency exists
                return True
        return False

    def unused_check_alias(self, s: NodeID, t: NodeID, d: Dependency, root_loop: Node) -> bool:
        sub = self.subtree_of_type(root_loop, CUNode)
        parent_func_sink = self.get_parent_function(self.node_at(s))
        parent_func_source = self.get_parent_function(self.node_at(t))

        res = False
        d_var_name_str = cast(str, str(d.var_name))

        if self.unused_is_global(d_var_name_str, sub) and not (
            self.is_passed_by_reference(d, parent_func_sink)
            and self.is_passed_by_reference(d, parent_func_source)
        ):
            return res
        return not res

    def unused_is_global(self, var: str, tree: Sequence[Node]) -> bool:
        """Checks if variable is global

        :param var: variable name
        :param tree: nodes to search
        :return: true if global
        """

        for node in tree:
            if isinstance(node, CUNode):
                for gv in node.global_vars:
                    if gv.name == var:
                        # TODO from tmp global vars
                        return False
        return False

    def is_passed_by_reference(self, dep: Dependency, func: FunctionNode) -> bool:
        res = False

        for i in func.args:
            if i.name == dep.var_name:
                return True
        return False

    def unused_get_first_written_vars_in_loop(
        self, undefinedVarsInLoop: List[Variable], node: Node, root_loop: Node
    ) -> Set[Variable]:
        root_children = self.subtree_of_type(root_loop, CUNode)
        loop_node_ids = [n.id for n in root_children]
        fwVars = set()

        raw = set()
        war = set()
        waw = set()
        sub = root_children
        for sub_node in sub:
            raw.update(self.get_dep(sub_node, DepType.RAW, False))
            war.update(self.get_dep(sub_node, DepType.WAR, False))
            waw.update(self.get_dep(sub_node, DepType.WAW, False))

        for var in undefinedVarsInLoop:
            if var not in fwVars:
                for i in raw:
                    if i[2].var_name == var and i[0] in loop_node_ids and i[1] in loop_node_ids:
                        for e in itertools.chain(war, waw):
                            if (
                                e[2].var_name == var
                                and e[0] in loop_node_ids
                                and e[1] in loop_node_ids
                            ):
                                if e[2].sink_line == i[2].source_line:
                                    fwVars.add(var)

        return fwVars

    def get_dep(
        self, node: Node, dep_type: DepType, reversed: bool
    ) -> List[Tuple[NodeID, NodeID, Dependency]]:
        """Searches all dependencies of specified type

        :param node: node
        :param dep_type: type of dependency
        :param reversed: if true the it looks for incoming dependencies
        :return: list of dependencies
        """
        return [
            e
            for e in (
                self.in_edges(node.id, EdgeType.DATA)
                if reversed
                else self.out_edges(node.id, EdgeType.DATA)
            )
            if e[2].dtype == dep_type
        ]

    def is_scalar_val(self, allVars: List[Variable], var: str) -> bool:
        """Checks if variable is a scalar value

        :param var: variable
        :return: true if scalar
        """
        for x in allVars:
            if x.name == var:
                return not (
                    x.type.endswith("**") or x.type.startswith("ARRAY" or x.type.startswith("["))
                )
            else:
                return False
        raise ValueError("allVars must not be empty.")

    def get_variables(self, nodes: Sequence[Node]) -> Dict[Variable, Set[MemoryRegion]]:
        """Gets all variables and corresponding memory regions in nodes

        :param nodes: nodes
        :return: Set of variables
        """
        res: Dict[Variable, Set[MemoryRegion]] = dict()
        for node in nodes:
            if isinstance(node, CUNode):
                for v in node.local_vars:
                    if v not in res:
                        res[v] = set()
                for v in node.global_vars:
                    if v not in res:
                        res[v] = set()
                # try to identify memory regions
                for var_name in res:
                    # since the variable name is checked for equality afterwards,
                    # it is safe to consider incoming dependencies at this point as well.
                    # Note that INIT type edges are considered as well!
                    for _, _, dep in self.out_edges(node.id, EdgeType.DATA) + self.in_edges(
                        node.id, EdgeType.DATA
                    ):
                        if dep.var_name == var_name.name:
                            if dep.memory_region is not None:
                                res[var_name].add(cast(MemoryRegion, dep.memory_region))
        return res

    def get_undefined_variables_inside_loop(
        self, root_loop: Node, include_global_vars: bool = False
    ) -> Dict[Variable, Set[MemoryRegion]]:
        sub = self.subtree_of_type(root_loop, CUNode)
        vars = self.get_variables(sub)
        dummyVariables = []
        definedVarsInLoop = []
        definedVarsInCalledFunctions = []

        # Remove llvm temporary variables
        for var in vars:
            if var.defLine == "LineNotFound" or "0:" in var.defLine:
                dummyVariables.append(var)
            elif not include_global_vars:
                if var.defLine == "GlobalVar" and not self.is_reduction_var(
                    root_loop.start_position(), var.name
                ):
                    dummyVariables.append(var)

        # vars = list(set(vars) ^ set(dummyVariables))
        for key in set(dummyVariables):
            if key in vars:
                del vars[key]

        # Exclude variables which are defined inside the loop
        for var in vars:
            if (
                var.defLine >= root_loop.start_position()
                and var.defLine <= root_loop.end_position()
            ):
                definedVarsInLoop.append(var)

        # vars = list(set(vars) ^ set(definedVarsInLoop))
        for key in set(definedVarsInLoop):
            if key in vars:
                del vars[key]

        # Also, exclude variables which are defined inside
        # functions that are called within the loop
        for var in vars:
            for s in sub:
                if var.defLine >= s.start_position() and var.defLine <= s.end_position():
                    definedVarsInCalledFunctions.append(var)

        # vars = list(set(vars) ^ set(definedVarsInCalledFunctions))
        for key in set(definedVarsInCalledFunctions):
            if key in vars:
                del vars[key]

        return vars

    def unused_is_first_written_in_loop(self, dep: Dependency, root_loop: Node):
        """Checks whether a variable is first written inside the current node

        :param var:
        :param raw_deps: raw dependencies of the loop
        :param war_deps: war dependencies of the loop
        :param reverse_raw_deps:
        :param reverse_war_deps:
        :param tree: subtree of the loop
        :return: true if first written
        """

        result = False
        children = self.subtree_of_type(root_loop, CUNode)

        for v in children:
            for t, d in [
                (t, d)
                for s, t, d in self.out_edges(v.id, EdgeType.DATA)
                if d.dtype == DepType.WAR or d.dtype == DepType.WAW
            ]:
                if d.var_name is None:
                    return False
                assert d.var_name is not None
                if dep.var_name == d.var_name:
                    if dep.source_line == d.sink_line:
                        result = True
                        break
                # None may occur because __get_variables doesn't check for actual elements
        return result

    def is_loop_index(
        self, var_name: Optional[str], loops_start_lines: List[LineID], children: Sequence[Node]
    ) -> bool:
        """Checks, whether the variable is a loop index.

        :param var_name: name of the variable
        :param loops_start_lines: start lines of the loops
        :param children: children nodes of the loops
        :return: true if edge represents loop index
        """

        # If there is a raw dependency for var, the source cu is part of the loop
        # and the dependency occurs in loop header, then var is loop index+

        for c in children:
            for t, d in [
                (t, d)
                for s, t, d in self.out_edges(c.id, EdgeType.DATA)
                if d.dtype == DepType.RAW and d.var_name == var_name
            ]:
                if (
                    d.sink_line == d.source_line
                    and d.source_line in loops_start_lines
                    and self.node_at(t) in children
                ):
                    return True

        return False

    def is_readonly_inside_loop_body(
        self,
        dep: Dependency,
        root_loop: Node,
        children_cus: Sequence[Node],
        children_loops: Sequence[Node],
        loops_start_lines: Optional[List[LineID]] = None,
    ) -> bool:
        """Checks, whether a variable is read-only in loop body

        :param dep: dependency variable
        :param root_loop: root loop
        :return: true if variable is read-only in loop body
        """
        if loops_start_lines is None:
            loops_start_lines = [v.start_position() for v in children_loops]

        for v in children_cus:
            for t, d in [
                (t, d)
                for s, t, d in self.out_edges(v.id, EdgeType.DATA)
                if d.dtype == DepType.WAR or d.dtype == DepType.WAW
            ]:
                # If there is a waw dependency for var, then var is written in loop
                # (sink is always inside loop for waw/war)
                if dep.memory_region == d.memory_region and not (d.sink_line in loops_start_lines):
                    return False
            for t, d in [
                (t, d) for s, t, d in self.in_edges(v.id, EdgeType.DATA) if d.dtype == DepType.RAW
            ]:
                # If there is a reverse raw dependency for var, then var is written in loop
                # (source is always inside loop for reverse raw)
                if dep.memory_region == d.memory_region and not (
                    d.source_line in loops_start_lines
                ):
                    return False
        return True

    def get_parent_function(self, node: Node) -> FunctionNode:
        """Finds the parent of a node

        :param node: current node
        :return: node of parent function
        """
        if isinstance(node, FunctionNode):
            return node
        assert node.parent_function_id
        return cast(FunctionNode, self.node_at(node.parent_function_id))

    def get_left_right_subtree(
        self, target: Node, right_subtree: bool, ignore_called_nodes: bool = False
    ) -> List[Node]:
        """Searches for all subnodes of main which are to the left or to the right of the specified node

        :param target: node that divides the tree
        :param right_subtree: true - right subtree, false - left subtree
        :return: list of nodes in the subtree
        """
        stack: List[Node] = []
        res: List[Node] = []
        visited = set()

        parent_func = self.get_parent_function(target)
        stack.append(parent_func)

        while stack:
            current = stack.pop()

            if current == target:
                return res
            if isinstance(current, CUNode):
                res.append(current)

            if current in visited:  # suppress looping
                continue
            else:
                visited.add(current)

            if not ignore_called_nodes:
                stack.extend(
                    self.direct_children_or_called_nodes(current)
                    if right_subtree
                    else reversed(self.direct_children_or_called_nodes(current))
                )
            else:
                stack.extend(
                    self.direct_children(current)
                    if right_subtree
                    else reversed(self.direct_children(current))
                )
        return res

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

        for child in [c for c in self.direct_children_or_called_nodes(source) if c not in visited]:
            path = self.__path_rec(child, target, visited)
            if path:
                path.insert(0, source)
                return path
        return []

    def get_reduction_sign(self, line: str, name: str) -> str:
        """Returns reduction operation for variable

        :param line: loop line number
        :param name: variable name
        :return: reduction operation
        """
        for rv in self.reduction_vars:
            if rv["loop_line"] == line and rv["name"] == name:
                return rv["operation"]
        return ""

    def dump_to_pickled_json(self) -> str:
        """Encodes and returns the entire Object into a pickled json string.
        The encoded string can be reconstructed into an object by using:
        jsonpickle.decode(json_str)

        :return: encoded string
        """
        return jsonpickle.encode(self)

    def check_reachability(self, target: Node, source: Node, edge_types: List[EdgeType]) -> bool:
        """check if target is reachable from source via edges of types edge_type.
        :param pet: PET graph
        :param source: CUNode
        :param target: CUNode
        :param edge_types: List[EdgeType]
        :return: Boolean"""
        if source == target:
            return True
        visited: List[str] = []
        queue = [target]
        while len(queue) > 0:
            cur_node = queue.pop(0)
            if type(cur_node) == list:
                cur_node_list = cast(List[Node], cur_node)
                cur_node = cur_node_list[0]
            visited.append(cur_node.id)
            tmp_list = [
                (s, t, e)
                for s, t, e in self.in_edges(cur_node.id)
                if s not in visited and e.etype in edge_types
            ]
            for e in tmp_list:
                if self.node_at(e[0]) == source:
                    return True
                else:
                    if e[0] not in visited:
                        queue.append(cast(Node, self.node_at(e[0])))
        return False

    def is_predecessor(self, source_id: NodeID, target_id: NodeID) -> bool:
        """returns true, if source is a predecessor of target.
        This analysis includes traversal of successor, child and calls edges."""
        # if source and target_id are located within differenct functions, consider the callees instead of source_id
        source_parent_function = self.get_parent_function(self.node_at(source_id))
        target_parent_function = self.get_parent_function(self.node_at(target_id))
        if source_parent_function != target_parent_function:
            for callee_id in [
                s for s, _, _ in self.in_edges(source_parent_function.id, EdgeType.CALLSNODE)
            ]:
                if self.is_predecessor(callee_id, target_id):
                    return True

        # if target is a loop node, get the first child of the loop, i.e. the entry node into the loop
        target_node = self.node_at(target_id)
        if target_node.type == NodeType.LOOP:
            target_id = self.direct_children(target_node)[0].id

        # perform a bfs search for target
        queue: List[NodeID] = [source_id]
        visited: List[NodeID] = []
        while queue:
            current = queue.pop(0)
            if current == target_id:
                return True
            visited.append(current)
            # add direct successors to queue
            queue += [
                n.id
                for n in self.direct_successors(self.node_at(current))
                if n.id not in visited and n.id not in queue
            ]
            # add children to queue
            queue += [
                n.id
                for n in self.direct_children(self.node_at(current))
                if n.id not in visited and n.id not in queue
            ]
            # add called functions to queue
            queue += [
                t
                for _, t, _ in self.out_edges(current, EdgeType.CALLSNODE)
                if t not in visited and t not in queue
            ]
        return False

    def check_reachability_and_get_path_nodes(
        self, target: CUNode, source: CUNode, edge_types: List[EdgeType]
    ) -> Tuple[bool, List[CUNode]]:
        """check if target is reachable from source via edges of types edge_type.
        :param pet: PET graph
        :param source: CUNode
        :param target: CUNode
        :param edge_types: List[EdgeType]
        :return: Boolean"""
        if source == target:
            return True, []

        # trivially not reachable
        if (
            self.get_parent_function(target) != self.get_parent_function(source)
            and EdgeType.CALLSNODE not in edge_types
        ):
            print("TRIVIAL FALSE!: ", source, target)
            return False, []

        visited: List[NodeID] = []
        queue: List[Tuple[CUNode, List[CUNode]]] = [(target, [])]
        while len(queue) > 0:
            cur_node, cur_path = queue.pop(0)
            if type(cur_node) == list:
                cur_node_list = cast(List[CUNode], cur_node)
                cur_node = cur_node_list[0]
            visited.append(cur_node.id)
            tmp_list = [
                (s, t, e)
                for s, t, e in self.in_edges(cur_node.id)
                if s not in visited and e.etype in edge_types
            ]
            for e in tmp_list:
                if self.node_at(e[0]) == source:
                    return True, cur_path
                else:
                    if e[0] not in visited:
                        tmp_path = copy.deepcopy(cur_path)
                        tmp_path.append(cur_node)
                        queue.append((cast(CUNode, self.node_at(e[0])), tmp_path))
        return False, []

    def dump_to_gephi_file(self, name="pet.gexf"):
        """Note: Destroys the PETGraph!"""
        # replace node data with label
        for node_id in self.g.nodes:
            tmp_cu = self.g.nodes[node_id]["data"]
            del self.g.nodes[node_id]["data"]
            self.g.nodes[node_id]["id"] = tmp_cu.id
            self.g.nodes[node_id]["type"] = str(tmp_cu.type)
        for edge in self.g.edges:
            dep: Dependency = self.g.edges[edge]["data"]
            del self.g.edges[edge]["data"]
            self.g.edges[edge]["edge_type"] = str(dep.etype.name)
            if dep.etype == EdgeType.DATA:
                self.g.edges[edge]["var"] = dep.var_name
                self.g.edges[edge]["dep_type"] = str(dep.dtype.name)
        nx.write_gexf(self.g, name)

    def get_variable(self, root_node_id: NodeID, var_name: str) -> Optional[Variable]:
        """Search for the type of the given variable by BFS searching through successor edges in reverse, starting from
        the given root node, and checking the global and local vars of each encountered CU node."""
        queue: List[NodeID] = [root_node_id]
        visited: Set[NodeID] = set()
        while queue:
            current = queue.pop(0)
            current_node = cast(CUNode, self.node_at(current))
            visited.add(current)
            variables = current_node.local_vars + current_node.global_vars
            for v in variables:
                if v.name == var_name:
                    return v
            # add predecessors of current to the list
            predecessors = [s for s, t, d in self.in_edges(current, EdgeType.SUCCESSOR)]
            for pred in predecessors:
                if pred not in visited and pred not in queue:
                    queue.append(pred)
        return None

    def get_memory_regions(self, nodes: List[CUNode], var_name: str) -> Set[MemoryRegion]:
        """check dependencies of nodes for usages of 'var_name' and extract memory regions related to this name"""
        mem_regs: Set[MemoryRegion] = set()
        for node in nodes:
            out_deps = self.out_edges(node.id, EdgeType.DATA)
            for s, t, d in out_deps:
                if d.var_name == var_name:
                    if d.memory_region is not None:
                        mem_regs.add(cast(MemoryRegion, d.memory_region))
        return mem_regs

    def get_path_nodes_between(
        self, target: CUNode, source: CUNode, edge_types: List[EdgeType]
    ) -> List[CUNode]:
        """get all nodes of all patch which allow reaching target from source via edges of types edge_type.
        :param pet: PET graph
        :param source: CUNode
        :param target: CUNode
        :param edge_types: List[EdgeType]
        :return: List of encountered nodes"""

        visited: List[NodeID] = []
        queue: List[Tuple[CUNode, List[CUNode]]] = [
            (cast(CUNode, self.node_at(t)), [])
            for s, t, d in self.out_edges(source.id, edge_types)
            if type(self.node_at(t)) == CUNode
        ]

        while len(queue) > 0:
            cur_node, cur_path = queue.pop(0)
            if type(cur_node) == list:
                cur_node_list = cast(List[CUNode], cur_node)
                cur_node = cur_node_list[0]
            visited.append(cur_node.id)
            tmp_list = [
                (s, t, e)
                for s, t, e in self.out_edges(cur_node.id)
                if t not in visited and e.etype in edge_types
            ]
            for e in tmp_list:
                if self.node_at(e[1]) == target or self.node_at(e[1]) == source:
                    continue
                else:
                    if e[1] not in visited:
                        tmp_path = copy.deepcopy(cur_path)
                        tmp_path.append(cur_node)
                        queue.append((cast(CUNode, self.node_at(e[1])), tmp_path))
        return [cast(CUNode, self.node_at(nid)) for nid in set(visited)]
