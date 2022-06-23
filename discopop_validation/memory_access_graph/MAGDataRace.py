from discopop_validation.data_race_prediction.behavior_modeller.classes.Operation import Operation


class MAGDataRace(object):
    parent_node_id: str
    operation_1: Operation
    operation_2: Operation

    def __init__(self, node_id: str, operation_1: Operation, operation_2: Operation):
        self.parent_node_id = node_id
        self.operation_1 = operation_1
        self.operation_2 = operation_2
