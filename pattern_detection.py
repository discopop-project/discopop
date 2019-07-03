import numpy as np
from graph_tool.util import find_edge, find_vertex
from graph_tool.spectral import adjacency
from graph_tool.search import dfs_iterator, bfs_iterator
from graph_tool.all import Vertex, Graph
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

    def is_depending(self, v_source: Vertex, v_target: Vertex) -> bool:
        """Detect if source vertex or one of it's children depends on target vertex or on one of it's children
        """
        children = self.get_all_children(v_target)
        children.append(v_target)

        for dep in self.get_all_dependencies(v_source):
            if dep in children:
                return True
        return False

    def get_all_dependencies(self, node: Vertex) -> List[Vertex]:
        """Returns all data dependencies of the node and it's children
        """
        dep_set = set()
        children = self.get_all_children(node)
        children.append(node)
        for v in children:
            for e in v.out_edges():
                if self.pet.graph.ep.type[e] == 'dependence':
                    dep_set.add(e.target())
        return dep_set

    def get_all_children(self, root: Vertex) -> List[Vertex]:
        """Finds all children of the specified node
        """
        res = []
        for e in root.out_edges():
            if self.pet.graph.ep.type[e] == 'child':
                if self.pet.graph.vp.type[e.target()] == '0':
                    res.append(e.target())
                res.extend(self.get_all_children(e.target()))
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
        # TODO faster iteration necessary?

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

        # TODO backprop RAW dependencies in graph to enable auto matrix calculation
        # print(adjacency(loop_graph).todense())

        graph_vector = []
        for i in range(0, len(loop_subnodes) - 1):
            # Fix: the dependencies of loop-indices can be excluded, if they are read-only in loop body.
            graph_vector.append(1 if self.is_depending(loop_subnodes[i + 1], loop_subnodes[i]) else 0)

        pipeline_vector = []
        for i in range(0, len(loop_subnodes) - 1):
            pipeline_vector.append(1)

        min_weight = 1
        for i in range(0, len(loop_subnodes) - 1):
            for j in range(i + 1, len(loop_subnodes)):
                if self.is_depending(loop_subnodes[i], loop_subnodes[j]):
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

    def detect_patterns(self):
        self.__detect_pipeline_loop()
