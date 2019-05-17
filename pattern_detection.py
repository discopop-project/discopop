import numpy as np
from graph_tool.util import find_edge, find_vertex
from graph_tool.spectral import adjacency
from graph_tool.search import dfs_iterator

def find_subNodes(graph, node, criteria):
    subNodes = []
    for relevant_edge in graph.get_out_edges(node):
        if graph.ep.type[graph.edge(relevant_edge[0], relevant_edge[1])] == criteria:
            subNodes.append(relevant_edge[1])
    return subNodes

class PatternDetector(object):
    def __init__(self, pet_graph):
        self.pet = pet_graph

    def __detect_pipeline(self):
        for loop_node in find_vertex(self.pet.graph, self.pet.graph.vp.type, '2'):
            loop_subnodes = []
            for v in find_subNodes(self.pet.graph, loop_node, 'child'):
                node = self.pet.graph.vertex(v)
                if self.pet.graph.vp.startsAtLine[node] == self.pet.graph.vp.startsAtLine[loop_node] and self.pet.graph.vp.endsAtLine[node] == self.pet.graph.vp.startsAtLine[loop_node]:
                    continue
                if self.pet.graph.vp.startsAtLine[node] == self.pet.graph.vp.endsAtLine[loop_node] and self.pet.graph.vp.endsAtLine[node] == self.pet.graph.vp.endsAtLine[loop_node]:
                    continue
                ### TODO: Try to add 3rd check for checking if the startline is in startline of child loops
                loop_subnodes.append(node)

            if len(loop_subnodes) < 2: # No chain of stages found
                return

            # Create graph view for the loop region CUs and then get its adjacency matrix
            loop_graph = self.pet.filter_view(loop_subnodes, 'dependence')
            print(adjacency(loop_graph).todense())
            # self.pet.visualize(loop_graph)
            # create graph vector

            # create pipeline pattern vector

            #



    def detect_patterns(self):
        self.__detect_pipeline()

