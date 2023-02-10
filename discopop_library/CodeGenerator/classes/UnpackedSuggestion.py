# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import os
from typing import Tuple, Dict, List

from discopop_library.CodeGenerator.classes.ContentBuffer import ContentBuffer
from discopop_library.CodeGenerator.classes.Enums import (
    PragmaType,
    OmpConstructPositioning,
    PragmaPosition,
)
from discopop_library.CodeGenerator.classes.Pragma import Pragma


class UnpackedSuggestion(object):
    type: str
    values: dict
    file_id: int
    start_line: int
    end_line: int

    def __init__(self, type_str: str, values: dict):
        self.type = type_str
        self.values = values

        # get start and end line of target section
        self.file_id = int(self.values["start_line"].split(":")[0])
        self.start_line = int(self.values["start_line"].split(":")[1])
        self.end_line = int(self.values["end_line"].split(":")[1])

    def __get_do_all_and_reduction_pragmas(self) -> List[Pragma]:
        pragmas = []
        pragma = Pragma()
        pragma.pragma_str = "#pragma omp parallel for "
        if len(self.values["first_private"]) > 0:
            pragma.pragma_str += "firstprivate(" + ",".join(self.values["first_private"]) + ") "
        if len(self.values["private"]) > 0:
            pragma.pragma_str += "private(" + ",".join(self.values["private"]) + ") "
        if len(self.values["last_private"]) > 0:
            pragma.pragma_str += "lastprivate(" + ",".join(self.values["last_private"]) + ") "
        if len(self.values["shared"]) > 0:
            pragma.pragma_str += "shared(" + ",".join(self.values["shared"]) + ") "
        if len(self.values["reduction"]) > 0:
            reductions_dict: Dict[str, List[str]] = dict()
            for entry in self.values["reduction"]:
                red_type: str = entry.split(":")[0]
                var: str = entry.split(":")[1]
                if red_type not in reductions_dict:
                    reductions_dict[red_type] = []
                reductions_dict[red_type].append(var)
            for red_type in reductions_dict:
                pragma.pragma_str += (
                    "reduction(" + red_type + ":" + ",".join(reductions_dict[red_type]) + ") "
                )

        pragma.file_id = self.file_id
        pragma.start_line = self.start_line
        pragma.end_line = self.end_line

        pragmas.append(pragma)
        return pragmas

    def __get_pipeline_pragmas(self) -> List[Pragma]:
        pragmas = []

        for stage in self.values["stages"]:
            pragma = Pragma()
            pragma.file_id = self.file_id
            pragma.start_line = int(stage["startsAtLine"].split(":")[1])
            pragma.end_line = int(stage["endsAtLine"].split(":")[1])
            pragma.pragma_str = "#pragma omp task "
            if len(stage["first_private"]) > 0:
                pragma.pragma_str += "firstprivate(" + ",".join(stage["first_private"]) + ") "
            if len(stage["private"]) > 0:
                pragma.pragma_str += "private(" + ",".join(stage["private"]) + ") "
            if len(stage["shared"]) > 0:
                pragma.pragma_str += "shared(" + ",".join(stage["shared"]) + ") "
            if len(stage["reduction"]) > 0:
                reductions_dict: Dict[str, List[str]] = dict()
                for entry in stage["reduction"]:
                    red_type: str = entry.split(":")[0]
                    var: str = entry.split(":")[1]
                    if red_type not in reductions_dict:
                        reductions_dict[red_type] = []
                    reductions_dict[red_type].append(var)
                for red_type in reductions_dict:
                    pragma.pragma_str += (
                        "reduction(" + red_type + ":" + ",".join(reductions_dict[red_type]) + ") "
                    )
            if len(stage["in_deps"]) > 0:
                pragma.pragma_str += "depends(in:" + ",".join(stage["in_deps"]) + ") "
            if len(stage["out_deps"]) > 0:
                pragma.pragma_str += "depends(out:" + ",".join(stage["out_deps"]) + ") "
            if len(stage["in_out_deps"]) > 0:
                pragma.pragma_str += "depends(inout:" + ",".join(stage["in_out_deps"]) + ") "
            pragmas.append(pragma)
        return pragmas

    def __get_simple_gpu_pragmas(
        self,
        region_start,
        region_end,
        contained_loops,
        map_to_vars,
        map_from_vars,
        map_to_from_vars,
        map_alloc_vars,
        map_delete_vars,
        consumed_vars,
        produced_vars,
        indentation: int = 0,
        ignore_mapping_clauses: bool = False,
    ) -> List[Pragma]:
        pragmas = []

        region_start_line = int(region_start.split(":")[1])
        region_end_line = int(region_end.split(":")[1])
        for loop in contained_loops:
            loop_start = loop["start_line"]
            loop_start_line = int(loop_start.split(":")[1])
            loop_end = loop["end_line"]
            loop_end_line = int(loop_end.split(":")[1])
            for construct in loop["constructs"]:
                construct_start = construct["line"]
                construct_start_line = int(construct_start.split(":")[1])
                pragma = Pragma()
                pragma.pragma_str = construct["name"] + " "
                if loop["collapse"] > 1:
                    pragma.pragma_str += "collapse(" + str(loop["collapse"]) + ") "
                for clause in construct["clauses"]:
                    if ignore_mapping_clauses:
                        if clause.startswith("map("):
                            continue
                    pragma.pragma_str += clause + " "
                # determine start_line and end_line
                if construct_start_line == loop_start_line:
                    # if construct targets loop, use loop scope
                    start_line = loop_start_line
                    end_line = loop_end_line
                elif loop_start_line <= construct_start_line <= loop_end_line:
                    # if construct is inside loop scope, start at construct line and end at loop scope
                    # (should not be used currently)
                    start_line = construct_start_line
                    end_line = loop_end_line
                else:
                    # else, use construct line
                    start_line = construct_start_line
                    end_line = construct_start_line
                # determine positioning of the pragma
                if construct["positioning"] == OmpConstructPositioning.BEFORE_LINE:
                    pragma.pragma_position = PragmaPosition.BEFORE_START
                elif construct["positioning"] == OmpConstructPositioning.AFTER_LINE:
                    pragma.pragma_position = PragmaPosition.AFTER_START
                else:
                    raise ValueError(
                        "Unsupported positioning information: ", construct["positioning"]
                    )
                # create pragma for visualization
                pragma.start_line = start_line
                pragma.end_line = end_line
                pragma.file_id = self.file_id
                pragmas.append(pragma)

        return pragmas

    def get_pragmas(self) -> List[Pragma]:
        """returns a list of source code lines and pragmas to be inserted into the code preview"""
        pragmas = []
        if self.type == "do_all" or self.type == "reduction":
            pragmas += self.__get_do_all_and_reduction_pragmas()
            return pragmas
        elif self.type == "pipeline":
            pragmas += self.__get_pipeline_pragmas()
        elif self.type == "simple_gpu":
            pragmas += self.__get_simple_gpu_pragmas(
                self.values["start_line"],
                self.values["end_line"],
                self.values["contained_loops"],
                self.values["map_to_vars"],
                self.values["map_from_vars"],
                self.values["map_to_from_vars"],
                self.values["map_alloc_vars"],
                self.values["map_delete_vars"],
                self.values["consumed_vars"],
                self.values["produced_vars"],
            )
        else:
            pragma = Pragma()
            pragma.file_id = self.file_id
            pragma.start_line = self.start_line
            pragma.end_line = self.end_line
            pragma.pragma_str = "#CURRENTLY UNSUPPORTED PREVIEW FOR TYPE: " + self.type
            pragmas.append(pragma)
        return pragmas
