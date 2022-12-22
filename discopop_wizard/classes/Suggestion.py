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


class PragmaType(IntEnum):
    PRAGMA = 1
    REGION = 2


class Suggestion(object):
    type: str
    values: dict
    file_id: int
    start_line: int
    end_line: int

    def __init__(self, type: str, values: dict):
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
        with open(os.path.join(execution_configuration.working_copy_path, "FileMapping.txt"), "r") as f:
            for line in f.readlines():
                line = line.replace("\n", "")
                split_line = line.split("\t")
                id = int(split_line[0])
                path = split_line[1]
                file_mapping[id] = path

        # load source code to content window
        source_code_path = file_mapping[self.file_id]
        max_line_num_length = 0
        with open(source_code_path, "r") as f:
            lines = f.readlines()
            max_line_num_length = len(str(len(lines)))
            for idx, line in enumerate(lines):
                idx = idx + 1  # start with line number 1
                padded_line_num = str(idx)
                while len(padded_line_num) < max_line_num_length:
                    padded_line_num += " "
                source_code.insert(tk.END, padded_line_num + "    " + line)
        # get list of pragmas to be inserted
        pragmas = self.__get_pragmas()

        # insert pragmas to code preview and add highlights
        highlight_start_positions = self.__insert_pragmas(source_code, pragmas, max_line_num_length)

        # show targeted code section
        source_code.see(highlight_start_positions[0])

        # disable source code text widget to disallow editing
        source_code.config(state=tk.DISABLED)

    def get_as_button(self, canvas: tk.Canvas, code_preview_frame: tk.Frame, execution_configuration) -> tk.Button:
        return tk.Button(canvas, text=self.type + " @ " + self.values["start_line"],
                         command=lambda: self.show_code_section(code_preview_frame, execution_configuration))

    def __insert_pragmas(self, source_code: tk.Text, pragmas: List[Tuple[int, int, str, PragmaType]], max_line_num_lenght: int):
        highlight_start_positions = []

        idx = 0
        for start_line, end_line, pragma_str, pragma_type in sorted(pragmas, reverse=True,
                                                       key=lambda v: int(v[0])):  # sort reverse by line num
            # add pragma string
            padding = ""
            while len(padding) < max_line_num_lenght:
                padding += " "
            source_code.insert(str(start_line) + ".0", padding + "    " + pragma_str + "\n")
            # highlight inserted pragmas and their target code sections
            pos = self.__highlight_code(source_code, start_line, end_line + 1,
                                        idx, pragma_type, max_line_num_lenght)  # +1 to account for added pragma line
            highlight_start_positions.append(pos)
            idx += 1

        return sorted(highlight_start_positions, key=lambda value: int(value.split(".")[0]))

    def __highlight_code(self, source_code: tk.Text, start_line: int, end_line: int, index, pragma_type: PragmaType,
                         max_line_num_length: int):
        """highlights the specified lines in the source code preview and returns the used start position.
        index is used to determine the color."""
        end_line_length = 200
        background_color = "#e5f2b3" if index % 2 == 0 else "#a4ed9a"
        if pragma_type == PragmaType.PRAGMA:
            # highlight source code
            # highlight code line by line
            for line_num in range(start_line, end_line + 1):
                start_pos = str(line_num) + "." + str(max_line_num_length + 4)  # + 4 to account for added whitespaces
                end_pos = str(line_num) + "." + str(end_line_length)
                source_code.tag_add("start" + str(index) + ":" + str(line_num), start_pos, end_pos)
                source_code.tag_config("start" + str(index) + ":" + str(line_num), background=background_color,
                                       foreground="black")
            start_pos = str(start_line) + "." + str(max_line_num_length)
        elif pragma_type == PragmaType.REGION:
            # highlight start line of region
            start_pos = str(start_line) + ".0"
            end_pos = str(start_line) + "." + str(end_line_length)
            source_code.tag_add("start" + str(index) + ":region_start", start_pos, end_pos)
            source_code.tag_config("start" + str(index) + ":region_start", background=background_color,
                                   foreground="black")
            # highlight line numbers within region
            for line_num in range(start_line + 1, end_line + 1):
                start_pos = str(line_num) + ".0"
                end_pos = str(line_num) + "." + str(max_line_num_length)
                source_code.tag_add("start" + str(index) + ":region_" + str(line_num), start_pos, end_pos)
                source_code.tag_config("start" + str(index) + ":region_" + str(line_num), background=background_color,
                                       foreground="black")
            start_pos = str(start_line) + ".0"
        else:
            raise ValueError("Unsupported pragma type: ", pragma_type)
        return start_pos

    def __get_pragmas(self) -> List[Tuple[int, int, str, PragmaType]]:
        """returns a list of source code lines and pragmas to be inserted into the code preview"""
        pragmas = []
        if self.type == "do_all" or self.type == "reduction":
            pragma = "#pragma omp parallel for "
            if len(self.values["first_private"]) > 0:
                pragma += "firstprivate(" + ",".join(self.values["first_private"]) + ") "
            if len(self.values["private"]) > 0:
                pragma += "private(" + ",".join(self.values["private"]) + ") "
            if len(self.values["last_private"]) > 0:
                pragma += "lastprivate(" + ",".join(self.values["last_private"]) + ") "
            if len(self.values["shared"]) > 0:
                pragma += "shared(" + ",".join(self.values["shared"]) + ") "
            if len(self.values["reduction"]) > 0:
                reductions_dict = dict()
                for entry in self.values["reduction"]:
                    red_type = entry.split(":")[0]
                    var = entry.split(":")[1]
                    if red_type not in reductions_dict:
                        reductions_dict[red_type] = []
                    reductions_dict[red_type].append(var)
                for red_type in reductions_dict:
                    pragma += "reduction(" + red_type + ":" + ",".join(reductions_dict[red_type]) + ") "
            pragma_tuple = (self.start_line, self.end_line, pragma, PragmaType.PRAGMA)
            pragmas.append(pragma_tuple)
            return pragmas
        elif self.type == "pipeline":
            for stage in self.values["stages"]:
                pragma = "#pragma omp task "
                if len(stage["first_private"]) > 0:
                    pragma += "firstprivate(" + ",".join(stage["first_private"]) + ") "
                if len(stage["private"]) > 0:
                    pragma += "private(" + ",".join(stage["private"]) + ") "
                if len(stage["shared"]) > 0:
                    pragma += "shared(" + ",".join(stage["shared"]) + ") "
                if len(stage["reduction"]) > 0:
                    reductions_dict = dict()
                    for entry in stage["reduction"]:
                        red_type = entry.split(":")[0]
                        var = entry.split(":")[1]
                        if red_type not in reductions_dict:
                            reductions_dict[red_type] = []
                        reductions_dict[red_type].append(var)
                    for red_type in reductions_dict:
                        pragma += "reduction(" + red_type + ":" + ",".join(reductions_dict[red_type]) + ") "
                if len(stage["in_deps"]) > 0:
                    pragma += "depends(in:" + ",".join(stage["in_deps"]) + ") "
                if len(stage["out_deps"]) > 0:
                    pragma += "depends(out:" + ",".join(stage["out_deps"]) + ") "
                if len(stage["in_out_deps"]) > 0:
                    pragma += "depends(inout:" + ",".join(stage["inout_deps"]) + ") "
                pragma_tuple = (
                    int(stage["startsAtLine"].split(":")[1]), int(stage["endsAtLine"].split(":")[1]), pragma,
                    PragmaType.PRAGMA)
                pragmas.append(pragma_tuple)
        elif self.type == "gpu":
            region_start = self.values["start_line"]
            region_start_line = int(region_start.split(":")[1])
            region_end = self.values["end_line"]
            region_end_line = int(region_end.split(":")[1])
            for loop in self.values["contained_loops"]:
                loop_start = loop["start_line"]
                loop_start_line = int(loop_start.split(":")[1])
                loop_end = loop["end_line"]
                loop_end_line = int(loop_end.split(":")[1])
                for construct in loop["constructs"]:
                    construct_start = construct["line"]
                    construct_start_line = int(construct_start.split(":")[1])
                    pragma = construct["name"] + " "
                    for clause in construct["clauses"]:
                        pragma += clause + " "
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
                    pragmas.append((start_line, end_line, pragma, PragmaType.PRAGMA))
            # mark gpu region
            # increase region end line to account for added pragmas
            pragmas_in_region = [p for p in pragmas if p[0] >= region_start_line and p[1] <= region_end_line]
            region_pragma = "// gpu region "
            consumed_str = "consumes(" if len(self.values["consumed_vars"]) > 0 else ""
            consumed_str += ",".join(self.values["consumed_vars"])
            consumed_str += ") " if len(self.values["consumed_vars"]) > 0 else ""

            produced_str = "produces(" if len(self.values["produced_vars"]) > 0 else ""
            produced_str += ",".join(self.values["produced_vars"])
            produced_str += ") " if len(self.values["produced_vars"]) > 0 else ""

            allocated_str = "allocates(" if len(self.values["allocated_vars"]) > 0 else ""
            allocated_str += ",".join(self.values["allocated_vars"])
            allocated_str += ") " if len(self.values["allocated_vars"]) > 0 else ""

            deleted_str = "deletes(" if len(self.values["deleted_vars"]) > 0 else ""
            deleted_str += ",".join(self.values["deleted_vars"])
            deleted_str += ") " if len(self.values["deleted_vars"]) > 0 else ""

            region_pragma += consumed_str
            region_pragma += produced_str
            region_pragma += allocated_str
            region_pragma += deleted_str

            pragmas.append((region_start_line, region_end_line + len(pragmas_in_region), region_pragma, PragmaType.REGION))
        else:
            pragmas.append((self.start_line, self.end_line, "#CURRENTLY UNSUPPORTED PREVIEW FOR TYPE: " + self.type,
                            PragmaType.PRAGMA))
        return pragmas

    def get_details(self) -> str:
        """Returns the details string which should be shown when hovering over the Suggestion button."""
        import pprint
        return pprint.pformat(self.values)
