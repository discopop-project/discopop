# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
from __future__ import annotations

from typing import Dict, List, Optional, Set, Tuple, TYPE_CHECKING

if TYPE_CHECKING:
    from discopop_explorer.classes.TaskGraph.TGNode import TGNode

from discopop_explorer.classes.PEGraph.Dependency import Dependency
from discopop_explorer.classes.TaskGraph.Aliases import LevelIndex, PositionIndex


class Context(object):
    contained_nodes: List[TGNode]
    contained_contexts: Set[Context]
    successor: Optional[Context]
    predecessor: Optional[Context]
    parent_context: Optional[Context]
    outgoing_dependencies: Set[Tuple[Context, Dependency]]

    def __init__(self) -> None:
        self.contained_nodes = []
        self.contained_contexts = set()
        self.parent_context = None
        self.successor = None
        self.predecessor = None
        self.outgoing_dependencies = set()

    def get_contained_nodes(self, inclusive: bool = False) -> List[TGNode]:
        """
        Returns the nodes contained in the current context.
        inclusive: If False, does not consider contexts contained in the current context. If true, included contexts are traversed recursively.
        """
        if not inclusive:
            return self.contained_nodes
        nodes: List[TGNode] = []
        nodes += self.contained_nodes
        for ctx in self.contained_contexts:
            nodes += ctx.get_contained_nodes(inclusive=True)
        return nodes

    def get_contained_contexts(self, inclusive: bool = False) -> Set[Context]:
        """
        Returns the contexts contained in the current context.
        If inclusive is False, only the directly contained contexts will be returned. If inclusive is True, contexts will be collected recursively.
        """
        if not inclusive:
            return self.contained_contexts
        result: Set[Context] = set()
        result = result.union(self.contained_contexts)
        for ctx in self.contained_contexts:
            result = result.union(ctx.get_contained_contexts(inclusive=True))
        return result

    def add_node(self, node: TGNode) -> None:
        self.contained_nodes.append(node)

    def add_contained_context(self, context: Context) -> None:
        if context == self:
            # do not allow the creation of self-containing relations
            return
        self.contained_contexts.add(context)

    def register_parent_context(self, context: Context) -> None:
        if context == self:
            # do not allow the creation of self-parenting relations
            return
        self.parent_context = context

    def register_successor_context(self, context: Context) -> None:
        if context == self:
            # do not allow the creation of self-succession relations
            return
        self.successor = context
        context.predecessor = self

    def get_preceeding_contexts(self) -> Set[Context]:
        preceeding_contexts: Set[Context] = set()
        parent_queue: List[Context] = [self.parent_context] if self.parent_context is not None else []
        predecessor_queue: List[Context] = [self.predecessor] if self.predecessor is not None else []
        visited: Set[Context] = set()
        while len(parent_queue) > 0 or len(predecessor_queue) > 0:
            while len(predecessor_queue) > 0:
                current_pred = predecessor_queue.pop()
                preceeding_contexts.add(current_pred)
                preceeding_contexts = preceeding_contexts.union(current_pred.get_contained_contexts(inclusive=True))
                if current_pred.predecessor is not None:
                    if current_pred.predecessor not in visited:
                        visited.add(current_pred.predecessor)
                        predecessor_queue.append(current_pred.predecessor)
            while len(parent_queue) > 0:
                current_parent = parent_queue.pop()
                if current_parent.predecessor is not None:
                    if current_parent.predecessor not in visited:
                        visited.add(current_parent.predecessor)
                        predecessor_queue.append(current_parent.predecessor)
                if current_parent.parent_context is not None:
                    if current_parent.parent_context not in visited:
                        visited.add(current_parent.parent_context)
                        parent_queue.append(current_parent.parent_context)
        return preceeding_contexts

    def get_successive_contexts(self) -> Set[Context]:
        successive_contexts: Set[Context] = set()
        parent_queue: List[Context] = [self.parent_context] if self.parent_context is not None else []
        successor_queue: List[Context] = [self.successor] if self.successor is not None else []
        visited: Set[Context] = set()
        while len(parent_queue) > 0 or len(successor_queue) > 0:
            while len(successor_queue) > 0:
                current_succ = successor_queue.pop()
                successive_contexts.add(current_succ)
                successive_contexts = successive_contexts.union(current_succ.get_contained_contexts(inclusive=True))
                if current_succ.successor is not None:
                    if current_succ.successor not in visited:
                        visited.add(current_succ.successor)
                        successor_queue.append(current_succ.successor)
            while len(parent_queue) > 0:
                current_parent = parent_queue.pop()
                if current_parent.successor is not None:
                    if current_parent.successor not in visited:
                        visited.add(current_parent.successor)
                        successor_queue.append(current_parent.successor)
                if current_parent.parent_context is not None:
                    if current_parent.parent_context not in visited:
                        visited.add(current_parent.parent_context)
                        parent_queue.append(current_parent.parent_context)
        return successive_contexts

    def register_outgoing_dependency(self, target_context: Context, dependency: Dependency) -> None:
        self.outgoing_dependencies.add((target_context, dependency))

    def get_outgoing_dependency_targets(self) -> Set[Context]:
        return set([outgoing_dependency[0] for outgoing_dependency in self.outgoing_dependencies])

    def get_plot_bounding_box(self) -> Tuple[int, LevelIndex, LevelIndex, PositionIndex, PositionIndex]:
        if len(self.contained_nodes) == 0:
            return 0, 0, 0, 0, 0
        levels = [n.level for n in self.contained_nodes]
        positions = [n.position for n in self.contained_nodes]
        return len(self.contained_nodes), min(levels), max(levels), min(positions), max(positions)

    def get_plot_border_color(self) -> str:
        return "b"

    def get_plot_face_color(self) -> str:
        return "red"

    def get_plot_face_alpha(self) -> float:
        return 0.2

    def get_label(self) -> str:
        return "CTX"
