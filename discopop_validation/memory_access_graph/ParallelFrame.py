from discopop_validation.data_race_prediction.task_graph.classes.TaskGraphNode import TaskGraphNode


class ParallelFrame(object):
    identifier: int
    origin_task_graph_node: TaskGraphNode

    def __init__(self, identifier: int, origin: TaskGraphNode):
        self.identifier = identifier
        self.origin_task_graph_node = origin

    def __str__(self):
        return "(" + str(self.identifier) + ",or" + str(self.origin_task_graph_node.node_id) + ")"
