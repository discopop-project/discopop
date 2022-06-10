from sys import maxsize

from typing import List, Tuple

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
