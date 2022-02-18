from discopop_validation.classes.Configuration import Configuration
from discopop_validation.data_race_prediction.target_code_sections.extraction import \
    identify_target_sections_from_pragma
from discopop_validation.data_race_prediction.task_graph.classes.TaskGraphNodeResult import TaskGraphNodeResult


class TaskGraphNode(object):
    node_id: int
    result: TaskGraphNodeResult

    def __init__(self, node_id):
        self.node_id = node_id
        self.result = None
        self.pragma = None

    def get_label(self):
        return "TGN"

    def get_color(self):
        return "green"

    def compute_result(self, task_graph):
        print("COMPUTING: ", self.node_id)
        predecessor_edges = list(task_graph.graph.in_edges(self.node_id))
        #if single predecessor exists, relay result of previous node
        if len(predecessor_edges) == 1:
            predecessor, _ = predecessor_edges[0]
            self.result = task_graph.graph.nodes[predecessor]["data"].result
            print("relayed result.")
        #if multiple predecessors exist, relay combination of results of previous nodes
        elif len(predecessor_edges) > 1:
            self.result = TaskGraphNodeResult()
            for pred, _ in predecessor_edges:
                self.result.combine(task_graph.graph.nodes[pred]["data"].result)
            print("combined results.")
        #if no predecessor exists, create empty TaskGraphNodeResult
        else:
            self.result = TaskGraphNodeResult()
            print("created new TGNR")

        # perform node-specific computation
        self.__node_specific_result_computation()

        # trigger result computation for each successor node
        for _, successor in task_graph.graph.out_edges(self.node_id):
            print("succ: ", successor)
            task_graph.graph.nodes[successor]["data"].compute_result(task_graph)

    def insert_behavior_model(self, run_configuration: Configuration):
        if self.pragma is None:
            return
        self.pragma.apply_preprocessing()
        if run_configuration.verbose_mode:
            print("identify target code sections...")
        target_code_sections = identify_target_sections_from_pragma(self.pragma)

        # todo current


    def __node_specific_result_computation(self):
        # This generic node does not perform any specific computations.
        # needs to be implemented in each node class
        return