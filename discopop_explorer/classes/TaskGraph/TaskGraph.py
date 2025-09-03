# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import copy
import random
import signal
import logging
from typing import Any, Dict, List, Optional, Set, Tuple, Union, cast
import warnings
import networkx as nx  # type: ignore
import matplotlib
from networkx import Graph
from tqdm import tqdm

from discopop_explorer.aliases.LineID import LineID
from discopop_explorer.aliases.NodeID import NodeID
from discopop_explorer.classes.PEGraph.CUNode import CUNode
from discopop_explorer.classes.PEGraph.Dependency import Dependency
from discopop_explorer.classes.TaskGraph.Branching.TGEndBranchNode import TGEndBranchNode
from discopop_explorer.classes.TaskGraph.Branching.TGEndBranchParentNode import TGEndBranchParentNode
from discopop_explorer.classes.TaskGraph.Branching.TGStartBranchNode import TGStartBranchNode
from discopop_explorer.classes.TaskGraph.Branching.TGStartBranchParentNode import TGStartBranchParentNode
from discopop_explorer.classes.TaskGraph.Contexts.BranchContext import BranchContext
from discopop_explorer.classes.TaskGraph.Contexts.BranchingParentContext import BranchingParentContext
from discopop_explorer.classes.TaskGraph.Contexts.Context import Context
from discopop_explorer.classes.TaskGraph.Contexts.FunctionContext import FunctionContext
from discopop_explorer.classes.TaskGraph.Contexts.IterationContext import IterationContext
from discopop_explorer.classes.TaskGraph.Contexts.LoopParentContext import LoopParentContext
from discopop_explorer.classes.TaskGraph.Contexts.utils import (
    CallStackElementType,
    convert_callstacks_to_lineIDs,
    get_context_call_stack,
)
from discopop_explorer.classes.TaskGraph.Functions.TGEndFunctionNode import TGEndFunctionNode
from discopop_explorer.classes.TaskGraph.Functions.TGEndInlinedFunctionNode import TGEndInlinedFunctionNode
from discopop_explorer.classes.TaskGraph.Functions.TGStartFunctionNode import TGStartFunctionNode
from discopop_explorer.classes.TaskGraph.Functions.TGStartInlinedFunctionNode import TGStartInlinedFunctionNode
from discopop_explorer.classes.TaskGraph.Loops.TGEndLoopNode import TGEndLoopNode
from discopop_explorer.classes.TaskGraph.Loops.TGEndtIterationNode import TGEndIterationNode
from discopop_explorer.classes.TaskGraph.Loops.TGStartIterationNode import TGStartIterationNode
from discopop_explorer.classes.TaskGraph.Loops.TGStartLoopNode import TGStartLoopNode
from discopop_explorer.classes.TaskGraph.RootNode import RootNode
from discopop_explorer.classes.TaskGraph.TGFunctionNode import TGFunctionNode
from discopop_explorer.classes.TaskGraph.VisitorMarker import EndFunctionMarker, VisitorMarker
from discopop_explorer.enums.DepType import DepType
from discopop_explorer.enums.EdgeType import EdgeType
from discopop_explorer.functions.PEGraph.properties.is_loop_index import is_loop_index
from discopop_explorer.functions.PEGraph.traversal.called_functions import get_called_nodes
from discopop_explorer.functions.PEGraph.traversal.children import get_entry_child
from discopop_explorer.functions.PEGraph.traversal.parent import get_parent_function
from discopop_explorer.functions.PEGraph.traversal.predecessors import direct_predecessors
from discopop_explorer.functions.PEGraph.traversal.successors import direct_successors

matplotlib.use("TkAgg")
import matplotlib.pyplot as plt  # type:ignore
from matplotlib.patches import Rectangle

from discopop_explorer.classes.PEGraph.FunctionNode import FunctionNode
from discopop_explorer.classes.PEGraph.PEGraphX import PEGraphX
from discopop_explorer.classes.TaskGraph.Aliases import (
    FunctionID,
    LevelIndex,
    PETNode,
    PETNodeID,
    PositionIndex,
    TGNodeID,
)
from discopop_explorer.classes.TaskGraph.TGNode import TGNode
from discopop_explorer.enums.NodeType import NodeType
from discopop_explorer.functions.PEGraph.queries.nodes import all_nodes
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg

logger = logging.getLogger("Explorer")


# Aliases
TGConstructionQueueElement = Tuple[Optional[TGNode], Union[PETNode, VisitorMarker]]  # (Predecessor, current element)


class TaskGraph(object):
    pet: PEGraphX
    graph: nx.MultiDiGraph
    root: TGNode
    function_id_map: Dict[PETNodeID, FunctionID] = dict()
    TGNode_pet_node_id_to_tg_node: Dict[PETNodeID, TGNode] = dict()
    TGFunctionNode_pet_node_id_to_tg_node: Dict[PETNodeID, TGFunctionNode] = dict()
    TGStartFunctionNode_pet_node_id_to_tg_node: Dict[PETNodeID, TGStartFunctionNode] = dict()
    TGEndFunctionNode_pet_node_id_to_tg_node: Dict[PETNodeID, TGEndFunctionNode] = dict()
    contexts: List[Context] = []
    current_level: LevelIndex = 0
    current_position: Dict[LevelIndex, PositionIndex] = {0: 0}
    plotting_axis = None  # type: ignore
    plotting_graph_buffer = None
    plotting_postions_buffer = None

    def __init__(self, pet: PEGraphX) -> None:
        self.pet = pet
        self.graph = nx.MultiDiGraph()
        # define updating plot window
        fig1 = plt.figure(1)
        self.plotting_axis = fig1.add_subplot(1, 1, 1)
        plt.ion()
        # start processing
        self.__assign_function_ids(pet)
        self.__construct_from_pet(pet)
        print("Waiting for user to close the Window...")
        # plt.show(block=True)
        plt.ioff()

    def __assign_function_ids(self, pet: PEGraphX) -> None:
        id = 0
        for function in all_nodes(pet, type=FunctionNode):
            self.function_id_map[function.id] = id
            id += 1
        logger.info("Assigned function ids:\n" + str(self.function_id_map))

    def __construct_from_pet(self, pet: PEGraphX) -> None:
        logger.info("Hello world!")
        # prepare function graphs without calling
        self.__visit_pet(pet)
        self.__break_cycles()
        self.__fix_loop_structures()
        self.__duplicate_loop_iterations()
        self.__validate_graph_structure()
        self.__inline_function_calls()
        self.__add_branching_nodes()
        self.__assign_contexts()  # assign contexts before inlining to keep runtime of branching context detection in check
        self.__assign_node_levels()
        self.__calculate_context_nesting()
        self.__calculate_context_successions()
        self.__insert_data_dependencies()
        self.__validate_data_dependencies()

    def add_node(self, node: TGNode) -> None:
        self.graph.add_node(node)

    def add_edge(self, source: Optional[TGNode], target: Optional[TGNode]) -> None:
        if source is None or target is None:
            return
        # disallow duplicate edges
        if self.graph.has_edge(source, target):
            return
        self.graph.add_edge(source, target)

    def __get_next_level(self) -> LevelIndex:
        buffer = self.current_level
        self.current_level += 1
        self.current_position[self.current_level] = 0
        return buffer

    def __get_current_level(self) -> LevelIndex:
        return self.current_level

    def __get_next_position(self, level: LevelIndex) -> PositionIndex:
        buffer = self.current_position[self.current_level]
        self.current_position[self.current_level] += 1
        return buffer

    def plot(self, highlight_nodes: Optional[List[TGNode]] = None) -> None:
        self.update_plot(self.graph, highlight_nodes=highlight_nodes)
        print("Waiting for user to close the Window...")
        plt.show()

    def quick_layout(self, subgraph: Optional[Graph] = None) -> Dict[TGNode, Tuple[float, float]]:
        logger.info("----> generating quick layout...")
        if subgraph is None:
            graph = self.graph
        else:
            graph = subgraph
        positions: Dict[TGNode, Tuple[float, float]] = dict()
        entries: List[TGNode] = []
        for node in graph.nodes:
            if graph.in_degree(node) > 0:
                continue
            entries.append(node)

        # assign positions by dfs-traversing
        occupied_positions: Dict[int, int] = dict()
        current_x_offset = 0
        for entry in entries:
            # get x offset of the current tree and reset the occupied positions
            current_x_offset = max(occupied_positions.values()) if len(occupied_positions.values()) > 0 else 0
            occupied_positions.clear()
            # assign positions
            queue: List[Tuple[TGNode, int]] = [(entry, 0)]
            while len(queue) > 0:
                current_node, current_level = queue.pop()
                if current_node in positions:
                    continue

                if current_level not in occupied_positions:
                    occupied_positions[current_level] = current_x_offset
                occupied_positions[current_level] += 1
                current_position = occupied_positions[current_level]
                positions[current_node] = (float(current_position), float(-current_level))

                out_edges = graph.out_edges(current_node)

                for _, target in out_edges:
                    queue.append((target, current_level + 1))
        return positions

    def update_plot(self, subgraph: Optional[Graph] = None, highlight_nodes: Optional[List[TGNode]] = None) -> None:
        logger.info("Plotting...")
        plt.clf()
        if subgraph is None:
            graph = self.graph
        else:
            graph = subgraph
        #         signal.signal(signal.SIGINT, signal.SIG_DFL)

        # TODO implement custon positioning for cases where only contexts are printed
        logger.info("---> generating layout...")
        # positions = nx.nx_pydot.pydot_layout(graph, prog="dot")
        positions = self.quick_layout(graph)
        logger.info("--->    Done.")

        # draw context patches
        min_patch_width = 1.0
        ax = plt.gca()
        for ctx in self.contexts:
            # calculate bounding box
            x_min = None
            x_max = None
            y_min = None
            y_max = None
            for ctx_node in ctx.get_contained_nodes(inclusive=True):
                if not graph.has_node(ctx_node):  # in case subgraphs are plotted
                    continue
                x, y = positions[ctx_node]
                if x_min is None:
                    x_min = x
                else:
                    x_min = min(x_min, x)
                if x_max is None:
                    x_max = x
                else:
                    x_max = max(x_max, x)
                if y_min is None:
                    y_min = y
                else:
                    y_min = min(y_min, y)
                if y_max is None:
                    y_max = y
                else:
                    y_max = max(y_max, y)

            if x_min is None:
                continue
            if x_max is None:
                continue
            if y_min is None:
                continue
            if y_max is None:
                continue

            # draw bounding box
            x_span = x_max - x_min
            y_span = y_max - y_min

            # force minimum x_span
            if x_span < min_patch_width:
                difference = min_patch_width - x_span
                x_span = min_patch_width
                x_min = x_min - (difference / 2)

            ax.add_patch(  # type: ignore
                Rectangle(
                    (x_min, y_min),
                    width=x_span,
                    height=y_span,
                    linewidth=1,
                    edgecolor=ctx.get_plot_border_color(),
                    facecolor=ctx.get_plot_face_color(),
                    alpha=ctx.get_plot_face_alpha(),
                )
            )

        # TODO add option to show contexts only
        # draw regular nodes
        if highlight_nodes is None:
            nx.draw_networkx_nodes(graph, positions)
        else:
            nx.draw_networkx_nodes(graph, positions, nodelist=[n for n in graph.nodes() if n not in highlight_nodes])
        # draw highlighted nodes
        if highlight_nodes is not None:
            nx.draw_networkx_nodes(graph, positions, nodelist=highlight_nodes, node_color="red")

        # draw edges
        nx.draw_networkx_edges(graph, positions)

        # get node labels
        labels = {}
        for node in graph.nodes():
            labels[node] = node.get_label()
        nx.draw_networkx_labels(graph, positions, labels, font_size=7)
        logger.info("---> showing...")

        self.plotting_graph_buffer = graph
        self.plotting_postions_buffer = positions

        plt.pause(0.01)

    def update_plot_node_color(self, nodes: List[TGNode], color: str) -> None:
        nx.draw_networkx_nodes(
            self.plotting_graph_buffer, self.plotting_postions_buffer, nodelist=nodes, node_color=color
        )

    def plot_context_graph(self) -> None:
        logger.info("Plotting context graph...")

        ctx_graph = nx.MultiDiGraph()
        for ctx in self.contexts:
            ctx_graph.add_node(ctx)
        # add contained edges for positioning
        for ctx in self.contexts:
            for contained_ctx in ctx.contained_contexts:
                ctx_graph.add_edge(ctx, contained_ctx)
        # add successor edges for positioning
        for ctx in self.contexts:
            if ctx.successor is not None:
                ctx_graph.add_edge(ctx, ctx.successor)
        # calculate layout
        positions = nx.nx_pydot.pydot_layout(ctx_graph, prog="dot")
        # remove successor edges for plotting contained edges
        for ctx in self.contexts:
            if ctx.successor is not None:
                ctx_graph.remove_edge(ctx, ctx.successor)
        # draw nodes
        node_colors = [ctx.get_plot_face_color() for ctx in self.contexts]
        nx.draw_networkx_nodes(ctx_graph, positions, nodelist=self.contexts, node_color=node_colors)
        # draw contained edges
        nx.draw_networkx_edges(ctx_graph, positions)
        # remove contained edges
        to_be_removed: List[Tuple[Any, Any]] = []
        for edge in ctx_graph.edges:
            to_be_removed.append(edge)
        for tbr in to_be_removed:
            ctx_graph.remove_edge(tbr[0], tbr[1])
        # draw successor edges
        for ctx in self.contexts:
            if ctx.successor is not None:
                ctx_graph.add_edge(ctx, ctx.successor)
        nx.draw_networkx_edges(ctx_graph, positions, edge_color="green")
        # remove successor edges
        to_be_removed = []
        for edge in ctx_graph.edges:
            to_be_removed.append(edge)
        for tbr in to_be_removed:
            ctx_graph.remove_edge(tbr[0], tbr[1])
        # draw dependency edges
        for ctx in self.contexts:
            targets: Set[Any] = set()
            for outgoing_dependency in ctx.outgoing_dependencies:
                targets.add(outgoing_dependency[0])
            for target in targets:
                ctx_graph.add_edge(ctx, target)
        nx.draw_networkx_edges(ctx_graph, positions, edge_color="red")

        # draw labels
        labels = {}
        for ctx in self.contexts:
            labels[ctx] = ctx.get_label()
        nx.draw_networkx_labels(ctx_graph, positions, labels, font_size=7)
        logger.info("---> showing...")
        print("Waiting for user to close the Window...")
        plt.show()

    def plot_context_debug_graph(self) -> None:
        logger.info("Plotting context debug graph...")

        ctx_graph = nx.MultiDiGraph()
        for ctx in self.contexts:
            ctx_graph.add_node(ctx)
            for ctx_cont_node in ctx.contained_nodes:
                ctx_graph.add_node(ctx_cont_node)
        # add contained edges for positioning
        for ctx in self.contexts:
            for contained_ctx in ctx.contained_contexts:
                ctx_graph.add_edge(ctx, contained_ctx)
            for ctx_cont_node in ctx.contained_nodes:
                ctx_graph.add_edge(ctx, ctx_cont_node)
        # calculate layout
        positions = nx.nx_pydot.pydot_layout(ctx_graph, prog="dot")
        # draw nodes
        nx.draw_networkx_nodes(ctx_graph, positions, nodelist=self.contexts, node_color="orange")
        nx.draw_networkx_nodes(
            ctx_graph, positions, nodelist=[n for n in ctx_graph.nodes if n not in self.contexts], node_color="cyan"
        )
        # draw contained edges
        nx.draw_networkx_edges(ctx_graph, positions)
        # draw dependency edges
        tbr = []
        for edge in ctx_graph.edges:
            tbr.append(edge)
        for edge in tbr:
            ctx_graph.remove_edge(edge[0], edge[1])
        for ctx in self.contexts:
            for deps in ctx.outgoing_dependencies:
                ctx_graph.add_edge(ctx, deps[0])
        nx.draw_networkx_edges(ctx_graph, positions, edge_color="red")
        # draw labels
        labels = {}
        for node in ctx_graph.nodes:
            labels[node] = node.get_label()
        nx.draw_networkx_labels(ctx_graph, positions, labels, font_size=7)
        logger.info("---> showing...")
        print("Waiting for user to close the Window...")
        plt.show()

    def __get_or_insert_TGNode(self, pet_node_id: PETNodeID, level: LevelIndex, position: PositionIndex) -> TGNode:
        if pet_node_id is not None:
            if pet_node_id in self.TGNode_pet_node_id_to_tg_node:
                return self.TGNode_pet_node_id_to_tg_node[pet_node_id]
            node = TGNode(pet_node_id, level, position)
            self.TGNode_pet_node_id_to_tg_node[pet_node_id] = node
            return node
        return TGNode(pet_node_id, level, position)

    def __get_or_insert_TGFunctionNode(
        self, pet_node_id: PETNodeID, level: LevelIndex, position: PositionIndex
    ) -> TGFunctionNode:
        if pet_node_id is not None:
            if pet_node_id in self.TGFunctionNode_pet_node_id_to_tg_node:
                return self.TGFunctionNode_pet_node_id_to_tg_node[pet_node_id]
            node = TGFunctionNode(pet_node_id, level, position)
            self.TGFunctionNode_pet_node_id_to_tg_node[pet_node_id] = node
            return node
        return TGFunctionNode(pet_node_id, level, position)

    def __get_or_insert_TGStartFunctionNode(
        self, pet_node_id: PETNodeID, level: LevelIndex, position: PositionIndex
    ) -> TGStartFunctionNode:
        if pet_node_id is not None:
            if pet_node_id in self.TGStartFunctionNode_pet_node_id_to_tg_node:
                return self.TGStartFunctionNode_pet_node_id_to_tg_node[pet_node_id]
            node = TGStartFunctionNode(pet_node_id, level, position)
            self.TGStartFunctionNode_pet_node_id_to_tg_node[pet_node_id] = node
            return node
        return TGStartFunctionNode(pet_node_id, level, position)

    def __get_or_insert_TGEndFunctionNode(
        self, pet_node_id: PETNodeID, level: LevelIndex, position: PositionIndex
    ) -> TGEndFunctionNode:
        if pet_node_id is not None:
            if pet_node_id in self.TGEndFunctionNode_pet_node_id_to_tg_node:
                return self.TGEndFunctionNode_pet_node_id_to_tg_node[pet_node_id]
            node = TGEndFunctionNode(pet_node_id, level, position)
            self.TGEndFunctionNode_pet_node_id_to_tg_node[pet_node_id] = node
            return node
        return TGEndFunctionNode(pet_node_id, level, position)

    def node_registered(self, pet_node_id: PETNodeID) -> bool:
        return pet_node_id in self.TGNode_pet_node_id_to_tg_node

    def __visit_pet(self, pet: PEGraphX) -> None:
        # construct Taskgraph by visiting the PET Graph
        root = RootNode(None, self.__get_next_level(), self.__get_next_position(self.__get_current_level()))
        self.add_node(root)
        self.root = root

        pet_root = pet.main
        pet_root_node = self.__get_or_insert_TGFunctionNode(
            pet_root.id, self.__get_next_level(), self.__get_next_position(self.__get_current_level())
        )

        functions = all_nodes(self.pet, FunctionNode)

        queue: List[TGConstructionQueueElement] = [(root, pet_root)] + [(None, func) for func in functions]

        while len(queue) > 0:
            predecessor, current = queue.pop(0)
            if isinstance(current, VisitorMarker):
                queue = self.__visit_marker(predecessor, current, queue)
            else:
                queue = self.__visit_node(predecessor, current, queue)

    def __visit_node(
        self, predecessor: Optional[TGNode], pet_node: PETNode, queue: List[TGConstructionQueueElement]
    ) -> List[TGConstructionQueueElement]:
        if pet_node.type == NodeType.CU:
            queue = self.__visit_CUNode(predecessor, pet_node, queue)
        elif pet_node.type == NodeType.FUNC:
            queue = self.__visit_FunctionNode(predecessor, pet_node, queue)
        elif pet_node.type == NodeType.LOOP:
            queue = self.__visit_LoopNode(predecessor, pet_node, queue)
        else:
            warnings.warn("Unsupported node type encountered: " + str(pet_node.type))
        return queue

    def __visit_marker(
        self, predecessor: Optional[TGNode], marker: VisitorMarker, queue: List[TGConstructionQueueElement]
    ) -> List[TGConstructionQueueElement]:
        if isinstance(marker, EndFunctionMarker):
            queue = self.__visit_EndFunctionMarker(predecessor, marker, queue)
        return queue

    def __visit_EndFunctionMarker(
        self, predecessor: Optional[TGNode], marker: EndFunctionMarker, queue: List[TGConstructionQueueElement]
    ) -> List[TGConstructionQueueElement]:
        #        self.context_stack.remove(marker.context)
        node = self.__get_or_insert_TGEndFunctionNode(
            marker.function_node, self.__get_next_level(), self.__get_next_position(self.__get_current_level())
        )
        self.add_node(node)
        self.add_edge(predecessor, node)
        return queue

    def __visit_CUNode(
        self, predecessor: Optional[TGNode], pet_node: PETNode, queue: List[TGConstructionQueueElement]
    ) -> List[TGConstructionQueueElement]:
        successors = direct_successors(self.pet, pet_node)
        if len(successors) > 1:
            return self.__visit_branching(predecessor, pet_node, queue)
        node = self.__get_or_insert_TGNode(
            pet_node.id, self.__get_next_level(), self.__get_next_position(self.__get_current_level())
        )
        self.add_node(node)
        self.add_edge(predecessor, node)

        if len(successors) > 0:
            queue.append((node, successors[0]))
        else:
            # determine parent function
            for pred in direct_predecessors(self.pet, pet_node):
                try:
                    parent_function = get_parent_function(self.pet, pred)
                    queue.append(
                        (
                            node,
                            EndFunctionMarker(
                                parent_function.id,
                                self.__get_next_level(),
                                self.__get_next_position(self.__get_current_level()),
                            ),
                        )
                    )
                    break
                except:
                    continue

        return queue

    def __visit_branching(
        self, predecessor: Optional[TGNode], pet_node: PETNode, queue: List[TGConstructionQueueElement]
    ) -> List[TGConstructionQueueElement]:
        node = self.__get_or_insert_TGNode(
            pet_node.id, self.__get_next_level(), self.__get_next_position(self.__get_current_level())
        )
        self.add_node(node)
        self.add_edge(predecessor, node)

        for successor in direct_successors(self.pet, pet_node):
            if not self.node_registered(successor.id):
                queue.append((node, successor))

        return queue

    def __visit_FunctionNode(
        self, predecessor: Optional[TGNode], pet_node: PETNode, queue: List[TGConstructionQueueElement]
    ) -> List[TGConstructionQueueElement]:

        func_node = self.__get_or_insert_TGFunctionNode(
            pet_node.id, self.__get_current_level(), self.__get_next_position(self.__get_current_level())
        )
        self.add_node(func_node)
        self.add_edge(predecessor, func_node)

        func_start_node = self.__get_or_insert_TGStartFunctionNode(
            pet_node.id, self.__get_current_level(), self.__get_next_position(self.__get_current_level())
        )
        self.add_node(func_start_node)
        self.add_edge(func_node, func_start_node)

        queue.append((func_start_node, get_entry_child(self.pet, pet_node)[0]))

        return queue

    def __visit_LoopNode(
        self, predecessor: Optional[TGNode], pet_node: PETNode, queue: List[TGConstructionQueueElement]
    ) -> List[TGConstructionQueueElement]:
        warnings.warn("Not implemented!")
        return queue

    def __break_cycles(self) -> None:
        # search for cycles in each function and replace them with two distinct iteraions
        logger.info("Breaking cycles...")

        for function_node in self.TGFunctionNode_pet_node_id_to_tg_node.values():
            logger.info("--> " + function_node.get_label())
            # progress search if cycle can not be broken
            search_source: TGNode = function_node
            search_source_queue = self.get_descendants(function_node)

            while True:
                # find cycle
                try:
                    cycle = nx.find_cycle(self.graph, source=search_source)
                except nx.NetworkXNoCycle:
                    # no further cycles in function
                    break
                cycle_nodes: Set[TGNode] = set()
                for tpl in cycle:
                    cycle_nodes.add(tpl[0])
                    cycle_nodes.add(tpl[1])

                # find entry node and exit node
                entry_node: Optional[TGNode] = None
                exit_node: Optional[TGNode] = None
                iteration_entry_points: List[TGNode] = []
                queue: List[TGNode] = [function_node]
                visited: Set[TGNode] = set()
                while len(queue) > 0:
                    exit_node = None
                    current = queue.pop(0)
                    visited.add(current)
                    #                    print("\nCurrent: ", current)
                    #                    print("Cycle nodes: ", cycle_nodes)
                    successors = self.get_successors(current)
                    #                    print("IN CYCLE: ", current in cycle_nodes)
                    #                    print("SUCC: ", len(successors))
                    #                    print("---> ", successors)

                    if len(successors) > 1:
                        if current in cycle_nodes:

                            found_successor_in_cycle = False
                            for succ in successors:
                                if succ in cycle_nodes:
                                    found_successor_in_cycle = True
                                if succ not in cycle_nodes:
                                    exit_node = succ
                                if exit_node is not None and found_successor_in_cycle:
                                    break
                            if exit_node is not None and found_successor_in_cycle:
                                entry_node = current
                                iteration_entry_points = [n for n in successors if n in cycle_nodes]
                                break
                        else:
                            for succ in successors:
                                if succ not in visited and succ not in queue:
                                    queue.append(succ)
                    elif len(successors) == 1:
                        if successors[0] not in visited and successors[0] not in queue:
                            queue.append(successors[0])
                    else:
                        continue

                iteration_exit_points: List[TGNode] = [p for p in self.get_predecessors(entry_node) if p in cycle_nodes]

                #                print("Found entry node: ", entry_node.get_label() if entry_node is not None else "NONE")
                #                print("Found exit node: ", exit_node.get_label() if exit_node is not None else "NONE")
                #                print("Found iteration entry points: ", [n.get_label() for n in iteration_entry_points])
                #                print("Found iteration exit points: ", [n.get_label() for n in iteration_exit_points])

                if entry_node is not None and exit_node is not None:
                    # cycle can be broken. Reset search point for cycle search
                    search_source_queue = self.get_descendants(function_node)
                    search_source = function_node

                    # break cycle
                    for itexp in iteration_exit_points:
                        self.graph.remove_edge(itexp, entry_node)
                        logger.info("  --> Removed edge " + itexp.get_label() + " --> " + entry_node.get_label())

                    # add loop start marking between entry_node and its predecessors
                    lsm = TGStartLoopNode(entry_node.pet_node_id, entry_node.level, entry_node.position)
                    self.add_node(lsm)
                    for pred in self.get_predecessors(entry_node):
                        self.graph.remove_edge(pred, entry_node)
                        self.add_edge(pred, lsm)
                    self.add_edge(lsm, entry_node)

                    # add loop end marking between entry_node and exit_node
                    lem = TGEndLoopNode(entry_node.pet_node_id, entry_node.level, entry_node.position)
                    self.add_node(lem)
                    self.graph.remove_edge(entry_node, exit_node)
                    self.add_edge(entry_node, lem)
                    self.add_edge(lem, exit_node)

                    # add iteration entry markings between entry_node and iteration_entry_points
                    ism_list: List[TGStartIterationNode] = []
                    for itenp in iteration_entry_points:
                        self.graph.remove_edge(entry_node, itenp)
                        ism = TGStartIterationNode(
                            itenp.pet_node_id, itenp.level, itenp.position, entry_node.pet_node_id
                        )
                        ism_list.append(ism)
                        self.add_node(ism)
                        self.add_edge(entry_node, ism)
                        self.add_edge(ism, itenp)

                    # add iteration exit markings after iteration_exit_points
                    iem_list: List[TGEndIterationNode] = []
                    for itexp in iteration_exit_points:
                        iem = TGEndIterationNode(itexp.pet_node_id, itexp.level, itexp.position, entry_node.pet_node_id)
                        iem_list.append(iem)
                        self.add_node(iem)
                        self.add_edge(itexp, iem)

                    # redirect edge from entry -> end_loop to iteration_exit markers -> end_loop
                    self.graph.remove_edge(entry_node, lem)
                    for iem in iem_list:
                        self.add_edge(iem, lem)

                else:
                    logger.warning(
                        "NO entry_node and exit_node found for cycle: "
                        + str([(t[0].get_label(), t[1].get_label()) for t in cycle])
                    )
                    # crudely break the cycle by removing the edge back to the first encountered node
                    logger.warning(
                        "--> crudely broken cycle by removing edge: "
                        + str((cycle[-1][0].get_label(), cycle[-1][1].get_label()))
                    )
                    self.graph.remove_edge(cycle[-1][0], cycle[-1][1])
                    # try to minimize the "error" by connecting the end of the cycle to a successor of the "entry" node, if it is outside the cycle
                    outside_successor = None
                    for succ in self.get_successors(cycle[-1][0]):
                        if succ not in cycle_nodes:
                            outside_successor = succ
                            break
                    if outside_successor is not None:
                        self.add_edge(cycle[-1][1], outside_successor)
                        logger.warning(
                            "----> added new edge to outside successor: "
                            + str((cycle[-1][1].get_label(), outside_successor.get_label()))
                        )
                    else:
                        # if this is not possible, connect the exit to the function exit node to preserve the correct graph structure
                        descendants = self.get_descendants(function_node)
                        function_exit_nodes = [
                            d
                            for d in descendants
                            if type(d) is TGEndFunctionNode and d.pet_node_id == function_node.pet_node_id
                        ]
                        if len(function_exit_nodes) > 0:
                            self.add_edge(cycle[-1][1], function_exit_nodes[0])
                            logger.warning(
                                "----> added new edge to function exit node: "
                                + str((cycle[-1][1].get_label(), function_exit_nodes[0].get_label()))
                            )
                        else:
                            raise ValueError(
                                "Could neither determine outside loop successor nor function exit node for broken cycle: "
                                + str([(t[0].get_label(), t[1].get_label()) for t in cycle])
                            )

                    # progress search
                    if len(search_source_queue) > 0:
                        search_source = search_source_queue.pop(0)
                    else:
                        break

    def __fix_loop_structures(self, plot_problematic_loops: bool = False) -> None:
        # in case a loop contains a branch to a non-iteration node (e.g. via "break"- statement), delete this edge and cleanup the graph
        logger.info("Fixing loop structures...")
        for function_node in tqdm(self.TGFunctionNode_pet_node_id_to_tg_node.values()):
            logger.info("--> " + function_node.get_label())
            modification_found = True
            while modification_found:
                modification_found = False
                descendants = self.get_descendants(function_node)
                # find problematic loops
                start_iteration_nodes = [d for d in descendants if isinstance(d, TGStartIterationNode)]
                end_iteration_nodes = [d for d in descendants if isinstance(d, TGEndIterationNode)]
                for sin in start_iteration_nodes:
                    for ein in end_iteration_nodes:
                        if sin.pet_node_id != ein.pet_node_id:
                            continue
                        # filter corresponding start and end iteration nodes
                        if not nx.has_path(self.graph, sin, ein):
                            continue
                        shortest_path = nx.shortest_path(self.graph, sin, ein)
                        if (
                            len(
                                [
                                    n
                                    for n in shortest_path
                                    if (n.pet_node_id == sin.pet_node_id) and isinstance(n, TGStartIterationNode)
                                ]
                            )
                            > 1
                        ):
                            # more than one iteration start node found
                            continue
                        if (
                            len(
                                [
                                    n
                                    for n in shortest_path
                                    if (n.pet_node_id == ein.pet_node_id) and isinstance(n, TGEndIterationNode)
                                ]
                            )
                            > 1
                        ):
                            # more than one iteration end node found
                            continue

                        iteration_nodes = self.__get_iteration_nodes(sin, ein)
                        # check iteration nodes for branches to outside the iteration
                        invalid_edges: List[(Tuple[TGNode, TGNode])] = []
                        for itn in iteration_nodes:
                            if itn == ein:
                                continue
                            for succ in self.get_successors(itn):
                                if succ not in iteration_nodes:
                                    invalid_edges.append((itn, succ))

                        if len(invalid_edges) == 0:
                            continue
                        # found problematic loop
                        print("Invalid edges: ", [(e[0].get_label(), e[1].get_label()) for e in invalid_edges])

                        # show problematic loop
                        if plot_problematic_loops:
                            self.update_plot(
                                subgraph=nx.subgraph(self.graph, descendants),
                                highlight_nodes=[e[1] for e in invalid_edges],
                            )

                        # issue warningn and delete problematic edges
                        loop_position_string = (
                            ("line " + self.pet.node_at(sin.pet_node_id).start_position())
                            if sin.pet_node_id is not None
                            else ("CU ID " + str(sin.pet_node_id))
                        )
                        reason_position_string = ""

                        logger.warning(
                            "Found and fixing invalid loop structure in loop at "
                            + loop_position_string
                            + ". Reasons found at lines:"
                        )
                        for invalid_source in [e[0] for e in invalid_edges]:
                            logger.warning(
                                "--> "
                                + (
                                    self.pet.node_at(invalid_source.pet_node_id).start_position()
                                    if invalid_source.pet_node_id is not None
                                    else "NONE"
                                )
                            )
                        logger.warning(
                            "Typical reasons include break statements and similar. Treat results using this loop with caution."
                        )

                        for invalid_edge_source, invalid_edge_target in invalid_edges:
                            if self.graph.has_edge(invalid_edge_source, invalid_edge_target):
                                self.graph.remove_edge(invalid_edge_source, invalid_edge_target)

                        # cleanup the graph by deleting nodes with no incoming edges
                        for _, invalid_edge_target in invalid_edges:
                            queue: List[TGNode] = [invalid_edge_target]
                            while len(queue) > 0:
                                current = queue.pop(0)
                                if not self.graph.has_node(current):
                                    continue
                                predecessors = self.get_predecessors(current)
                                if len(predecessors) == 0:
                                    # mark successors for potential cleanup
                                    queue += [s for s in self.get_successors(current) if s not in queue]
                                    # delete current node
                                    logger.warning("---> deleting node: " + current.get_label())
                                    self.graph.remove_node(current)
                                    modification_found = True
                        if modification_found:
                            break
                    if modification_found:
                        break

    def __duplicate_loop_iterations(self, plot_progress: bool = False) -> None:
        logger.info("Duplicating loop iterations...")
        for function_node in tqdm(self.TGFunctionNode_pet_node_id_to_tg_node.values()):
            logger.info("--> " + function_node.get_label())
            added_copies: Set[TGNode] = set()  # do not allow the re-copying of copies
            already_considered: Set[TGNode] = set()  # do not allo the re-copying of nodes
            modification_found = True
            # plotting progress
            if plot_progress:
                original_descendants = self.get_descendants(function_node)
                self.update_plot(self.graph.subgraph(original_descendants))
                original_start_iteration_nodes = [
                    cast(TGNode, d) for d in original_descendants if isinstance(d, TGStartIterationNode)
                ]
                original_end_iteration_nodes = [
                    cast(TGNode, d) for d in original_descendants if isinstance(d, TGEndIterationNode)
                ]
                self.update_plot_node_color(original_start_iteration_nodes, color="orange")
                self.update_plot_node_color(original_end_iteration_nodes, color="orange")

            # retry duplication of loop iterations until each iteration in the function is followied by a duplicate
            # multiple tries are necessary, as every occurence of a loop needs to be duplicated
            while modification_found:
                modification_found = False
                logger.info("--> " + function_node.get_label())
                descendants = self.get_descendants(function_node)
                # plotting progress
                if plot_progress:
                    self.update_plot_node_color([n for n in original_descendants if n in already_considered], "green")

                start_iteration_nodes = [
                    d
                    for d in descendants
                    if isinstance(d, TGStartIterationNode) and d not in added_copies and d not in already_considered
                ]
                end_iteration_nodes = [
                    d
                    for d in descendants
                    if isinstance(d, TGEndIterationNode) and d not in added_copies and d not in already_considered
                ]

                # filter start_iteration_nodes to those, which have not already been duplicated
                filtered_start_iteration_nodes: List[TGStartIterationNode] = []
                for sin in start_iteration_nodes:
                    already_duplicated = False
                    for pred in self.get_predecessors(sin):
                        if (
                            isinstance(pred, TGEndIterationNode)
                            and pred.parent_loop_pet_node_id == sin.parent_loop_pet_node_id
                        ):
                            already_duplicated = True
                            break
                    if not already_duplicated:
                        filtered_start_iteration_nodes.append(sin)
                # filter end_iteration_nodes to those, which have not already been duplicated
                filtered_end_iteration_nodes: List[TGEndIterationNode] = []
                for ein in end_iteration_nodes:
                    already_duplicated = False
                    #                    print("EIN: ", ein.get_label(), ein)
                    #                    print("EIN SUCC: ", [n.get_label() for n in self.get_successors(ein)])
                    for succ in self.get_successors(ein):
                        if (
                            isinstance(succ, TGStartIterationNode)
                            and succ.parent_loop_pet_node_id == ein.parent_loop_pet_node_id
                        ):
                            already_duplicated = True
                            #                            print("--> Already duplicated")
                            break
                    if not already_duplicated:
                        filtered_end_iteration_nodes.append(ein)

                # find corresponding end iteration node for each start
                for sin in filtered_start_iteration_nodes:
                    #                    print("SIN: ", sin.get_label())
                    for ein in filtered_end_iteration_nodes:
                        #                        print("EIN: ", ein.get_label())
                        # only consider pairs with equal corresponding pet_node_id's
                        if sin.parent_loop_pet_node_id != ein.parent_loop_pet_node_id:
                            continue

                        # get iteration nodes
                        iteration_nodes = self.__get_iteration_nodes(sin, ein)
                        if len(iteration_nodes) == 0:
                            continue

                        # copy the iteration nodes and connect them to the original iteration
                        ein_successors = self.get_successors(ein)
                        for succ in ein_successors:
                            self.graph.remove_edge(ein, succ)
                        copied_nodes: Dict[TGNode, TGNode] = dict()

                        copied_nodes, copied_path, copied_iteration_entry, copied_iteration_exit = (
                            self.__copy_iteration_subgraph(copied_nodes, iteration_nodes, sin, ein)
                        )
                        #                            print("COPIED PATH: ", [n.get_label() for n in copied_path])
                        self.add_edge(ein, copied_iteration_entry)
                        for succ in ein_successors:
                            self.add_edge(copied_iteration_exit, succ)
                        for copied_node in copied_nodes.values():
                            added_copies.add(copied_node)

                        for iteration_node in iteration_nodes:
                            already_considered.add(iteration_node)
                        modification_found = True

    def __assign_contexts(self) -> None:  # TODO: make the used graph parametric
        logger.info("Assigning contexts...")
        self.__assign_function_contexts()
        self.__assign_branching_contexts()
        #        self.__assign_parent_contexts_to_nodes()
        self.__assign_loop_contexts()
        self.__assign_parent_contexts_to_nodes()

    def __assign_function_contexts(self) -> None:
        logger.info("Assigning function contexts...")
        for function_node in tqdm(self.TGFunctionNode_pet_node_id_to_tg_node.values()):
            descendants = self.get_descendants(function_node)
            function_start_nodes = [n for n in descendants if isinstance(n, TGStartFunctionNode)]
            for fsn in function_start_nodes:
                function_context = FunctionContext(fsn.pet_node_id)
                function_context.add_node(fsn)
                fsn.register_created_context(function_context)
                #                for fsn_descendant in self.get_descendants(fsn):
                #                    function_context.add_node(fsn_descendant)
                self.contexts.append(function_context)

    def __assign_branching_contexts(self) -> None:
        logger.info("Assigning branching contexts...")
        # preparation
        logger.info("--> Selecting entry points...")
        start_branch_nodes: List[TGNode] = []
        start_branch_parent_nodes: List[TGNode] = []
        for node in tqdm(self.graph.nodes):
            if isinstance(node, TGStartBranchNode):
                start_branch_nodes.append(node)
            if isinstance(node, TGStartBranchParentNode):
                start_branch_parent_nodes.append(node)

        # create individual branch context
        logger.info("--> Create branch contexts")
        for sbn in tqdm(start_branch_nodes):
            # create Context
            branch_context = BranchContext()
            sbn.register_created_context(branch_context)
            self.contexts.append(branch_context)
            # DFS find nodes contained in the context
            queue: List[Tuple[TGNode, int]] = [(succ, 0) for succ in self.get_successors(sbn)]
            visited: Set[Tuple[TGNode, int]] = set()
            contained_nodes: Set[TGNode] = set()
            while len(queue) > 0:
                current_node, current_level = queue.pop()
                # stop search on this path, if a EndBranchNode is found and level is 0
                if isinstance(current_node, TGEndBranchNode):
                    if current_level == 0:
                        # stop search along this path
                        continue
                    else:
                        # decrease level
                        current_level -= 1
                # increase the level, if a StartBranchNode is encountered
                if isinstance(current_node, TGStartBranchNode):
                    current_level += 1
                # mark the node on the path as contained in the branch
                contained_nodes.add(current_node)
                # enqueue successors
                for succ in self.get_successors(current_node):
                    queue_element = (succ, current_level)
                    if queue_element not in visited:
                        queue.append(queue_element)
                        visited.add(queue_element)
            # register contained nodes in the context
        #            for contained_node in contained_nodes:
        #                branch_context.add_node(contained_node)

        # create branching parent contexts
        logger.info("--> Create branch parent contexts...")
        for sbpn in tqdm(start_branch_parent_nodes):
            branch_parent_context = BranchingParentContext()
            self.contexts.append(branch_parent_context)
            sbpn.created_context = branch_parent_context
            # get and register contained branch contexts
            for succ in self.get_successors(sbpn):
                # ensure correct structure
                if not isinstance(succ, TGStartBranchNode):
                    raise ValueError(
                        "InvalidGraphStructure: incorrect node type: "
                        + str(type(succ))
                        + " following a node of type "
                        + str(type(sbpn))
                        + " !"
                    )
                if succ.created_context is None:
                    raise ValueError(
                        "Field invalid: created_context of "
                        + str(type(succ))
                        + " node "
                        + succ.get_label()
                        + " is None!"
                    )
                succ.created_context.register_parent_context(branch_parent_context)
                branch_parent_context.add_contained_context(succ.created_context)

    def __assign_loop_contexts(self) -> None:
        logger.info("Assigning loop contexts...")

        for node in tqdm(self.graph.nodes):
            if not isinstance(node, TGStartLoopNode):
                continue

            # search corresponding loop end node
            loop_end_node: Optional[TGNode] = None
            queue: List[Tuple[TGNode, int]] = [(node, -1)]  # integer counts entered equivalent loops due to inlining
            visited: Set[TGNode] = {node}
            while len(queue) > 0:
                current, entered_equivalent_loops = queue.pop(0)
                if isinstance(current, TGEndLoopNode) and (node.pet_node_id == current.pet_node_id):
                    if entered_equivalent_loops == 0:
                        loop_end_node = current
                        break
                    else:
                        entered_equivalent_loops -= 1
                if isinstance(current, TGStartLoopNode) and (node.pet_node_id == current.pet_node_id):
                    entered_equivalent_loops += 1
                for succ in self.get_successors(current):
                    if succ not in visited:
                        queue.append((succ, entered_equivalent_loops))
                        visited.add(succ)

            if loop_end_node is None:
                logger.warning("Could not determine loop end node for loop: " + node.get_label())
                plt.ioff()
                self.plot(highlight_nodes=[node])
                plt.pause(1)
                raise ValueError("Could not determine loop end node for loop: " + node.get_label())

            # search general loop nodes
            general_loop_nodes: set[TGNode] = {node, loop_end_node}
            shortest_loop_path = nx.shortest_path(self.graph, source=node, target=loop_end_node)
            for path_node in shortest_loop_path:
                general_loop_nodes.add(path_node)
                # add nodes from parent contexts to find nodes in branches within the loop body as well
                if len(path_node.parent_context) > 0:
                    for parent_ctx in path_node.parent_context:
                        if isinstance(parent_ctx, BranchingParentContext):
                            for n in parent_ctx.get_contained_nodes(inclusive=True):
                                general_loop_nodes.add(n)

            # search loop iteration starts
            iteration_starts: List[TGNode] = []
            for n in general_loop_nodes:
                if isinstance(n, TGStartIterationNode) and (n.parent_loop_pet_node_id == node.pet_node_id):
                    iteration_starts.append(n)

            # establish pairs between iteration start and end points
            valid_pairs: List[Tuple[TGStartIterationNode, TGEndIterationNode]] = []
            for it_start in iteration_starts:
                it_end: Optional[TGNode] = None
                it_queue: List[Tuple[TGNode, int]] = [
                    (it_start, -1)
                ]  # integer counts entered equivalent loops due to inlining
                it_visited: Set[TGNode] = {it_start}
                while len(it_queue) > 0:
                    current, entered_equivalent_iterations = it_queue.pop(0)
                    if isinstance(current, TGEndIterationNode) and (
                        cast(TGStartIterationNode, it_start).parent_loop_pet_node_id == current.parent_loop_pet_node_id
                    ):
                        if entered_equivalent_iterations == 0:
                            it_end = current
                            break
                        else:
                            entered_equivalent_iterations -= 1
                    if isinstance(current, TGStartIterationNode) and (
                        cast(TGStartIterationNode, it_start).parent_loop_pet_node_id == current.parent_loop_pet_node_id
                    ):
                        if entered_equivalent_iterations == -1:
                            entered_equivalent_iterations += 1
                        else:
                            raise ValueError("Invalid iteration structure found at node: " + current.get_label())
                    for succ in self.get_successors(current):
                        if succ not in it_visited:
                            it_queue.append((succ, entered_equivalent_iterations))
                            it_visited.add(succ)
                if it_end is not None:
                    valid_pairs.append((cast(TGStartIterationNode, it_start), cast(TGEndIterationNode, it_end)))

            # get iteration nodes for each pair
            pair_iteration_nodes: Dict[Tuple[TGStartIterationNode, TGEndIterationNode], List[TGNode]] = dict()
            for it_start, it_end in valid_pairs:
                tmp_iteration_nodes: set[TGNode] = {it_start, it_end}
                try:
                    shortest_iteration_path = nx.shortest_path(self.graph, source=it_start, target=it_end)
                except nx.NetworkXNoPath:
                    plt.ioff()
                    self.plot(highlight_nodes=[it_start, it_end])
                    plt.pause(1)

                for path_node in shortest_iteration_path:
                    tmp_iteration_nodes.add(path_node)
                    # add nodes from parent contexts to find nodes in branches within the loop iteration as well
                    if len(path_node.parent_context) > 0:  # ignore cases where only the function-context is set
                        for parent_ctx in path_node.parent_context:
                            if isinstance(parent_ctx, BranchingParentContext):
                                for n in parent_ctx.get_contained_nodes(inclusive=True):
                                    tmp_iteration_nodes.add(n)
                    # add it_end to tmp_iteration_nodes
                    tmp_iteration_nodes.add(it_end)
                pair_iteration_nodes[(it_start, it_end)] = list(tmp_iteration_nodes)

            # create loop context
            loop_context = LoopParentContext(node.pet_node_id)
            node.register_created_context(loop_context)
            #            for loop_node in general_loop_nodes:
            #                is_regular_loop_node = True
            #                for iteration_nodes in pair_iteration_nodes.values():
            #                    if loop_node in iteration_nodes:
            #                        is_regular_loop_node = False
            #                        break
            #                if is_regular_loop_node:
            #                    loop_context.add_node(loop_node)
            self.contexts.append(loop_context)

            # create iteration contexts
            for pair in pair_iteration_nodes:
                iteration_context = IterationContext(loop_context)
                pair[0].register_created_context(iteration_context)
                #                for iteration_node in pair_iteration_nodes[pair]:
                #                    iteration_context.add_node(iteration_node)
                loop_context.add_contained_context(iteration_context)
                self.contexts.append(iteration_context)

    def __assign_parent_contexts_to_nodes(self) -> None:
        # assigns each node the innermost context containing the node
        logger.info("Assigning parent contexts to nodes...")
        #        for ctx in tqdm(self.contexts):
        #            for node in ctx.get_contained_nodes(inclusive=False):
        #                node.add_parent_context(ctx)
        logger.info("--> classify entry points...")
        entry_points: List[TGNode] = []
        for node in tqdm(self.graph.nodes):
            if len(self.get_predecessors(node)) == 0:
                entry_points.append(node)
        logger.info("DFS parsing entry points...")
        for entry_point in tqdm(entry_points):
            queue: List[Tuple[TGNode, Optional[Context]]] = []
            root_context = Context()
            # skip root node when initializing the queue
            if isinstance(entry_point, RootNode):
                for succ in self.get_successors(entry_point):
                    queue.append((succ, root_context))
            else:
                queue = [(entry_point, root_context)]
            already_enqueued: Set[Tuple[TGNode, Optional[Context]]] = set()
            while len(queue) > 0:
                current_node, current_parent_context = queue.pop(0)
                # check if a new context is entered
                entered_context: Optional[Context] = None
                if (
                    isinstance(current_node, TGStartFunctionNode)
                    or isinstance(current_node, TGStartLoopNode)
                    or isinstance(current_node, TGStartIterationNode)
                    or isinstance(current_node, TGStartBranchParentNode)
                    or isinstance(current_node, TGStartBranchNode)
                ):
                    entered_context = current_node.created_context

                # check if a context is exited
                exited_context: bool = False
                if (
                    isinstance(current_node, TGEndFunctionNode)
                    or isinstance(current_node, TGEndLoopNode)
                    or isinstance(current_node, TGEndIterationNode)
                    or isinstance(current_node, TGEndBranchParentNode)
                    or isinstance(current_node, TGEndBranchNode)
                ):
                    exited_context = True

                if entered_context is not None:
                    if current_parent_context is not None:
                        entered_context.register_parent_context(current_parent_context)
                    current_parent_context = entered_context
                    current_parent_context.add_node(current_node)
                    current_node.add_parent_context(current_parent_context)
                elif exited_context:
                    if current_parent_context is not None:
                        current_parent_context.add_node(current_node)
                        current_node.add_parent_context(current_parent_context)
                        current_parent_context = current_parent_context.parent_context
                    else:
                        pass
                else:
                    # regular node found
                    if current_parent_context is not None:
                        current_parent_context.add_node(current_node)
                        current_node.add_parent_context(current_parent_context)
                    else:
                        pass
                # add successors to the queue
                for succ in self.get_successors(current_node):
                    queue_element = (succ, current_parent_context)
                    if queue_element not in already_enqueued:
                        queue.append(queue_element)
                        already_enqueued.add(queue_element)

    def __assign_node_levels(self) -> None:
        # assings levels to each node starting from the outer most context
        # this should allow a cheap check for "incoming" and "outgoing" dependencies
        warnings.warn("Not yet implemented!")

    def __calculate_context_successions(self) -> None:
        logger.info("Assigning context successions...")
        logger.info("--> classify entry points...")
        entry_points: List[TGNode] = []
        for node in tqdm(self.graph.nodes):
            if len(self.get_predecessors(node)) == 0:
                entry_points.append(node)

        logger.info("--> DFS parsing entry points...")
        for entry_point in tqdm(entry_points):
            # initialize succession calculation
            queue: List[Tuple[TGNode, int, Tuple[Optional[Context], ...]]] = [
                (entry_point, 0, (None,))
            ]  # each position in the list corresponds to one level. Last position is always the last level
            already_enqueued: Set[Tuple[TGNode, int]] = set()
            while len(queue) > 0:
                current_node, current_level, current_predecessor_contexts_tuple = queue.pop(0)
                current_predecessor_contexts = list(current_predecessor_contexts_tuple)
                # check for entering new context level
                entered_context: Optional[Context] = None
                if (
                    isinstance(current_node, TGStartFunctionNode)
                    or isinstance(current_node, TGStartLoopNode)
                    or isinstance(current_node, TGStartIterationNode)
                    or isinstance(current_node, TGStartBranchParentNode)
                    or isinstance(current_node, TGStartBranchNode)
                ):
                    entered_context = current_node.created_context
                if entered_context is not None:
                    # connect previous context to entered context as successor
                    if current_predecessor_contexts[-1] is not None:
                        current_predecessor_contexts[-1].register_successor_context(entered_context)
                    # update the dictionary of contexts
                    current_predecessor_contexts[-1] = entered_context
                    # update current context level
                    current_level += 1
                    current_predecessor_contexts.append(None)

                # check for exiting context level
                exited_context: bool = False
                if (
                    isinstance(current_node, TGEndFunctionNode)
                    or isinstance(current_node, TGEndLoopNode)
                    or isinstance(current_node, TGEndIterationNode)
                    or isinstance(current_node, TGEndBranchParentNode)
                    or isinstance(current_node, TGEndBranchNode)
                ):
                    exited_context = True
                if exited_context:
                    # update current context level
                    current_level -= 1
                    current_predecessor_contexts = current_predecessor_contexts[:-1]

                # add successors to the queue
                for succ in self.get_successors(current_node):
                    queue_element = (succ, current_level, tuple(current_predecessor_contexts))
                    if (queue_element[0], queue_element[1]) not in already_enqueued:
                        queue.append(queue_element)
                        already_enqueued.add((queue_element[0], queue_element[1]))

    ## DEBUG
    #       plt.ioff()
    #       self.plot_context_graph()
    #       plt.pause(1)
    ## !DEBUG

    def __calculate_context_nesting(self) -> None:
        logger.info("Assigning context nestings...")
        logger.info("--> classify entry points...")

        entry_points: List[TGNode] = []
        for node in tqdm(self.graph.nodes):
            if len(self.get_predecessors(node)) == 0:
                entry_points.append(node)

        logger.info("--> DFS parsing entry points...")
        for entry_point in tqdm(entry_points):

            # initialize the nesting calculation
            queue: List[Tuple[TGNode, Optional[Context]]] = [(entry_point, None)]
            already_enqueued: Set[Tuple[TGNode, Optional[Context]]] = {(entry_point, None)}
            while len(queue) > 0:
                current_node, current_context = queue.pop(0)

                # check for entering a new contexts
                entered_context: Optional[Context] = None
                if (
                    isinstance(current_node, TGStartFunctionNode)
                    or isinstance(current_node, TGStartLoopNode)
                    or isinstance(current_node, TGStartIterationNode)
                    or isinstance(current_node, TGStartBranchParentNode)
                    or isinstance(current_node, TGStartBranchNode)
                ):
                    entered_context = current_node.created_context

                # check for exiting a context
                exited_context: bool = False
                if (
                    isinstance(current_node, TGEndFunctionNode)
                    or isinstance(current_node, TGEndLoopNode)
                    or isinstance(current_node, TGEndIterationNode)
                    or isinstance(current_node, TGEndBranchParentNode)
                    or isinstance(current_node, TGEndBranchNode)
                ):
                    exited_context = True

                # assert validity of the results
                if entered_context is not None and exited_context:
                    raise ValueError("Impossible result")

                # handle entering a context
                if entered_context is not None:
                    # register current_context as a parent of the entered context
                    if current_context is not None:
                        current_context.add_contained_context(entered_context)
                        entered_context.register_parent_context(current_context)
                    # update the current context
                    current_context = entered_context
                elif exited_context:
                    # update the current context
                    if current_context is None:
                        logger.error("Current context must not be None during processing!")
                        plt.ioff()
                        self.plot(highlight_nodes=[current_node])
                        plt.pause(10)
                        raise ValueError("Current context must not be None during processing!")
                    # if current_context.parent_context is None:
                    #    raise ValueError("Parent context is unspecified. Exiting a context thus not possible!")
                    else:
                        current_context = current_context.parent_context

                # add successors to the queue
                for succ in self.get_successors(current_node):
                    queue_element = (succ, current_context)
                    if queue_element not in already_enqueued:
                        queue.append(queue_element)
                        already_enqueued.add(queue_element)

    ### DEBGU
    #        plt.ioff()
    #        self.plot_context_graph()
    #        plt.pause(1)
    #        for ctx in self.contexts:
    #            print("parents: ", str([c.get_label() for c in ctx.parent_context]))
    #        import sys
    #        sys.exit(0)
    ### !DEBUG

    def __inline_function_calls(self) -> None:
        warnings.warn("Not yet implemented!")
        logger.info("Inlining function calls...")
        self.print_graph_statistics(self.graph, "pre inlining")
        # determine calling nodes
        calling_pet_nodes = [n.id for n in all_nodes(self.pet) if len(get_called_nodes(self.pet, n)) > 0]

        # inline functions calls starting from the root node
        # repeat the process until no modification is found anymore, i.e. no further functions calls need to be inlined
        # Tracking of the call path depth for "early termination", i.e. supporting recursion and cyclic calls
        call_path_limit = 100
        call_path_depth = 0
        modification_found = True
        with tqdm(total=call_path_limit, desc="Callpath depth") as progress_bar:
            while modification_found:
                call_path_depth += 1
                if call_path_depth >= call_path_limit:
                    logger.info("Maximum call path depth of " + str(call_path_limit) + " reached.")
                    break
                modification_found = False
                descendants = self.get_descendants(self.root)
                calling_nodes: List[TGNode] = []
                for node in descendants:
                    if (
                        node.pet_node_id in calling_pet_nodes and type(node) == TGNode
                    ):  # check for type TGNode to exclude function calls etc.
                        calling_nodes.append(node)
                # filter calling nodes to such, which have not been inlined already
                filtered_calling_nodes: List[TGNode] = []
                for cn in calling_nodes:
                    already_inlined = False
                    for succ in self.get_successors(cn):
                        if isinstance(succ, TGStartInlinedFunctionNode):
                            # call already inlined
                            already_inlined = True
                            break
                    if not already_inlined:
                        filtered_calling_nodes.append(cn)

                for fcn in tqdm(filtered_calling_nodes, desc="Open calls"):
                    if fcn.pet_node_id is None:
                        continue
                    # duplicate inlined function body and insert it after the caller
                    called_functions_pet_nodes = get_called_nodes(self.pet, self.pet.node_at(fcn.pet_node_id))
                    for cf_pet_node in called_functions_pet_nodes:
                        function_entry = self.TGFunctionNode_pet_node_id_to_tg_node[cf_pet_node.id]
                        #                        logger.info("--> function entry: " + function_entry.get_label())
                        inlined_entry, inlined_exit = self.__duplicate_inlined_function(function_entry, fcn.pet_node_id)
                        # connect edges
                        for succ in self.get_successors(fcn):
                            self.graph.remove_edge(fcn, succ)
                            self.add_edge(fcn, inlined_entry)
                            self.add_edge(inlined_exit, succ)
                        modification_found = True

                progress_bar.update()

                self.print_graph_statistics(self.graph, "post inlining")

    def __add_branching_nodes(self) -> None:
        logger.info("Adding branching nodes...")
        # select branch parent nodes
        branch_parent_nodes = [n for n in self.graph.nodes if len(self.get_successors(n)) > 1]
        # select merge nodes
        merge_nodes = [n for n in self.graph.nodes if len(self.get_predecessors(n)) > 1]
        # add StartBranchParent nodes
        start_branch_parent_nodes: List[TGNode] = []
        for bpn in branch_parent_nodes:
            start_branch_parent_node = TGStartBranchParentNode(bpn.pet_node_id, level=bpn.level, position=bpn.position)
            start_branch_parent_nodes.append(start_branch_parent_node)
            self.add_node(start_branch_parent_node)
            for succ in self.get_successors(bpn):
                self.graph.remove_edge(bpn, succ)
                self.add_edge(start_branch_parent_node, succ)
            self.add_edge(bpn, start_branch_parent_node)

        # add EndBranchParent nodes
        end_branch_parent_nodes: List[TGNode] = []
        for mn in merge_nodes:
            end_branch_parent_node = TGEndBranchParentNode(mn.pet_node_id, level=mn.level, position=mn.position)
            end_branch_parent_nodes.append(end_branch_parent_node)
            self.add_node(end_branch_parent_node)
            for pred in self.get_predecessors(mn):
                self.graph.remove_edge(pred, mn)
                self.add_edge(pred, end_branch_parent_node)
            self.add_edge(end_branch_parent_node, mn)

        # add StartBranch nodes
        for sbpn in start_branch_parent_nodes:
            for succ in self.get_successors(sbpn):
                start_branch_node = TGStartBranchNode(sbpn.pet_node_id, level=sbpn.level, position=sbpn.position)
                self.add_node(start_branch_node)
                self.graph.remove_edge(sbpn, succ)
                self.add_edge(sbpn, start_branch_node)
                self.add_edge(start_branch_node, succ)

        # add EndBranch nodes
        for ebpn in end_branch_parent_nodes:
            for pred in self.get_predecessors(ebpn):
                end_branch_node = TGEndBranchNode(ebpn.pet_node_id, level=ebpn.level, position=ebpn.position)
                self.add_node(end_branch_node)
                self.graph.remove_edge(pred, ebpn)
                self.add_edge(pred, end_branch_node)
                self.add_edge(end_branch_node, ebpn)

        logger.info("--> validating amounts of node successors and predecessors...")
        for node in tqdm(self.graph.nodes):
            succ_count = len(self.get_successors(node))
            pred_count = len(self.get_predecessors(node))
            if succ_count < 2 and pred_count < 2:
                continue
            if (succ_count >= 2) and (not isinstance(node, TGStartBranchParentNode)):
                logger.error("Invalid node type: " + str(type(node)) + " with " + str(succ_count) + " successors!")
                plt.ioff()
                self.plot(highlight_nodes=[node])
                plt.pause(1)
                raise ValueError("Invalid graph structure!")
            if (pred_count >= 2) and (not isinstance(node, TGEndBranchParentNode)):
                logger.error("Invalid node type: " + str(type(node)) + " with " + str(pred_count) + " predecessors!")
                plt.ioff()
                self.plot(highlight_nodes=[node])
                plt.pause(1)
                raise ValueError("Invalid graph structure!")

    def __duplicate_inlined_function(
        self, inlined_function: TGFunctionNode, inlining_pet_node_id: PETNodeID
    ) -> Tuple[TGStartInlinedFunctionNode, TGEndInlinedFunctionNode]:

        # initialize entry and exit nodes
        entry = TGStartInlinedFunctionNode(inlining_pet_node_id, 0, 0)
        exit = TGEndInlinedFunctionNode(inlining_pet_node_id, 0, 0)
        self.add_node(entry)
        self.add_node(exit)

        copied_nodes: Dict[TGNode, TGNode] = dict()
        function_body_nodes = self.get_descendants(inlined_function) + [inlined_function]
        # copy function body nodes
        for fbn in function_body_nodes:
            fbn_copy = copy.deepcopy(fbn)
            copied_nodes[fbn] = fbn_copy
            self.graph.add_node(fbn_copy)
        # copy function body edges
        for fbn in function_body_nodes:
            for succ in self.get_successors(fbn):
                self.graph.add_edge(copied_nodes[fbn], copied_nodes[succ])

        # connect function body to entry and exit nodes
        self.add_edge(entry, copied_nodes[inlined_function])
        for fbn in function_body_nodes:
            if isinstance(fbn, TGEndFunctionNode) and fbn.pet_node_id == inlined_function.pet_node_id:
                self.add_edge(copied_nodes[fbn], exit)

        return entry, exit

    def __insert_data_dependencies(self) -> None:
        logger.info("Inserting data dependencies...")

        # iterate over all edges in PET Graph
        for source, target, dependency_dict in tqdm(self.pet.g.edges(data=True)):
            dependency = cast(Dependency, dependency_dict["data"])
            # only consider DATA edges
            if dependency.etype != EdgeType.DATA:
                continue
            # ignore INIT edges
            if dependency.dtype == DepType.INIT:
                continue

            # find all pairs of TGNodes which qualify as source and / or targets of the dependency (Note: due to the duplication of iterations and function inlining, multiple occurrences are possible!)
            source_tg_nodes: List[TGNode] = []
            for node in self.graph.nodes:
                # search for regular nodes (i.e. CU nodes) with the given PET node id
                if type(node) == TGNode and node.pet_node_id is not None:
                    if node.pet_node_id == source:
                        source_tg_nodes.append(node)

            for source_tg in source_tg_nodes:
                # find target nodes for the dependency
                target_tg_nodes: Set[TGNode] = self.get_closest_predecessors_with_matching_pet_node_id(
                    source_tg,
                    target,
                    disallow_target_contexts=set(),
                    # disallow_target_contexts=source_tg.parent_context
                )

                # register dependency between each pair of source and target nodes
                for target_tg in list(target_tg_nodes):
                    # ignore dependencies within a single context
                    if source_tg.parent_context == target_tg.parent_context:
                        continue
                    for source_parent_ctx in source_tg.parent_context:
                        for target_parent_ctx in target_tg.parent_context:
                            source_parent_ctx.register_outgoing_dependency(target_parent_ctx, dependency)

    def __validate_data_dependencies(self) -> None:
        logger.info("Validating data dependencies using existing metadata...")
        invalid_deps: List[Tuple[Context, Context, Dependency]] = []
        valid_deps: Set[Tuple[Context, Context, Dependency]] = set()
        for source_ctx in tqdm(self.contexts):
            source_call_stack: Optional[List[Context]] = None  # only calculate, if it is required
            for target_ctx, dep in source_ctx.outgoing_dependencies:
                print()
                print(
                    "PARSING: "
                    + str(dep.source_line)
                    + " "
                    + str(dep.sink_line)
                    + " "
                    + str(dep.dtype)
                    + " "
                    + str(dep.var_name)
                )
                # check if metadata exists
                if (
                    dep.metadata_inter_call_dep is None
                    or dep.metadata_intra_call_dep is None
                    or dep.metadata_inter_iteration_dep is None
                    or dep.metadata_intra_iteration_dep is None
                ):
                    # no metadata exists
                    continue
                # check if any list is non-empty, i.e., if a check is actually required
                if (
                    len(dep.metadata_source_ancestors) == 0
                    and len(dep.metadata_sink_ancestors) == 0
                    and len(dep.metadata_inter_call_dep) == 0
                    and len(dep.metadata_intra_call_dep) == 0
                    and len(dep.metadata_inter_iteration_dep) == 0
                    and len(dep.metadata_intra_iteration_dep) == 0
                ):
                    # all lists are empty. no check required.
                    continue
                # calculate callstacks for validation
                if source_call_stack is None:
                    source_call_stack = get_context_call_stack(source_ctx)
                target_call_stack = get_context_call_stack(target_ctx)
                print("Source CS: " + str(source_call_stack))
                print("Target CTX: " + target_ctx.get_label())
                print("Target CS: " + str(target_call_stack))
                # get LineIDs from callstacks
                converted_source_call_stack = convert_callstacks_to_lineIDs(self.pet, source_call_stack)
                converted_target_call_stack = convert_callstacks_to_lineIDs(self.pet, target_call_stack)

                print("Conv. Source.CS: " + str(converted_source_call_stack))
                print("Conv. Target.CS: " + str(converted_target_call_stack))

                skip_further_checks = False

                # validate source ancestors
                if (not skip_further_checks) and len(dep.metadata_sink_ancestors) > 0:
                    filtered_source_call_stack = [
                        elem[1] for elem in converted_source_call_stack if elem[0] != CallStackElementType.ITERATION
                    ]
                    print("FSCS: " + str(filtered_source_call_stack))
                    print("SANC: " + str(dep.metadata_sink_ancestors))

                    for entry in dep.metadata_sink_ancestors:
                        if entry not in filtered_source_call_stack:
                            logger.warning(
                                "found source-ancestor mismatch: "
                                + entry
                                + ". Keep dependency to err on the safe side."
                            )
                            # following checks would not target the current dependency. Keep the dependency to err on the safe side.
                            skip_further_checks = True
                            break

                # validate sink ancestors
                if (not skip_further_checks) and len(dep.metadata_source_ancestors) > 0:
                    filtered_target_call_stack = [
                        elem[1] for elem in converted_target_call_stack if elem[0] != CallStackElementType.ITERATION
                    ]
                    print("FTCS: " + str(filtered_target_call_stack))
                    print("TANC: " + str(dep.metadata_source_ancestors))
                    for entry in dep.metadata_source_ancestors:
                        if entry not in filtered_target_call_stack:
                            logger.warning(
                                "found sink-ancestor mismatch: " + entry + ". Keep dependency to err on the safe side."
                            )
                            # following checks would not target the current dependency. Keep the dependency to err on the safe side.
                            skip_further_checks = True
                            break

                if skip_further_checks:
                    continue

                dependency_valid = True

                # validate intra-call relation
                if dependency_valid and len(dep.metadata_intra_call_dep) > 0:
                    # check for exact same parent function
                    overlapping_stack_elements = [elem for elem in source_call_stack if elem in target_call_stack]
                    converted_overlapping_stack_elements = convert_callstacks_to_lineIDs(
                        self.pet, overlapping_stack_elements
                    )
                    filtered_conv_ov_stack_elements = [
                        elem[1]
                        for elem in converted_overlapping_stack_elements
                        if elem[0] == CallStackElementType.FUNCTION
                    ]
                    print("IAC-FCOSE: " + str(filtered_conv_ov_stack_elements))
                    print("IAC-MICD: " + str(dep.metadata_intra_call_dep))
                    for entry in dep.metadata_intra_call_dep:
                        if entry not in filtered_conv_ov_stack_elements:
                            logger.warning("found intra-call mismatch: " + entry)
                            dependency_valid = False
                            break

                # validate inter-call relation
                if dependency_valid and len(dep.metadata_inter_call_dep) > 0:
                    # check for differenct parent nodes of the same function
                    source_call_stack_function_filtered = [
                        elem for elem in source_call_stack if isinstance(elem, FunctionContext)
                    ]
                    target_call_stack_function_filtered = [
                        elem for elem in target_call_stack if isinstance(elem, FunctionContext)
                    ]
                    disjoint_function_nodes = [
                        elem
                        for elem in source_call_stack_function_filtered
                        if elem not in target_call_stack_function_filtered
                    ]
                    converted_disjoint_function_nodes = convert_callstacks_to_lineIDs(
                        self.pet, cast(List[Context], disjoint_function_nodes)
                    )
                    unpacked_converted_disjoint_function_nodes = [elem[1] for elem in converted_disjoint_function_nodes]
                    print("CDFN: ", str(converted_disjoint_function_nodes))
                    for entry in dep.metadata_inter_call_dep:
                        if entry not in unpacked_converted_disjoint_function_nodes:
                            logger.warning("found inter-call mismatch: " + entry)
                            dependency_valid = False
                            break

                # validate intra-iteration relation
                if dependency_valid and len(dep.metadata_intra_iteration_dep) > 0:
                    # check for equal iteration node
                    overlapping_stack_elements = [elem for elem in source_call_stack if elem in target_call_stack]
                    converted_overlapping_stack_elements = convert_callstacks_to_lineIDs(
                        self.pet, overlapping_stack_elements
                    )
                    iteration_filtered_conv_ov_stack_elements = [
                        elem[1]
                        for elem in converted_overlapping_stack_elements
                        if elem[0] == CallStackElementType.ITERATION
                    ]
                    loop_filtered_conv_ov_stack_elements = [
                        elem[1] for elem in converted_overlapping_stack_elements if elem[0] == CallStackElementType.LOOP
                    ]
                    print("IAI-IFCOSE: " + str(iteration_filtered_conv_ov_stack_elements))
                    print("IAI-MIID: " + str(dep.metadata_intra_iteration_dep))
                    for entry in dep.metadata_intra_iteration_dep:
                        if entry not in loop_filtered_conv_ov_stack_elements:
                            # source and target not in the same loop.
                            continue
                        if entry not in iteration_filtered_conv_ov_stack_elements:
                            logger.warning("found intra-iteration mismatch: " + entry)
                            dependency_valid = False
                            break

                # validate inter-iteration relation
                if dependency_valid and len(dep.metadata_inter_iteration_dep) > 0:
                    # check for differing iteration node
                    source_call_stack_iteration_filtered = [
                        elem for elem in source_call_stack if isinstance(elem, IterationContext)
                    ]
                    target_call_stack_iteration_filtered = [
                        elem for elem in target_call_stack if isinstance(elem, IterationContext)
                    ]
                    source_disjoint_iteration_nodes = [
                        elem
                        for elem in source_call_stack_iteration_filtered
                        if elem not in target_call_stack_iteration_filtered
                    ]
                    target_disjoint_iteration_nodes = [
                        elem
                        for elem in target_call_stack_iteration_filtered
                        if elem not in source_call_stack_iteration_filtered
                    ]

                    source_disjoint_iteration_parent_loops = [
                        elem.belongs_to_context for elem in source_disjoint_iteration_nodes
                    ]
                    target_disjoint_iteration_parent_loops = [
                        elem.belongs_to_context for elem in target_disjoint_iteration_nodes
                    ]
                    overlapping_parent_loops = [
                        elem
                        for elem in source_disjoint_iteration_parent_loops
                        if elem in target_disjoint_iteration_parent_loops
                    ]
                    converted_overlapping_loop_nodes = convert_callstacks_to_lineIDs(self.pet, overlapping_parent_loops)
                    filtered_conv_ov_loop_nodes = [elem[1] for elem in converted_overlapping_loop_nodes]
                    print("FCOLN: " + str(filtered_conv_ov_loop_nodes))
                    print("MIEID: " + str(dep.metadata_inter_iteration_dep))
                    for entry in dep.metadata_inter_iteration_dep:
                        if entry not in filtered_conv_ov_loop_nodes:
                            logger.warning("found inter-iteration mismatch: " + entry)
                            dependency_valid = False
                            break

                # mark dependency invalid, if required
                if not dependency_valid:
                    invalid_deps.append((source_ctx, target_ctx, dep))
                else:
                    valid_deps.add((source_ctx, target_ctx, dep))

        self.__print_context_statistics("Pre validation")

        # remove invalid dependencies
        print("LEN INVALID PRE: ", len(invalid_deps))
        invalid_deps = [entry for entry in invalid_deps if entry not in valid_deps]
        print("LEN INVALID PRE: ", len(invalid_deps))
        for source_ctx, target_ctx, dep in invalid_deps:
            tpl = (target_ctx, dep)
            if tpl in source_ctx.outgoing_dependencies:
                source_ctx.outgoing_dependencies.remove(tpl)

        self.__print_context_statistics("Post validation")

    #        ## DEBUG
    #        # print remaining dependencies
    #        print("REMAINING DEPS: ")
    #        for ctx in self.contexts:
    #            print("CTX: " + ctx.get_label())
    #            for target_ctx, dep in ctx.outgoing_dependencies:
    #                print("--> " + str(dep.source_line) + " " + str(dep.sink_line) + " " + str(dep.dtype) + " " + str(dep.var_name))
    #       ## !DEBUG

    def __print_context_statistics(self, label: str = "") -> None:
        # prepare context dependency count
        ctx_dep_count = 0
        for ctx in self.contexts:
            ctx_dep_count += len(ctx.outgoing_dependencies)
        # print to console
        logger.info("####################")
        logger.info("# Context statistics: " + label)
        logger.info("# Context count: " + str(len(self.contexts)))
        logger.info("# Context deps:  " + str(ctx_dep_count))
        logger.info("####################")

    def __get_iteration_nodes(
        self, iteration_entry: TGStartIterationNode, iteration_exit: TGEndIterationNode
    ) -> Set[TGNode]:
        queue: List[TGNode] = [iteration_entry]
        visited: Set[TGNode] = set()
        iteration_nodes: Set[TGNode] = set()
        while len(queue) > 0:
            current_source = queue.pop(0)
            visited.add(current_source)
            if nx.has_path(self.graph, current_source, iteration_exit):
                iteration_nodes.add(current_source)

            # do not consider successors of iteration end node
            if current_source == iteration_exit:
                continue
            # add successors of regular iteration nodes to the queue
            for succ in self.get_successors(current_source):
                if succ in queue or succ in visited:
                    continue
                queue.append(succ)
        return iteration_nodes

    def __validate_graph_structure(self) -> None:
        warnings.warn("Not yet implemented!")

    def get_successors(self, node: Optional[TGNode]) -> List[TGNode]:
        if node is None:
            return []
        successors = list(set([t for s, t in self.graph.out_edges(node)]))
        ## DEBUG
        #        if node.get_label() == "3:34" and len(successors) > 1:
        #            print("SUCCESSORS: ", str([c.get_label() for c in successors]))
        #            plt.ioff()
        #            self.plot(highlight_nodes=[node] + successors)
        #            plt.pause(1)
        ## !DEBUG
        return successors

    def get_predecessors(self, node: Optional[TGNode]) -> List[TGNode]:
        if node is None:
            return []
        predecessors = list(set([s for s, t in self.graph.in_edges(node)]))
        return predecessors

    def get_closest_predecessors_with_matching_pet_node_id(
        self, node: Optional[TGNode], pet_node_id: PETNodeID, disallow_target_contexts: Set[Context]
    ) -> Set[TGNode]:
        """Returns the predecessors with pet_node_id for each path starting from node in a set."""
        if node is None:
            return set()
        queue: List[TGNode] = self.get_predecessors(node)
        visited: Set[TGNode] = set(queue)
        result: Set[TGNode] = set()
        while len(queue) > 0:
            current_node = queue.pop()
            if current_node.pet_node_id == pet_node_id and type(current_node) == TGNode:
                if len(current_node.parent_context.intersection(disallow_target_contexts)) == 0:
                    # no overlap with disallowed contexts
                    result.add(current_node)
                    continue
            for pred in self.get_predecessors(current_node):
                if pred not in visited:
                    visited.add(pred)
                    queue.append(pred)
        return result

    def get_descendants(self, node: TGNode) -> List[TGNode]:
        return list(nx.descendants(self.graph, node))

    def print_graph_statistics(self, graph: Graph, label: str = "") -> None:
        cleaned_label = "" if len(label) == 0 else "(" + label + ")"
        logger.info("### Graph Statisticts " + cleaned_label + " ###")
        logger.info("--> Nodes: " + str(len(graph.nodes)))
        logger.info("--> Edges: " + str(len(graph.edges)))
        # logger.info("--> longest path length: " + str(nx.dag_longest_path_length(graph)))
        logger.info("#########################")

    def __copy_iteration_subgraph(
        self,
        copied_nodes: Dict[TGNode, TGNode],
        iteration_nodes: Set[TGNode],
        iteration_entry: TGNode,
        iteration_exit: TGNode,
    ) -> Tuple[Dict[TGNode, TGNode], List[TGNode], TGNode, TGNode]:
        if len(iteration_nodes) == 0:
            raise ValueError("Empty set of iteration nodes not supported as an argument!")
        copied_iteration_nodes: List[TGNode] = []
        # copy nodes
        for node in iteration_nodes:
            if node not in copied_nodes:
                node_copy = copy.deepcopy(node)
                self.add_node(node_copy)
                copied_nodes[node] = node_copy
            copied_iteration_nodes.append(copied_nodes[node])
        # copy edges
        try:
            for source in [
                n for n in iteration_nodes if n != iteration_exit
            ]:  # do not copy outgoing edges of the path exit
                for succ in self.get_successors(source):
                    self.add_edge(copied_nodes[source], copied_nodes[succ])
        except KeyError:
            print("ERROR AT: source: ", source.get_label(), "  succ: ", succ.get_label())
            plt.ioff()
            self.plot()

        return copied_nodes, copied_iteration_nodes, copied_nodes[iteration_entry], copied_nodes[iteration_exit]
