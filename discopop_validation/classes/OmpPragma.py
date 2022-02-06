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

    def __str__(self):
        return "" + str(self.file_id) + " : " + str(self.start_line) + "-" + str(self.end_line) + " : " + self.pragma

    def init_with_pragma_line(self, pragma_line):
        # unpack raw pragma line
        split_pragma_line = pragma_line.split(";")
        self.file_id = int(split_pragma_line[0])
        self.start_line = int(split_pragma_line[1])
        self.end_line = int(split_pragma_line[2])
        self.pragma = split_pragma_line[3]
        return self

    def init_with_values(self, file_id: str, start_line: str, end_line: str, pragma: str):
        self.file_id = int(file_id)
        self.start_line = int(start_line)
        self.end_line = int(end_line)
        self.pragma = pragma
        return self

    def get_type(self):
        if self.pragma.startswith("parallel for "):
            return PragmaType.PARALLEL_FOR
        raise ValueError("Unsupported pragma-type:", self.pragma)

    def get_variables_listed_as(self, type: str) -> List[str]:
        """possible types: firstprivate, private, shared, reduction"""
        listed_vars: List[str] = []
        found_strings =  [x.group() for x in re.finditer(r' ' + type + '\(\w*(\,\s*\w*)*\)', self.pragma)]
        for found_str in found_strings:
            tmp_vars = found_str[found_str.index("(")+1:found_str.index(")")].split(",")
            # clean up and  add to listed_vars
            for var in tmp_vars:
                while var.startswith(" "):
                    var = var[1:]
                while var.endswith(" "):
                    var = var[:-1]
                if len(var) > 0:
                    listed_vars.append(var)
        return listed_vars
