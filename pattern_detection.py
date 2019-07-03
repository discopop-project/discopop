import numpy as np
from graph_tool.util import find_vertex
from graph_tool.all import Vertex, Graph, Edge
from typing import List
from PETGraph import PETGraph


def find_subNodes(graph: Graph, node: Vertex, criteria: str) -> List[Vertex]:
    """ returns direct children of a given node
    """
    return [e.target() for e in node.out_edges() if graph.ep.type[e] == criteria]


def correlation_coefficient(v1: List[float], v2: List[float]) -> float:
    """ Calculates correlation coefficient as (A dot B) / (norm(A) * norm(B))
    """
    return np.dot(v1, v2) / (np.linalg.norm(v1) * np.linalg.norm(v2))


class PatternDetector(object):
    pet: PETGraph

    def __init__(self, pet_graph: PETGraph):
        self.pet = pet_graph

    def is_depending(self, v_source: Vertex, v_target: Vertex, root_loop: Vertex) -> bool:
        """Detect if source vertex or one of it's children depends on target vertex or on one of it's children
        """
        children = self.get_subtree_of_type(v_target, '0')
        children.append(v_target)

        for dep in self.get_all_dependencies(v_source, root_loop):
            if dep in children:
                return True
        return False

    def is_loop_index(self, e: Edge, loops_start_lines: List[str], children: List[Vertex]) -> bool:
        """Checks if dependency is a loop index
        """

        # TODO check all dependencies necessary?
        return (self.pet.graph.ep.source[e] == self.pet.graph.ep.sink[e]
                and self.pet.graph.ep.source[e] in loops_start_lines
                and e.target() in children)

    def get_all_dependencies(self, node: Vertex, root_loop: Vertex) -> List[Vertex]:
        """Returns all data dependencies of the node and it's children
        """
        dep_set = set()
        children = self.get_subtree_of_type(node, '0')
        children.append(node)

        loops_start_lines = [self.pet.graph.vp.startsAtLine[v]
                             for v in self.get_subtree_of_type(root_loop, '2')]

        for v in children:
            for e in v.out_edges():
                if self.pet.graph.ep.type[e] == 'dependence':
                    if not (self.is_loop_index(e, loops_start_lines, self.get_subtree_of_type(root_loop, '0'))):
                        dep_set.add(e.target())
        return dep_set

    def get_subtree_of_type(self, root: Vertex, type: str) -> List[Vertex]:
        """Returns all nodes of a given type from a subtree
        """
        res = []
        if self.pet.graph.vp.type[root] == type:
            res.append(root)

        for e in root.out_edges():
            if self.pet.graph.ep.type[e] == 'child':
                res.extend(self.get_subtree_of_type(e.target(), type))
        return res

    def is_pipeline_subnode(self, root: Vertex, current: Vertex, children_start_lines: List[str]) -> bool:
        """Checks if node is a valid subnode for pipeline
        """
        r_start = self.pet.graph.vp.startsAtLine[root]
        r_end = self.pet.graph.vp.endsAtLine[root]
        c_start = self.pet.graph.vp.startsAtLine[current]
        c_end = self.pet.graph.vp.endsAtLine[current]
        return not (c_start == r_start and c_end == r_start
                    or c_start == r_end and c_end == r_end
                    or c_start == c_end and c_start in children_start_lines)

    def __detect_pipeline_loop(self):
        """Search pipeline pattern on all the loops within the application
        """
        for node in find_vertex(self.pet.graph, self.pet.graph.vp.type, '2'):
            self.pet.graph.vp.pipeline[node] = self.__detect_pipeline(node)
            if self.pet.graph.vp.pipeline[node] > 0:
                print('Pipeline at ', self.pet.graph.vp.id[node])
                print('start: ', self.pet.graph.vp.startsAtLine[node])
                print('end: ', self.pet.graph.vp.endsAtLine[node])

    def __detect_pipeline(self, root: Vertex) -> float:
        """Calculate pipeline value for node. Returns pipeline scalar value
        """

        # TODO how deep
        children_start_lines = [self.pet.graph.vp.startsAtLine[v]
                                for v in find_subNodes(self.pet.graph, root, 'child')
                                if self.pet.graph.vp.type[v] == '2']

        loop_subnodes = [v for v in find_subNodes(self.pet.graph, root, 'child')
                         if self.is_pipeline_subnode(root, v, children_start_lines)]

        # No chain of stages found
        if len(loop_subnodes) < 2:
            self.pet.graph.vp.pipeline[root] = -1
            return 0

        graph_vector = []
        for i in range(0, len(loop_subnodes) - 1):
            graph_vector.append(1 if self.is_depending(loop_subnodes[i + 1], loop_subnodes[i], root) else 0)

        pipeline_vector = []
        for i in range(0, len(loop_subnodes) - 1):
            pipeline_vector.append(1)

        min_weight = 1
        for i in range(0, len(loop_subnodes) - 1):
            for j in range(i + 1, len(loop_subnodes)):
                if self.is_depending(loop_subnodes[i], loop_subnodes[j], root):
                    # TODO whose corresponding entry in the graph matrix is nonzero?
                    node_weight = 1 - (j - i) / (len(loop_subnodes) - 1)
                    if min_weight > node_weight > 0:
                        min_weight = node_weight

        if min_weight == 1:
            graph_vector.append(0)
            pipeline_vector.append(0)
        else:
            graph_vector.append(1)
            pipeline_vector.append(min_weight)
        return correlation_coefficient(graph_vector, pipeline_vector)

    def __detect_do_all_loop(self):
        """Search for do_loop pattern
        """
        for node in find_vertex(self.pet.graph, self.pet.graph.vp.type, '2'):
            val = self.__detect_do_all(node)
            if val > 0:
                self.pet.graph.vp.doAll[node] = val
                print('Do All at ', self.pet.graph.vp.id[node])
                print('Coefficient ', val)

    def __detect_do_all(self, root: Vertex):
        graph_vector = []

        subnodes = find_subNodes(self.pet.graph, root, 'child')

        for i in range(0, len(subnodes)):
            for j in range(i, len(subnodes)):
                if self.is_depending(subnodes[i], subnodes[j], root):
                    graph_vector.append(0)
                else:
                    graph_vector.append(1)

        pattern_vector = [1 for _ in graph_vector]

        if np.linalg.norm(graph_vector) == 0:
            return 0

        return correlation_coefficient(graph_vector, pattern_vector)

    def detect_patterns(self):
        self.__detect_pipeline_loop()
        self.__detect_do_all_loop()
