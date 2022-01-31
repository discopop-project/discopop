from enum import IntEnum
import typing
import re
from typing import List

class PragmaType(IntEnum):
    PARALLEL_FOR = 1


class OmpPragma(object):
    file_id: int
    start_line: int
    end_line: int
    pragma: str

    def __init__(self, pragma_line):
        # unpack raw pragma line
        split_pragma_line = pragma_line.split(";")
        self.file_id = int(split_pragma_line[0])
        self.start_line = int(split_pragma_line[1])
        self.end_line = int(split_pragma_line[2])
        self.pragma = split_pragma_line[3]

    def __str__(self):
        return "" + str(self.file_id) + " : " + str(self.start_line) + "-" + str(self.end_line) + " : " + self.pragma

    def get_type(self):
        if self.pragma.startswith("parallel for "):
            return PragmaType.PARALLEL_FOR
        raise ValueError("Unsupported pragma-type:", self.pragma)

    def get_shared_variables(self) -> List[str]:
        shared_vars: List[str] = []
        shared_strings =  [x.group() for x in re.finditer(r'shared\(\w*(\,\s*\w*)*\)', self.pragma)]
        for shared_str in shared_strings:
            tmp_vars = shared_str[shared_str.index("(")+1:shared_str.index(")")].split(",")
            # clean up and  add to shared_vars
            for var in tmp_vars:
                while var.startswith(" "):
                    var = var[1:]
                while var.endswith(" "):
                    var = var[:-1]
                shared_vars.append(var)
        return shared_vars