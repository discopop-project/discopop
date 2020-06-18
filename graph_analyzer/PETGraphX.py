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
from parser import readlineToCUIdMap, writelineToCUIdMap, lineToCUIdMap

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


class DepType(Enum):
    CHILD = 0
    SUCCESSOR = 1
    DATA = 2


class CuType(IntEnum):
    CU = 0
    FUNC = 1
    LOOP = 2
    DUMMY = 3


class Dependency:
    type: DepType

    def __init__(self, type: DepType):
        self.type = type


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

    def __init__(self, id: str):
        self.id = id
        self.file_id, self.node_id = parse_id(id)

    def __str__(self):
        return self.id

    def __eq__(self, other):
        if isinstance(other, str):
            return other == self.id
        elif isinstance(other, CuNode):
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
    # TODO variables
    return n


class PETGraphX(object):
    reduction_vars: List[Dict[str, str]]
    loop_data: Dict[str, int]

    def __init__(self, cu_dict, dependencies_list, loop_data, reduction_vars):
        self.graph = nx.MultiDiGraph()
        self.loop_data = loop_data
        self.reduction_vars = reduction_vars

        for id, node in cu_dict.items():
            self.graph.add_node(id, data=parse_cu(node))

        for node_id, node in cu_dict.items():
            source = node_id
            if 'childrenNodes' in dir(node):
                for child in [n.text for n in node.childrenNodes]:
                    if child not in self.graph:
                        print(f"WARNING: no child node {child} found")
                    self.graph.add_edge(source, child, data=Dependency(DepType.CHILD))
            if 'successors' in dir(node) and 'CU' in dir(node.successors):
                for successor in [n.text for n in node.successors.CU]:
                    if successor not in self.graph:
                        print(f"WARNING: no successor node {successor} found")
                    self.graph.add_edge(source, successor, data=Dependency(DepType.SUCCESSOR))

        # calculate position before dependencies affect them
        # self.pos = nx.shell_layout(self.graph) # maybe
        # self.pos = nx.kamada_kawai_layout(self.graph) # maybe
        self.pos = nx.planar_layout(self.graph)  # good

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
                        self.graph.add_edge(sink_cu_id, source_cu_id, data=Dependency(DepType.DATA))
                        # self.graph.ep.type[e] = 'dependence'
                        # self.graph.ep.source[e] = dep.source
                        # self.graph.ep.sink[e] = dep.sink
                        # self.graph.ep.dtype[e] = dep.type
                        # self.graph.ep.var[e] = dep.var_name

        # TODO deps

    def show(self):
        print("showing")
        plt.plot()
        pos = self.pos

        # draw nodes
        nx.draw_networkx_nodes(self.graph, pos=pos, node_color='#2B85FD', node_shape='o',
                               nodelist=[n for n in self.graph.nodes if self.node_at(n).type == CuType.CU])
        nx.draw_networkx_nodes(self.graph, pos=pos, node_color='#ff5151', node_shape='d',
                               nodelist=[n for n in self.graph.nodes if self.node_at(n).type == CuType.LOOP])
        nx.draw_networkx_nodes(self.graph, pos=pos, node_color='grey', node_shape='s',
                               nodelist=[n for n in self.graph.nodes if self.node_at(n).type == CuType.DUMMY])
        nx.draw_networkx_nodes(self.graph, pos=pos, node_color='#cf65ff', node_shape='s',
                               nodelist=[n for n in self.graph.nodes if self.node_at(n).type == CuType.FUNC])
        nx.draw_networkx_nodes(self.graph, pos=pos, node_color='yellow', node_shape='h', node_size=750,
                               nodelist=[n for n in self.graph.nodes if self.node_at(n).name == 'main'])
        # id as label
        labels = {}
        for n in self.graph.nodes:
            labels[n] = str(self.graph.nodes[n]['data'])
        nx.draw_networkx_labels(self.graph, pos, labels, font_size=10)

        nx.draw_networkx_edges(self.graph, pos,
                               edgelist=[e for e in self.graph.edges(data='data') if e[2].type == DepType.CHILD])
        nx.draw_networkx_edges(self.graph, pos, edge_color='green',
                               edgelist=[e for e in self.graph.edges(data='data') if e[2].type == DepType.SUCCESSOR])
        nx.draw_networkx_edges(self.graph, pos, edge_color='red',
                               edgelist=[e for e in self.graph.edges(data='data') if e[2].type == DepType.DATA])
        plt.show()
        # plt.savefig('graphX.svg')

    def node_at(self, id: str) -> CuNode:
        return self.graph.nodes[id]['data']

    def edge_at(self, source: str, target: str) -> Dependency:
        g = self.graph[source][target]
        return self.graph[source][target]['data']

    def edge_data_at(self, edge: tuple) -> List[Dependency]:
        g = self.graph[edge[0]][edge[1]]
        return self.graph[edge[0]][edge[1]]['data']

    def is_child(self, edge: Tuple[str, str, Dependency]):
        return edge[2].type == DepType.CHILD

