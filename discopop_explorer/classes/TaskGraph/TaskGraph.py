# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import copy
import signal
import logging
from typing import Dict, List, Optional, Set, Tuple, Union, cast
import warnings
import networkx as nx  # type: ignore
import matplotlib

from discopop_explorer.classes.PEGraph.CUNode import CUNode
from discopop_explorer.classes.TaskGraph.Contexts.Context import Context
from discopop_explorer.classes.TaskGraph.Contexts.FunctionContext import FunctionContext
from discopop_explorer.classes.TaskGraph.Functions.TGEndFunctionNode import TGEndFunctionNode
from discopop_explorer.classes.TaskGraph.Functions.TGStartFunctionNode import TGStartFunctionNode
from discopop_explorer.classes.TaskGraph.Loops.TGEndLoopNode import TGEndLoopNode
from discopop_explorer.classes.TaskGraph.Loops.TGEndtIterationNode import TGEndIterationNode
from discopop_explorer.classes.TaskGraph.Loops.TGStartIterationNode import TGStartIterationNode
from discopop_explorer.classes.TaskGraph.Loops.TGStartLoopNode import TGStartLoopNode
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
        self.__break_cycles()
        self.__duplicate_loop_iterations()
        self.__validate_graph_structure()

    def add_node(self, node: TGNode) -> None:
        self.graph.add_node(node)

    #        for ctx in self.context_stack:
    #            ctx.add_node(node)

    def add_edge(self, source: Optional[TGNode], target: Optional[TGNode]) -> None:
        if source is None or target is None:
            return
        # disallow duplicate edges
        if self.graph.has_edge(source, target):
            warnings.warn(
                "Attempted creation of a duplicate edge. Prevented. Source: "
                + (source.get_label() if source is not None else "None")
                + " Target: "
                + (target.get_label() if target is not None else "None")
            )
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
        logger.info("Plotting...")
        signal.signal(signal.SIGINT, signal.SIG_DFL)
        f, ax = plt.subplots(1, 1, figsize=(8, 5))
        # get node positions
        #        positions: Dict[TGNode, Tuple[LevelIndex, PositionIndex]] = dict()
        #        for node in self.graph.nodes():
        #            positions[node] = (node.position, -node.level)  # (x, y),
        # top left is 0,0
        logger.info("---> generating layout...")
        positions = nx.nx_pydot.graphviz_layout(self.graph, prog="dot")
        logger.info("--->    Done.")

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
        logger.info("---> showing...")
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
                        ism = TGStartIterationNode(entry_node.pet_node_id, entry_node.level, entry_node.position)
                        ism_list.append(ism)
                        self.add_node(ism)
                        self.add_edge(entry_node, ism)
                        self.add_edge(ism, itenp)

                    # add iteration exit markings after iteration_exit_points
                    iem_list: List[TGEndIterationNode] = []
                    for itexp in iteration_exit_points:
                        iem = TGEndIterationNode(entry_node.pet_node_id, entry_node.level, entry_node.position)
                        iem_list.append(iem)
                        self.add_node(iem)
                        self.add_edge(itexp, iem)

                    # redirect edge from entry -> end_loop to iteration_exit markers -> end_loop
                    self.graph.remove_edge(entry_node, lem)
                    for iem in iem_list:
                        self.add_edge(iem, lem)

                else:
                    # progress search
                    if len(search_source_queue) > 0:
                        search_source = search_source_queue.pop(0)
                    else:
                        break

    def __duplicate_loop_iterations(self) -> None:
        logger.info("Duplicating loop iterations...")
        for function_node in self.TGFunctionNode_pet_node_id_to_tg_node.values():
            added_copies: Set[TGNode] = set()  # do not allow the re-copying of copies
            already_considered: Set[TGNode] = set()  # do not allo the re-copying of nodes
            modification_found = True
            # retry duplication of loop iterations until each iteration in the function is followied by a duplicate
            # multiple tries are necessary, as every occurence of a loop needs to be duplicated
            while modification_found:
                modification_found = False
                logger.info("--> " + function_node.get_label())
                descendants = self.get_descendants(function_node)
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
                print("  --> SIN: ", [n.get_label() for n in start_iteration_nodes])
                print("  --> EIN: ", [n.get_label() for n in end_iteration_nodes])
                # filter start_iteration_nodes to those, which have not already been duplicated
                filtered_start_iteration_nodes: List[TGStartIterationNode] = []
                for sin in start_iteration_nodes:
                    already_duplicated = False
                    for pred in self.get_predecessors(sin):
                        if isinstance(pred, TGEndIterationNode) and pred.pet_node_id == sin.pet_node_id:
                            already_duplicated = True
                            break
                    if not already_duplicated:
                        filtered_start_iteration_nodes.append(sin)
                # filter end_iteration_nodes to those, which have not already been duplicated
                filtered_end_iteration_nodes: List[TGEndIterationNode] = []
                for ein in end_iteration_nodes:
                    already_duplicated = False
                    print("EIN: ", ein.get_label(), ein)
                    print("EIN SUCC: ", [n.get_label() for n in self.get_successors(ein)])
                    for succ in self.get_successors(ein):
                        if isinstance(succ, TGStartFunctionNode) and succ.pet_node_id == ein.pet_node_id:
                            already_duplicated = True
                            print("--> Already duplicated")
                            break
                    if not already_duplicated:
                        filtered_end_iteration_nodes.append(ein)

                # find corresponding end iteration node for each start
                for sin in filtered_start_iteration_nodes:
                    print("SIN: ", sin.get_label())
                    for ein in filtered_end_iteration_nodes:
                        print("EIN: ", ein.get_label())
                        # only consider pairs with equal corresponding pet_node_id's
                        if sin.pet_node_id != ein.pet_node_id:
                            continue
                        # validate the identified path by checking, if no other start / end iteration with the same pet_node_id is contained in the path,
                        # i.e., make sure that each considered path is restrained to a single iteration
                        paths = nx.all_simple_paths(self.graph, sin, ein)
                        valid_paths: List[List[TGNode]] = []
                        for path in paths:
                            start_count = len(
                                [
                                    n
                                    for n in path
                                    if (n.pet_node_id == sin.pet_node_id) and isinstance(n, TGStartIterationNode)
                                ]
                            )
                            end_count = len(
                                [
                                    n
                                    for n in path
                                    if (n.pet_node_id == sin.pet_node_id) and isinstance(n, TGEndIterationNode)
                                ]
                            )
                            if start_count == 1 and end_count == 1:
                                valid_paths.append(path)
                        print("VALID PATHS: ", [[n.get_label() for n in p] for p in valid_paths])
                        if len(valid_paths) == 0:
                            continue
                        # TODO copy the validated paths and connect them to the original iteration
                        ein_successors = self.get_successors(ein)
                        for succ in ein_successors:
                            self.graph.remove_edge(ein, succ)
                        copied_nodes: Dict[TGNode, TGNode] = dict()
                        for path in valid_paths:
                            copied_nodes, copied_path = self.__copy_iteration_subgraph(copied_nodes, path)
                            print("COPIED PATH: ", [n.get_label() for n in copied_path])
                            self.add_edge(ein, copied_path[0])
                            for succ in ein_successors:
                                self.add_edge(copied_path[-1], succ)
                        for copied_node in copied_nodes.values():
                            added_copies.add(copied_node)
                        for path in valid_paths:
                            for path_node in path:
                                already_considered.add(path_node)
                        # self.plot()
                        modification_found = True

    def __validate_graph_structure(self) -> None:
        warnings.warn("Not yet implemented!")

    def get_successors(self, node: Optional[TGNode]) -> List[TGNode]:
        if node is None:
            return []
        successors = list(set([t for s, t in self.graph.out_edges(node)]))
        return successors

    def get_predecessors(self, node: Optional[TGNode]) -> List[TGNode]:
        if node is None:
            return []
        predecessors = list(set([s for s, t in self.graph.in_edges(node)]))
        return predecessors

    def get_descendants(self, node: TGNode) -> List[TGNode]:
        return list(nx.descendants(self.graph, node))

    def __copy_iteration_subgraph(
        self, copied_nodes: Dict[TGNode, TGNode], path: List[TGNode]
    ) -> Tuple[Dict[TGNode, TGNode], List[TGNode]]:
        warnings.warn("Not yet implemented!")
        copied_path: List[TGNode] = []
        # copy nodes
        for node in path:
            if node not in copied_nodes:
                node_copy = copy.deepcopy(node)
                self.add_node(node_copy)
                copied_nodes[node] = node_copy
            copied_path.append(copied_nodes[node])
        # copy edges
        for idx in range(0, len(copied_path[:-1])):  # do not copy outgoing edges of the path exit
            self.add_edge(copied_path[idx], copied_path[idx + 1])
        return copied_nodes, copied_path
