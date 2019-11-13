from graph_tool import Vertex

import PETGraph


class PatternInfo(object):
    """Base class for pattern detection info
    """
    node: Vertex
    node_id: str
    start_line: str
    end_line: str

    def __init__(self, pet: PETGraph, node: Vertex):
        """
        :param pet: PET graph
        :param node: node, where pipeline was detected
        """
        self.node = node
        self.node_id = pet.graph.vp.id[node]
        self.start_line = pet.graph.vp.startsAtLine[node]
        self.end_line = pet.graph.vp.endsAtLine[node]
