# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import os

import tkinter as tk
from enum import IntEnum
from tkinter import ttk
from typing import List, Tuple

from discopop_explorer.pattern_detectors.combined_gpu_patterns.CombinedGPURegions import UpdateType, EntryPointType, \
    ExitPointType
from discopop_wizard.classes.CodePreview import CodePreview
from discopop_wizard.classes.Pragma import Pragma


class PragmaType(IntEnum):
    PRAGMA = 1
    REGION = 2


class Suggestion(object):
    type: str
    values: dict
    file_id: int
    start_line: int
    end_line: int

    def __init__(self, wizard, type: str, values: dict):
        self.wizard = wizard
        self.type = type
        self.values = values

        # get start and end line of target section
        self.file_id = int(self.values["start_line"].split(":")[0])
        self.start_line = int(self.values["start_line"].split(":")[1])
        self.end_line = int(self.values["end_line"].split(":")[1])

    def show_code_section(self, parent_frame: tk.Frame, execution_configuration):

        # close elements of parent_frame
        for c in parent_frame.winfo_children():
            c.destroy()

        # configure parent_frame
        parent_frame.rowconfigure(0, weight=1)
        parent_frame.columnconfigure(0, weight=1)

        # create content frame and scroll bars
        source_code = tk.Text(parent_frame, wrap=tk.NONE)
        source_code.grid(row=0, column=0, sticky="nsew")

        # create a Scrollbar and associate it with the content frame
        y_scrollbar = ttk.Scrollbar(parent_frame, command=source_code.yview)
        y_scrollbar.grid(row=0, column=1, sticky='nsew')
        source_code['yscrollcommand'] = y_scrollbar.set

        x_scrollbar = ttk.Scrollbar(parent_frame, orient="horizontal", command=source_code.xview)
        x_scrollbar.grid(row=1, column=0, columnspan=2, sticky='nsew')
        source_code['xscrollcommand'] = x_scrollbar.set

        # load file mapping from project path
        file_mapping: dict[int, str] = dict()
        with open(os.path.join(execution_configuration.value_dict["working_copy_path"], "FileMapping.txt"), "r") as f:
            for line in f.readlines():
                line = line.replace("\n", "")
                split_line = line.split("\t")
                id = int(split_line[0])
                path = split_line[1]
                file_mapping[id] = path

        # create CodePreview object
        code_preview = CodePreview(self.wizard, self.file_id, file_mapping[self.file_id])

        # get and insert pragmas
        pragmas = self.__get_pragmas()
        for pragma in pragmas:
            code_preview.add_pragma(pragma, [])

        # show CodePreview
        code_preview.show_in(source_code)

        # show targeted code section
        code_preview.jump_to_first_modification(source_code)

        # disable source code text widget to disallow editing
        source_code.config(state=tk.DISABLED)

    def get_as_button(self, canvas: tk.Canvas, code_preview_frame: tk.Frame, execution_configuration) -> tk.Button:
        return tk.Button(canvas, text=self.type + " @ " + self.values["start_line"],
                         command=lambda: self.show_code_section(code_preview_frame, execution_configuration))

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
            reductions_dict = dict()
            for entry in self.values["reduction"]:
                red_type = entry.split(":")[0]
                var = entry.split(":")[1]
                if red_type not in reductions_dict:
                    reductions_dict[red_type] = []
                reductions_dict[red_type].append(var)
            for red_type in reductions_dict:
                pragma.pragma_str += "reduction(" + red_type + ":" + ",".join(reductions_dict[red_type]) + ") "

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
                reductions_dict = dict()
                for entry in stage["reduction"]:
                    red_type = entry.split(":")[0]
                    var = entry.split(":")[1]
                    if red_type not in reductions_dict:
                        reductions_dict[red_type] = []
                    reductions_dict[red_type].append(var)
                for red_type in reductions_dict:
                    pragma.pragma_str += "reduction(" + red_type + ":" + ",".join(reductions_dict[red_type]) + ") "
            if len(stage["in_deps"]) > 0:
                pragma.pragma_str += "depends(in:" + ",".join(stage["in_deps"]) + ") "
            if len(stage["out_deps"]) > 0:
                pragma.pragma_str += "depends(out:" + ",".join(stage["out_deps"]) + ") "
            if len(stage["in_out_deps"]) > 0:
                pragma.pragma_str += "depends(inout:" + ",".join(stage["in_out_deps"]) + ") "
            pragmas.append(pragma)
        return pragmas

    def __get_simple_gpu_pragmas(self, region_start, region_end, contained_loops, map_to_vars, map_from_vars,
                                 map_to_from_vars, map_alloc_vars, map_delete_vars, consumed_vars, produced_vars,
                                 indentation: int = 0, ignore_mapping_clauses: bool = False
                                 ) -> List[Tuple[int, int, str, PragmaType, int]]:
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
                # create pragma for visualization
                pragma.start_line = start_line
                pragma.end_line = end_line
                pragma.file_id = self.file_id
                pragmas.append(pragma)

        return pragmas

    def __get_update_pragmas(self, update_instructions) -> List[Pragma]:
        pragmas = []
        for source_cu_id, sink_cu_id, update_type, target_var, pragma_line in update_instructions:
            pragma = Pragma()
            pragma.pragma_str = "#pragma omp target update "

            if update_type == UpdateType.TO_DEVICE:
                pragma.pragma_str += "to("
            elif update_type == UpdateType.FROM_DEVICE:
                pragma.pragma_str += "from("
            else:
                raise ValueError("Unsupported update type: ", update_type)
            pragma.pragma_str += target_var + ") "
            pragma_line_num = int(pragma_line.split(":")[1])
            pragma.start_line = pragma_line_num
            pragma.end_line = pragma_line_num
            pragma.file_id = self.file_id
            pragmas.append(pragma)
        return pragmas

    def __get_data_region_dependencies(self, depend_in, depend_out) -> List[Pragma]:
        pragmas = []
        for var_name, cu_id, pragma_line in depend_in:
            pragma = Pragma()
            pragma.pragma_str = "#depend in(" + var_name + ")"
            pragma_line_num = int(pragma_line.split(":")[1])
            pragma.start_line = pragma_line_num
            pragma.end_line = pragma_line_num
            pragma.file_id = self.file_id
            pragmas.append(pragma)

        for var_name, cu_id, pragma_line in depend_out:
            pragma = Pragma()
            pragma.pragma_str = "#depend out(" + var_name + ")"
            pragma_line_num = int(pragma_line.split(":")[1])
            pragma.start_line = pragma_line_num
            pragma.end_line = pragma_line_num
            pragma.file_id = self.file_id
            pragmas.append(pragma)

        return pragmas

    def __get_data_region_pragmas(self, entry_points, exit_points) -> List[Pragma]:
        pragmas = []
        for var_name, cu_id, entry_point_type, pragma_line in entry_points:
            pragma = Pragma()
            pragma.pragma_str = "#enter data "
            if entry_point_type == EntryPointType.TO_DEVICE:
                pragma.pragma_str += "to("
            elif entry_point_type == EntryPointType.ALLOCATE:
                pragma.pragma_str += "alloc("
            elif entry_point_type == EntryPointType.ASYNC_TO_DEVICE:
                pragma.pragma_str += "async to("
            elif entry_point_type == EntryPointType.ASYNC_ALLOCATE:
                pragma.pragma_str += "async alloc("
            else:
                raise ValueError("Usupported EntryPointType: ", entry_point_type)
            pragma.pragma_str += var_name + ") "
            pragma_line_num = int(pragma_line.split(":")[1])
            pragma.start_line = pragma_line_num
            pragma.end_line = pragma_line_num
            pragma.file_id = self.file_id
            pragmas.append(pragma)

        for var_name, cu_id, exit_point_type, pragma_line in exit_points:
            pragma = Pragma()
            pragma.pragma_str = "#exit data "
            if exit_point_type == ExitPointType.FROM_DEVICE:
                pragma.pragma_str += "from("
            elif exit_point_type == ExitPointType.DELETE:
                pragma.pragma_str += "delete("
            elif exit_point_type == ExitPointType.ASYNC_FROM_DEVICE:
                pragma.pragma_str += "async from("
            else:
                raise ValueError("Usupported ExitPointType: ", exit_point_type)
            pragma.pragma_str += var_name + ") "
            pragma_line_num = int(pragma_line.split(":")[1])
            pragma.start_line = pragma_line_num
            pragma.end_line = pragma_line_num
            pragma.file_id = self.file_id
            pragmas.append(pragma)
        return pragmas

    def __get_combined_gpu_pragmas(self) -> List[Pragma]:
        pragmas = []
        # add async data movement
        pragmas += self.__get_data_region_pragmas(self.values["data_region_entry_points"],
                                                  self.values["data_region_exit_points"])
        # add dependencies
        pragmas += self.__get_data_region_dependencies(self.values["data_region_depend_in"], self.values["data_region_depend_out"])

        # add gpu loops
        for region in self.values["contained_regions"]:
            pragmas += self.__get_simple_gpu_pragmas(region["start_line"], region["end_line"],
                                                     region["contained_loops"],
                                                     region["map_to_vars"], region["map_from_vars"],
                                                     region["map_to_from_vars"],
                                                     region["map_alloc_vars"], region["map_delete_vars"],
                                                     region["consumed_vars"], region["produced_vars"], indentation=0, ignore_mapping_clauses=True)
        # add update instructions to pragmas
        pragmas += self.__get_update_pragmas(self.values["update_instructions"])

        return pragmas

    def __get_pragmas(self) -> List[Pragma]:
        """returns a list of source code lines and pragmas to be inserted into the code preview"""
        pragmas = []
        if self.type == "do_all" or self.type == "reduction":
            pragmas += self.__get_do_all_and_reduction_pragmas()
            return pragmas
        elif self.type == "pipeline":
            pragmas += self.__get_pipeline_pragmas()
        elif self.type == "simple_gpu":
            pragmas += self.__get_simple_gpu_pragmas(self.values["start_line"], self.values["end_line"],
                                                     self.values["contained_loops"],
                                                     self.values["map_to_vars"], self.values["map_from_vars"],
                                                     self.values["map_to_from_vars"],
                                                     self.values["map_alloc_vars"], self.values["map_delete_vars"],
                                                     self.values["consumed_vars"], self.values["produced_vars"]
                                                     )
        elif self.type == "combined_gpu":
            pragmas += self.__get_combined_gpu_pragmas()
        else:
            pragma = Pragma()
            pragma.file_id = self.file_id
            pragma.start_line = self.start_line
            pragma.end_line = self.end_line
            pragma.pragma_str = "#CURRENTLY UNSUPPORTED PREVIEW FOR TYPE: " + self.type
            pragmas.append(pragma)
        return pragmas

    def get_details(self) -> str:
        """Returns the details string which should be shown when hovering over the Suggestion button."""
        import pprint
        return pprint.pformat(self.values)
