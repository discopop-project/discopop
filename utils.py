from typing import List, Set

import numpy as np
from graph_tool.all import Vertex, Graph, Edge


def correlation_coefficient(v1: List[float], v2: List[float]) -> float:
    """ Calculates correlation coefficient as (A dot B) / (norm(A) * norm(B))
    """
    norm_product = np.linalg.norm(v1) * np.linalg.norm(v2)
    return 0 if norm_product == 0 else np.dot(v1, v2) / norm_product


def find_subnodes(graph: Graph, node: Vertex, criteria: str) -> List[Vertex]:
    """ returns direct children of a given node
    """
    return [e.target() for e in node.out_edges() if graph.ep.type[e] == criteria]


def depends(graph: Graph, source, target):
    if source == target:
        return False
    target_nodes = get_subtree_of_type(graph, target, '*')

    for node in get_subtree_of_type(graph, source, '*'):
        for dep in [e.target() for e in node.out_edges() if graph.ep.dtype[e] == 'RAW']:
            if dep in target_nodes:
                return True
    return False


def is_depending(graph: Graph, v_source: Vertex, v_target: Vertex, root_loop: Vertex) -> bool:
    """Detect if source vertex or one of it's children depends on target vertex or on one of it's children
    """
    children = get_subtree_of_type(graph, v_target, '0')
    children.append(v_target)

    for dep in get_all_dependencies(graph, v_source, root_loop):
        if dep in children:
            return True
    return False


def is_loop_index(graph: Graph, e: Edge, loops_start_lines: List[str], children: List[Vertex]) -> bool:
    """Checks, whether the variable is a loop index.
    """

    # TODO check all dependencies necessary?

    # If there is a raw dependency for var, the source cu is part of the loop
    # and the dependency occurs in loop header, then var is loop index+
    return (graph.ep.source[e] == graph.ep.sink[e]
            and graph.ep.source[e] in loops_start_lines
            and e.target() in children)


def is_readonly_inside_loop_body(graph: Graph, dep: Edge, root_loop: Vertex) -> bool:
    """Checks, whether a variable is read only in loop body
    """
    loops_start_lines = [graph.vp.startsAtLine[v]
                         for v in get_subtree_of_type(graph, root_loop, '2')]

    children = get_subtree_of_type(graph, root_loop, '0')

    for v in children:
        for e in v.out_edges():
            # If there is a waw dependency for var, then var is written in loop
            # (sink is always inside loop for waw/war)
            if graph.ep.dtype[e] == 'WAR' or graph.ep.dtype[e] == 'WAW':
                if (graph.ep.var[dep] == graph.ep.var[e]
                        and not (graph.ep.sink[e] in loops_start_lines)):
                    return False
        for e in v.in_edges():
            # If there is a reverse raw dependency for var, then var is written in loop
            # (source is always inside loop for reverse raw)
            if graph.ep.dtype[e] == 'RAW':
                if (graph.ep.var[dep] == graph.ep.var[e]
                        and not (graph.ep.source[e] in loops_start_lines)):
                    return False
    return True


def get_all_dependencies(graph: Graph, node: Vertex, root_loop: Vertex) -> Set[Vertex]:
    """Returns all data dependencies of the node and it's children
    """
    dep_set = set()
    children = get_subtree_of_type(graph, node, '0')

    loops_start_lines = [graph.vp.startsAtLine[v]
                         for v in get_subtree_of_type(graph, root_loop, '2')]

    for v in children:
        for e in v.out_edges():
            if graph.ep.type[e] == 'dependence' and graph.ep.dtype[e] == 'RAW':
                if not (is_loop_index(graph, e, loops_start_lines, get_subtree_of_type(graph, root_loop, '0'))
                        and is_readonly_inside_loop_body(graph, e, root_loop)):
                    dep_set.add(e.target())
    return dep_set


def get_subtree_of_type(graph: Graph, root: Vertex, type: str) -> List[Vertex]:
    """Returns all nodes of a given type from a subtree
    """
    res = []
    if graph.vp.type[root] == type or type == '*':
        res.append(root)

    for e in root.out_edges():
        if graph.ep.type[e] == 'child':
            res.extend(get_subtree_of_type(graph, e.target(), type))
    return res
