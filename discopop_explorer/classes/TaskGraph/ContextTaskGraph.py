# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import logging
from typing import Optional
from matplotlib import pyplot as plt
import networkx as nx
from tqdm import tqdm
from discopop_explorer.classes.PEGraph.PEGraphX import PEGraphX
from discopop_explorer.classes.TaskGraph.Contexts.Context import Context
from discopop_explorer.classes.TaskGraph.TGNode import TGNode
from discopop_explorer.classes.TaskGraph.TaskGraph import TaskGraph

logger = logging.getLogger("Explorer")


class ContextTaskGraph(object):
    pet: PEGraphX
    task_graph: TaskGraph
    graph: nx.MultiDiGraph

    def __init__(self, task_graph: TaskGraph) -> None:
        self.pet = task_graph.pet
        self.task_graph = task_graph
        self.graph = nx.MultiDiGraph()
        # define updating plot window
        fig1 = plt.figure(1)
        self.plotting_axis = fig1.add_subplot(1, 1, 1)
        plt.ion()
        # start processing
        self.__construct_from_task_graph()
        self.__coarsen_graph()

        print("Waiting for user to close the Window...")
        # plt.show(block=True)
        plt.ioff()

    def __construct_from_task_graph(self) -> None:
        """convert the given task graph to a ContextTaskGraph for Task detection. The created graph will be used to determine Forks, Barriers, and Tasks."""
        logger.info("Constructing ContextTaskGraph...")
        logger.info("--> Add context nodes...")
        for ctx in tqdm(self.task_graph.contexts):
            self.add_node(ctx)
        logger.info("--> Add dependency edges...")
        for ctx in tqdm(self.task_graph.contexts):
            for sink_ctx, dep in ctx.outgoing_dependencies:
                self.add_edge(sink_ctx, ctx)

    def __coarsen_graph(self) -> None:
        """increases the sizes of the contexts"""
        logger.info("TODO: Coarsen graph")

    def plot(self) -> None:
        self.update_plot()
        print("Waiting for user to close the Window...")
        plt.show()

    def update_plot(self) -> None:
        logger.info("Plotting...")
        plt.clf()

        logger.info("---> generating layout...")
        positions = nx.nx_pydot.pydot_layout(self.graph, prog="dot")
        logger.info("--->    Done.")

        # draw regular nodes
        nx.draw_networkx_nodes(self.graph, positions)
        # draw edges
        nx.draw_networkx_edges(self.graph, positions)

        # get node labels
        labels = {}
        for node in self.graph.nodes():
            labels[node] = node.get_label()
        nx.draw_networkx_labels(self.graph, positions, labels, font_size=7)
        logger.info("---> showing...")

        plt.pause(0.01)

    def add_node(self, node: Context) -> None:
        self.graph.add_node(node)

    def add_edge(self, source: Optional[Context], target: Optional[Context]) -> None:
        if source is None or target is None:
            return
        # disallow duplicate edges
        if self.graph.has_edge(source, target):
            return
        self.graph.add_edge(source, target)
