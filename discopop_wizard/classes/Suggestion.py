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
from typing import List, Tuple, Dict

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
        file_mapping: dict[int, str] = dict()
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

    def get_as_button(self, canvas: tk.Canvas, code_preview_frame: tk.Frame, execution_configuration) -> tk.Button:
        return tk.Button(canvas, text=self.type + " @ " + self.values["start_line"],
                         command=lambda: self.show_code_section(code_preview_frame, execution_configuration))

    def get_details(self) -> str:
        """Returns the details string which should be shown when hovering over the Suggestion button."""
        import pprint
        return pprint.pformat(self.values)
