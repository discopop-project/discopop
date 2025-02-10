# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

from __future__ import annotations
from multiprocessing import Pool
from typing import Dict, List, Optional, cast, Set, Tuple
import warnings

from discopop_explorer.functions.PEGraph.properties.is_loop_index import is_loop_index
from discopop_explorer.functions.PEGraph.properties.is_readonly_inside_loop_body import is_readonly_inside_loop_body
from discopop_explorer.functions.PEGraph.queries.edges import in_edges, out_edges
from discopop_explorer.functions.PEGraph.queries.nodes import all_nodes
from discopop_explorer.functions.PEGraph.queries.subtree import subtree_of_type
from discopop_explorer.functions.PEGraph.queries.variables import get_variables
from discopop_explorer.functions.PEGraph.traversal.parent import get_parent_function
from discopop_library.HostpotLoader.HotspotNodeType import HotspotNodeType
from discopop_library.HostpotLoader.HotspotType import HotspotType  # type: ignore

from discopop_explorer.classes.patterns.PatternInfo import PatternInfo
from discopop_explorer.classes.PEGraph.PEGraphX import (
    PEGraphX,
)
from discopop_explorer.classes.PEGraph.LoopNode import LoopNode
from discopop_explorer.classes.PEGraph.CUNode import CUNode
from discopop_explorer.classes.PEGraph.Node import Node
from discopop_explorer.classes.PEGraph.Dependency import Dependency
from discopop_explorer.aliases.MemoryRegion import MemoryRegion
from discopop_explorer.aliases.LineID import LineID
from discopop_explorer.aliases.NodeID import NodeID
from discopop_explorer.enums.NodeType import NodeType
from discopop_explorer.enums.DepType import DepType
from discopop_explorer.enums.EdgeType import EdgeType
from discopop_explorer.utils import filter_for_hotspots, is_reduction_var, classify_loop_variables
from discopop_explorer.classes.variable import Variable
from typing import TYPE_CHECKING

from discopop_library.Stubs.PerfoGraph.clangInterleaveFactor import get_clang_interleave_factor
from discopop_library.Stubs.PerfoGraph.clangVectorizationFactor import get_clang_vectorization_factor

if TYPE_CHECKING:
    from discopop_library.result_classes.DetectionResult import DetectionResult


class ClangVectorizationInfo(PatternInfo):
    """Class, that contains clang vectorization detection result"""

    def __init__(self, pet: PEGraphX, node: Node):
        """
        :param pet: PET graph
        :param node: node, where reduction was detected
        """
        PatternInfo.__init__(self, node)
        self.pragma = "#pragma clang loop vectorize(enable)"
        self.VF = get_clang_vectorization_factor(node.start_position())
        self.IF = get_clang_interleave_factor(node.start_position())

    def __str__(self) -> str:
        return (
            f"Start line: {self.start_line}\n"
            f"End line: {self.end_line}\n"
            f"pragma: {self.pragma}\n"
            f"VF: {self.VF}\n"
            f"IF: {self.IF}\n"
        )


def run_detection(
    pet: PEGraphX,
    res: DetectionResult,
) -> List[ClangVectorizationInfo]:
    """Search for clang loop vectorization pattern

    :param pet: PET graph
    :return: List of detected pattern info
    """
    result: List[ClangVectorizationInfo] = []
    for pattern in res.patterns.do_all + res.patterns.reduction:
        if is_vectorizable(cast(LoopNode, pet.node_at(pattern.node_id))):
            result.append(ClangVectorizationInfo(pet, pet.node_at(pattern.node_id)))
    return result


def is_vectorizable(loop: LoopNode) -> bool:
    # TODO improve
    return True
