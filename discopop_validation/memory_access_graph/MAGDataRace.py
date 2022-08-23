from discopop_validation.data_race_prediction.behavior_modeller.classes.Operation import Operation


class MAGDataRace(object):
    parent_node_id: str
    operation_1: Operation
    operation_2: Operation
    is_weak: bool

    def __init__(self, node_id: str, operation_1: Operation, operation_2: Operation, is_weak_data_race: bool):
        self.parent_node_id = node_id
        self.operation_1 = operation_1
        self.operation_2 = operation_2
        self.is_weak = is_weak_data_race

    def __eq__(self, other):
        if self.parent_node_id == other.parent_node_id and \
            self.operation_1 == other.operation_1 and \
            self.operation_2 == other.operation_2 and \
            self.is_weak == other.is_weak:
            return True
        return False