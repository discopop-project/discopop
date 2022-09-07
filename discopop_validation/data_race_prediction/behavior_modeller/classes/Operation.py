from typing import List, Tuple

from discopop_validation.data_race_prediction.behavior_modeller.classes.OperationModifierType import \
    OperationModifierType


class Operation:
    mode: str
    target_name: str
    target_indices: List[str]
    line: int
    col: int
    pet_cu_id: str
    # origin line and col will only be different from line / col if Operation occured inside a called function
    origin_line: int
    origin_col: int
    section_id: int
    file_id: str
    modifiers: List[Tuple[OperationModifierType, str]]
    line_mapping_applied = False

    def __init__(self, suggestion_type, file_id, section_id, mode, target_name, line, col, origin_line, origin_col,
                 target_indices=[]):
        self.mode = mode
        self.target_name = target_name
        self.target_indices = target_indices
        self.line = line
        self.col = col
        self.origin_line = origin_line
        self.origin_col = origin_col
        self.section_id = section_id
        self.suggestion_type = suggestion_type
        self.file_id = file_id
        self.modifiers = []
        self.pet_cu_id = ""

    def __str__(self):
        if self.mode.startswith("c"):
            pretty_mode = "c" + str(self.mode.count("c")) + self.mode[-1]
        else:
            pretty_mode = self.mode

        # if operation occurs inside called function, report origin line and col additionally
        return_str = "" + str(self.file_id) + ";" + str(self.section_id) + ";" + str(self.line) + ":" + str(
            self.col) + ";" + pretty_mode + "->" + self.target_name
        if self.mode.startswith("c"):
            return_str += " Origin: " + str(self.origin_line) + ":" + str(self.origin_col)
        if len(self.modifiers) > 0:
            return_str += "\n\tModifiers: " + " ".join([str(m[0]) + "-" + m[1] for m in self.modifiers])
        return return_str

    def __eq__(self, other):
        return self.mode == other.mode and \
               self.target_name == other.target_name and \
               self.target_indices == other.target_indices and \
               self.file_id == other.file_id and \
               self.line == other.line

    def get_target_name_without_fingerprint(self):
        # fingerprint length of 8 characters assumed
        return self.target_name[:-9]

    def get_location_str(self):
        """used to output found data races if requested.
        Format: file_id;line;column"""
        return str(self.file_id) + ";" + str(self.line) + ";" + str(self.col)

    def add_modifier(self, modifier_type: OperationModifierType, value_string: str):
        self.modifiers.append((modifier_type, value_string))
