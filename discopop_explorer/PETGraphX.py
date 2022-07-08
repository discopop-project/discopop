# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

from enum import IntEnum, Enum
from platform import node
from typing import Dict, List, Tuple, Set, Optional, cast

import matplotlib.pyplot as plt
import networkx as nx  # type:ignore
from lxml.objectify import ObjectifiedElement  # type:ignore

from .parser import readlineToCUIdMap, writelineToCUIdMap, DependenceItem
from .variable import Variable
import time
import itertools

node_props = [
    ('BasicBlockID', 'string', '\'\''),
    ('pipeline', 'float', '0'),
    ('doAll', 'bool', 'False'),
    ('geomDecomp', 'bool', 'False'),
    ('reduction', 'bool', 'False'),
    ('mwType', 'int', '2'),
    ('localVars', 'object', '[]'),
    ('globalVars', 'object', '[]'),
    ('args', 'object', '[]'),
    ('recursiveFunctionCalls', 'object', '[]'),
]

edge_props = [
    ('type', 'string'),
    ('source', 'string'),
    ('sink', 'string'),
    ('var', 'string'),
    ('dtype', 'string'),
]


def parse_id(node_id: str) -> Tuple[int, int]:
    split = node_id.split(':')
    return int(split[0]), int(split[1])


class EdgeType(Enum):
    CHILD = 0
    SUCCESSOR = 1
    DATA = 2
    CALLSNODE = 3


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


class Dependency:
    etype: EdgeType
    dtype: Optional[DepType] = None
    var_name: Optional[str] = None
    source: Optional[str] = None
    sink: Optional[str] = None

    def __init__(self, type: EdgeType):
        self.etype = type

    def __str__(self):
        return self.var_name if self.var_name is not None else str(self.etype)


class CUNode:
    id: str
    file_id: int
    node_id: int
    source_file: int
    start_line: int
    end_line: int
    type: NodeType
    name: str
    instructions_count: int = -1
    return_instructions_count: int = -1
    loop_iterations: int = -1
    mw_type = MWType.FORK
    basic_block_id = ""
    recursive_function_calls: List[str] = []
    node_calls: List[Dict[str, str]] = []
    reduction: bool = False
    do_all: bool = False
    geometric_decomposition: bool = False
    pipeline: float = -1
    local_vars: List[Variable] = []
    global_vars: List[Variable] = []
    args: List[Variable] = []
    tp_contains_task: bool = False
    tp_contains_taskwait: bool = False
    tp_omittable: bool = False

    def __init__(self, node_id: str):
        self.id = node_id
        self.file_id, self.node_id = parse_id(node_id)

    @classmethod
    def from_kwargs(cls, node_id: str, **kwargs):
        node = cls(node_id)
        for key, value in kwargs.items():
            setattr(node, key, value)
        return node

    def start_position(self) -> str:
        """Start position file_id:line
        e.g. 23:45

        :return:
        """
        return f'{self.source_file}:{self.start_line}'

    def end_position(self) -> str:
        """End position file_id:line
        e.g. 23:45

        :return:
        """
        return f'{self.source_file}:{self.end_line}'

    def __str__(self):
        return self.id

    def __eq__(self, other):
        if isinstance(other, CUNode):
            return other.id == self.id
        else:
            return False

    def __hash__(self):
        return hash(id)


def parse_cu(node: ObjectifiedElement) -> CUNode:
    n = CUNode(node.get("id"))
    n.type = NodeType(int(node.get("type")))
    n.source_file, n.start_line = parse_id(node.get("startsAtLine"))
    _, n.end_line = parse_id(node.get("endsAtLine"))
    n.name = node.get("name")
    n.instructions_count = node.get("instructionsCount", 0)

    if hasattr(node, 'funcArguments') and hasattr(node.funcArguments, 'arg'):
        n.args = [Variable(v.get('type'), v.text, v.get('defLine'))
                  for v in node.funcArguments.arg]

    if hasattr(node, 'callsNode') and hasattr(node.callsNode, 'recursiveFunctionCall'):
        n.recursive_function_calls = [
            n.text for n in node.callsNode.recursiveFunctionCall]

    if n.type == NodeType.CU:
        if hasattr(node.localVariables, 'local'):
            n.local_vars = [Variable(v.get('type'), v.text, v.get('defLine'))
                            for v in node.localVariables.local]
        if hasattr(node.globalVariables, 'global'):
            n.global_vars = [Variable(v.get('type'), v.text, v.get('defLine'))
                             for v in getattr(node.globalVariables, 'global')]
        if hasattr(node, 'BasicBlockID'):
            n.basic_block_id = getattr(node, 'BasicBlockID')
        if hasattr(node, 'returnInstructions'):
            n.return_instructions_count = int(
                getattr(node, 'returnInstructions').get('count'))
        if hasattr(node.callsNode, 'nodeCalled'):
            n.node_calls = [{"cuid": v.text,  "atLine": v.get('atLine')} for v in getattr(
                node.callsNode, 'nodeCalled') if v.get('atLine') is not None]
    return n


def parse_dependency(dep) -> Dependency:
    d = Dependency(EdgeType.DATA)
    d.source = dep.source
    d.sink = dep.sink
    d.dtype = DepType[dep.type]
    d.var_name = dep.var_name
    return d


class PETGraphX(object):
    g: nx.MultiDiGraph
    reduction_vars: List[Dict[str, str]]
    main: CUNode
    pos: Dict

    def __init__(self, g: nx.MultiDiGraph, reduction_vars: List[Dict[str, str]], pos):
        self.g = g
        self.reduction_vars = reduction_vars
        for _, node in g.nodes(data='data'):
            if node.name == "main":
                self.main = node
        self.pos = pos

    @classmethod
    def from_parsed_input(cls, cu_dict: Dict[str, ObjectifiedElement], dependencies_list: List[DependenceItem],
                          loop_data: Dict[str, int], reduction_vars: List[Dict[str, str]]):
        """Constructor for making a PETGraphX from the output of parser.parse_inputs()"""
        # t1 = time.time()
        g = nx.MultiDiGraph()
        # t2 = time.time()
        # print(f"MultiDiGraph: {t2-t1}")

        for id, node in cu_dict.items():
            n = parse_cu(node)
            g.add_node(id, data=n)
        # t3 = time.time()
        # print(f"for id, node in cu_dict.items(): {t3-t2}")

        for node_id, node in cu_dict.items():
            source = node_id
            if 'childrenNodes' in dir(node):
                for child in [n.text for n in node.childrenNodes]:
                    if child not in g:
                        print(f"WARNING: no child node {child} found")
                    g.add_edge(source, child, data=Dependency(EdgeType.CHILD))
            if 'successors' in dir(node) and 'CU' in dir(node.successors):
                for successor in [n.text for n in node.successors.CU]:
                    if successor not in g:
                        print(f"WARNING: no successor node {successor} found")
                    g.add_edge(source, successor,
                               data=Dependency(EdgeType.SUCCESSOR))

            # 28.02.2022 as a merge conflict to ClassificationBug added
            if 'callsNode' in dir(node) and 'nodeCalled' in dir(node.callsNode):
                for nodeCalled in [n.text for n in node.callsNode.nodeCalled]:
                    if nodeCalled not in g:
                        print(f"WARNING: no nodeCalled {nodeCalled} found")
                    g.add_edge(source, nodeCalled,
                               data=Dependency(EdgeType.CALLSNODE))

        # t4 = time.time()
        # print(f"for node_id, node in cu_dict.items(): {t4-t3}")

        for _, node in g.nodes(data='data'):
            if node.type == NodeType.LOOP:
                node.loop_iterations = loop_data.get(node.start_position(), 0)
        # t5 = time.time()
        # print(f"for _, node in g.nodes(data='data'): {t5-t4}")

        # calculate position before dependencies affect them
        try:
            pos = nx.planar_layout(g)  # good
        except nx.exception.NetworkXException:
            try:
                # fallback layouts
                pos = nx.shell_layout(g)  # maybe
                # pos = nx.kamada_kawai_layout(g)  # maybe tooo slow
            except nx.exception.NetworkXException:
                pos = nx.random_layout(g)
        # t6 = time.time()
        # print(f"try: {t6-t5}")
        for dep in dependencies_list:
            print("\nDEP: ", dep.var_name)
            print(readlineToCUIdMap)
            if dep.type == 'INIT':
                sink = readlineToCUIdMap[dep.sink]
                for s in sink:
                    g.add_edge(s, s, data=parse_dependency(dep))
                continue

            sink_cu_ids = readlineToCUIdMap[dep.sink]
            source_cu_ids = writelineToCUIdMap[dep.source]
            print("SINKS: ", sink_cu_ids)
            print("SOURCES: ", source_cu_ids)
            for sink_cu_id in sink_cu_ids:
                for source_cu_id in source_cu_ids:

                    # 28.02.2022: Removed as a merge conflict with ClassificationBug
                    # if sink_cu_id == source_cu_id and (dep.type == 'WAR' or dep.type == 'WAW'):
                    #    continue
                    # elif sink_cu_id and source_cu_id:
                    #    g.add_edge(sink_cu_id, source_cu_id,
                    #               data=parse_dependency(dep))

                    sink_node = g.nodes[sink_cu_id]['data']
                    source_node = g.nodes[source_cu_id]['data']
                    vars_in_sink_node = set()
                    vars_in_source_node = set()
                    for var in itertools.chain(sink_node.local_vars, sink_node.global_vars):
                        vars_in_sink_node.add(var.name)
                    for var in itertools.chain(source_node.local_vars, source_node.global_vars):
                        vars_in_source_node.add(var.name)

                    if(dep.var_name not in vars_in_sink_node and
                            dep.var_name not in vars_in_source_node):
                        continue
                        # if sink_cu_id == source_cu_id and (dep.type == 'WAR' or dep.type == 'WAW'):
                        #     continue
                    if sink_cu_id and source_cu_id:
                        g.add_edge(sink_cu_id, source_cu_id,
                                   data=parse_dependency(dep))
        # t7 = time.time()
        # print(f"for dep in dependencies_list: {t7-t6}")
        return cls(g, reduction_vars, pos)

    def show(self):
        """Plots the graph

        :return:
        """
        # print("showing")
        plt.plot()
        pos = self.pos

        # draw nodes
        nx.draw_networkx_nodes(self.g, pos=pos, node_size=200, node_color='#2B85FD', node_shape='o',
                               nodelist=[n for n in self.g.nodes if self.node_at(n).type == NodeType.CU])
        nx.draw_networkx_nodes(self.g, pos=pos, node_size=200, node_color='#ff5151', node_shape='d',
                               nodelist=[n for n in self.g.nodes if self.node_at(n).type == NodeType.LOOP])
        nx.draw_networkx_nodes(self.g, pos=pos, node_size=200, node_color='grey', node_shape='s',
                               nodelist=[n for n in self.g.nodes if self.node_at(n).type == NodeType.DUMMY])
        nx.draw_networkx_nodes(self.g, pos=pos, node_size=200, node_color='#cf65ff', node_shape='s',
                               nodelist=[n for n in self.g.nodes if self.node_at(n).type == NodeType.FUNC])
        nx.draw_networkx_nodes(self.g, pos=pos, node_color='yellow', node_shape='h', node_size=250,
                               nodelist=[n for n in self.g.nodes if self.node_at(n).name == 'main'])
        # id as label
        labels = {}
        for n in self.g.nodes:
            labels[n] = str(self.g.nodes[n]['data'])
        nx.draw_networkx_labels(self.g, pos, labels, font_size=7)

        nx.draw_networkx_edges(self.g, pos,
                               edgelist=[e for e in self.g.edges(data='data') if e[2].etype == EdgeType.CHILD])
        nx.draw_networkx_edges(self.g, pos, edge_color='green',
                               edgelist=[e for e in self.g.edges(data='data') if e[2].etype == EdgeType.SUCCESSOR])
        nx.draw_networkx_edges(self.g, pos, edge_color='red',
                               edgelist=[e for e in self.g.edges(data='data') if e[2].etype == EdgeType.DATA])
        nx.draw_networkx_edges(self.g, pos, edge_color='yellow',
                               edgelist=[e for e in self.g.edges(data='data') if e[2].etype == EdgeType.CALLSNODE])

        # plt.figure(figsize=(12, 12))
        # nx.spring_layout(self.g, k=0.1, iterations=20)
        plt.show()
        plt.savefig('graphX.svg')

    def node_at(self, node_id: str) -> CUNode:
        """Gets node data by node id

        :param node_id: id of the node
        :return: Node
        """
        return self.g.nodes[node_id]['data']

    def all_nodes(self, type: NodeType = None) -> List[CUNode]:
        """List of all nodes of specified type

        :param type: type of node
        :return: List of all nodes
        """
        return [n[1] for n in self.g.nodes(data='data') if type is None or n[1].type == type]

    def out_edges(self, node_id: str, etype: EdgeType = None) -> List[Tuple[str, str, Dependency]]:
        """Get outgoing edges of node of specified type

        :param node_id: id of the source node
        :param etype: type of edges
        :return: list of outgoing edges
        """
        return [t for t in self.g.out_edges(node_id, data='data') if etype is None or t[2].etype == etype]

    def in_edges(self, node_id: str, etype: EdgeType = None) -> List[Tuple[str, str, Dependency]]:
        """Get incoming edges of node of specified type

        :param node_id: id of the target node
        :param etype: type of edges
        :return: list of incoming edges
        """
        return [t for t in self.g.in_edges(node_id, data='data') if etype is None or t[2].etype == etype]

    def subtree_of_type(self, root: CUNode, type: Optional[NodeType]) -> List[CUNode]:
        """Gets all nodes in subtree of specified type including root

        :param root: root node
        :param type: type of children, None is equal to a wildcard
        :return: list of nodes in subtree
        """
        return self.__subtree_of_type_rec(root, type, set())

    def __subtree_of_type_rec(self, root: CUNode, type: Optional[NodeType], visited: Set[CUNode]) -> List[CUNode]:
        """Gets all nodes in subtree of specified type including root

        :param root: root node
        :param type: type of children, None is equal to a wildcard
        :param visited: set of visited nodes
        :return: list of nodes in subtree
        """
        res: List[CUNode] = []
        for visited_cu in visited:
            if self.__cu_equal__(root, visited_cu):
                return res
        visited.add(root)
        if root.type == type or type is None:
            res.append(root)
        for s, t, e in self.out_edges(root.id, EdgeType.CHILD):
            res.extend(self.__subtree_of_type_rec(
                self.node_at(t), type, visited))
        return res

    def __cu_equal__(self, cu_1: CUNode, cu_2: CUNode):
        """Alternative to CUNode.__eq__, bypasses the isinstance-check and relies on MyPy for type safety.
        :param cu_1: CUNode 1
        :param cu_2: CUNode 2
        :return: True, if cu_1 == cu_2. False, else"""
        if cu_1.id == cu_2.id:
            return True
        return False

    def direct_successors(self, root: CUNode) -> List[CUNode]:
        """Gets only direct successors of any type

        :param root: root node
        :return: list of direct successors
        """
        return [self.node_at(t) for s, t, d in self.out_edges(root.id, EdgeType.SUCCESSOR)]

    def direct_children(self, root: CUNode) -> List[CUNode]:
        """Gets only direct children of any type

        :param root: root node
        :return: list of direct children
        """
        return [self.node_at(t) for s, t, d in self.out_edges(root.id, EdgeType.CHILD)]

    def direct_children_of_type(self, root: CUNode, type: NodeType) -> List[CUNode]:
        """Gets only direct children of specified type

        :param root: root node
        :param type: type of children
        :return: list of direct children
        """
        return [self.node_at(t) for s, t, d in self.out_edges(root.id, EdgeType.CHILD)
                if self.node_at(t).type == type]

    def is_reduction_var(self, line: str, name: str) -> bool:
        """Determines, whether or not the given variable is reduction variable

        :param line: loop line number
        :param name: variable name
        :return: true if is reduction variable
        """
        return any(rv for rv in self.reduction_vars if rv['loop_line'] == line and rv['name'] == name)

    def depends_ignore_readonly(self, source: CUNode, target: CUNode, root_loop: CUNode,
                                children_cache: Dict[CUNode,
                                                     List[CUNode]] = None,
                                dep_cache: Dict[Tuple[CUNode, CUNode], Set[CUNode]] = None) -> bool:
        """Detects if source node or one of it's children has a RAW dependency to target node or one of it's children
        The loop index and readonly variables are ignored

        :param source: source node for dependency detection
        :param target: target of dependency
        :param root_loop: root loop
        :param children_cache: option to allow caching of found children, used for do-all-detection
        :param dep_cache: option to allow caching of found dependencies, used for do-all-detection
        :return: true, if there is RAW dependency
        """
        if children_cache is not None:
            if target in children_cache:
                children = children_cache[target]
            else:
                children = self.subtree_of_type(target, NodeType.CU)
                children_cache[target] = children
        else:
            children = self.subtree_of_type(target, NodeType.CU)
        # TODO children.append(target)

        if dep_cache is not None:
            if (source, root_loop) in dep_cache:
                dependencies = dep_cache[(source, root_loop)]
            else:
                dependencies = self.get_all_dependencies(source, root_loop)
                dep_cache[(source, root_loop)] = dependencies
        else:
            dependencies = self.get_all_dependencies(source, root_loop)

        for dep in dependencies:
            if dep in children:
                return True
        return False

    def get_all_dependencies(self, node: CUNode, root_loop: CUNode) -> Set[CUNode]:
        """Returns all data dependencies of the node and it's children
        This method ignores loop index and read only variables

        :param node: node
        :param root_loop: root loop
        :return: list of all RAW dependencies of the node
        """
        dep_set = set()
        loops_start_lines = []
        undefinedVarsInLoop = []
        firstWrittenVarsInLoop: Set[Variable] = set()

        loop_node_ids = [n.id for n in self.subtree_of_type(
            root_loop, NodeType.CU)]
        children = self.subtree_of_type(node, NodeType.CU)

        # 28.02.2022: Removed as a merge conflict with ClassificationBug
        # loops_start_lines = [v.start_position()
        #                     for v in self.subtree_of_type(root_loop, NodeType.LOOP)]

        # for v in children:
        #    for t, d in [(t, d) for s, t, d in self.out_edges(v.id, EdgeType.DATA) if d.dtype == DepType.RAW and self.is_inside_node(d, root_loop)]:

        for v in self.subtree_of_type(root_loop, NodeType.LOOP):
            loops_start_lines.append(v.start_position())

        allVars = self.get_undefined_variables_inside_loop(root_loop)
        undefinedVarsInLoop = [var.name for var in allVars]
        firstWrittenVarsInLoop = self.get_first_written_vars_in_loop(
            undefinedVarsInLoop, node, root_loop)

        for v in children:
            for s, t, d in [(s, t, d) for s, t, d in self.out_edges(v.id, EdgeType.DATA)
                            if d.dtype == DepType.RAW and d.var_name in undefinedVarsInLoop]:
                if (self.is_loop_index(d.var_name, loops_start_lines, self.subtree_of_type(root_loop, NodeType.CU))
                        or self.is_readonly_inside_loop_body(d, root_loop)):
                    continue
                # TODO:
                # if the dependence is by a variable
                # which is written first in the loop, ignore it
                if d.var_name in firstWrittenVarsInLoop:
                    continue
                # if(self.is_first_written_in_loop(d, root_loop)):
                #     # if (self.is_scalar_val(allVars, d.var_name)):
                #     continue
                # if the dependence is not inside the loop, ignore it
                if s not in loop_node_ids or t not in loop_node_ids:
                    continue
# check if the var name of the dep appears in either of the CU nodes.
# Otherwise, it should be a false pos/neg dep.
                dep_set.add(self.node_at(t))

        return dep_set

    # 28.02.2022: Removed as a merge conflict with ClassificationBug
    # def is_inside_node(self, d: Dependency, tmpNode: node) -> bool:
    #    sink = int(d.sink.split(":")[1])
    #    source = int(d.source.split(":")[1])
    #    if sink >= tmpNode.start_line and sink <= tmpNode.end_line and source >= tmpNode.start_line and source <= tmpNode.end_line:
    #        return True
    #    else:
    #        return False

    def check_alias(self, s: str, t: str, d: Dependency, root_loop: CUNode) -> bool:
        sub = self.subtree_of_type(root_loop, NodeType.CU)
        parent_func_sink = self.get_parent_function(self.node_at(s))
        parent_func_source = self.get_parent_function(self.node_at(t))

        res = False
        d_var_name_str = cast(str, str(d.var_name))

        if(self.is_global(d_var_name_str, sub) and
            not (self.is_passed_by_reference(d, parent_func_sink) and
                 self.is_passed_by_reference(d, parent_func_source))):
            return res
        return not res


    def is_global(self, var: str, tree: List[CUNode]) -> bool:
        """Checks if variable is global

        :param var: variable name
        :param tree: nodes to search
        :return: true if global
        """

        for node in tree:
            if node.type == NodeType.CU:
                for gv in node.global_vars:
                    if gv.name == var:
                        # TODO from tmp global vars
                        return False
        return False

    def is_passed_by_reference(self, dep: Dependency, func: CUNode) -> bool:

        res = False

        for i in func.args:
            if(i.name == dep.var_name):
                res = True
                break

        return res

    def get_first_written_vars_in_loop(self, undefinedVarsInLoop: List[Variable], node: CUNode, root_loop: CUNode) -> Set[Variable]:
        loop_node_ids = [n.id for n in self.subtree_of_type(
            root_loop, NodeType.CU)]
        fwVars = set()

        raw = set()
        war = set()
        waw = set()
        sub = self.subtree_of_type(root_loop, NodeType.CU)
        for sub_node in sub:
            raw.update(self.get_dep(sub_node, DepType.RAW, False))
            war.update(self.get_dep(sub_node, DepType.WAR, False))
            waw.update(self.get_dep(sub_node, DepType.WAW, False))

        for var in undefinedVarsInLoop:
            if var not in fwVars:
                for i in raw:
                    if(i[2].var_name == var
                       and i[0] in loop_node_ids and i[1] in loop_node_ids):
                        for e in itertools.chain(war, waw):
                            if (e[2].var_name == var
                                    and e[0] in loop_node_ids and e[1] in loop_node_ids):
                                if e[2].sink == i[2].source:
                                    fwVars.add(var)

        return fwVars

    def get_dep(self, node: CUNode, dep_type: DepType,
                reversed: bool) -> List[Tuple[str, str, Dependency]]:
        """Searches all dependencies of specified type

        :param node: node
        :param dep_type: type of dependency
        :param reversed: if true the it looks for incoming dependencies
        :return: list of dependencies
        """
        return [e for e in (self.in_edges(node.id, EdgeType.DATA) if reversed else self.out_edges(node.id, EdgeType.DATA))
                if e[2].dtype == dep_type]

    def is_scalar_val(self, allVars: List[Variable], var: str) -> bool:
        """Checks if variable is a scalar value

        :param var: variable
        :return: true if scalar
        """
        for x in allVars:
            if x.name == var:
                return not (x.type.endswith('**') or x.type.startswith('ARRAY' or x.type.startswith('[')))
            else:
                return False
        raise ValueError("allVars must not be empty.")

    def __get_variables(self, nodes: List[CUNode]) -> Set[Variable]:
        """Gets all variables in nodes

        :param nodes: nodes
        :return: Set of variables
        """
        res = set()
        for node in nodes:
            for v in node.local_vars:
                res.add(v)
            for v in node.global_vars:
                res.add(v)
        return res

    def get_undefined_variables_inside_loop(self, root_loop: CUNode) -> List[Variable]:

        sub = self.subtree_of_type(root_loop, NodeType.CU)
        vars = list(self.__get_variables(sub))
        dummyVariables = []
        definedVarsInLoop = []
        definedVarsInCalledFunctions = []

        # Remove llvm temporary variables
        for var in vars:
            if var.defLine == "LineNotFound" or var.defLine == "GlobalVar" or "0:" in var.defLine:
                dummyVariables.append(var)

        vars_list = list(set(vars) ^ set(dummyVariables))
        # Exclude variables which are defined inside the loop
        for var in vars_list:
            if var.defLine >= root_loop.start_position() and var.defLine <= root_loop.end_position():
                definedVarsInLoop.append(var)

        vars_list = list(set(vars) ^ set(definedVarsInLoop))

        # Also, exclude variables which are defined inside
        # functions that are called within the loop
        for var in vars_list:
            for s in sub:
                if var.defLine >= s.start_position() and var.defLine <= s.end_position():
                    definedVarsInCalledFunctions.append(var)

        vars_list = list(set(vars) ^ set(definedVarsInCalledFunctions))

        return vars_list

    def is_first_written_in_loop(self, dep: Dependency, root_loop: CUNode):
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
        children = self.subtree_of_type(root_loop, NodeType.CU)

        for v in children:
            for t, d in [(t, d) for s, t, d in self.out_edges(v.id, EdgeType.DATA)
                         if d.dtype == DepType.WAR or d.dtype == DepType.WAW]:
                if d.var_name is None:
                    return False
                assert d.var_name is not None
                if dep.var_name == d.var_name:
                    if dep.source == d.sink:
                        result = True
                        break
                # None may occur because __get_variables doesn't check for actual elements
        return result

    def is_first_written(self, var: str, raw: Set[Tuple[str, str, Dependency]],
                         war: Set[Tuple[str, str, Dependency]], sub: List[CUNode]) -> bool:
        """Checks whether a variable is first written inside the current node

        :param var: variable name
        :param raw: raw dependencies of the loop
        :param war: war dependencies of the loop
        :param sub: subtree of the loop
        :return: true if first written
        """
        for e in war:
            if e[2].var_name == var and any([n.id == e[1] for n in sub]):
                res = False
                for eraw in raw:
                    # TODO check
                    if (eraw[2].var_name == var and any([n.id == e[1] for n in sub])
                            and e[0] == eraw[2].sink):
                        res = True
                        break
                if not res:
                    return False
        return False

    def is_loop_index(self, var_name: Optional[str], loops_start_lines: List[str], children: List[CUNode]) -> bool:
        """Checks, whether the variable is a loop index.

        :param var_name: name of the variable
        :param loops_start_lines: start lines of the loops
        :param children: children nodes of the loops
        :return: true if edge represents loop index
        """

        # If there is a raw dependency for var, the source cu is part of the loop
        # and the dependency occurs in loop header, then var is loop index+

        for c in children:
            for t, d in [(t, d) for s, t, d in self.out_edges(c.id, EdgeType.DATA)
                         if d.dtype == DepType.RAW and d.var_name == var_name]:
                if (d.sink == d.source
                        and d.source in loops_start_lines
                        and self.node_at(t) in children):
                    return True

        return False

    def is_readonly_inside_loop_body(self, dep: Dependency, root_loop: CUNode) -> bool:
        """Checks, whether a variable is read-only in loop body

        :param dep: dependency variable
        :param root_loop: root loop
        :return: true if variable is read-only in loop body
        """
        # TODO pass as param?
        loops_start_lines = [v.start_position()
                             for v in self.subtree_of_type(root_loop, NodeType.LOOP)]
        children = self.subtree_of_type(root_loop, NodeType.CU)

        for v in children:
            for t, d in [(t, d) for s, t, d in self.out_edges(v.id, EdgeType.DATA)
                         if d.dtype == DepType.WAR or d.dtype == DepType.WAW]:
                # If there is a waw dependency for var, then var is written in loop
                # (sink is always inside loop for waw/war)
                if (dep.var_name == d.var_name
                        and not (d.sink in loops_start_lines)):
                    return False
            for t, d in [(t, d) for s, t, d in self.in_edges(v.id, EdgeType.DATA)
                         if d.dtype == DepType.RAW]:
                # If there is a reverse raw dependency for var, then var is written in loop
                # (source is always inside loop for reverse raw)
                if (dep.var_name == d.var_name
                        and not (d.source in loops_start_lines)):
                    return False
        return True

    def get_parent_function(self, node: CUNode) -> CUNode:
        """Finds the parent of a node

        :param node: current node
        :return: number of iterations
        """
        parent = self.in_edges(node.id, EdgeType.CHILD)

        while parent:
            node = self.node_at(parent[0][0])
            if node.type == NodeType.FUNC:
                break
            parent = self.in_edges(node.id, EdgeType.CHILD)

        return node

    def get_left_right_subtree(self, target: CUNode, right_subtree: bool) -> List[CUNode]:
        """Searches for all subnodes of main which are to the left or to the right of the specified node

        :param target: node that divides the tree
        :param right_subtree: true - right subtree, false - left subtree
        :return: list of nodes in the subtree
        """
        stack: List[CUNode] = []
        res: List[CUNode] = []
        visited = []

        parent_func = self.get_parent_function(target)
        stack.append(parent_func)

        while stack:
            current = stack.pop()

            if current == target:
                return res
            if current.type == NodeType.CU:
                res.append(current)

            if current in visited:  # suppress looping
                continue
            else:
                visited.append(current)

            stack.extend(self.direct_children(current) if right_subtree
                         else reversed(self.direct_children(current)))
        return res

    def path(self, source: CUNode, target: CUNode) -> List[CUNode]:
        """DFS from source to target over edges of child type

        :param source: source node
        :param target: target node
        :return: list of nodes from source to target
        """
        return self.__path_rec(source, target, set())

    def __path_rec(self, source: CUNode, target: CUNode, visited: Set[CUNode]) -> List[CUNode]:
        """DFS from source to target over edges of child type

        :param source: source node
        :param target: target node
        :return: list of nodes from source to target
        """
        visited.add(source)
        if source == target:
            return [source]

        for child in [c for c in self.direct_children(source) if c not in visited]:
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
            if rv['loop_line'] == line and rv['name'] == name:
                return rv['operation']
        return ""
