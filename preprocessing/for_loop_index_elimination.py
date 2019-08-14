import numpy as np
from graph_tool.util import find_vertex
from graph_tool.all import Vertex, Graph, Edge
from typing import List
from PETGraph import PETGraph

# TODO util class
def is_loop_index(self, e: Edge, loops_start_lines: List[str], children: List[Vertex]) -> bool:
    """Checks, whether the variable is a loop index.
    """

    # TODO check all dependencies necessary?

    # If there is a raw dependency for var, the source cu is part of the loop
    # and the dependency occurs in loop header, then var is loop index+
    return (self.pet.graph.ep.source[e] == self.pet.graph.ep.sink[e]
            and self.pet.graph.ep.source[e] in loops_start_lines
            and e.target() in children)


def is_readonly_inside_loop_body(self, dep: Edge, root_loop: Vertex) -> bool:
    """Checks, whether a variable is read only in loop body
    """
    loops_start_lines = [self.pet.graph.vp.startsAtLine[v]
                         for v in self.get_subtree_of_type(root_loop, '2')]

    children = self.get_subtree_of_type(root_loop, '0')

    for v in children:
        for e in v.out_edges():
            # If there is a waw dependency for var, then var is written in loop
            # (sink is always inside loop for waw/war)
            if self.pet.graph.ep.dtype[e] == 'WAR' or self.pet.graph.ep.dtype[e] == 'WAW':
                if (self.pet.graph.ep.var[dep] == self.pet.graph.ep.var[e]
                        and not (self.pet.graph.ep.sink[e] in loops_start_lines)):
                    return False
        for e in v.in_edges():
            # If there is a reverse raw dependency for var, then var is written in loop
            # (source is always inside loop for reverse raw)
            if self.pet.graph.ep.dtype[e] == 'RAW':
                if (self.pet.graph.ep.var[dep] == self.pet.graph.ep.var[e]
                        and not (self.pet.graph.ep.source[e] in loops_start_lines)):
                    return False
    return True


def get_all_dependencies(self, node: Vertex, root_loop: Vertex) -> List[Vertex]:
    """Returns all data dependencies of the node and it's children
    """
    dep_set = set()
    children = self.get_subtree_of_type(node, '0')

    loops_start_lines = [self.pet.graph.vp.startsAtLine[v]
                         for v in self.get_subtree_of_type(root_loop, '2')]

    for v in children:
        for e in v.out_edges():
            if self.pet.graph.ep.type[e] == 'dependence' and self.pet.graph.ep.dtype[e] == 'RAW':
                if not (self.is_loop_index(e, loops_start_lines, self.get_subtree_of_type(root_loop, '0'))
                        and self.is_readonly_inside_loop_body(e, root_loop)):
                    dep_set.add(e.target())
    return dep_set

def run(pet):
    for node in find_vertex(pet.graph, pet.graph.vp.type, '2'):
        pass
    return pet
