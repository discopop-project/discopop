from graph_tool.all import graph_draw, radial_tree_layout, minimize_nested_blockmodel_dl, draw_hierarchy, GraphView


# sub = GraphView(cu_graph, vfilt=lambda v: cu_graph.vp.type[v]=='2')
    pos = radial_tree_layout(cu_graph, cu_graph.vertex(10))
    # state = minimize_nested_blockmodel_dl(cu_graph, deg_corr=True)
    # draw_hierarchy(state, vertex_shape=cu_graph.vp.viz_shape, vertex_text=cu_graph.vp.id, vertex_fill_color=cu_graph.vp.viz_color, edge_color=cu_graph.ep.viz_color, edge_dash_style=cu_graph.ep.viz_dash_style, output='output.svg')
    graph_draw(cu_graph, pos=pos, vertex_shape=cu_graph.vp.viz_shape,
                         vertex_text=cu_graph.vp.id,
                         vertex_fill_color=cu_graph.vp.viz_color,
                         edge_marker_size=20,
                         edge_color=cu_graph.ep.viz_color,
                         edge_dash_style=cu_graph.ep.viz_dash_style,
                         vertex_font_size=16, output='output.svg')
