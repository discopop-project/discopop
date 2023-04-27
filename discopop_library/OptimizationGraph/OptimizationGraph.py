import networkx as nx  # type: ignore
import matplotlib.pyplot as plt  # type:ignore

from discopop_explorer.PETGraphX import PETGraphX
from discopop_library.OptimizationGraph.PETParser.PETParser import PETParser
from discopop_library.OptimizationGraph.classes.nodes.FunctionRoot import FunctionRoot
from discopop_library.OptimizationGraph.classes.nodes.GenericNode import GenericNode
from discopop_library.OptimizationGraph.classes.nodes.Workload import Workload


class OptimizationGraph(object):
    graph: nx.DiGraph

    def __init__(self, pet: PETGraphX):
        self.graph = PETParser(pet).parse()
        self.show()

    def show(self):
        """Plots the graph

        :return:
        """
        # print("showing")
        plt.plot()
        pos = nx.planar_layout(self.graph)

        drawn_nodes = set()
        # draw nodes
        nx.draw_networkx_nodes(
            self.graph,
            pos=pos,
            node_size=200,
            node_color="#ff5151",
            node_shape="d",
            nodelist=[n for n in self.graph.nodes if isinstance(self.data_at(n), FunctionRoot)],
        )
        drawn_nodes.update([n for n in self.graph.nodes if isinstance(self.data_at(n), FunctionRoot)])

        nx.draw_networkx_nodes(
            self.graph,
            pos=pos,
            node_size=200,
            node_color="#2B85FD",
            node_shape="o",
            nodelist=[n for n in self.graph.nodes if isinstance(self.data_at(n), Workload) and n not in drawn_nodes],
        )
        drawn_nodes.update([n for n in self.graph.nodes if isinstance(self.data_at(n), Workload) and n not in drawn_nodes])

        # id as label
        labels = {}
        for n in self.graph.nodes:
            labels[n] = self.graph.nodes[n]["data"].get_plot_label()
        nx.draw_networkx_labels(self.graph, pos, labels, font_size=7)

        nx.draw_networkx_edges(
            self.graph,
            pos,
            edgelist=[e for e in self.graph.edges(data="data")],
        )
        plt.show()

    def data_at(self, node_id: int) -> GenericNode:
        """Return the data object stored at the networkx node with id node_id."""
        return self.graph.nodes[node_id]["data"]
