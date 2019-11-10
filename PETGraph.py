from graph_tool.all import Graph
from graph_tool.all import graph_draw, GraphView, interactive_window
from graph_tool.draw import arf_layout
from graph_tool.search import bfs_iterator

from parser import readlineToCUIdMap, writelineToCUIdMap, lineToCUIdMap

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
    ('BasicBlockID', 'string', 'node.get("BasicBlockID", \'\')'),
    ('pipeline', 'float', '0'),
    ('doAll', 'float', '0'),
    ('geomDecomp', 'bool', 'False'),
    ('reduction', 'bool', 'False'),
    ('mwType', 'string', '\'FORK\''),
    ('localVars', 'object', '[]'),
    ('globalVars', 'object', '[]'),

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
    children_graph: GraphView
    dep_graph: GraphView
    graph: Graph

    def __init__(self, cu_dict, dependences_list):
        self.graph = Graph()

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

            if node.get("type") == '0':
                if hasattr(node.localVariables, 'local'):
                    self.graph.vp.localVars[v] = [v.text for v in node.localVariables.local]

                if hasattr(node.globalVariables, 'global'):
                    self.graph.vp.globalVars[v] = [v.text for v in getattr(node.globalVariables, 'global')]

                self.graph.vp.instructionsCount[v] = node.instructionsCount

        # Adding edges (successors and children) to the graph
        for node_id, node in cu_dict.items():
            source = self.graph.vertex(GT_map_node_indices[node_id])
            if 'childrenNodes' in dir(node):
                for child in node.childrenNodes:
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

        for dep in dependences_list:
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

    def interactive_visualize(self, view=None):
        view = view if view else self.graph
        interactive_window(view,
                           vprops={'text': self.graph.vp.id,
                                   'fill_color': self.graph.vp.viz_color,
                                   'shape': self.graph.vp.viz_shape},
                           eprops={'color': self.graph.ep.viz_color})

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
