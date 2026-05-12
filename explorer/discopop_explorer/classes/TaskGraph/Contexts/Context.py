# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
from __future__ import annotations

from typing import Dict, List, Optional, Set, Tuple, TYPE_CHECKING

from discopop_explorer.classes.PEGraph.CUNode import CUNode
from discopop_explorer.classes.PEGraph.PEGraphX import PEGraphX

if TYPE_CHECKING:
    from discopop_explorer.classes.TaskGraph.TGNode import TGNode

from discopop_explorer.aliases.LineID import LineID
from discopop_explorer.classes.PEGraph.Dependency import Dependency
from discopop_explorer.classes.TaskGraph.Aliases import LevelIndex, PETNode, PositionIndex


class Context(object):
    contained_nodes: List[TGNode]
    contained_contexts: Set[Context]
    successor: Optional[Context]
    predecessor: Optional[Context]
    parent_context: Optional[Context]
    outgoing_dependencies: Set[Tuple[Context, Dependency]]
    incoming_dependencies: Set[Tuple[Context, Dependency]]
    affected_contexts_by_outgoing_dependency: Dict[
        Dependency, List[Context]
    ]  # List of contexts in order of upward tree traversal
    affecting_contexts_by_incoming_dependency: Dict[
        Dependency, List[Context]
    ]  # List of contexts in order of upward tree traversal
    state_ids: List[int]

    def __init__(self) -> None:
        self.contained_nodes = []
        self.contained_contexts = set()
        self.parent_context = None
        self.successor = None
        self.predecessor = None
        self.outgoing_dependencies = set()
        self.incoming_dependencies = set()
        self.affected_contexts_by_outgoing_dependency = dict()
        self.affecting_contexts_by_incoming_dependency = dict()
        self._ancestor_contexts_cache: Optional[List[Context]] = None
        self._code_scope_cache: Optional[List[LineID]] = None
        self._closest_function_ancestor_computed: bool = False
        self._closest_function_ancestor: Optional[Context] = None
        self.state_ids = []

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

    def get_contained_contexts_in_sequence(self, is_entry: bool = True) -> List[Context]:
        """enumerates contained contexts in their sequence of occurrence in the program"""
        result: List[Context] = []
        for ctx in self.contained_contexts:
            if ctx.predecessor is None:
                # entry of a sequence
                result.append(ctx)
                result += ctx.get_contained_contexts_in_sequence(is_entry=False)

        if not is_entry:
            if self.successor is not None:
                result += self.successor.get_contained_contexts_in_sequence(is_entry=False)

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

    def is_function_context(self) -> bool:
        return False

    def get_ancestor_contexts(self) -> List[Context]:
        """return the ancestor contexts of the current context, starting with the direct parent context and ending with the root context."""
        if self._ancestor_contexts_cache is not None:
            return self._ancestor_contexts_cache
        ancestors: List[Context] = []
        current_context = self.parent_context
        while current_context is not None:
            ancestors.append(current_context)
            current_context = current_context.parent_context
        self._ancestor_contexts_cache = ancestors
        return ancestors

    def get_closest_function_ancestor(self) -> Optional[Context]:
        if self._closest_function_ancestor_computed:
            return self._closest_function_ancestor
        for ancestor in self.get_ancestor_contexts():
            if ancestor.is_function_context():
                self._closest_function_ancestor = ancestor
                break
        self._closest_function_ancestor_computed = True
        return self._closest_function_ancestor

    def register_outgoing_dependency(self, target_context: Context, dependency: Dependency) -> None:
        # register dependency
        self.outgoing_dependencies.add((target_context, dependency))
        target_context.incoming_dependencies.add((self, dependency))
        # register affected contexts
        self_ancestors = self.get_ancestor_contexts()
        target_ancestors = target_context.get_ancestor_contexts()
        # -> ignore matching prefix ancestors
        while len(self_ancestors) > 0 and len(target_ancestors) > 0 and self_ancestors[-1] == target_ancestors[-1]:
            self_ancestors = self_ancestors[:-1]
            target_ancestors = target_ancestors[:-1]
        # -> register affected contexts
        self.affected_contexts_by_outgoing_dependency[dependency] = target_ancestors
        target_context.affecting_contexts_by_incoming_dependency[dependency] = self_ancestors

    def delete_outgoing_dependency(self, target_context: Context, dependency: Dependency) -> None:
        # register dependency
        self.outgoing_dependencies.remove((target_context, dependency))
        target_context.incoming_dependencies.remove((self, dependency))
        # delete affected contexts
        if dependency in self.affected_contexts_by_outgoing_dependency:
            del self.affected_contexts_by_outgoing_dependency[dependency]
        if dependency in target_context.affecting_contexts_by_incoming_dependency:
            del target_context.affecting_contexts_by_incoming_dependency[dependency]

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

    def get_first_pet_node(self, pet: PEGraphX) -> Optional[PETNode]:
        for node in self.contained_nodes:
            pet_node = node.get_pet_node(pet)
            if pet_node is not None:
                return pet_node
        return None

    def get_code_scope(self, pet: PEGraphX, inclusive: bool = False) -> List[LineID]:
        """returns a list of code scopes contained in the context."""
        if not inclusive and self._code_scope_cache is not None:
            return self._code_scope_cache
        scope: List[LineID] = []
        for node in self.get_contained_nodes(inclusive=inclusive):
            pet_node = node.get_pet_node(pet)
            if pet_node is None:
                continue
            for i in range(pet_node.start_line, pet_node.end_line + 1):
                scope.append(LineID(str(pet_node.file_id) + ":" + str(i)))
        result = list(set(scope))
        if not inclusive:
            self._code_scope_cache = result
        return result

    def get_defined_variables(self, pet: PEGraphX) -> List[Tuple[str, LineID]]:
        """returns a list of defined variables in the context as tuples of (variable name, lineID)."""
        defined_vars: List[Tuple[str, LineID]] = []
        code_scope = self.get_code_scope(pet)
        for node in self.contained_nodes:
            pet_node = node.get_pet_node(pet)
            if pet_node is None:
                continue
            if isinstance(pet_node, CUNode):
                for var in pet_node.local_vars + pet_node.global_vars:
                    var_def_line = var.defLine
                    if var_def_line in code_scope:  # implicitly ignore definition line "LineNotFound"
                        # print("Definition of variable " + var.name + " at line " + var_def_line)
                        defined_vars.append((str(var.name), LineID(var_def_line)))

        # remove duplicates
        defined_vars = list(set(defined_vars))
        return defined_vars

    def get_state_ids(self) -> List[int]:
        if len(self.state_ids) != 0:
            return self.state_ids
        for anc in self.get_ancestor_contexts():
            if len(anc.state_ids) != 0:
                return anc.state_ids
        return []
