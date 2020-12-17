# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.


import itertools
from typing import List, Set, Dict, Tuple

import numpy as np

from .PETGraphX import PETGraphX, NodeType, CUNode, DepType, EdgeType, Dependency
from .variable import Variable

loop_data: Dict[str, int] = {}


def correlation_coefficient(v1: List[float], v2: List[float]) -> float:
    """Calculates correlation coefficient as (A dot B) / (norm(A) * norm(B))

    :param v1: first vector
    :param v2: second vector
    :return: correlation coefficient, 0 if one of the norms is 0
    """
    norm_product = np.linalg.norm(v1) * np.linalg.norm(v2)  # type:ignore
    return 0 if norm_product == 0 else np.dot(v1, v2) / norm_product  # type:ignore


def find_subnodes(pet: PETGraphX, node: CUNode, criteria: EdgeType) -> List[CUNode]:
    """Returns direct children of a given node

    :param pet: PET graph
    :param node: CUNode
    :param criteria: EdgeType, type of edges to traverse
    :return: list of children nodes
    """
    return [pet.node_at(t) for s, t, d in pet.out_edges(node.id) if d.etype == criteria]


def depends(pet: PETGraphX, source: CUNode, target: CUNode) -> bool:
    """Detects if source node or one of it's children has a RAW dependency to target node or one of it's children

    :param pet: PET graph
    :param source: source node for dependency detection
    :param target: target of dependency
    :return: true, if there is RAW dependency
    """
    if source == target:
        return False
    # target_nodes = pet.get_left_right_subtree(target, True)
    target_nodes = pet.subtree_of_type(target, None)

    # for node in pet.get_left_right_subtree(source, True):
    for node in pet.subtree_of_type(source, NodeType.CU):
        # for dep in [e.target() for e in pet.out_edges(node.id, EdgeType.DATA)]: # if e.dtype == 'RAW']:
        for target in [pet.node_at(target_id) for source_id, target_id, dependence in
                       pet.out_edges(node.id, EdgeType.DATA) if dependence.dtype == DepType.RAW]:
            if target in target_nodes:
                return True
    return False


def is_loop_index2(pet: PETGraphX, root_loop: CUNode, var_name: str) -> bool:
    """Checks, whether the variable is a loop index.

    :param pet: CU graph
    :param root_loop: root loop
    :param var_name: name of the variable
    :return: true if variable is index of the loop
    """
    loops_start_lines = [v.start_position() for v in pet.subtree_of_type(root_loop, NodeType.LOOP)]
    return pet.is_loop_index(var_name, loops_start_lines, pet.subtree_of_type(root_loop, NodeType.CU))


def total_instructions_count(pet: PETGraphX, root: CUNode) -> int:
    """Calculates total number of the instructions in the subtree of a given node

    :param pet: PET graph
    :param root: root node
    :return: number of instructions
    """
    res = 0
    for node in pet.get_left_right_subtree(root, True):
        res += node.instructions_count
    return res


def calculate_workload(pet: PETGraphX, node: CUNode) -> int:
    """Calculates workload for a given node
    The workload is the number of instructions multiplied by respective number of iterations

    :param pet: PET graph
    :param node: root node
    :return: workload
    """
    res = 0
    if node.type == NodeType.DUMMY:
        return 0
    elif node.type == NodeType.CU:
        res += node.instructions_count
    elif node.type == NodeType.FUNC:
        for child in find_subnodes(pet, node, EdgeType.CHILD):
            res += calculate_workload(pet, child)
    elif node.type == NodeType.LOOP:
        for child in find_subnodes(pet, node, EdgeType.CHILD):
            if child.type == NodeType.CU:
                if 'for.inc' in child.basic_block_id:
                    res += child.instructions_count
                elif 'for.cond' in child.basic_block_id:
                    res += child.instructions_count * (
                            get_loop_iterations(node.start_position()) + 1)
                else:
                    res += child.instructions_count * get_loop_iterations(node.start_position())
            else:
                res += calculate_workload(pet, child) * get_loop_iterations(node.start_position())
    return res


def get_loop_iterations(line: str) -> int:
    """Calculates the number of iterations in specified loop

    :param line: start line of the loop
    """
    return loop_data.get(line, 0)


def __get_dep_of_type(pet: PETGraphX, node: CUNode, dep_type: DepType,
                      reversed: bool) -> List[Tuple[str, str, Dependency]]:
    """Searches all dependencies of specified type

    :param pet: CU graph
    :param node: node
    :param dep_type: type of dependency
    :param reversed: if true the it looks for incoming dependencies
    :return: list of dependencies
    """
    return [e for e in (pet.in_edges(node.id, EdgeType.DATA) if reversed else pet.out_edges(node.id, EdgeType.DATA))
            if e[2].dtype == dep_type]


def __get_variables(nodes: List[CUNode]) -> Set[Variable]:
    """Gets all variables in nodes

    :param nodes: nodes
    :return: Set of variables
    """
    res = set()
    for node in nodes:
        for v in node.local_vars:
            res.add(v)
        for v in node.global_vars:
            res.add(v)
    return res


def is_reduction_var(line: str, name: str, reduction_vars: List[Dict[str, str]]) -> bool:
    """Determines, whether or not the given variable is reduction variable

    :param line: loop line number
    :param name: variable name
    :param reduction_vars: List of reduction variables
    :return: true if is reduction variable
    """
    return any(rv for rv in reduction_vars if rv['loop_line'] == line and rv['name'] == name)


def is_reduction_any(possible_lines: List[str], name: str, reduction_vars: List[Dict[str, str]]) -> bool:
    """Determines, whether or not the given variable is reduction variable

    :param possible_lines: possible loop line number
    :param name: variable name
    :param reduction_vars: List of reduction variables
    :return: true if is reduction variable
    """
    for line in possible_lines:
        if is_reduction_var(line, name, reduction_vars):
            return True

    return False


def is_written_in_subtree(var_name: str, raw: Set[Tuple[str, str, Dependency]],
                          waw: Set[Tuple[str, str, Dependency]], tree: List[CUNode]) -> bool:
    """ Checks if variable is written in subtree

    :param var_name: variable name
    :param raw: raw dependencies of the loop
    :param waw: waw dependencies of the loop
    :param tree: subtree
    :return: true if is written
    """
    for e in itertools.chain(raw, waw):
        if e[2].var_name == var_name and any([n.id == e[1] for n in tree]):
            return True
    return False


def is_func_arg(pet: PETGraphX, var: str, node: CUNode) -> bool:
    """Checks if variable is a function argument

    :param pet: CU graph
    :param var: variable name
    :param node: loop node
    :return: true if variable is argument
    """
    # None may occur because __get_variables doesn't check for actual elements
    if var is None:
        return False
    if '.' not in var:
        return False
    parents = [pet.node_at(edge[0]) for edge in pet.in_edges(node.id, EdgeType.CHILD)]
    # add current node to parents, if it is of type FUNC
    if node.type == NodeType.FUNC:
        parents.append(node)
    parent_functions = [cu for cu in parents if cu.type == NodeType.FUNC]
    for pf in parent_functions:
        for arg in pf.args:
            if var.startswith(arg.name):
                return True
    return False


def is_scalar_val(var) -> bool:
    """Checks if variable is a scalar value

    :param var: variable
    :return: true if scalar
    """
    return not (var.type.endswith('**') or var.type.startswith('ARRAY' or var.type.startswith('[')))


def is_readonly(var: str, war: Set[Tuple[str, str, Dependency]],
                waw: Set[Tuple[str, str, Dependency]], rev_war: Set[Tuple[str, str, Dependency]]) -> bool:
    """Checks if variable is readonly

    :param var: variable name
    :param war: war dependencies of the loop
    :param waw: waw dependencies of the loop
    :param rev_war: reversed raw dependencies of the loop
    :return: trie if readonly
    """
    for e in itertools.chain(war, waw, rev_war):
        if e[2].var_name == var:
            return False
    return True


def is_global(var: str, tree: List[CUNode]) -> bool:
    """Checks if variable is global

    :param var: variable name
    :param tree: nodes to search
    :return: true if global
    """

    for node in tree:
        if node.type == NodeType.CU:
            for gv in node.global_vars:
                if gv.name == var:
                    # TODO from tmp global vars
                    return False
    return False


def is_first_written(var: str, raw: Set[Tuple[str, str, Dependency]],
                     war: Set[Tuple[str, str, Dependency]], sub: List[CUNode]) -> bool:
    """Checks whether a variable is first written inside the current node

    :param var: variable name
    :param raw: raw dependencies of the loop
    :param war: war dependencies of the loop
    :param sub: subtree of the loop
    :return: true if first written
    """
    for e in war:
        if e[2].var_name == var and any([n.id == e[1] for n in sub]):
            res = False
            for eraw in raw:
                # TODO check
                if (eraw[2].var_name == var and any([n.id == e[1] for n in sub])
                        and e[0] == eraw[2].sink):
                    res = True
                    break
            if not res:
                return False
    return True


def is_first_written_new(var: Variable, raw_deps: Set[Tuple[str, str, Dependency]],
                         war_deps: Set[Tuple[str, str, Dependency]], reverse_raw_deps: Set[Tuple[str, str, Dependency]],
                         reverse_war_deps: Set[Tuple[str, str, Dependency]], tree: List[CUNode]):
    """Checks whether a variable is first written inside the current node

    :param var:
    :param raw_deps: raw dependencies of the loop
    :param war_deps: war dependencies of the loop
    :param reverse_raw_deps:
    :param reverse_war_deps:
    :param tree: subtree of the loop
    :return: true if first written
    """
    result = False
    # None may occur because __get_variables doesn't check for actual elements
    if var.name is None:
        return False
    is_read = is_read_in(var, raw_deps, war_deps, reverse_raw_deps, reverse_war_deps, tree)
    if var.name is None:
        print("Empty var.name found. Skipping.")
        return False
    for dep in raw_deps:
        assert dep[2].var_name is not None
        if var.name in dep[2].var_name and any([n.id == dep[1] for n in tree]):
            result = True
            for warDep in war_deps:
                assert warDep[2].var_name is not None
                if (var.name in warDep[2].var_name
                        and any([n.id == dep[1] for n in tree])
                        and dep[2].source == warDep[2].sink):
                    result = False
                    break
    return result or not is_read


def is_read_in_subtree(var: str, rev_raw: Set[Tuple[str, str, Dependency]], tree: List[CUNode]) -> bool:
    """Checks if variable is read in subtree

    :param var: variable name
    :param rev_raw: reversed raw dependencies of the loop
    :param tree: subtree
    :return: true if read in right subtree
    """
    for e in rev_raw:
        if e[2].var_name == var and any([n.id == e[1] for n in tree]):
            return True
    return False


def is_depend_in_out(var: Variable, in_deps: List[Tuple[str, str, Dependency]],
                     out_deps: List[Tuple[str, str, Dependency]]) -> bool:
    """there is an in and out dependency

    :param var: Variable
    :param in_deps: in dependencies
    :param out_deps: out dependencies
    :return: true if dependency is both in and out
    """
    for in_dep in in_deps:
        for out_dep in out_deps:
            if var.name == in_dep[2].var_name and in_dep[2].var_name == out_dep[2].var_name:
                return True
    return False


def is_depend_in_var(var: Variable, in_deps: List[Tuple[str, str, Dependency]],
                     raw_deps_on: Set[Tuple[str, str, Dependency]]) -> bool:
    """Checks if variable is written inside a dependent task and read in current task

    :param var: Variable
    :param in_deps: in dependencies
    :param raw_deps_on: raw dependencies
    :return: true if variable is in dependency
    """
    for in_dep in in_deps:
        if in_dep[2].var_name == var.name and in_dep in raw_deps_on:
            return True
    return False


def is_depend_out_var(var: Variable, reverse_raw_deps_on: Set[Tuple[str, str, Dependency]],
                      out_deps: List[Tuple[str, str, Dependency]]) -> bool:
    """Checks if variable is written inside a current task and read in dependent task

        :param var: Variable
        :param reverse_raw_deps_on: raw dependencies
        :param out_deps: in dependencies
        :return: true if variable is out dependency
        """
    for dep in out_deps:
        if dep[2].var_name == var.name and dep in reverse_raw_deps_on:
            return True
    return False


def is_read_in(var: Variable, raw_deps_on: Set[Tuple[str, str, Dependency]],
               war_deps_on: Set[Tuple[str, str, Dependency]], reverse_raw_deps_on: Set[Tuple[str, str, Dependency]],
               reverse_war_deps_on: Set[Tuple[str, str, Dependency]], tree: List[CUNode]) -> bool:
    """Check all reverse RAW dependencies (since we know that var is written in loop, because
    is_first_written returned true)

    :param var: variable
    :param raw_deps_on: raw dependencies
    :param war_deps_on: war dependencies
    :param reverse_raw_deps_on: reverse raw dependencies
    :param reverse_war_deps_on: reverse war dependencies
    :param tree: nodes of the loop
    :return:
    """
    for dep in raw_deps_on:
        # If there is a reverse raw dependency for var and the sink cu is not part
        # of the loop, then var is read in rst
        if var.name == dep[2].var_name:
            return True
    for dep in war_deps_on:
        if var.name == dep[2].var_name and any([n.id == dep[1] for n in tree]):
            return True
    for dep in reverse_raw_deps_on:
        # If there is a reverse raw dependency for var and the sink cu is not part
        # of the loop, then var is read in rst
        if var.name == dep[2].var_name and any([n.id == dep[1] for n in tree]):
            return True
    for dep in reverse_war_deps_on:
        if var.name == dep[2].var_name:
            return True
    return False


def get_child_loops(pet: PETGraphX, node: CUNode) -> Tuple[List[CUNode], List[CUNode]]:
    """Gets all do-all and reduction subloops

    :param pet: CU graph
    :param node: root node
    :return: list of do-all and list of reduction loop nodes
    """
    do_all = []
    reduction = []

    for child in pet.subtree_of_type(node, NodeType.LOOP):
        if child.do_all:
            do_all.append(child)
        elif child.reduction:
            reduction.append(child)

    for func_child in pet.direct_children_of_type(node, NodeType.FUNC):
        for child in pet.direct_children_of_type(func_child, NodeType.LOOP):
            if child.do_all:
                do_all.append(child)
            elif child.reduction:
                reduction.append(child)

    return do_all, reduction


def classify_loop_variables(pet: PETGraphX, loop: CUNode) -> Tuple[List[Variable], List[Variable], List[Variable],
                                                                   List[Variable], List[Variable]]:
    """Classifies variables inside the loop

    :param pet: CU graph
    :param loop: loop node
    :return: first_private, private, last_private, shared, reduction
    """
    first_private = []
    private = []
    last_private = []
    shared = []
    reduction = []

    lst = pet.get_left_right_subtree(loop, False)
    rst = pet.get_left_right_subtree(loop, True)
    sub = pet.subtree_of_type(loop, NodeType.CU)

    variables = __get_variables(sub)

    raw = set()
    war = set()
    waw = set()
    rev_raw = set()

    for sub_node in sub:
        raw.update(__get_dep_of_type(pet, sub_node, DepType.RAW, False))
        war.update(__get_dep_of_type(pet, sub_node, DepType.WAR, False))
        waw.update(__get_dep_of_type(pet, sub_node, DepType.WAW, False))
        rev_raw.update(__get_dep_of_type(pet, sub_node, DepType.RAW, True))

    for var in variables:
        if is_loop_index2(pet, loop, var.name):
            private.append(var)
        elif loop.reduction and pet.is_reduction_var(loop.start_position(), var.name):
            var.operation = pet.get_reduction_sign(loop.start_position(), var.name)
            reduction.append(var)
            # TODO grouping
        elif (is_written_in_subtree(var.name, raw, waw, lst) or is_func_arg(pet, var.name, loop)
              and is_scalar_val(var)) and is_readonly(var.name, war, waw, rev_raw):
            if is_global(var.name, sub):
                private.append(var)
            else:
                first_private.append(var)
        elif is_first_written(var.name, raw, war, sub):
            # TODO simplify
            if is_read_in_subtree(var.name, rev_raw, rst):
                if is_scalar_val(var):
                    last_private.append(var)
                else:
                    shared.append(var)
            else:
                if is_scalar_val(var):
                    private.append(var)
                else:
                    shared.append(var)

    return first_private, private, last_private, shared, reduction


def classify_task_vars(pet: PETGraphX, task: CUNode, type: str, in_deps: List[Tuple[str, str, Dependency]],
                       out_deps: List[Tuple[str, str, Dependency]]):
    """Classify task variables

    :param pet: CU graph
    :param task: node
    :param type: type of task
    :param in_deps: in dependencies
    :param out_deps: out dependencies
    """
    first_private: List[Variable] = []
    private: List[Variable] = []
    shared: List[Variable] = []
    depend_in: List[Variable] = []
    depend_out: List[Variable] = []
    depend_in_out: List[Variable] = []
    reduction: List[str] = []

    left_sub_tree = pet.get_left_right_subtree(task, False)
    right_sub_tree = pet.get_left_right_subtree(task, True)
    subtree = pet.subtree_of_type(task, NodeType.CU)
    t_loop = pet.subtree_of_type(task, NodeType.LOOP)

    vars: Set[Variable] = set()
    if task.type == NodeType.FUNC:
        tmp = __get_variables(subtree)
        vars_strings = []
        for v in task.args:
            vars_strings.append(v.name)
        for v in tmp:
            # None may occur because __get_variables doesn't check for actual elements
            if v.name is None:
                continue

            if "." in v.name:
                name = v.name[0: v.name.index(".")]  # substring before '.'
            else:
                name = v.name

            if name in vars_strings:
                vars.add(v)
    else:
        vars = __get_variables(pet.subtree_of_type(task, NodeType.CU))

    raw_deps_on = set()  # set<Dependence>
    war_deps_on = set()
    waw_deps_on = set()

    reverse_raw_deps_on = set()
    reverse_war_deps_on = set()
    reverse_waw_deps_on = set()
    # init = []  # set<String>

    for sub_node in subtree:
        # insert all entries from child_cu.RAW_deps_on into RAW_deps_on etc.
        raw_deps_on.update(__get_dep_of_type(pet, sub_node, DepType.RAW, False))
        war_deps_on.update(__get_dep_of_type(pet, sub_node, DepType.WAR, False))
        waw_deps_on.update(__get_dep_of_type(pet, sub_node, DepType.WAW, False))

        reverse_raw_deps_on.update(__get_dep_of_type(pet, sub_node, DepType.RAW, True))
        reverse_war_deps_on.update(__get_dep_of_type(pet, sub_node, DepType.WAR, True))
        reverse_waw_deps_on.update(__get_dep_of_type(pet, sub_node, DepType.WAW, True))

    do_all_loops, reduction_loops = get_child_loops(pet, task)
    # reduction_result = ""

    if task.type == NodeType.LOOP:
        if task.reduction:
            reduction_loops.append(task)
        else:
            do_all_loops.append(task)

    loop_nodes = [n for n in t_loop if n.reduction]
    if task.reduction:
        loop_nodes.append(task)

    loops_start_lines = [n.start_position() for n in loop_nodes]
    loop_children = [c for n in loop_nodes for c in pet.direct_children(n)]

    for var in vars:
        var_is_loop_index = False
        # get RAW dependencies for var
        tmp_deps = [dep for dep in raw_deps_on if dep[2].var_name == var.name]
        for edge in tmp_deps:
            if pet.is_loop_index(edge[2].var_name, loops_start_lines, loop_children):
                var_is_loop_index = True
                break
        if var_is_loop_index:
            private.append(var)
        elif (("GeometricDecomposition" in type or "Pipeline" in type)
              and is_reduction_any(loops_start_lines, var.name, pet.reduction_vars)):
            reduction.append(var.name)
        elif is_depend_in_out(var, in_deps, out_deps):
            depend_in_out.append(var)
        elif is_depend_in_var(var, in_deps, raw_deps_on):
            depend_in.append(var)
        elif is_depend_out_var(var, reverse_raw_deps_on, out_deps):
            depend_out.append(var)
        elif ((is_written_in_subtree(var.name, raw_deps_on, waw_deps_on, left_sub_tree) or
               (is_func_arg(pet, var.name, task) and is_scalar_val(var))) and
              is_readonly(var.name, war_deps_on, waw_deps_on, reverse_raw_deps_on)):
            if is_global(var.name, subtree):
                shared.append(var)
            else:
                first_private.append(var)
        elif is_first_written_new(var, raw_deps_on, war_deps_on, reverse_raw_deps_on, reverse_war_deps_on, subtree):
            if is_scalar_val(var):
                if is_read_in(var, raw_deps_on, war_deps_on, reverse_raw_deps_on, reverse_war_deps_on, right_sub_tree):
                    shared.append(var)
                else:
                    private.append(var)
            else:
                shared.append(var)

    return first_private, private, shared, depend_in, depend_out, depend_in_out, reduction
