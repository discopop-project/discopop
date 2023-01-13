# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import copy
from typing import Tuple, Optional, List, Dict
import tkinter as tk

from discopop_wizard.classes.Pragma import Pragma, PragmaPosition


class Line(object):
    line_num: Optional[int]
    meta_information: List[str]
    meta_live_device_variables: List[str]
    content: str
    highlight_color: Optional[str]
    owns_region: Optional[int]
    belongs_to_regions: List[int]
    belongs_to_original_line: int

    def __init__(self, wizard, parent_line_num: int, line_num=None, content=""):
        self.wizard = wizard
        self.line_num = line_num
        self.meta_information = []
        self.meta_live_device_variables = []
        self.content = content
        self.highlight_color = None
        self.owns_region = None
        self.belongs_to_regions = []
        self.belongs_to_original_line = parent_line_num

    def get_metadata_live_device_variables_str(self, padded_length: int = 0) -> str:
        result = ""
        result += "" if len(self.meta_live_device_variables) == 0 else "live(" + ",".join(self.meta_live_device_variables) + ")"
        # add padding
        while len(result) < padded_length:
            result = result + " "  # padding right
        return result

    def get_metadata_regions_str(self, padded_length: int = 0) -> str:
        result = ""
        result += "" if self.owns_region is None else "+" + str(self.owns_region)
        regions_str = "" if len(self.belongs_to_regions) == 0 else str(self.belongs_to_regions)
        # add padding
        while len(result) + len(regions_str) < padded_length:
            result = result + " "  # padding right
        result += regions_str
        return result

    def display(self, parent_element: tk.Text, line_idx: int, max_line_num: int, max_region_metadata_len: int, max_live_variable_metadata_len: int):
        if not self.content.endswith("\n"):
            self.content += "\n"

        # assemble line_num_str if requested
        line_num_str = ""
        if self.wizard.settings.code_preview_show_line_numbers == 1:
            line_num_str = str(self.line_num) if self.line_num is not None else ""
            while len(line_num_str) < len(str(max_line_num)):
                line_num_str += " "
            line_num_str += "  "  # padding

        # assemble regions metadata string if requested
        regions_metadata_str = ""
        if self.wizard.settings.code_preview_show_metadata_regions == 1:
            regions_metadata_str = self.get_metadata_regions_str(padded_length=max_region_metadata_len)
            regions_metadata_str += " | "  # padding right

        # assemble live variables metadata string if requested
        live_variables_metadata_str = ""
        if self.wizard.settings.code_preview_show_metadata_live_device_variables == 1:
            live_variables_metadata_str = self.get_metadata_live_device_variables_str(padded_length=max_live_variable_metadata_len)
            live_variables_metadata_str += " | "  # padding right

        # assemble line for display
        line = ""
        line += live_variables_metadata_str
        line += regions_metadata_str
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


class CodePreview(object):
    lines: List[Line]
    max_line_num: int  # used to determine width of padding
    file_id: int
    next_free_region_id = 0

    def __init__(self, wizard, file_id: int, source_code_path: str, tab_width: int = 4):
        self.wizard = wizard
        self.file_id = file_id
        self.lines = []
        self.max_line_num = 0
        # load source code
        with open(source_code_path, "r") as f:
            lines = f.readlines()
            for idx, line in enumerate(lines):
                idx = idx + 1  # start with line number 1
                self.max_line_num = idx
                line_obj = Line(self.wizard, idx, line_num=idx, content=line)
                self.lines.append(line_obj)

    def print_lines(self):
        for line in self.lines:
            print(line)

    def __get_next_free_region_id(self) -> int:
        buffer = self.next_free_region_id
        self.next_free_region_id += 1
        return buffer

    def show_in(self, parent_element: tk.Text):
        """Displays the contents of the CodePreview object in the supplied parent_element."""
        # calculate required information
        max_region_metadata_len = 0
        for line in self.lines:
            tmp = line.get_metadata_regions_str()
            if len(tmp) > max_region_metadata_len:
                max_region_metadata_len = len(tmp)
        max_live_variable_metadata_len = 0
        for line in self.lines:
            tmp = line.get_metadata_live_device_variables_str()
            if len(tmp) > max_live_variable_metadata_len:
                max_live_variable_metadata_len = len(tmp)


        for line_idx, line in enumerate(self.lines):
            # offset line_id to account for start with 1
            offset_line_id = line_idx + 1
            line.display(parent_element, offset_line_id, self.max_line_num, max_region_metadata_len, max_live_variable_metadata_len)

    def jump_to_first_modification(self, parent_element: tk.Text):
        """Jumps to the location of the first modified source code location."""
        first_location = ""
        for idx, line in enumerate(self.lines):
            if line.line_num is None:
                first_location = "" + str(idx) + ".0"
                break
        parent_element.see(first_location)

    def append_line_before(self, parent_line_num: int, line: Line):
        """Appends line before the specified parent_line_num"""
        for idx, potential_parent_line in enumerate(self.lines):
            if potential_parent_line.line_num == parent_line_num:
                self.lines.insert(idx, line)
                return

    def append_line_after(self, parent_line_num: int, line: Line):
        """Appends line after the specified parent_line_num"""
        for idx, potential_parent_line in enumerate(self.lines):
            if potential_parent_line.line_num == parent_line_num:
                if idx + 1 < len(self.lines):
                    self.lines.insert(idx + 1, line)
                else:
                    self.lines.append(line)
                return

    def add_pragma(self, pragma: Pragma, parent_regions: List[int]):
        """insert pragma into the maintained list of source code lines"""
        if pragma.start_line is None or pragma.end_line is None:
            raise ValueError("Unsupported start or end line: ", pragma.start_line, "-", pragma.end_line)
        if pragma.file_id is None:
            raise ValueError("Unsupported file_id: ", pragma.file_id)
        if pragma.file_id != self.file_id:
            return  # incorrect target file, ignore the pragma

        # construct line
        pragma_line = Line(self.wizard, pragma.start_line)
        pragma_line.content = pragma.pragma_str
        pragma_line.belongs_to_regions = copy.deepcopy(parent_regions)
        # create new region if necessary
        if len(pragma.children) > 0:
            region_id = self.__get_next_free_region_id()
            pragma_line.owns_region = region_id
            pragma_line.belongs_to_regions.append(region_id)

        if pragma.pragma_position == PragmaPosition.BEFORE_START:
            self.append_line_before(pragma.start_line, pragma_line)
        elif pragma.pragma_position == PragmaPosition.AFTER_START:
            self.append_line_after(pragma.start_line, pragma_line)
        elif pragma.pragma_position == PragmaPosition.BEFORE_END:
            self.append_line_before(pragma.end_line, pragma_line)
        elif pragma.pragma_position == PragmaPosition.AFTER_END:
            self.append_line_after(pragma.end_line, pragma_line)
        else:
            raise ValueError("Unsupported pragma position: ", pragma.pragma_position)

        # update belonging information of contained lines
        tmp_start_line = pragma.start_line if pragma.pragma_position == PragmaPosition.BEFORE_START else pragma.start_line + 1
        tmp_end_line = pragma.end_line + 1
        for line_num in range(tmp_start_line, tmp_end_line):
            for line in self.lines:
                if line.line_num == line_num:
                    line.belongs_to_regions += [n for n in pragma_line.belongs_to_regions if
                                                n not in line.belongs_to_regions]

        # append children to lines (mark as contained in region)
        for child_pragma in pragma.children:
            self.add_pragma(child_pragma, pragma_line.belongs_to_regions)

    def add_live_variables(self, live_variables: Dict[int, List[str]]):
        for line_num in live_variables:
            for idx, line in enumerate(self.lines):
                if line.line_num == line_num:
                    self.lines[idx].meta_live_device_variables = live_variables[line_num]
