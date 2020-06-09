# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import os
from typing import Dict, List

import gi

gi.require_version('Gtk', '3.0')
from gi.repository import Gtk

from graph_tool import Vertex
from graph_tool.all import Graph
from graph_tool.all import graph_draw, GraphView, GraphWindow
from graph_tool.draw import arf_layout, radial_tree_layout
from graph_tool.search import bfs_iterator

from parser import readlineToCUIdMap, writelineToCUIdMap, lineToCUIdMap
from variable import Variable

node_type_info = {
    '0': {
        'name': 'cu',
        'color': 'white',
        'shape': 'square'
    },
    '1': {
        'name': 'func',
        'color': 'gray',
        'shape': 'pentagon'
    },
    '2': {
        'name': 'loop',
        'color': 'red',
        'shape': 'circle'
    },
    '3': {
        'name': 'dummy',
        'color': 'black',
        'shape': 'pie'
    },
}

type_map = {
    '0': 'cu',
    '1': 'func',
    '2': 'loop',
    '3': 'dummy'
}

node_props = [
    ('id', 'string', 'node.get("id")'),
    ('type', 'string', 'type_map[node.get("type")]'),
    ('startsAtLine', 'string', 'node.get("startsAtLine")'),
    ('endsAtLine', 'string', 'node.get("endsAtLine")'),
    ('name', 'string', 'node.get("name")'),
    ('instructionsCount', 'int', 'node.get("instructionsCount", 0)'),
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

    ('viz_color', 'string', 'node_type_info[node.get("type")]["color"]'),
    ('viz_shape', 'string', 'node_type_info[node.get("type")]["shape"]')
]

edge_props = [
    ('type', 'string'),
    ('source', 'string'),
    ('sink', 'string'),
    ('var', 'string'),
    ('dtype', 'string'),

    ('viz_color', 'vector<double>'),
    ('viz_dash_style', 'vector<double>')
]

GT_map_node_indices = dict()


class PETGraph(object):
    reduction_vars: List[Dict[str, str]]
    loop_data: Dict[str, int]
    children_graph: GraphView
    dep_graph: GraphView
    graph: Graph
    main: Vertex

    def __init__(self, cu_dict, dependencies_list, loop_data, reduction_vars):
        self.file_mapping = {}
        self.graph = Graph()
        self.loop_data = loop_data
        self.reduction_vars = reduction_vars

        # Define the properties for each node
        for prop in node_props:
            self.graph.vertex_properties[prop[0]] = self.graph.new_vertex_property(prop[1])
        for prop in edge_props:
            self.graph.edge_properties[prop[0]] = self.graph.new_edge_property(prop[1])

        # Adding vertices (CU nodes) to the graph
        for node_id, node in cu_dict.items():
            v = self.graph.add_vertex()
            GT_map_node_indices[node_id] = self.graph.vertex_index[v]

            for prop in node_props:
                self.graph.vp[prop[0]][v] = eval(prop[2])

            if hasattr(node, 'funcArguments') and hasattr(node.funcArguments, 'arg'):
                self.graph.vp.args[v] = [Variable(v.get('type'), v.text) for v in node.funcArguments.arg]

            if hasattr(node, 'callsNode') and hasattr(node.callsNode, 'recursiveFunctionCall'):
                self.graph.vp.recursiveFunctionCalls[v] = [v.text for v in node.callsNode.recursiveFunctionCall]

            if node.get("type") == '0':
                if hasattr(node.localVariables, 'local'):
                    self.graph.vp.localVars[v] = [Variable(v.get('type'), v.text) for v in node.localVariables.local]

                if hasattr(node.globalVariables, 'global'):
                    self.graph.vp.globalVars[v] = [Variable(v.get('type'), v.text) for v in
                                                   getattr(node.globalVariables, 'global')]

                self.graph.vp.instructionsCount[v] = node.instructionsCount
                self.graph.vp.BasicBlockID[v] = node.BasicBlockID

        # Adding edges (successors and children) to the graph
        for node_id, node in cu_dict.items():
            source = self.graph.vertex(GT_map_node_indices[node_id])
            if 'childrenNodes' in dir(node):
                for child in node.childrenNodes:
                    if child not in GT_map_node_indices:
                        print("Skipping dummy node " + str(child))
                        continue
                    sink = self.graph.vertex(GT_map_node_indices[child])
                    e = self.graph.add_edge(source, sink)
                    self.graph.ep.type[e] = 'child'
                    self.graph.ep.viz_color[e] = [0.0, 0.0, 0.5, 1]
            if 'successors' in dir(node) and 'CU' in dir(node.successors):
                for successor in node.successors.CU:
                    sink = self.graph.vertex(GT_map_node_indices[successor])
                    e = self.graph.add_edge(source, sink)
                    self.graph.ep.type[e] = 'successor'
                    self.graph.ep.viz_color[e] = [0.0, 0.5, 0.0, 0.5]

        for dep in dependencies_list:
            sink_cu_ids = lineToCUIdMap[dep.sink] if dep.type == 'INIT' else readlineToCUIdMap[dep.sink]
            source_cu_ids = writelineToCUIdMap[dep.source]
            for sink_cu_id in sink_cu_ids:
                if dep.type == 'INIT':
                    pass  # TODO: nodeMap[sinkNodeId].Init.insert(dep.var);
                else:
                    for source_cu_id in source_cu_ids:
                        if sink_cu_id == source_cu_id and (dep.type == 'WAR' or dep.type == 'WAW'):
                            continue
                        elif sink_cu_id and source_cu_id:
                            source_v = self.graph.vertex(GT_map_node_indices[source_cu_id])
                            sink_v = self.graph.vertex(GT_map_node_indices[sink_cu_id])
                            e = self.graph.add_edge(sink_v, source_v)
                            self.graph.ep.type[e] = 'dependence'
                            self.graph.ep.source[e] = dep.source
                            self.graph.ep.sink[e] = dep.sink
                            self.graph.ep.dtype[e] = dep.type
                            self.graph.ep.var[e] = dep.var_name

                            self.graph.ep.viz_dash_style[e] = [1, 1, 0]
                            self.graph.ep.viz_color[e] = [0.4, 0.4, 0.4, 0.5]

        self.dep_graph = self.filter_view(edges_type='dependence')
        self.children_graph = self.filter_view(edges_type='child')

        self.main = None
        for v in self.graph.vertices():
            if self.graph.vp.name[v] == 'main':
                self.main = v
                break

    def filter_view(self, nodes_id='*', edges_type='*'):
        vfilter = None if nodes_id == '*' else lambda v: self.graph.vertex_index[v] in nodes_id
        efilter = None if edges_type == '*' else lambda e: self.graph.ep.type[e] == edges_type

        return GraphView(self.graph, vfilt=vfilter, efilt=efilter)

    def get_root_node(self):
        in_degrees = self.children_graph.get_in_degrees(self.children_graph.get_vertices())
        root_idx = in_degrees.tolist().index(0)
        return self.graph.vertex(root_idx)

    def infer_level_dependencies(self):
        for level in bfs_iterator(self.children_graph, source=self.get_root_node()):
            print(self.graph.vp.id[level.source()], self.graph.vp.id[level.target()])
            # for depth in dfs_iterator()

    def key_pressed_callback(self, widget, graph: Graph, picked, pos: Vertex, vprops, vpropsdic, eprops):
        file_id = self.graph.vp.startsAtLine[pos].split(':')[0]
        graph.set_edge_filter(None)
        self.visible.a = False
        if file_id in self.file_mapping:
            with open(self.file_mapping[file_id]) as f:
                lines = f.readlines()
            print(f'Node: {self.graph.vp.id[pos]}')
            print(f'Name: {self.graph.vp.name[pos]}')
            print(f'Type: {self.graph.vp.type[pos]}')
            start = int(self.graph.vp.startsAtLine[pos].split(':')[1]) - 1
            # TODO inclusive or exclusive
            end = int(self.graph.vp.endsAtLine[pos].split(':')[1])
            for i in range(start, end):
                print(lines[i].replace('\n', ''))
            print()
        else:
            print(f'Unknown file id: {file_id}')

        for e in graph.edges():
            self.visible[e] = graph.ep.type[e] != 'dependence'
        for e in pos.out_edges():
            self.visible[e] = True
        for e in pos.in_edges():
            self.visible[e] = True

        graph.set_edge_filter(self.visible, inverted=False)

        self.win.graph.regenerate_surface()
        self.win.graph.queue_draw()

    def interactive_visualize(self, file_mapping=None):
        self.parse_mapping(file_mapping)
        layout = radial_tree_layout(self.graph, self.main)

        self.visible = self.graph.new_edge_property("bool")
        self.visible.a = False
        for e in self.graph.edges():
            self.visible[e] = self.graph.ep.type[e] != 'dependence'
        self.graph.set_edge_filter(self.visible, inverted=False)
        print('Hover over the node and press any key to display source lines and dependencies')
        self.win = GraphWindow(self.graph, layout, geometry=(1000, 1000),
                               vprops={'text': self.graph.vp.id,
                                       'fill_color': self.graph.vp.viz_color,
                                       'shape': self.graph.vp.viz_shape},
                               eprops={'color': self.graph.ep.viz_color,
                                       'text': self.graph.ep.var},
                               key_press_callback=self.key_pressed_callback)

        self.win.connect("delete_event", Gtk.main_quit)
        self.win.show_all()
        Gtk.main()

    def parse_mapping(self, path):
        self.file_mapping.clear()
        if os.path.isfile(path):
            with open(path) as f:
                for line in f.readlines():
                    split = line.split('\t')
                    self.file_mapping[split[0]] = split[1].strip()
        else:
            print(f'File mapping not found at {path}')

    def visualize(self, view=None, filename='output.svg'):
        view = view if view else self.graph

        # layout = radial_tree_layout(view, self.get_root_node())
        # layout = sfdp_layout(view)
        # layout = fruchterman_reingold_layout(view)
        layout = arf_layout(view)  # ok
        # layout = planar_layout(view) # SIGSEGV
        # layout = random_layout(view) # no
        graph_draw(view, pos=layout, vertex_shape=self.graph.vp.viz_shape,
                   vertex_text=self.graph.vp.id,
                   vertex_fill_color=self.graph.vp.viz_color,
                   edge_marker_size=10,
                   edge_color=self.graph.ep.viz_color,
                   edge_dash_style=self.graph.ep.viz_dash_style,
                   vertex_font_size=16, output=filename)

        # SIGSEGV
        # graphviz_draw(g=view, pos=None, size=(15, 15),
        #               pin=False, layout='circo',
        #               maxiter=None, ratio='fill', overlap=False, sep=None,
        #               splines=False, vsize=0.105, penwidth=1.0, elen=None,
        #               gprops={}, vprops={'id': view.vp.id}, eprops={},
        #               vcolor="#a40000", ecolor="#2e3436",
        #               vcmap=None, vnorm=True, ecmap=None, enorm=True, vorder=None, eorder=None,
        #               output=filename, output_format="auto", fork=False, return_string=False)
