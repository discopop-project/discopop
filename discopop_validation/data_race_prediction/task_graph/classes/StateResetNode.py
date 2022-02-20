from typing import List

from discopop_validation.data_race_prediction.task_graph.classes.TaskGraphNode import TaskGraphNode


# todo might be removed
class StateResetNode(TaskGraphNode):
    reset_variables: List[str]


    def get_label(self):
        return "[" + " ".join(self.reset_variables) + "]"

    def get_color(self):
        return "red"

    def compute_result(self):
        """reset the specified variables to the last entry in stateSaveStack"""
        # todo
        pass

