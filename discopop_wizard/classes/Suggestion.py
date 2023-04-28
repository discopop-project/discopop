# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import os
import sys

import tkinter as tk
from enum import IntEnum
from tkinter import ttk
from typing import Any, Dict, List, Tuple

from discopop_explorer.pattern_detectors.combined_gpu_patterns.classes.Enums import ExitPointPositioning, \
    EntryPointPositioning, ExitPointType, EntryPointType, UpdateType
from discopop_explorer.pattern_detectors.simple_gpu_patterns.GPULoop import OmpConstructPositioning
from discopop_library.CodeGenerator.classes.UnpackedSuggestion import UnpackedSuggestion
from discopop_wizard.classes.CodePreview import CodePreviewContentBuffer
from discopop_wizard.classes.Pragma import Pragma, PragmaPosition

class PragmaType(IntEnum):
    PRAGMA = 1
    REGION = 2

class Suggestion(UnpackedSuggestion):

    def __init__(self, wizard, type_str: str, values: dict):
        super().__init__(type_str, values)
        self.wizard = wizard

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
        file_mapping: Dict[int, str] = dict()
        with open(os.path.join(execution_configuration.value_dict["working_copy_path"], "FileMapping.txt"), "r") as f:
            for line in f.readlines():
                line = line.replace("\n", "")
                split_line = line.split("\t")
                id = int(split_line[0])
                path = split_line[1]
                file_mapping[id] = path

        # create CodePreview object
        code_preview = CodePreviewContentBuffer(self.wizard, self.file_id, file_mapping[self.file_id])

        # get and insert pragmas
        pragmas = self.get_pragmas()
        for pragma in pragmas:
            successful = code_preview.add_pragma(file_mapping, pragma, [], skip_compilation_check=True if self.wizard.settings.code_preview_disable_compile_check == 1 else False)
            # if the addition resulted in a non-compilable file, add the pragma as a comment
            if not successful:
                # print error codes
                self.wizard.console.print(code_preview.compile_result_buffer)
                code_preview.add_pragma(file_mapping, pragma, [], add_as_comment=True, skip_compilation_check=True)


        # show CodePreview
        code_preview.show_in(source_code)

        # show targeted code section
        code_preview.jump_to_first_modification(source_code)

        # disable source code text widget to disallow editing
        source_code.config(state=tk.DISABLED)

    def get_as_button(self, frame: tk.Frame, code_preview_frame: tk.Frame, execution_configuration) -> tk.Button:
        return tk.Button(frame, text=self.type + " @ " + self.values["start_line"],
                         command=lambda: self.show_code_section(code_preview_frame, execution_configuration))

    def __insert_pragmas(self, source_code: tk.Text, pragmas: List[Tuple[int, int, str]]):
        highlight_start_positions = []

        idx = 0
        for start_line, end_line, pragma_str in sorted(pragmas, reverse=True,
                                                       key=lambda v: int(v[0])):  # sort reverse by line num
            # add pragma string
            source_code.insert(str(start_line) + ".0", "    " + pragma_str + "\n")
            # highlight inserted pragmas and their target code sections
            pos = self.__highlight_code(source_code, start_line, end_line + 1,
                                        idx)  # +1 to account for added pragma line
            highlight_start_positions.append(pos)
            idx += 1

        return sorted(highlight_start_positions, key=lambda value: int(value.split(".")[0]))

    def __highlight_code(self, source_code: tk.Text, start_line: int, end_line: int, index):
        """highlights the specified lines in the source code preview and returns the used start position.
        index is used to determine the color."""
        end_line_length = 200
        background_color = "#e5f2b3" if index % 2 == 0 else "#a4ed9a"
        # highlight code
        start_pos = str(start_line) + ".0"
        end_pos = str(end_line) + "." + str(end_line_length)
        source_code.tag_add("start" + str(index), start_pos, end_pos)
        source_code.tag_config("start" + str(index), background=background_color, foreground="black")
        return start_pos

    def __get_pragmas(self) -> List[Tuple[int, int, str]]:
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
                reductions_dict: Dict[Any, Any] = dict()
                for entry in self.values["reduction"]:
                    red_type = entry.split(":")[0]
                    var = entry.split(":")[1]
                    if red_type not in reductions_dict:
                        reductions_dict[red_type] = []
                    reductions_dict[red_type].append(var)
                for red_type in reductions_dict:
                    pragma += "reduction(" + red_type + ":" + ",".join(reductions_dict[red_type]) + ") "
            pragma_tuple = (self.start_line, self.end_line, pragma)
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
                    pragma += "depends(inout:" + ",".join(stage["in_out_deps"]) + ") "
                pragma_tuple = (
                int(stage["startsAtLine"].split(":")[1]), int(stage["endsAtLine"].split(":")[1]), pragma)
                pragmas.append(pragma_tuple)
        else:
            pragmas.append((self.start_line, self.end_line, "#CURRENTLY UNSUPPORTED PREVIEW FOR TYPE: " + self.type))
        return pragmas

    def get_details(self) -> str:
        """Returns the details string which should be shown when hovering over the Suggestion button."""
        import pprint
        return pprint.pformat(self.values)
