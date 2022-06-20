import random

from discopop_validation.data_race_prediction.parallel_construct_graph.classes.PCGraphNode import PCGraphNode


class ParallelUnit(object):
    identifier: int
    origin_pc_graph_node: PCGraphNode
    visualization_color: str

    def __init__(self, identifier: int, origin: PCGraphNode):
        self.identifier = identifier
        self.origin_pc_graph_node = origin
        # generate random color for the visualization
        self.visualization_color = "#" + ''.join([random.choice('0123456789ABCDEF') for j in range(6)])
        print("\nCOLOR: ", self.visualization_color, " \n")

    def __str__(self):
        return "(" + str(self.identifier) + ",or" + str(self.origin_pc_graph_node.node_id) + ")"

    def __eq__(self, other):
        if str(self) != str(other):
            return False
        return True