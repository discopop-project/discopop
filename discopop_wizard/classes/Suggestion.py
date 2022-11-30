# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import os

import tkinter as tk
from tkinter import ttk


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

        end_line_length = 200

        # load source code to content window
        source_code_path = file_mapping[self.file_id]
        with open(source_code_path, "r") as f:
            for idx, line in enumerate(f.readlines()):
                idx = idx + 1  # start with line number 1
                if idx == self.start_line or (self.start_line == 0 and idx == 1):
                    # add pragma string
                    source_code.insert(tk.END, "    " + self.__get_pragma() + "\n")
                source_code.insert(tk.END, str(idx) + "    " + line)
                if idx == self.end_line:
                    end_line_length = len(str(idx) + "    " + line)

        # highlight code
        start_pos = str(self.start_line) + ".0"
        end_pos = str(self.end_line + 1) + "." + str(end_line_length)  # +1 to correct inserted pragma
        source_code.tag_add("start", start_pos, end_pos)
        source_code.tag_config("start", background="#e5f2b3", foreground="black")

        # show targeted code section
        source_code.see(start_pos)

        # disable source code text widget to disallow editing
        source_code.config(state=tk.DISABLED)

    def get_as_button(self, canvas: tk.Canvas, code_preview_frame: tk.Frame, execution_configuration) -> tk.Button:
        return tk.Button(canvas, text=self.type + " @ " + self.values["start_line"],
                         command=lambda: self.show_code_section(code_preview_frame, execution_configuration))

    def __get_pragma(self) -> str:
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
            return pragma
        return "#CURRENTLY UNSUPPORTED PREVIEW FOR TYPE: " + self.type

    def get_details(self) -> str:
        """Returns the details string which should be shown when hovering over the Suggestion button."""
        import pprint
        return pprint.pformat(self.values)
