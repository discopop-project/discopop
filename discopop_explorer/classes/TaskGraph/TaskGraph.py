# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import signal
import logging
from typing import Dict, List, Optional, Set, Tuple, Union
import warnings
import networkx as nx  # type: ignore
import matplotlib

from discopop_explorer.classes.TaskGraph.Contexts.BranchContext import BranchContext
from discopop_explorer.classes.TaskGraph.Contexts.BranchingParentContext import BranchingParentContext
from discopop_explorer.classes.TaskGraph.Contexts.Context import Context
from discopop_explorer.classes.TaskGraph.Contexts.FunctionContext import FunctionContext
from discopop_explorer.classes.TaskGraph.Functions.TGEndFunctionNode import TGEndFunctionNode
from discopop_explorer.classes.TaskGraph.Functions.TGStartFunctionNode import TGStartFunctionNode
from discopop_explorer.classes.TaskGraph.RootNode import RootNode
from discopop_explorer.classes.TaskGraph.TGFunctionNode import TGFunctionNode
from discopop_explorer.classes.TaskGraph.VisitorMarker import EndFunctionMarker, VisitorMarker
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
    context_stack: List[Context] = []
    visited_contexts: List[Context] = []
    current_level: LevelIndex = 0
    current_position: Dict[LevelIndex, PositionIndex] = {0: 0}

    def __init__(self, pet: PEGraphX) -> None:
        self.pet = pet
        self.graph = nx.MultiDiGraph()
        self.__assign_function_ids(pet)
        self.__construct_from_pet(pet)

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
        self.__assign_contexts()

    def add_node(self, node: TGNode) -> None:
        self.graph.add_node(node)

    #        for ctx in self.context_stack:
    #            ctx.add_node(node)

    def add_edge(self, source: Optional[TGNode], target: Optional[TGNode]) -> None:
        if source is None or target is None:
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

    def plot(self) -> None:
        signal.signal(signal.SIGINT, signal.SIG_DFL)
        logger.info("Nodes: \n" + str(self.graph.nodes()))
        f, ax = plt.subplots(1, 1, figsize=(8, 5))
        # get node positions
        #        positions: Dict[TGNode, Tuple[LevelIndex, PositionIndex]] = dict()
        #        for node in self.graph.nodes():
        #            positions[node] = (node.position, -node.level)  # (x, y),
        # top left is 0,0
        positions = nx.nx_pydot.graphviz_layout(self.graph, prog="dot")

        # draw context patches
        min_patch_width = 0.1
        min_patch_height = 0.2
        for ctx in self.visited_contexts:
            contained_nodes_count, level_min, level_max, position_min, position_max = ctx.get_plot_bounding_box()
            if contained_nodes_count <= 0:
                continue
            level_span = level_max - level_min
            position_span = max(0.1, position_max - position_min)
            ax.add_patch(
                Rectangle(
                    (position_min - (min_patch_width / 2), -level_min + (min_patch_height / 2)),
                    position_span + min_patch_width,
                    -(level_span - min_patch_height),
                    linewidth=1,
                    edgecolor=ctx.get_plot_border_color(),
                    facecolor=ctx.get_plot_face_color(),
                )
            )
        nx.draw(self.graph, positions, with_labels=False)
        # get node labels
        labels = {}
        for node in self.graph.nodes():
            labels[node] = node.get_label()
        nx.draw_networkx_labels(self.graph, positions, labels, font_size=7)
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

    def __assign_contexts(self) -> None:
        warnings.warn("Not yet implemented!")

    def __visit_pet(self, pet: PEGraphX) -> None:
        # construct Taskgraph by visiting the PET Graph
        general_context = Context()
        self.context_stack.append(general_context)
        self.visited_contexts.append(general_context)
        root = RootNode(None, self.__get_next_level(), self.__get_next_position(self.__get_current_level()))
        self.add_node(root)

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

        # TODO: replace PETnodes in BranchContext with TGNodes
        warnings.warn("Not implemented: replace PETnodes in BranchContext with TGNodes")

    def __visit_node(
        self, predecessor: Optional[TGNode], pet_node: PETNode, queue: List[TGConstructionQueueElement]
    ) -> List[TGConstructionQueueElement]:
        logger.info("visiting: " + str(pet_node) + " type: " + str(pet_node.type))
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
        logger.info("visiting marker: " + str(marker))
        if isinstance(marker, EndFunctionMarker):
            queue = self.__visit_EndFunctionMarker(predecessor, marker, queue)
        return queue

    def __visit_EndFunctionMarker(
        self, predecessor: Optional[TGNode], marker: EndFunctionMarker, queue: List[TGConstructionQueueElement]
    ) -> List[TGConstructionQueueElement]:
        logger.info("End Function marker: " + str(marker.function_node))
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
        warnings.warn("Not implemented!")
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
