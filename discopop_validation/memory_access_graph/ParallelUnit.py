from discopop_validation.data_race_prediction.parallel_construct_graph.classes.PCGraphNode import PCGraphNode


class ParallelUnit(object):
    identifier: int
    origin_pc_graph_node: PCGraphNode

    def __init__(self, identifier: int, origin: PCGraphNode):
        self.identifier = identifier
        self.origin_pc_graph_node = origin

    def __str__(self):
        return "(" + str(self.identifier) + ",or" + str(self.origin_pc_graph_node.node_id) + ")"
