from typing import Optional, List

from discopop_validation.classes.OmpPragma import OmpPragma
from discopop_validation.data_race_prediction.behavior_modeller.classes.BehaviorModel import BehaviorModel
from discopop_validation.data_race_prediction.parallel_construct_graph.classes.ResultObject import ResultObject
from discopop_validation.data_race_prediction.parallel_construct_graph.classes.PCGraphNode import PCGraphNode


class FunctionNode(PCGraphNode):
    result: Optional[ResultObject]
    pragma: Optional[OmpPragma]
    behavior_models: List[BehaviorModel]
    name: Optional[str]
    file_id: Optional[int]
    start_line: Optional[int]
    end_line: Optional[int]
    pet_cu_id: str

    def __init__(self, node_id, pet_cu_id, pragma=None, name=None, file_id=None, start_line=None, end_line=None):
        super().__init__(node_id, pragma)
        self.name = name
        self.file_id = file_id
        self.start_line = start_line
        self.end_line = end_line
        self.pet_cu_id = pet_cu_id

    def __str__(self):
        return str(self.node_id)

    def get_label(self):
        if self.name is None:
            return "NONAME"
        label = str(self.node_id) + " " + self.name
        if self.file_id is not None and self.start_line is not None and self.end_line is not None:
            label += "\n"
            label += str(self.file_id) + ":" + str(self.start_line) + "-" + str(self.end_line)
        return label

    def get_color(self, mark_data_races: bool):
        color = "violet"
        if mark_data_races:
            if len(self.data_races) > 0:
                color = "red"
        return color

    def get_start_line(self) -> int:
        if self.start_line is not None:
            return self.start_line

    def get_end_line(self) -> int:
        if self.end_line is not None:
            return self.end_line

    def get_file_id(self) -> int:
        if self.file_id is not None:
            return self.file_id