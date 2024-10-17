# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
from __future__ import annotations
from typing import TYPE_CHECKING, Dict, List, Optional, Sequence, Set, cast
from discopop_explorer.aliases.MemoryRegion import MemoryRegion
from discopop_explorer.aliases.NodeID import NodeID
from discopop_explorer.classes.PEGraph.CUNode import CUNode
from discopop_explorer.classes.PEGraph.Node import Node

if TYPE_CHECKING:
    from discopop_explorer.classes.PEGraph.PEGraphX import PEGraphX
from discopop_explorer.classes.variable import Variable
from discopop_explorer.enums.EdgeType import EdgeType
from discopop_explorer.functions.PEGraph.properties.is_reduction_var_by_name import is_reduction_var_by_name
from discopop_explorer.functions.PEGraph.queries.edges import in_edges, out_edges
from discopop_explorer.functions.PEGraph.queries.subtree import subtree_of_type


def get_variable(pet: PEGraphX, root_node_id: NodeID, var_name: str) -> Optional[Variable]:
    """Search for the type of the given variable by BFS searching through successor edges in reverse, starting from
    the given root node, and checking the global and local vars of each encountered CU node."""
    queue: List[NodeID] = [root_node_id]
    visited: Set[NodeID] = set()
    while queue:
        current = queue.pop(0)
        current_node = cast(CUNode, pet.node_at(current))
        visited.add(current)
        variables = current_node.local_vars + current_node.global_vars
        for v in variables:
            if v.name == var_name:
                return v
        # add predecessors of current to the list
        predecessors = [s for s, t, d in in_edges(pet, current, EdgeType.SUCCESSOR)]
        for pred in predecessors:
            if pred not in visited and pred not in queue:
                queue.append(pred)
    return None


def get_variables(pet: PEGraphX, nodes: Sequence[Node]) -> Dict[Variable, Set[MemoryRegion]]:
    """Gets all variables and corresponding memory regions in nodes

    :param nodes: nodes
    :return: Set of variables
    """
    res: Dict[Variable, Set[MemoryRegion]] = dict()
    for node in nodes:
        if isinstance(node, CUNode):
            for v in node.local_vars:
                if v not in res:
                    res[v] = set()
            for v in node.global_vars:
                if v not in res:
                    res[v] = set()
            # try to identify memory regions
            for var_name in res:
                # since the variable name is checked for equality afterwards,
                # it is safe to consider incoming dependencies at this point as well.
                # Note that INIT type edges are considered as well!
                for _, _, dep in out_edges(pet, node.id, EdgeType.DATA) + in_edges(pet, node.id, EdgeType.DATA):
                    if dep.var_name == var_name.name:
                        if dep.memory_region is not None:
                            res[var_name].add(dep.memory_region)
    return res


def get_undefined_variables_inside_loop(
    pet: PEGraphX, root_loop: Node, include_global_vars: bool = False
) -> Dict[Variable, Set[MemoryRegion]]:
    sub = subtree_of_type(pet, root_loop, CUNode)
    vars = get_variables(pet, sub)
    dummyVariables = []
    definedVarsInLoop = []
    definedVarsInCalledFunctions = []

    # Remove llvm temporary variables
    for var in vars:
        if var.defLine == "LineNotFound" or "0:" in var.defLine:
            dummyVariables.append(var)
        elif not include_global_vars:
            if var.defLine == "GlobalVar" and not is_reduction_var_by_name(pet, root_loop.start_position(), var.name):
                dummyVariables.append(var)

    # vars = list(set(vars) ^ set(dummyVariables))
    for key in set(dummyVariables):
        if key in vars:
            del vars[key]

    # Exclude variables which are defined inside the loop
    for var in vars:
        if var.defLine >= root_loop.start_position() and var.defLine <= root_loop.end_position():
            definedVarsInLoop.append(var)

    # vars = list(set(vars) ^ set(definedVarsInLoop))
    for key in set(definedVarsInLoop):
        if key in vars:
            del vars[key]

    # Also, exclude variables which are defined inside
    # functions that are called within the loop
    for var in vars:
        for s in sub:
            if var.defLine >= s.start_position() and var.defLine <= s.end_position():
                definedVarsInCalledFunctions.append(var)

    # vars = list(set(vars) ^ set(definedVarsInCalledFunctions))
    for key in set(definedVarsInCalledFunctions):
        if key in vars:
            del vars[key]

    return vars
