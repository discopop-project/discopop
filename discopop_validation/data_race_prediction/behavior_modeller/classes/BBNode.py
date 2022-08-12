from sys import maxsize

from typing import List, Tuple

from discopop_validation.classes.Configuration import Configuration
from discopop_validation.data_race_prediction.behavior_modeller.classes.Operation import Operation


class BBNode:
    id: int
    operations: List[Operation]
    contained_in_relevant_sections: List[int]
    name: str
    start_pos: Tuple[int, int]
    end_pos: Tuple[int, int]
    file_id: int

    def __init__(self, node_id):
        self.id = node_id
        self.operations = []
        self.contained_in_relevant_sections = []
        self.name = ""
        self.start_pos = (maxsize, maxsize)
        self.end_pos = (-maxsize, -maxsize)
        self.file_id = -1

    def apply_line_mapping_to_operations(self, run_configuration: Configuration):
        for op in self.operations:
            replaced_buffer = []
            for key in run_configuration.line_mapping:
                key_file_id = key.split(":")[0]
                key_line_num = key.split(":")[1]
                if key_line_num in replaced_buffer:
                    continue
                if op.file_id == key_file_id:
                    if str(op.line) == key_line_num:
                        # apply mapping
                        op.line = int(run_configuration.line_mapping[key].split(":")[1])
                        replaced_buffer.append(str(op.line))
