# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import copy
import sys
from pathlib import Path
from typing import Tuple, Optional, List, Dict, Sequence, cast
import tkinter as tk

from discopop_library.CodeGenerator.classes.ContentBuffer import ContentBuffer
from discopop_library.CodeGenerator.classes.Line import Line
from discopop_wizard.classes.Pragma import Pragma, PragmaPosition


class CodePreviewLine(Line):
    highlight_color: Optional[str]

    def __init__(self, parent_line_num: int, line_num=None, content=""):
        super().__init__(parent_line_num, line_num, content)
        self.highlight_color = None

    def display(self, wizard, parent_element: tk.Text, line_idx: int, max_line_num: int):
        if not self.content.endswith("\n"):
            self.content += "\n"

        # assemble line_num_str if requested
        line_num_str = ""
        if wizard.settings.code_preview_show_line_numbers == 1:
            line_num_str = str(self.line_num) if self.line_num is not None else ""
            while len(line_num_str) < len(str(max_line_num)):
                line_num_str += " "
            line_num_str += "  "  # padding

        # assemble line for display
        line = ""
        line += line_num_str
        line += self.content

        parent_element.insert(tk.END, line)

        # highlight inserted pragmas
        if self.line_num is None:
            # todo generate background colors
            background_color = "#e5f2b3" if line_idx % 2 == 0 else "#a4ed9a"
            if self.owns_region is not None:
                # highlight entire line if a new region is created
                self.__highlight(parent_element, line_idx, 0, len(line), background_color)
            else:
                # highlight pragma only
                self.__highlight(parent_element, line_idx, len(line) - len(self.content), len(line), background_color)

    def __highlight(self, parent_element: tk.Text, line_idx: int, start_position: int, end_position: int, color: str):
        """highlights the given section of the line in the given color"""
        start_position_str = str(line_idx) + "." + str(start_position)
        end_position_str = str(line_idx) + "." + str(end_position)
        parent_element.tag_add(color + ":" + start_position_str + "-" + end_position_str, start_position_str,
                               end_position_str)
        parent_element.tag_config(color + ":" + start_position_str + "-" + end_position_str, background=color,
                                  foreground="black")


class CodePreviewContentBuffer(ContentBuffer):
    max_line_num: int  # used to determine width of padding
    file_id: int
    next_free_region_id = 0
    lines: List[Line]

    def __init__(self, wizard, file_id: int, source_code_path: Path, tab_width: int = 4):
        super().__init__(file_id, source_code_path, tab_width, line_type=CodePreviewLine)
        self.wizard = wizard

    def show_in(self, parent_element: tk.Text):
        """Displays the contents of the CodePreview object in the supplied parent_element."""
        for line_idx, line in enumerate(self.lines):
            # offset line_id to account for start with 1
            offset_line_id = line_idx + 1
            cast(CodePreviewLine, line).display(self.wizard, parent_element, offset_line_id, self.max_line_num)

    def jump_to_first_modification(self, parent_element: tk.Text):
        """Jumps to the location of the first modified source code location."""
        first_location = ""
        for idx, line in enumerate(self.lines):
            if line.line_num is None:
                first_location = "" + str(idx) + ".0"
                break
        if first_location == "":
            first_location = "1.0"
        parent_element.see(first_location)
