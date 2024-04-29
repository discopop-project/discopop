# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
import sys
from multiprocessing import Pool
from typing import List, Dict, Set, Tuple, cast
import warnings

from alive_progress import alive_bar  # type: ignore

from .PatternInfo import PatternInfo
from .reduction_detector import ReductionInfo
from ..PEGraphX import (
    CUNode,
    LoopNode,
    PEGraphX,
    Node,
    NodeType,
    EdgeType,
    LineID,
    MemoryRegion,
    DepType,
    NodeID,
)
from ..utils import classify_loop_variables, filter_for_hotspots
from ..variable import Variable


class DoAllInfo(PatternInfo):
    """Class, that contains do-all detection result"""

    def __init__(self, pet: PEGraphX, node: Node):
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
        self.scheduling_clause = "static"
        self.collapse_level = 1

    def __str__(self):
        return (
            f"Do-all at: {self.node_id}\n"
            f"Start line: {self.start_line}\n"
            f"End line: {self.end_line}\n"
            # f"iterations: {self.iterations_count}\n"
            # f"instructions: {self.instructions_count}\n"
            # f"workload: {self.workload}\n"
            f'pragma: "#pragma omp parallel for"\n'
            f"collapse: {self.collapse_level}\n"
            f"private: {[v.name for v in self.private]}\n"
            f"shared: {[v.name for v in self.shared]}\n"
            f"first private: {[v.name for v in self.first_private]}\n"
            f"reduction: {[v.name for v in self.reduction]}\n"
            f"last private: {[v.name for v in self.last_private]}\n"
            f"scheduling clause: {self.scheduling_clause}"
        )


global_pet = None


def run_detection(pet: PEGraphX, hotspots, reduction_info: List[ReductionInfo]) -> List[DoAllInfo]:
    """Search for do-all loop pattern

    :param pet: PET graph
    :return: List of detected pattern info
    """
    import tqdm  # type: ignore

    global global_pet
    global_pet = pet
    result: List[DoAllInfo] = []
    nodes = pet.all_nodes(LoopNode)

    # remove reduction loops
    print("ASDF: ", [r.node_id for r in reduction_info])
    print("Nodes: ", [n.start_position() for n in nodes])
    print("pre:", len(nodes))
    nodes = [n for n in nodes if n.id not in [r.node_id for r in reduction_info]]
    print("post:", len(nodes))

    nodes = cast(List[LoopNode], filter_for_hotspots(pet, cast(List[Node], nodes), hotspots))

    param_list = [(node) for node in nodes]
    with Pool(initializer=__initialize_worker, initargs=(pet,)) as pool:
        tmp_result = list(tqdm.tqdm(pool.imap_unordered(__check_node, param_list), total=len(param_list)))
    for local_result in tmp_result:
        result += local_result
    print("GLOBAL RES: ", [r.start_line for r in result])

    for pattern in result:
        pattern.get_workload(pet)
        pattern.get_per_iteration_workload(pet)

    # remove reduction operations from shared variables to prevent issues / incorrect results in the exported JSON file
    for idx, _ in enumerate(result):
        for idx_2, _ in enumerate(result[idx].shared):
            result[idx].shared[idx_2].operation = None

    return result


def __initialize_worker(pet):
    global global_pet
    global_pet = pet


def __check_node(param_tuple):
    global global_pet
    local_result = []
    node = param_tuple

    if __detect_do_all(global_pet, node):
        node.do_all = True
        if not node.reduction and node.loop_iterations >= 0 and not node.contains_array_reduction:
            local_result.append(DoAllInfo(global_pet, node))

    return local_result


def __detect_do_all(pet: PEGraphX, root_loop: LoopNode) -> bool:
    """Calculate do-all value for node

    :param pet: PET graph
    :param root: root node
    :return: true if do-all
    """
    subnodes = [pet.node_at(t) for s, t, d in pet.out_edges(root_loop.id, [EdgeType.CHILD, EdgeType.CALLSNODE])]

    # get required metadata
    loop_start_lines: List[LineID] = []
    root_children = pet.subtree_of_type(root_loop, (CUNode, LoopNode))
    root_children_cus = [cast(CUNode, cu) for cu in root_children if cu.type == NodeType.CU]
    root_children_loops = [cast(LoopNode, cu) for cu in root_children if cu.type == NodeType.LOOP]
    for v in root_children_loops:
        loop_start_lines.append(v.start_position())
    fp, p, lp, s, r = classify_loop_variables(pet, root_loop)
    # get variables which are defined inside the loop
    defined_inside_loop: List[Tuple[Variable, Set[MemoryRegion]]] = []
    tmp_loop_variables = pet.get_variables(root_children_cus)
    for var in tmp_loop_variables:
        if ":" in var.defLine:
            file_id = int(var.defLine.split(":")[0])
            def_line_num = int(var.defLine.split(":")[1])
            for rc_cu in root_children_cus:
                if file_id == rc_cu.file_id and def_line_num >= rc_cu.start_line and def_line_num <= rc_cu.end_line:
                    defined_inside_loop.append((var, tmp_loop_variables[var]))

    # check if all subnodes are parallelizable
    file_io_warnings = []
    for node in pet.subtree_of_type(root_loop, CUNode):
        if node.performs_file_io:
            # node is not reliably parallelizable as some kind of file-io is performed.
            file_io_warnings.append(node)
            # return False  # too pessimistic
            # todo: issue critical around file_io

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

    for fio in file_io_warnings:
        warnings.warn("FileIO performed inside DoAll @ " + str(node.start_position()))

    return True


def __check_loop_dependencies(
    pet: PEGraphX,
    node_1: Node,
    node_2: Node,
    root_loop: LoopNode,
    root_children_cus: List[CUNode],
    root_children_loops: List[LoopNode],
    loop_start_lines: List[LineID],
    first_privates: List[Variable],
    privates: List[Variable],
    last_privates: List[Variable],
    defined_inside_loop: List[Tuple[Variable, Set[MemoryRegion]]],
) -> bool:
    """Returns True, if dependencies between the respective subgraphs chave been found.
    Returns False otherwise, which results in the potential suggestion of a Do-All pattern."""
    # get recursive children of source and target
    node_1_children_ids = [node.id for node in pet.subtree_of_type(node_1, CUNode)]
    node_2_children_ids = [node.id for node in pet.subtree_of_type(node_2, CUNode)]

    # get dependency edges between children nodes
    deps = set()
    for n in node_1_children_ids + node_2_children_ids:
        deps.update(
            [(s, t, d) for s, t, d in pet.in_edges(n, EdgeType.DATA) if s in node_1_children_ids + node_2_children_ids]
        )
        deps.update(
            [(s, t, d) for s, t, d in pet.out_edges(n, EdgeType.DATA) if t in node_1_children_ids + node_2_children_ids]
        )

    # get memory regions which are defined inside the loop
    memory_regions_defined_in_loop = set()
    for var, mem_regs in defined_inside_loop:
        memory_regions_defined_in_loop.update(mem_regs)

    for source, target, dep in deps:

        # todo: move this calculation to the innermost point possible to reduce computation costs
        # get metadata for dependency
        dep_source_nesting_level = __calculate_nesting_level(pet, root_loop, source)
        dep_target_nesting_level = __calculate_nesting_level(pet, root_loop, target)
        max_considered_intra_iteration_dep_level = max(dep_source_nesting_level, dep_target_nesting_level)

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

        # targeted variable is not read-only
        if dep.dtype == DepType.INIT:
            continue
        elif dep.dtype == DepType.RAW:
            # check RAW dependencies
            # RAW problematic, if it is not an intra-iteration RAW
            if not dep.intra_iteration:
                return True
            # if it is an intra iteration dependency, it is problematic if it belongs to a parent loop
            else:
                if dep.intra_iteration_level <= max_considered_intra_iteration_dep_level:
                    if pet.node_at(source) in root_children_cus and pet.node_at(target) in root_children_cus:
                        pass
                    else:
                        return True

        #                    # dep within the loop. not problematic, if intra_iteration_level == 0
        #                    if dep.intra_iteration_level == 0:
        #                        pass
        #                    else:
        #                        # might be problematic
        #                        # check if source and target in children loops
        #                        contained_in_nested_loop = False
        #                        for nested_loop in [l for l in root_children_loops if l != root_loop]:
        #                            nested_children = pet.subtree_of_type(nested_loop, (CUNode, LoopNode))
        #                            nested_children_cus = [cast(CUNode, cu) for cu in nested_children if cu.type == NodeType.CU]
        #                            if pet.node_at(source) in nested_children_cus and pet.node_at(target) in nested_children_cus:
        #                                contained_in_nested_loop = True
        #                        if not contained_in_nested_loop:
        #                            # problematic
        #                            return True

        #                else:
        #                    # dep could belong to a parent loop
        #                    if root_loop.get_nesting_level(pet) > 1 and dep.intra_iteration_level > 0:
        #                        # dep belongs to parent loop. Can not be ignored for the inner loop
        #                        return True

        elif dep.dtype == DepType.WAR:
            # check WAR dependencies
            # WAR problematic, if it is not an intra-iteration WAR and the variable is not private or firstprivate
            if not dep.intra_iteration:
                if dep.var_name not in [v.name for v in first_privates + privates + last_privates]:
                    # check if variable is defined inside loop
                    if dep.memory_region not in memory_regions_defined_in_loop:
                        return True
            # if it is an intra iteration dependency, it is problematic if it belongs to a parent loop
            elif dep.intra_iteration_level > root_loop.get_nesting_level(pet):
                tmp = root_loop.get_nesting_level(pet)
                return True
        elif dep.dtype == DepType.WAW:
            # check WAW dependencies
            # handled by variable classification
            pass
        else:
            raise ValueError("Unsupported dependency type: ", dep.dtype)

    # no problem found. Potentially suggest Do-All
    return False


def __old_detect_do_all(pet: PEGraphX, root_loop: CUNode) -> bool:
    """Calculate do-all value for node

    :param pet: PET graph
    :param root: root node
    :return: true if do-all
    """
    subnodes = [pet.node_at(t) for s, t, d in pet.out_edges(root_loop.id, [EdgeType.CHILD, EdgeType.CALLSNODE])]

    # check if all subnodes are parallelizable
    for node in pet.subtree_of_type(root_loop, CUNode):
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


def __calculate_nesting_level(pet: PEGraphX, root_loop: LoopNode, cu_node_id: str):
    potential_parents = [(cu_node_id, -1)]  # -1 to offset the initialization with cu_node_id
    while True:
        if len(potential_parents) == 0:
            # warnings.warn("root_loop: " + str(root_loop) + " not a parent of cu_node_id: " + str(cu_node_id))
            return sys.maxsize
        current_node_id, nesting_level = potential_parents.pop()
        if current_node_id == root_loop.id:
            # found
            return nesting_level
        # add new parents to the queue
        for in_child_edge in pet.in_edges(cast(NodeID, current_node_id), EdgeType.CHILD):
            potential_parents.append((in_child_edge[0], nesting_level + 1))
