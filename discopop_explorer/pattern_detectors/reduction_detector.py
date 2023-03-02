# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.


from typing import List

from .PatternInfo import PatternInfo
from ..PETGraphX import PETGraphX, NodeType, CUNode, EdgeType, DepType, LineID, Variable
from ..utils import is_reduction_var, classify_loop_variables, contains


class ReductionInfo(PatternInfo):
    """Class, that contains reduction detection result"""

    def __init__(self, pet: PETGraphX, node: CUNode):
        """
        :param pet: PET graph
        :param node: node, where reduction was detected
        """
        PatternInfo.__init__(self, node)
        self.pragma = "#pragma omp parallel for"

        fp, p, lp, s, r = classify_loop_variables(pet, node)
        self.first_private = fp
        self.private = p
        self.last_private = lp
        self.shared = s
        self.reduction = r

    def __str__(self):
        return (
            f"Reduction at: {self.node_id}\n"
            f"Start line: {self.start_line}\n"
            f"End line: {self.end_line}\n"
            f"pragma: {self.pragma}\n"
            f"private: {[v.name for v in self.private]}\n"
            f"shared: {[v.name for v in self.shared]}\n"
            f"first private: {[v.name for v in self.first_private]}\n"
            f'reduction: {[v.operation + ":" + v.name for v in self.reduction]}\n'
            f"last private: {[v.name for v in self.last_private]}"
        )


def run_detection(pet: PETGraphX) -> List[ReductionInfo]:
    """Search for reduction pattern

    :param pet: PET graph
    :return: List of detected pattern info
    """
    result: List[ReductionInfo] = []
    nodes = pet.all_nodes(NodeType.LOOP)
    for idx, node in enumerate(nodes):
        print("Reduction: ", idx, "/", len(nodes))
        if not contains(result, lambda x: x.node_id == node.id) and __detect_reduction(pet, node):
            node.reduction = True
            if node.loop_iterations >= 0:
                result.append(ReductionInfo(pet, node))

    return result


def __detect_reduction(pet: PETGraphX, root: CUNode) -> bool:
    """Detects reduction pattern in loop

    :param pet: PET graph
    :param root: the loop node
    :return: true if is reduction loop
    """
    all_vars = []
    for node in pet.subtree_of_type(root, NodeType.CU):
        all_vars.extend(node.local_vars)
        all_vars.extend(node.global_vars)

    # get required metadata
    loop_start_lines: List[LineID] = []
    root_children = pet.subtree_of_type(root, (NodeType.CU, NodeType.LOOP))
    root_children_cus = [cu for cu in root_children if cu.type == NodeType.CU]
    root_children_loops = [cu for cu in root_children if cu.type == NodeType.LOOP]
    for v in root_children_loops:
        loop_start_lines.append(v.start_position())
    reduction_vars = [
        v for v in all_vars if is_reduction_var(root.start_position(), v.name, pet.reduction_vars)
    ]
    reduction_var_names = [v.name for v in reduction_vars]
    fp, p, lp, s, r = classify_loop_variables(pet, root)

    if __check_loop_dependencies(
        pet,
        root,
        root_children_cus,
        root_children_loops,
        loop_start_lines,
        reduction_var_names,
        fp,
        p,
    ):
        return False

    # if the loop contains any reduction variable, create a reduction suggestion
    return bool(reduction_vars)


def __check_loop_dependencies(
    pet: PETGraphX,
    root_loop: CUNode,
    root_children_cus: List[CUNode],
    root_children_loops: List[CUNode],
    loop_start_lines: List[LineID],
    reduction_var_names: List[str],
    first_privates: List[Variable],
    privates: List[Variable],
) -> bool:
    """Returns True, if dependencies between the respective subgraphs chave been found.
    Returns False otherwise, which results in the potential suggestion of a Reduction pattern."""
    # get recursive children of source and target
    loop_children_ids = [node.id for node in root_children_cus]

    # get dependency edges between children nodes
    deps = set()
    for n in loop_children_ids:
        deps.update(
            [(s, t, d) for s, t, d in pet.in_edges(n, EdgeType.DATA) if s in loop_children_ids]
        )
        deps.update(
            [(s, t, d) for s, t, d in pet.out_edges(n, EdgeType.DATA) if t in loop_children_ids]
        )

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

        # targeted variable is not read-only
        if dep.dtype == DepType.INIT:
            continue
        elif dep.dtype == DepType.RAW:
            # check RAW dependencies
            # Reductions are only valid, if the value of the reduction variable is not stored in a shared variable.
            # This property is violated if a RAW dependency for the reduction variable between different CUs exist
            # since CUs follow the Read-Compute-Write pattern.
            if dep.var_name in reduction_var_names:
                if source != target:
                    # if raw_deps for reduction variables between different CU's exist,
                    # the above described property is violated
                    # --> not a valid reduction
                    return True
            else:
                # RAW does not target a reduction variable.
                # RAW problematic, if it is not an intra-iteration RAW.
                if not dep.intra_iteration:
                    return True
        elif dep.dtype == DepType.WAR:
            # check WAR dependencies
            # WAR problematic, if it is not an intra-iteration WAR and the variable is not private or firstprivate
            if not dep.intra_iteration:
                if dep.var_name not in [v.name for v in first_privates + privates]:
                    return True
        elif dep.dtype == DepType.WAW:
            # check WAW dependencies
            # handled by variable classification
            pass
        else:
            raise ValueError("Unsupported dependency type: ", dep.dtype)

    # no problem found. Potentially suggest reduction
    return False
