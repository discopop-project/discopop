# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import logging
from typing import Dict, List, Optional, Set, Tuple
from matplotlib import pyplot as plt
import networkx as nx
from networkx import Graph
from tqdm import tqdm
from discopop_explorer.classes.PEGraph.PEGraphX import PEGraphX
from discopop_explorer.classes.TaskGraph.Contexts.Context import Context
from discopop_explorer.classes.TaskGraph.Contexts.InlinedFunctionContext import InlinedFunctionContext
from discopop_explorer.classes.TaskGraph.Contexts.WorkContext import WorkContext
from discopop_explorer.classes.TaskGraph.TGNode import TGNode
from discopop_explorer.classes.TaskGraph.TaskGraph import TaskGraph

logger = logging.getLogger("Explorer")


class CombinedContext(Context):
    def get_label(self) -> str:
        return "CombinedCTX"


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
        self.__print_graph_statistics("Pre simplification")
        try:
            print(nx.find_cycle(self.graph))
        except:
            print("NO CYCLE")
        # self.__simplify_graph()
        self.__print_graph_statistics("Post simplification")
        try:
            cycle = nx.find_cycle(self.graph)
            print("Cycle: ", cycle)
            cycle_nodes: Set[Context] = set()
            for tpl in cycle:
                cycle_nodes.add(tpl[0])
                cycle_nodes.add(tpl[1])
            plt.ioff()
            self.plot(highlight_nodes=list(cycle_nodes))
            plt.pause(1)
        except:
            print("NO CYCLE")

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
        logger.info("--> Add contained edges...")
        for ctx in tqdm(self.task_graph.contexts):
            for sink_ctx in ctx.get_contained_contexts():
                # check if sink_ctx is an entry to a successor sequence
                if sink_ctx.predecessor is None:
                    self.add_edge(ctx, sink_ctx)
        logger.info("--> Add dependencies on called functions...")
        for ctx in tqdm(self.task_graph.contexts):
            for sink_ctx in ctx.get_contained_contexts():
                if isinstance(sink_ctx, InlinedFunctionContext):
                    self.add_edge(ctx, sink_ctx)
        logger.info("--> Add dependencies to force synchronization at exit nodes via synthetic landing pads...")
        required_synthetic_landing_pads: List[List[Context]] = []
        for ctx in tqdm(self.graph.nodes):
            # filter for entry nodes
            if len(self.get_predecessors(ctx)) != 0:
                continue
            # found entry node
            # get descendants without successors, aka leaf nodes
            leaf_nodes: List[Context] = []
            for desc in nx.descendants(self.graph, ctx):
                if len(self.get_successors(desc)) != 0:
                    continue
                # found leaf node
                leaf_nodes.append(desc)
            # register a synthetic landing pad for later creation
            if len(leaf_nodes) > 1:
                required_synthetic_landing_pads.append(leaf_nodes)
        # create synthetic landing pads
        for leaf_nodes in required_synthetic_landing_pads:
            landing_pad = WorkContext()
            self.add_node(landing_pad)
            for leaf in leaf_nodes:
                self.add_edge(leaf, landing_pad)
            logger.info("----> Added synthetic landing pad")

    def __simplify_graph(self) -> None:
        """Replace triangles in the graph with a CombinedContext node. Loop until no further triangles exist."""
        logger.info("Simplifying graph...")
        triangles_replaced = True
        while triangles_replaced:
            logger.info("--> iterating...")
            triangles_replaced = False
            queue: List[Context] = list(self.graph.nodes())
            while len(queue) > 0:
                node = queue.pop()
                predecessors = self.get_predecessors(node)
                if len(predecessors) < 2:
                    continue
                # check all combinations of predecessors for triangles
                triangle_nodes: Optional[Tuple[Context, Context]] = None
                for pred_1 in predecessors:
                    for pred_2 in predecessors:
                        if pred_1 == pred_2:
                            continue
                        # triangle exists, if pred_1 is a predecessor of pred_2 or vice versa
                        if pred_1 in self.get_predecessors(pred_2) or pred_2 in self.get_predecessors(pred_1):
                            triangle_nodes = (pred_1, pred_2)
                            break
                if triangle_nodes is None:
                    # did not find a triangle
                    continue
                # replace triangle with CombinedContext
                combined_context_node = CombinedContext()
                self.add_node(combined_context_node)
                # register contained contexts
                if isinstance(node, CombinedContext):
                    combined_context_node.contained_contexts = combined_context_node.contained_contexts.union(
                        node.contained_contexts
                    )
                else:
                    combined_context_node.contained_contexts.add(node)

                if isinstance(triangle_nodes[0], CombinedContext):
                    combined_context_node.contained_contexts = combined_context_node.contained_contexts.union(
                        triangle_nodes[0].contained_contexts
                    )
                else:
                    combined_context_node.contained_contexts.add(triangle_nodes[0])

                if isinstance(triangle_nodes[1], CombinedContext):
                    combined_context_node.contained_contexts = combined_context_node.contained_contexts.union(
                        triangle_nodes[1].contained_contexts
                    )
                else:
                    combined_context_node.contained_contexts.add(triangle_nodes[1])

                # check validity of the transformation. Do not allow the creation of bi-directional edges
                # -> get predecessors and successors
                raw_outside_predecessors = [
                    n
                    for n in self.get_predecessors(node)
                    + self.get_predecessors(triangle_nodes[0])
                    + self.get_predecessors(triangle_nodes[1])
                ]
                raw_outside_successors = [
                    n
                    for n in self.get_successors(node)
                    + self.get_successors(triangle_nodes[0])
                    + self.get_successors(triangle_nodes[1])
                ]
                # -> remove duplicates
                raw_outside_predecessors = list(set(raw_outside_predecessors))
                raw_outside_successors = list(set(raw_outside_successors))
                # -> cleanup
                outside_predecessors = [
                    n
                    for n in raw_outside_predecessors
                    if not (n == node or n == triangle_nodes[0] or n == triangle_nodes[1])
                ]
                outside_successors = [
                    n
                    for n in raw_outside_successors
                    if not (n == node or n == triangle_nodes[0] or n == triangle_nodes[1])
                ]
                # -> check if bi-directional edges would be created
                skip_triangle = False
                for pred in outside_predecessors:
                    if pred in outside_successors:
                        # bi-directional edge would be created! Ignore triangle.
                        skip_triangle = True
                        break
                if skip_triangle:
                    continue

                # redirect incoming edges
                for pred in outside_predecessors:
                    self.add_edge(pred, combined_context_node)

                # redirect outgoing edges
                for succ in outside_successors:
                    self.add_edge(combined_context_node, succ)

                # remove triangle nodes from queue
                if triangle_nodes[0] in queue:
                    queue.remove(triangle_nodes[0])
                if triangle_nodes[1] in queue:
                    queue.remove(triangle_nodes[1])
                # delete triangle nodes
                self.graph.remove_node(node)
                self.graph.remove_node(triangle_nodes[0])
                self.graph.remove_node(triangle_nodes[1])
                # allow one more iteration
                triangles_replaced = True

        logger.info("--> removing trivial nodes")
        to_be_removed: List[Context] = []
        for node in tqdm(self.graph.nodes):
            if len(self.get_predecessors(node)) == 0 and len(self.get_successors(node)) == 0:
                to_be_removed.append(node)
        for node in to_be_removed:
            self.graph.remove_node(node)

    def __print_graph_statistics(self, label: str = "") -> None:
        logger.info("####################")
        logger.info("# Graph statistics: " + label)
        logger.info("# Node count: " + str(len(self.graph.nodes)))
        logger.info("# Edge count:  " + str(len(self.graph.edges)))
        logger.info("####################")

    def get_predecessors(self, node: Optional[Context]) -> List[Context]:
        if node is None:
            return []
        predecessors = list(set([s for s, t in self.graph.in_edges(node)]))
        return predecessors

    def get_successors(self, node: Optional[Context]) -> List[Context]:
        if node is None:
            return []
        successors = list(set([t for s, t in self.graph.out_edges(node)]))
        return successors

    def plot(self, highlight_nodes: Optional[List[Context]] = None) -> None:
        self.update_plot(highlight_nodes)
        print("Waiting for user to close the Window...")
        plt.show()

    def update_plot(self, highlight_nodes: Optional[List[Context]] = None) -> None:
        logger.info("Plotting...")
        plt.clf()

        logger.info("---> generating layout...")
        positions = nx.nx_pydot.pydot_layout(self.graph, prog="sfdp")  # prog="dot")
        logger.info("--->    Done.")

        # draw regular nodes
        if highlight_nodes is None:
            nx.draw_networkx_nodes(self.graph, positions)
        else:
            nx.draw_networkx_nodes(
                self.graph, positions, nodelist=[n for n in self.graph.nodes() if n not in highlight_nodes]
            )
        # draw highlighted nodes
        if highlight_nodes is not None:
            nx.draw_networkx_nodes(self.graph, positions, nodelist=highlight_nodes, node_color="red")
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
