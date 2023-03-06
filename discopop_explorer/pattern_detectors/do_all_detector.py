# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
import sys
from typing import List, Dict, Set, Tuple

from .PatternInfo import PatternInfo
from ..PETGraphX import CUNode, LoopNode, PETGraphX, Node, NodeType, EdgeType
from ..utils import classify_loop_variables, contains
import time


class DoAllInfo(PatternInfo):
    """Class, that contains do-all detection result"""

    def __init__(self, pet: PETGraphX, node: Node):
        """
        :param pet: PET graph
        :param node: node, where do-all was detected
        """
        PatternInfo.__init__(self, node)
        fp, p, lp, s, r = classify_loop_variables(pet, node)
        self.first_private = fp
        self.private = p
        self.last_private = lp
        self.shared = s
        self.reduction = r

    def __str__(self):
        return (
            f"Do-all at: {self.node_id}\n"
            f"Start line: {self.start_line}\n"
            f"End line: {self.end_line}\n"
            # f"iterations: {self.iterations_count}\n"
            # f"instructions: {self.instructions_count}\n"
            # f"workload: {self.workload}\n"
            f'pragma: "#pragma omp parallel for"\n'
            f"private: {[v.name for v in self.private]}\n"
            f"shared: {[v.name for v in self.shared]}\n"
            f"first private: {[v.name for v in self.first_private]}\n"
            f"reduction: {[v.name for v in self.reduction]}\n"
            f"last private: {[v.name for v in self.last_private]}"
        )


def run_detection(pet: PETGraphX) -> List[DoAllInfo]:
    """Search for do-all loop pattern

    :param pet: PET graph
    :return: List of detected pattern info
    """
    result: List[DoAllInfo] = []
    nodes = pet.all_nodes(LoopNode)
    for idx, node in enumerate(nodes):
        print("Do-all:", idx, "/", len(nodes))
        if not contains(result, lambda x: x.node_id == node.id) and __detect_do_all(pet, node):
            node.do_all = True
            if not node.reduction and node.loop_iterations >= 0:
                result.append(DoAllInfo(pet, node))

    return result


def __detect_do_all(pet: PETGraphX, root_loop: Node) -> bool:
    """Calculate do-all value for node

    :param pet: PET graph
    :param root: root node
    :return: true if do-all
    """
    subnodes = [
        pet.node_at(t)
        for s, t, d in pet.out_edges(root_loop.id, [EdgeType.CHILD, EdgeType.CALLSNODE])
    ]

    # get required metadata
    loop_start_lines: List[LineID] = []
    root_children = pet.subtree_of_type(root_loop, (NodeType.CU, NodeType.LOOP))
    root_children_cus = [cu for cu in root_children if cu.type == NodeType.CU]
    root_children_loops = [cu for cu in root_children if cu.type == NodeType.LOOP]
    for v in root_children_loops:
        loop_start_lines.append(v.start_position())
    fp, p, lp, s, r = classify_loop_variables(pet, root_loop)
    # get variables which are defined inside the loop
    defined_inside_loop: List[Tuple[Variable, Set[MemoryRegion]]] = []
    tmp_loop_variables = pet.get_variables(root_children_cus)
    for var in tmp_loop_variables:
        if var.defLine >= root_loop.start_position() and var.defLine <= root_loop.end_position():
            defined_inside_loop.append((var, tmp_loop_variables[var]))

    # check if all subnodes are parallelizable
    for node in pet.subtree_of_type(root_loop, CUNode):
        if node.performs_file_io:
            # node is not reliably parallelizable as some kind of file-io is performed.
            return False

    for i in range(0, len(subnodes)):
        children_cache: Dict[Node, List[Node]] = dict()
        dependency_cache: Dict[Tuple[Node, Node], Set[Node]] = dict()
        for j in range(i, len(subnodes)):
            if __check_loop_dependencies(
                pet,
                subnodes[i],
                subnodes[j],
                root_loop,
                root_children_cus,
                root_children_loops,
                loop_start_lines,
                fp,
                p,
                lp,
                defined_inside_loop,
            ):
                # if pet.depends_ignore_readonly(subnodes[i], subnodes[j], root_loop):
                return False

    return True


def __check_loop_dependencies(
    pet: PETGraphX,
    node_1: CUNode,
    node_2: CUNode,
    root_loop: CUNode,
    root_children_cus: List[CUNode],
    root_children_loops: List[CUNode],
    loop_start_lines: List[LineID],
    first_privates: List[Variable],
    privates: List[Variable],
    last_privates: List[Variable],
    defined_inside_loop: List[Tuple[Variable, Set[MemoryRegion]]],
) -> bool:
    """Returns True, if dependencies between the respective subgraphs chave been found.
    Returns False otherwise, which results in the potential suggestion of a Do-All pattern."""
    # get recursive children of source and target
    node_1_children_ids = [node.id for node in pet.subtree_of_type(node_1, NodeType.CU)]
    node_2_children_ids = [node.id for node in pet.subtree_of_type(node_2, NodeType.CU)]

    # get dependency edges between children nodes
    deps = set()
    for n in node_1_children_ids + node_2_children_ids:
        deps.update(
            [
                (s, t, d)
                for s, t, d in pet.in_edges(n, EdgeType.DATA)
                if s in node_1_children_ids + node_2_children_ids
            ]
        )
        deps.update(
            [
                (s, t, d)
                for s, t, d in pet.out_edges(n, EdgeType.DATA)
                if t in node_1_children_ids + node_2_children_ids
            ]
        )

    # get memory regions which are defined inside the loop
    memory_regions_defined_in_loop = set()
    for var, mem_regs in defined_inside_loop:
        memory_regions_defined_in_loop.update(mem_regs)

    for source, target, dep in deps:
        # check if targeted variable is readonly inside loop
        if pet.is_readonly_inside_loop_body(
            dep,
            root_loop,
            root_children_cus,
            root_children_loops,
            loops_start_lines=loop_start_lines,
        ):
            # variable is readonly -> no problem
            continue

        # check if targeted variable is loop index
        if pet.is_loop_index(dep.var_name, loop_start_lines, root_children_cus):
            continue

        # check if variable is defined inside loop
        if dep.memory_region in memory_regions_defined_in_loop:
            continue

        # targeted variable is not read-only
        if dep.dtype == DepType.INIT:
            continue
        elif dep.dtype == DepType.RAW:
            # check RAW dependencies
            # RAW problematic, if it is not an intra-iteration RAW
            if not dep.intra_iteration:
                return True
        elif dep.dtype == DepType.WAR:
            # check WAR dependencies
            # WAR problematic, if it is not an intra-iteration WAR and the variable is not private or firstprivate
            if not dep.intra_iteration:
                if dep.var_name not in [v.name for v in first_privates + privates + last_privates]:
                    return True
        elif dep.dtype == DepType.WAW:
            # check WAW dependencies
            # handled by variable classification
            pass
        else:
            raise ValueError("Unsupported dependency type: ", dep.dtype)

    # no problem found. Potentially suggest Do-All
    return False


def __old_detect_do_all(pet: PETGraphX, root_loop: CUNode) -> bool:
    """Calculate do-all value for node

    :param pet: PET graph
    :param root: root node
    :return: true if do-all
    """
    subnodes = [
        pet.node_at(t)
        for s, t, d in pet.out_edges(root_loop.id, [EdgeType.CHILD, EdgeType.CALLSNODE])
    ]

    # check if all subnodes are parallelizable
    for node in pet.subtree_of_type(root_loop, NodeType.CU):
        if node.performs_file_io:
            # node is not reliably parallelizable as some kind of file-io is performed.
            return False

    for i in range(0, len(subnodes)):
        children_cache: Dict[CUNode, List[CUNode]] = dict()
        dependency_cache: Dict[Tuple[CUNode, CUNode], Set[CUNode]] = dict()
        for j in range(i, len(subnodes)):
            if pet.depends_ignore_readonly(subnodes[i], subnodes[j], root_loop):
                return False

    return True
