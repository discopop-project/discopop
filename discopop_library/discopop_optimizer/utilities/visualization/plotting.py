# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
import matplotlib.pyplot as plt  # type: ignore
import networkx as nx  # type: ignore

from discopop_library.discopop_optimizer.classes.edges.ChildEdge import ChildEdge
from discopop_library.discopop_optimizer.classes.edges.OptionEdge import OptionEdge
from discopop_library.discopop_optimizer.classes.edges.RequirementEdge import RequirementEdge
from discopop_library.discopop_optimizer.classes.edges.SuccessorEdge import SuccessorEdge
from discopop_library.discopop_optimizer.classes.edges.TemporaryEdge import TemporaryEdge
from discopop_library.discopop_optimizer.classes.nodes.ContextNode import ContextNode
from discopop_library.discopop_optimizer.classes.nodes.FunctionRoot import FunctionRoot
from discopop_library.discopop_optimizer.classes.nodes.Loop import Loop
from discopop_library.discopop_optimizer.classes.nodes.Workload import Workload
from discopop_library.discopop_optimizer.utilities.MOGUtilities import data_at


def show(graph):
    """Plots the graph

    :return:
    """
    fig, ax = plt.subplots()
    try:
        pos = nx.planar_layout(graph)  # good
    except nx.exception.NetworkXException:
        try:
            # fallback layouts
            pos = nx.shell_layout(graph)  # maybe
        except nx.exception.NetworkXException:
            pos = nx.random_layout(graph)

    drawn_nodes = set()
    nodes_lists = dict()
    node_ids = dict()
    node_insertion_sequence = []
    # draw nodes
    node_insertion_sequence.append(FunctionRoot)
    nodes_lists[FunctionRoot] = nx.draw_networkx_nodes(
        graph,
        pos=pos,
        ax=ax,
        node_size=200,
        node_color="#ff5151",
        node_shape="d",
        nodelist=[n for n in graph.nodes if isinstance(data_at(graph, n), FunctionRoot)],
    )
    node_ids[FunctionRoot] = [n for n in graph.nodes if isinstance(data_at(graph, n), FunctionRoot)]
    drawn_nodes.update([n for n in graph.nodes if isinstance(data_at(graph, n), FunctionRoot)])

    node_insertion_sequence.append(Loop)
    nodes_lists[Loop] = nx.draw_networkx_nodes(
        graph,
        pos=pos,
        ax=ax,
        node_size=200,
        node_color="#ff5151",
        node_shape="s",
        nodelist=[n for n in graph.nodes if isinstance(data_at(graph, n), Loop)],
    )
    node_ids[Loop] = [n for n in graph.nodes if isinstance(data_at(graph, n), Loop)]
    drawn_nodes.update([n for n in graph.nodes if isinstance(data_at(graph, n), Loop)])

    node_insertion_sequence.append(ContextNode)
    nodes_lists[ContextNode] = nx.draw_networkx_nodes(
        graph,
        pos=pos,
        ax=ax,
        node_size=200,
        node_color="yellow",
        node_shape="s",
        nodelist=[n for n in graph.nodes if isinstance(data_at(graph, n), ContextNode)],
    )
    node_ids[ContextNode] = [n for n in graph.nodes if isinstance(data_at(graph, n), ContextNode)]
    drawn_nodes.update([n for n in graph.nodes if isinstance(data_at(graph, n), ContextNode)])

    node_insertion_sequence.append(Workload)
    nodes_lists[Workload] = nx.draw_networkx_nodes(
        graph,
        pos=pos,
        ax=ax,
        node_size=200,
        node_color="#2B85FD",
        node_shape="o",
        nodelist=[n for n in graph.nodes if isinstance(data_at(graph, n), Workload) and n not in drawn_nodes],
    )
    node_ids[Workload] = [n for n in graph.nodes if isinstance(data_at(graph, n), Workload) and n not in drawn_nodes]
    drawn_nodes.update([n for n in graph.nodes if isinstance(data_at(graph, n), Workload) and n not in drawn_nodes])

    # id as label
    labels = {}
    for n in graph.nodes:
        labels[n] = graph.nodes[n]["data"].get_plot_label()
    nx.draw_networkx_labels(graph, pos, labels, font_size=7, ax=ax)

    nx.draw_networkx_edges(
        graph,
        pos,
        ax=ax,
        edge_color="black",
        edgelist=[e for e in graph.edges(data="data") if isinstance(e[2], SuccessorEdge)],
    )

    nx.draw_networkx_edges(
        graph,
        pos,
        ax=ax,
        edge_color="red",
        edgelist=[e for e in graph.edges(data="data") if isinstance(e[2], ChildEdge)],
    )

    nx.draw_networkx_edges(
        graph,
        pos,
        ax=ax,
        edge_color="green",
        edgelist=[e for e in graph.edges(data="data") if isinstance(e[2], TemporaryEdge)],
    )

    nx.draw_networkx_edges(
        graph,
        pos,
        ax=ax,
        edge_color="pink",
        edgelist=[e for e in graph.edges(data="data") if isinstance(e[2], OptionEdge)],
    )

    nx.draw_networkx_edges(
        graph,
        pos,
        ax=ax,
        edge_color="yellow",
        edgelist=[e for e in graph.edges(data="data") if isinstance(e[2], RequirementEdge)],
    )

    # define tool tip style when hovering
    # based on https://stackoverflow.com/questions/61604636/adding-tooltip-for-nodes-in-python-networkx-graph
    annot = ax.annotate(
        "",
        xy=(0, 0),
        xytext=(20, 20),
        textcoords="offset points",
        bbox=dict(boxstyle="round", fc="w"),
        arrowprops=dict(arrowstyle="->"),
    )
    annot.set_visible(False)

    idx_to_node_dict = {}
    for idx, node in enumerate(graph.nodes):
        idx_to_node_dict[idx] = node

    def update_annot(ind, node_ids_list):
        node_idx = ind["ind"][0]
        node_id = node_ids_list[node_idx]
        xy = pos[node_id]
        annot.xy = xy
        node_attr = {"node": node_id}
        node_attr.update(graph.nodes[node_id])
        text = data_at(graph, node_id).get_hover_text()
        annot.set_text(text)

    def hover(event):
        vis = annot.get_visible()
        if event.inaxes == ax:
            for node_type in node_insertion_sequence:
                nodes = nodes_lists[node_type]
                try:
                    cont, ind = nodes.contains(event)
                    if cont:
                        update_annot(ind, node_ids[node_type])
                        annot.set_visible(True)
                        fig.canvas.draw_idle()
                    else:
                        if vis:
                            annot.set_visible(False)
                            fig.canvas.draw_idle()
                except TypeError:
                    pass

    fig.canvas.mpl_connect("motion_notify_event", hover)
    plt.show()
