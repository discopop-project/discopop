from typing import List

from discopop_validation.data_race_prediction.task_graph.classes.TaskGraphNode import TaskGraphNode


# todo might be removed
class StateSaveNode(TaskGraphNode):

    def get_label(self):
        return "[" + " ".join(self.reset_variables) + "]"

    def get_color(self):
        return "red"

    def compute_result(self):
        """place new entry at the end of saved_states_stack"""
        # todo
        pass

