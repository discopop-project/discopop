# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

from __future__ import annotations
from typing import TYPE_CHECKING, List, Type

from discopop_explorer.classes.PEGraph.NodeT import NodeT
from discopop_explorer.enums.EdgeType import EdgeType
from discopop_explorer.functions.PEGraph.queries.edges import in_edges, out_edges

if TYPE_CHECKING:
    from discopop_explorer.classes.PEGraph.PEGraphX import PEGraphX
    from discopop_explorer.classes.PEGraph.Node import Node


def get_called_nodes(pet: PEGraphX, root: Node) -> List[Node]:
    """Gets called functions.

    :param root: root node
    :return: list of called functions
    """
    return [pet.node_at(t) for s, t, d in out_edges(pet, root.id, EdgeType.CALLSNODE)]
