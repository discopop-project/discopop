from graph_tool import Graph, Vertex


class PatternInfo(object):
    """Base class for pattern detection info
    """
    node: Vertex
    node_id: str
    start_line: str
    end_line: str

    def __init__(self, graph: Graph, node: Vertex):
        """
        :param graph: CU graph
        :param node: node, where pipeline was detected
        """
        self.node = node
        self.node_id = graph.vp.id[node]
        self.start_line = graph.vp.startsAtLine[node]
        self.end_line = graph.vp.endsAtLine[node]
