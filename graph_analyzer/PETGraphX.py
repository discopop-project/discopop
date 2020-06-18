# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

from typing import Dict, List, Tuple

import matplotlib.pyplot as plt
import networkx as nx
from lxml.objectify import ObjectifiedElement
from enum import IntEnum, Enum
from parser import readlineToCUIdMap, writelineToCUIdMap, lineToCUIdMap, DependenceItem
from variable import Variable

node_props = [
    ('BasicBlockID', 'string', '\'\''),
    ('pipeline', 'float', '0'),
    ('doAll', 'bool', 'False'),
    ('geomDecomp', 'bool', 'False'),
    ('reduction', 'bool', 'False'),
    ('mwType', 'string', '\'FORK\''),
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


def parse_id(node_id: str) -> (int, int):
    split = node_id.split(':')
    return int(split[0]), int(split[1])


class EdgeType(Enum):
    CHILD = 0
    SUCCESSOR = 1
    DATA = 2


class DepType(Enum):
    RAW = 0
    WAR = 1
    WAW = 2


class CuType(IntEnum):
    CU = 0
    FUNC = 1
    LOOP = 2
    DUMMY = 3


class Dependency:
    etype: EdgeType
    dtype: DepType
    var_name: str

    def __init__(self, type: EdgeType):
        self.etype = type
        self.dtype = None
        self.var_name = None


class CuNode:
    id: str
    file_id: int
    node_id: int
    source_file: int
    start_line: int
    end_line: int
    type: CuType
    name: str
    instructions_count: int
    loop_iterations: int
    reduction: bool
    local_vars: List[Variable]
    global_vars: List[Variable]

    def __init__(self, id: str):
        self.id = id
        self.file_id, self.node_id = parse_id(id)
        self.loop_iterations = 0
        self.local_vars = []
        self.global_vars = []

    def start_position(self) -> str:
        return f'{self.source_file}:{self.start_line}'

    def end_position(self) -> str:
        return f'{self.source_file}:{self.end_line}'

    def __str__(self):
        return self.id

    def __eq__(self, other):
        if isinstance(other, CuNode):
            return other.id == self.id
        else:
            return False

    def __hash__(self):
        return hash(id)


def parse_cu(node: ObjectifiedElement) -> CuNode:
    n = CuNode(node.get("id"))
    n.type = CuType(int(node.get("type")))
    n.source_file, n.start_line = parse_id(node.get("startsAtLine"))
    _, n.end_line = parse_id(node.get("endsAtLine"))
    n.name = node.get("name")
    n.instructions_count = node.get("instructionsCount", 0)
    # TODO func args
    # TODO recursive calls
    if n.type == CuType.CU:
        if hasattr(node.localVariables, 'local'):
            n.local_vars = [Variable(v.get('type'), v.text) for v in node.localVariables.local]
        if hasattr(node.globalVariables, 'global'):
            n.global_vars = [Variable(v.get('type'), v.text) for v in getattr(node.globalVariables, 'global')]

        # TODO self.graph.vp.instructionsCount[v] = node.instructionsCount
        # TODO self.graph.vp.BasicBlockID[v] = node.BasicBlockID
    return n


def parse_dependency(dep) -> Dependency:
    d = Dependency(EdgeType.DATA)
    # TODO needed?
    # self.graph.ep.source[e] = dep.source
    # self.graph.ep.sink[e] = dep.sink
    d.dtype = DepType[dep.type]
    d.var_name = dep.var_name
    return d


class PETGraphX(object):
    g: nx.MultiDiGraph
    reduction_vars: List[Dict[str, str]]

    def __init__(self, cu_dict: Dict[str, ObjectifiedElement], dependencies_list: List[DependenceItem],
                 loop_data: Dict[str, int], reduction_vars: List[Dict[str, str]]):
        self.g = nx.MultiDiGraph()
        self.reduction_vars = reduction_vars

        for id, node in cu_dict.items():
            self.g.add_node(id, data=parse_cu(node))

        for node in self.all_nodes(CuType.LOOP):
            node.loop_iterations = loop_data.get(node.start_position(), 0)

        for node_id, node in cu_dict.items():
            source = node_id
            if 'childrenNodes' in dir(node):
                for child in [n.text for n in node.childrenNodes]:
                    if child not in self.g:
                        print(f"WARNING: no child node {child} found")
                    self.g.add_edge(source, child, data=Dependency(EdgeType.CHILD))
            if 'successors' in dir(node) and 'CU' in dir(node.successors):
                for successor in [n.text for n in node.successors.CU]:
                    if successor not in self.g:
                        print(f"WARNING: no successor node {successor} found")
                    self.g.add_edge(source, successor, data=Dependency(EdgeType.SUCCESSOR))

        # calculate position before dependencies affect them
        # self.pos = nx.shell_layout(self.graph) # maybe
        # self.pos = nx.kamada_kawai_layout(self.graph) # maybe
        self.pos = nx.planar_layout(self.g)  # good

        for dep in dependencies_list:
            if dep.type == 'INIT':
                continue

            sink_cu_ids = readlineToCUIdMap[dep.sink]
            source_cu_ids = writelineToCUIdMap[dep.source]
            for sink_cu_id in sink_cu_ids:
                for source_cu_id in source_cu_ids:
                    if sink_cu_id == source_cu_id and (dep.type == 'WAR' or dep.type == 'WAW'):
                        continue
                    elif sink_cu_id and source_cu_id:
                        self.g.add_edge(sink_cu_id, source_cu_id, data=parse_dependency(dep))

    def show(self):
        print("showing")
        plt.plot()
        pos = self.pos

        # draw nodes
        nx.draw_networkx_nodes(self.g, pos=pos, node_color='#2B85FD', node_shape='o',
                               nodelist=[n for n in self.g.nodes if self.node_at(n).type == CuType.CU])
        nx.draw_networkx_nodes(self.g, pos=pos, node_color='#ff5151', node_shape='d',
                               nodelist=[n for n in self.g.nodes if self.node_at(n).type == CuType.LOOP])
        nx.draw_networkx_nodes(self.g, pos=pos, node_color='grey', node_shape='s',
                               nodelist=[n for n in self.g.nodes if self.node_at(n).type == CuType.DUMMY])
        nx.draw_networkx_nodes(self.g, pos=pos, node_color='#cf65ff', node_shape='s',
                               nodelist=[n for n in self.g.nodes if self.node_at(n).type == CuType.FUNC])
        nx.draw_networkx_nodes(self.g, pos=pos, node_color='yellow', node_shape='h', node_size=750,
                               nodelist=[n for n in self.g.nodes if self.node_at(n).name == 'main'])
        # id as label
        labels = {}
        for n in self.g.nodes:
            labels[n] = str(self.g.nodes[n]['data'])
        nx.draw_networkx_labels(self.g, pos, labels, font_size=10)

        nx.draw_networkx_edges(self.g, pos,
                               edgelist=[e for e in self.g.edges(data='data') if e[2].etype == EdgeType.CHILD])
        nx.draw_networkx_edges(self.g, pos, edge_color='green',
                               edgelist=[e for e in self.g.edges(data='data') if e[2].etype == EdgeType.SUCCESSOR])
        nx.draw_networkx_edges(self.g, pos, edge_color='red',
                               edgelist=[e for e in self.g.edges(data='data') if e[2].etype == EdgeType.DATA])
        plt.show()
        # plt.savefig('graphX.svg')

    def node_at(self, node_id: str) -> CuNode:
        return self.g.nodes[node_id]['data']

    def all_nodes(self, type: CuType = None) -> List[CuNode]:
        return [n[1] for n in self.g.nodes(data='data') if type is None or n[1].type == type]

    def out_edges(self, node_id: str, etype: EdgeType = None) -> List[Tuple[str, str, Dependency]]:
        return [t for t in self.g.out_edges(node_id, data='data') if etype is None or t[2].etype == etype]

    def in_edges(self, node_id: str, etype: EdgeType = None) -> List[Tuple[str, str, Dependency]]:
        return [t for t in self.g.in_edges(node_id, data='data') if etype is None or t[2].etype == etype]

    def subtree_of_type(self, root: CuNode, type: CuType) -> List[CuNode]:
        res = []
        if root.type == type:
            res.append(root)
        for s, t, e in self.out_edges(root.id, EdgeType.CHILD):
            res.extend(self.subtree_of_type(self.node_at(t), type))
        return res

    def is_reduction_var(self, line: str, name: str) -> bool:
        """Determines, whether or not the given variable is reduction variable

        :param line: loop line number
        :param name: variable name
        :param reduction_vars: List of reduction variables
        :return: true if is reduction variable
        """
        return any(rv for rv in self.reduction_vars if rv['loop_line'] == line and rv['name'] == name)

