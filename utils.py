import itertools
from typing import List, Set, Dict, Any

import numpy as np
from graph_tool.all import Vertex, Edge
from graph_tool.topology import shortest_path

import PETGraph

loop_data = {}


def correlation_coefficient(v1: List[float], v2: List[float]) -> float:
    """Calculates correlation coefficient as (A dot B) / (norm(A) * norm(B))

    :param v1: first vector
    :param v2: second vector
    :return: correlation coefficient, 0 if one of the norms is 0
    """
    norm_product = np.linalg.norm(v1) * np.linalg.norm(v2)
    return 0 if norm_product == 0 else np.dot(v1, v2) / norm_product


def find_subnodes(pet: PETGraph, node: Vertex, criteria: str) -> List[Vertex]:
    """Returns direct children of a given node

    :param pet: PET graph
    :param node: node
    :param criteria: type of dependency
    :return: list of children nodes
    """
    return [e.target() for e in node.out_edges() if pet.graph.ep.type[e] == criteria]


def depends(pet: PETGraph, source: Vertex, target: Vertex) -> bool:
    """Detects if source node or one of it's children has a RAW dependency to target node or one of it's children

    :param pet: PET graph
    :param source: source node for dependency detection
    :param target: target of dependency
    :return: true, if there is RAW dependency
    """
    if source == target:
        return False
    target_nodes = get_subtree_of_type(pet, target, '*')

    for node in get_subtree_of_type(pet, source, '*'):
        for dep in [e.target() for e in node.out_edges() if pet.graph.ep.dtype[e] == 'RAW']:
            if dep in target_nodes:
                return True
    return False


def depends_ignore_readonly(pet: PETGraph, source: Vertex, target: Vertex, root_loop: Vertex) -> bool:
    """Detects if source node or one of it's children has a RAW dependency to target node or one of it's children
    The loop index and readonly variables are ignored

    :param pet: PET graph
    :param source: source node for dependency detection
    :param target: target of dependency
    :param root_loop: root loop
    :return: true, if there is RAW dependency
    """
    children = get_subtree_of_type(pet, target, 'cu')
    # todo children.append(target)

    for dep in get_all_dependencies(pet, source, root_loop):
        if dep in children:
            return True
    return False


def is_loop_index(pet: PETGraph, edge: Edge, loops_start_lines: List[str], children: List[Vertex]) -> bool:
    """Checks, whether the variable is a loop index.

    :param pet: PET graph
    :param edge: RAW dependency
    :param loops_start_lines: start lines of the loops
    :param children: children nodes of the loops
    :return: true if edge represents loop index
    """

    # If there is a raw dependency for var, the source cu is part of the loop
    # and the dependency occurs in loop header, then var is loop index+

    for c in children:
        for dep in c.out_edges():
            if pet.graph.ep.dtype[dep] == 'RAW' and pet.graph.ep.var[dep] == pet.graph.ep.var[edge]:
                if (pet.graph.ep.source[dep] == pet.graph.ep.sink[dep]
                        and pet.graph.ep.source[dep] in loops_start_lines
                        and dep.target() in children):
                    return True

    return False


def is_readonly_inside_loop_body(pet: PETGraph, dep: Edge, root_loop: Vertex) -> bool:
    """Checks, whether a variable is read-only in loop body

    :param pet: PET graph
    :param dep: dependency variable
    :param root_loop: root loop
    :return: true if variable is read-only in loop body
    """
    loops_start_lines = [pet.graph.vp.startsAtLine[v]
                         for v in get_subtree_of_type(pet, root_loop, 'loop')]

    children = get_subtree_of_type(pet, root_loop, 'cu')

    for v in children:
        for e in v.out_edges():
            # If there is a waw dependency for var, then var is written in loop
            # (sink is always inside loop for waw/war)
            if pet.graph.ep.dtype[e] == 'WAR' or pet.graph.ep.dtype[e] == 'WAW':
                if (pet.graph.ep.var[dep] == pet.graph.ep.var[e]
                        and not (pet.graph.ep.sink[e] in loops_start_lines)):
                    return False
        for e in v.in_edges():
            # If there is a reverse raw dependency for var, then var is written in loop
            # (source is always inside loop for reverse raw)
            if pet.graph.ep.dtype[e] == 'RAW':
                if (pet.graph.ep.var[dep] == pet.graph.ep.var[e]
                        and not (pet.graph.ep.source[e] in loops_start_lines)):
                    return False
    return True


def get_all_dependencies(pet: PETGraph, node: Vertex, root_loop: Vertex) -> Set[Vertex]:
    """Returns all data dependencies of the node and it's children
    This method ignores loop index and read only variables

    :param pet: PET graph
    :param node: node
    :param root_loop: root loop
    :return: list of all RAW dependencies of the node
    """
    dep_set = set()
    children = get_subtree_of_type(pet, node, 'cu')

    loops_start_lines = [pet.graph.vp.startsAtLine[v]
                         for v in get_subtree_of_type(pet, root_loop, 'loop')]
    for v in children:
        for e in v.out_edges():
            if pet.graph.ep.type[e] == 'dependence' and pet.graph.ep.dtype[e] == 'RAW':
                if not (is_loop_index(pet, e, loops_start_lines, get_subtree_of_type(pet, root_loop, 'cu'))
                        and is_readonly_inside_loop_body(pet, e, root_loop)):
                    dep_set.add(e.target())
    return dep_set


# TODO set or list?
def get_subtree_of_type(pet: PETGraph, root: Vertex, node_type: str) -> List[Vertex]:
    """Returns all nodes of a given type from a subtree

    :param pet: PET graph
    :param root: root node
    :param node_type: specific type of nodes or '*' for wildcard
    :return: list of nodes of specified type from subtree
    """
    res = []
    if pet.graph.vp.type[root] == node_type or node_type == '*':
        res.append(root)

    for e in root.out_edges():
        if pet.graph.ep.type[e] == 'child':
            res.extend(get_subtree_of_type(pet, e.target(), node_type))
    return res


def total_instructions_count(pet: PETGraph, root: Vertex) -> int:
    """Calculates total number of the instructions in the subtree of a given node

    :param pet: PET graph
    :param root: root node
    :return: number of instructions
    """
    res = 0
    for node in get_subtree_of_type(pet, root, 'cu'):
        res += pet.graph.vp.instructionsCount[node]
    return res


def calculate_workload(pet: PETGraph, node: Vertex) -> int:
    """Calculates workload for a given node
    The workload is the number of instructions multiplied by respective number of iterations

    :param pet: PET graph
    :param node: root node
    :return: workload
    """
    res = 0
    if pet.graph.vp.type[node] == 'dummy':
        return 0
    elif pet.graph.vp.type[node] == 'cu':
        res += pet.graph.vp.instructionsCount[node]
    elif pet.graph.vp.type[node] == 'func':
        for child in find_subnodes(pet, node, 'child'):
            res += calculate_workload(pet, child)
    elif pet.graph.vp.type[node] == 'loop':
        for child in find_subnodes(pet, node, 'child'):
            if pet.graph.vp.type[child] == 'cu':
                if 'for.inc' in pet.graph.vp.BasicBlockID[child]:
                    res += pet.graph.vp.instructionsCount[child]
                elif 'for.cond' in pet.graph.vp.BasicBlockID[child]:
                    res += pet.graph.vp.instructionsCount[child] * (
                            get_loop_iterations(pet.graph.vp.startsAtLine[node]) + 1)
                else:
                    res += pet.graph.vp.instructionsCount[child] * get_loop_iterations(pet.graph.vp.startsAtLine[node])
            else:
                res += calculate_workload(pet, child) * get_loop_iterations(pet.graph.vp.startsAtLine[node])
    return res


def get_loop_iterations(line: str) -> int:
    """Calculates the number of iterations in specified loop

    :param line: start line of the loop
    """
    return loop_data.get(line, 0)


def classify_loop_variables(pet: PETGraph, loop: Vertex) -> (List[Any], List[Any], List[Any], List[Any], List[Any]):
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

    lst = __get_left_right_subtree(pet, loop, False)
    rst = __get_left_right_subtree(pet, loop, True)
    sub = get_subtree_of_type(pet, loop, 'cu')

    vars_old = __get_variables(pet, sub)

    vars = set(vars_old)

    raw = set()
    war = set()
    waw = set()
    rev_raw = set()

    for sub_node in sub:
        raw.update(__get_dep_of_type(pet, sub_node, 'RAW', False))
        war.update(__get_dep_of_type(pet, sub_node, 'WAR', False))
        waw.update(__get_dep_of_type(pet, sub_node, 'WAW', False))
        rev_raw.update(__get_dep_of_type(pet, sub_node, 'RAW', True))

    for var in vars:
        if is_loop_index2(pet, loop, var.name):
            private.append(var)
        elif pet.graph.vp.reduction[loop] and is_reduction_var(pet.graph.vp.startsAtLine[loop], var.name,
                                                               pet.reduction_vars):
            reduction.append(var)
            # TODO grouping
        elif (is_written_in_lst(pet, var.name, raw, waw, lst) or is_func_arg(pet, var.name, loop)
              and is_scalar_val(var)) and is_readonly(pet, var.name, war, waw, rev_raw):
            if is_global(pet, var.name, sub):
                private.append(var)
            else:
                first_private.append(var)
        elif is_first_written(pet, var.name, raw, war, sub):
            # TODO simplify
            if is_read_in_rst(pet, var.name, rev_raw, rst):
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


def is_loop_index2(pet: PETGraph, root_loop: Vertex, var_name: str) -> bool:
    """Checks, whether the variable is a loop index.

    :param pet: CU graph
    :param root_loop: root loop
    :param var_name: name of the variable
    :return: true if variable is index of the loop
    """
    loops_start_lines = [pet.graph.vp.startsAtLine[v]
                         for v in get_subtree_of_type(pet, root_loop, 'loop')]
    loops_start_lines.append(pet.graph.vp.startsAtLine[root_loop])
    children = get_subtree_of_type(pet, root_loop, 'cu')

    for c in children:
        for dep in c.out_edges():
            if pet.graph.ep.dtype[dep] == 'RAW' and pet.graph.ep.var[dep] == var_name:
                if (pet.graph.ep.source[dep] == pet.graph.ep.sink[dep]
                        and pet.graph.ep.source[dep] in loops_start_lines
                        and dep.target() in children):
                    return True

    return False


def __get_dep_of_type(pet: PETGraph, node: Vertex, dep_type: str, reversed: bool) -> List[Edge]:
    """Searches all dependencies of specified type

    :param pet: CU graph
    :param node: node
    :param dep_type: type of dependency
    :param reversed: if true the it looks for incoming dependencies
    :return: list of dependencies
    """
    return [e for e in (node.in_edges() if reversed else node.out_edges()) if pet.graph.ep.dtype[e] == dep_type]


def __get_left_right_subtree(pet: PETGraph, target: Vertex, right_subtree: bool) -> List[Vertex]:
    """Searches for all subnodes of main which are to the left or to the right of the specified node

    :param pet: CU graph
    :param target: node that devides the tree
    :param right_subtree: true - right subtree, false - left subtree
    :return: list of nodes in the subtree
    """
    stack = [pet.main]
    res = []

    while stack:
        current = stack.pop()

        if current == target:
            return res
        if pet.graph.vp.type[current] == 'cu':
            res.append(current)

        stack.extend(
            find_subnodes(pet, current, 'child') if right_subtree else reversed(find_subnodes(pet, current, 'child')))

    return res


def __get_variables(pet: PETGraph, nodes: List[Vertex]) -> Set[Any]:
    """Gets all variables in nodes

    :param pet: CU graph
    :param nodes: nodes
    :return: Set of variables
    """
    res = set()
    for node in nodes:
        for v in pet.graph.vp.localVars[node]:
            res.add(v)
        for v in pet.graph.vp.globalVars[node]:
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


def is_written_in_lst(pet: PETGraph, var: str, raw: Set[Edge], waw: Set[Edge], lst: List[Vertex]) -> bool:
    """ Checks if variable is written in left subtree

    :param pet: CU graph
    :param var: variable name
    :param raw: raw dependencies of the loop
    :param waw: waw dependencies of the loop
    :param lst: left subtree
    :return: true if is written
    """
    for e in itertools.chain(raw, waw):
        if pet.graph.ep.var[e] == var and e.target() in lst:
            return True
    return False


def is_func_arg(pet: PETGraph, var: str, node: Vertex):
    """Checks if variable is a function argument

    :param pet: CU graph
    :param var: variable name
    :param node: loop node
    :return: true if variable is argument
    """
    if '.' not in var:
        return False

    path = shortest_path(pet.children_graph, pet.main, node)[0]

    for node in reversed(path):
        if pet.graph.vp.type[node] == 'func':
            for arg in pet.graph.vp.args[node]:
                if var.startswith(arg.name):
                    return True

    return False


def is_scalar_val(var):
    """Checks if variable is a scalar value

    :param var: variable
    :return: true if scalar
    """
    return not (var.type.endswith('**') or var.type.startswith('ARRAY' or var.type.startswith('[')))


def is_readonly(pet: PETGraph, var: str, war: Set[Edge], waw: Set[Edge], rev_war: Set[Edge]) -> bool:
    """Checks if variable is readonly

    :param pet: CU graph
    :param var: variable name
    :param war: war dependencies of the loop
    :param waw: waw dependencies of the loop
    :param rev_war: reversed raw dependencies of the loop
    :return: trie if readonly
    """
    for e in itertools.chain(war, waw, rev_war):
        if pet.graph.ep.var[e] == var:
            return False
    return True


def is_global(pet: PETGraph, var: str, tree: List[Vertex]):
    """Checks if variable is global

    :param pet: CU graph
    :param var: variable name
    :param tree:
    :return: true if global
    """
    return False
    # TODO all or local global
    # TODO from tmp global vars
    for node in tree:
        if pet.graph.vp.type[node] == 'cu':
            for gv in pet.graph.vp.globalVars[node]:
                if gv.name == var:
                    return True
    return False


def is_first_written(pet: PETGraph, var: str, raw: Set[Edge], war: Set[Edge], sub: List[Vertex]) -> bool:
    """Checks whether a variable is first written inside the current node

    :param pet: CU graph
    :param var: variable name
    :param raw: raw dependencies of the loop
    :param war: war dependencies of the loop
    :param sub: subtree of the loop
    :return: true if first written
    """
    for e in war:
        if pet.graph.ep.var[e] == var and e.target() in sub:
            res = False
            for eraw in raw:
                if pet.graph.ep.var[eraw] == var and e.target() in sub \
                        and pet.graph.ep.source[e] == pet.graph.ep.sink[eraw]:
                    res = True
                    break
            if not res:
                return False
    return True


def is_read_in_rst(pet: PETGraph, var: str, rev_raw: Set[Edge], rst: List[Vertex]) -> bool:
    """Checks if variable is read in right subtree

    :param pet: CU graph
    :param var: variable name
    :param rev_raw: reversed raw dependencies of the loop
    :param rst: right subtree
    :return: true if read in right subtree
    """
    for e in rev_raw:
        if pet.graph.ep.var[e] == var and e.target() in rst:
            return True
    return False
