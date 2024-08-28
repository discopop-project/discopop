# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
from __future__ import annotations
from typing import TYPE_CHECKING, Optional, cast
from discopop_explorer.classes.PEGraph.FunctionNode import FunctionNode
from discopop_explorer.classes.PEGraph.Node import Node

if TYPE_CHECKING:
    from discopop_explorer.classes.PEGraph.PEGraphX import PEGraphX
from discopop_explorer.enums.EdgeType import EdgeType
from discopop_explorer.functions.PEGraph.queries.edges import in_edges


def get_parent_function(pet: PEGraphX, node: Node) -> FunctionNode:
    """Finds the parent of a node

    :param node: current node
    :return: node of parent function
    """
    if isinstance(node, FunctionNode):
        return node
    if node.parent_function_id is None:
        # no precalculated information found.
        current_node = node
        parent_node: Optional[Node] = node
        while parent_node is not None:
            current_node = parent_node
            if type(pet.node_at(current_node.id)) == FunctionNode:
                node.parent_function_id = current_node.id
                break
            parents = [e[0] for e in in_edges(pet, current_node.id, etype=EdgeType.CHILD)]
            if len(parents) == 0:
                parent_node = None
            else:
                parent_node = pet.node_at(parents[0])

    assert node.parent_function_id
    return cast(FunctionNode, pet.node_at(node.parent_function_id))
