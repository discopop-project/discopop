from enum import IntEnum
import typing
import re
from typing import List

class PragmaType(IntEnum):
    PARALLEL_FOR = 1
    PARALLEL = 2
    SINGLE = 3
    BARRIER = 4
    TASK = 5
    TASKWAIT = 6
    FOR = 7



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
        if self.pragma.startswith("parallel for"):
            return PragmaType.PARALLEL_FOR
        if self.pragma.startswith("parallel"):
            return PragmaType.PARALLEL
        if self.pragma.startswith("single"):
            return PragmaType.SINGLE
        if self.pragma.startswith("barrier"):
            return PragmaType.BARRIER
        if self.pragma.startswith("taskwait"):
            return PragmaType.TASKWAIT
        if self.pragma.startswith("task"):
            return PragmaType.TASK
        if self.pragma.startswith("for"):
            return PragmaType.FOR
        raise ValueError("Unsupported pragma-type:", self.pragma)

    def get_known_variables(self) -> List[str]:
        known_vars: List[str] = []
        known_vars += self.get_variables_listed_as("firstprivate")
        known_vars += self.get_variables_listed_as("private")
        known_vars += self.get_variables_listed_as("lastprivate")
        known_vars += self.get_variables_listed_as("shared")
        known_vars = list(dict.fromkeys(known_vars))
        return known_vars

    def get_variables_listed_as(self, type: str) -> List[str]:
        """possible types: firstprivate, private, shared, reduction"""
        listed_vars: List[str] = []
        found_strings =  [x.group() for x in re.finditer(r' ' + type + '\s*\([\w\s\,\:\+\-\*\&\|\^\.]*\)', self.pragma)]
        for found_str in found_strings:
            # separate treatment of reduction clauses required, since operations and ':' need to be removed
            if type == "reduction":
                inner_str = found_str[found_str.index("(") + 1:found_str.index(")")]
                # remove whitespaces
                inner_str = inner_str.replace(" ", "")
                # since only variable names are needed, operations and : can be removed
                inner_str = inner_str.replace(":","").replace("+","").replace("-","").replace("*","").replace("&","")
                inner_str = inner_str.replace("|", "").replace("^", "")
                # split on ,
                tmp_vars = inner_str.split(",")
            else:
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

    def apply_preprocessing(self):
        # if a variable is used in an reduction clause, make sure it is shared
        original_shared_vars = self.get_variables_listed_as("shared")
        vars_to_add: List[str] = []
        for reduction_var in self.get_variables_listed_as("reduction"):
            if not reduction_var in original_shared_vars:
                vars_to_add.append(reduction_var)
        for var in vars_to_add:
            self.add_to_shared(var)

    def add_to_shared(self, var_name: str):
        if " shared(" in self.pragma:
            split_pragma = self.pragma.split(" shared(")
            self.pragma = split_pragma[0] + " shared(" + var_name + "," + split_pragma[1]
        else:
            self.pragma += " shared(" + var_name + ")"

