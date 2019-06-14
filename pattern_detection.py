import numpy as np
from graph_tool.util import find_edge, find_vertex
from graph_tool.spectral import adjacency
from graph_tool.search import dfs_iterator, bfs_iterator
from graph_tool.all import Vertex, Graph
from typing import List
from PETGraph import PETGraph


def find_subNodes(graph: Graph, node: Vertex, criteria: str) -> List[Vertex]:
    return [e.target() for e in node.out_edges() if graph.ep.type[e] == criteria]


class PatternDetector(object):
    pet: PETGraph

    def __init__(self, pet_graph: PETGraph):
        self.pet = pet_graph

    def is_depending(self, v_source: Vertex, v_target: Vertex) -> bool:
        # TODO RAW dependencies are not inherited (13->11 ...)
        children = self.get_all_children(v_target)
        children.append(v_target)

        for e in v_source.out_edges():
            if self.pet.graph.ep.type[e] == 'dependence' and e.target() in children:
                return True
        return False

    def get_all_children(self, root: Vertex) -> List[Vertex]:
        res = []
        for e in root.out_edges():
            if self.pet.graph.ep.type[e] == 'child':
                if self.pet.graph.vp.type[e.target()] == '0':
                    res.append(e.target())
                res.extend(self.get_all_children(e.target()))
        return res

    def is_pipeline_subnode(self, root: Vertex, current: Vertex, children_start_lines: List[str]) -> bool:
        """checks if node is a valid subnode for pipeline
        """
        r_start = self.pet.graph.vp.startsAtLine[root]
        r_end = self.pet.graph.vp.endsAtLine[root]
        c_start = self.pet.graph.vp.startsAtLine[current]
        c_end = self.pet.graph.vp.endsAtLine[current]
        return not (c_start == r_start and c_end == r_start
                    or c_start == r_end and c_end == r_end
                    or c_start == c_end and c_start in children_start_lines)

    def __detect_pipelines(self):
        """Search for pipeline pattern
        """
        for node in find_vertex(self.pet.graph, self.pet.graph.vp.type, '2'):
            self.__detect_pipeline(node)

    def __detect_pipeline(self, root: Vertex) -> None:
        """Calculate pipeline value for node
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
            return

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
        pipeline_scalar_value = np.dot(graph_vector, pipeline_vector) / (np.linalg.norm(graph_vector)
                                                                         * np.linalg.norm(pipeline_vector))
        self.pet.graph.vp.pipeline[root] = pipeline_scalar_value
        print('Pipeline at ', self.pet.graph.vp.id[root])
        print('start: ', self.pet.graph.vp.startsAtLine[root])
        print('end: ', self.pet.graph.vp.endsAtLine[root])
        print('stages: ', len(loop_subnodes))

    def detect_patterns(self):
        self.__detect_pipelines()
