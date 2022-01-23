from typing import List


class Operation:
    mode: str
    target_name: str
    target_indices: List[str]
    line: int
    col: int
    # origin line and col will only be different from line / col if Operation occured inside a called function
    origin_line: int
    origin_col: int
    section_id: int
    cu_id: str

    def __init__(self, suggestion_type, cu_id, section_id, mode, target_name, line, col, origin_line, origin_col, target_indices = []):
        self.mode = mode
        self.target_name = target_name
        self.target_indices = target_indices
        self.line = line
        self.col = col
        self.origin_line = origin_line
        self.origin_col = origin_col
        self.section_id = section_id
        self.cu_id = cu_id
        self.suggestion_type = suggestion_type

    def __str__(self):
        if self.mode.startswith("c"):
            pretty_mode = "c" + str(self.mode.count("c")) + self.mode[-1]
        else:
            pretty_mode = self.mode

        # if operation occurs inside called function, report origin line and col additionally
        return_str = "CU(" + str(self.cu_id) + ");" + str(self.section_id) + ";" + str(self.line) + ":" + str(self.col) + ";" + pretty_mode + "->" + self.target_name
        if self.mode.startswith("c"):
            return_str += " Origin: " + str(self.origin_line) + ":" + str(self.origin_col)
        return return_str

    def __eq__(self, other):
        return self.mode == other.mode and \
            self.target_name == other.target_name and \
            self.target_indices == other.target_indices and \
            self.cu_id == other.cu_id

    def get_location_str(self):
        """used to output found data races if requested.
        Format: file_id;line;column"""
        return str(self.cu_id[0:self.cu_id.index(":")]) + ";" + str(self.line) + ";" + str(self.col)

        # todo add file id