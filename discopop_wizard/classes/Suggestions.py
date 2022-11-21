# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import os

import pytermgui as ptg


class Suggestion(object):
    suggestion: str
    id: int

    def __init__(self, id: int, suggestion: str):
        suggestion = suggestion.replace("\t", "    ")
        self.suggestion = suggestion
        self.id = id

    def get_as_button(self, manager: ptg.WindowManager, wizard, execution_configuration):
        return ptg.Button(label=self.suggestion.split("\n")[0],
                          onclick=lambda *_: self.__show_details_and_code(manager, wizard, execution_configuration))


    def __show_details_and_code(self, manager: ptg.WindowManager, wizard, execution_configuration):
        self.__show_details_section(manager, wizard)
        self.__show_code_section(manager, wizard, execution_configuration)


    def __show_details_section(self, manager: ptg.WindowManager, wizard):
        # close window
        for slot in manager.layout.slots:
            if slot.name == "body_1":
                slot.content.close()

        # create new details window
        details_window = (
            ptg.Window(
                ptg.Label(self.suggestion, parent_align=ptg.enums.HorizontalAlignment.LEFT)
            )
            .set_title("[210 bold]Details")
        )
        details_window.overflow = ptg.Overflow.SCROLL
        manager.add(details_window, assign="body_1")


    def __show_code_section(self, manager: ptg.WindowManager, wizard, execution_configuration):
        # close window
        for slot in manager.layout.slots:
            if slot.name == "body_2":
                slot.content.close()

        content = ptg.Container()

        # load file mapping from project path
        file_mapping: dict[int, str] = dict()
        with open(os.path.join(execution_configuration.project_path, "FileMapping.txt"), "r") as f:
            for line in f.readlines():
                line = line.replace("\n", "")
                split_line = line.split("\t")
                id = int(split_line[0])
                path = split_line[1]
                file_mapping[id] = path

        # get start and end line of target section
        start_line = int(self.suggestion.split("\n")[1].split(":")[2])
        end_line = int(self.suggestion.split("\n")[2].split(":")[2])

        # load source code to content window
        source_code_path = file_mapping[int(self.suggestion.split("\n")[0].split(":")[1])]
        file_length = 0
        for idx, line in enumerate(open(source_code_path, "r").readlines()):
            idx = idx + 1  # start with line number 1
            line = line.replace("\n", "")
            line = line.replace("\t", "    ")
            # set highlight style if required
            if idx >= start_line and idx <= end_line:
                style = "[210 bold]"
            else:
                style = ""
            content.lazy_add(ptg.Label(style + str(idx) + "    " + line, parent_align=ptg.enums.HorizontalAlignment.LEFT))
            file_length = idx

        # create new code window
        code_window = (
            ptg.Window(
                content,
            )
            .set_title("[210 bold]" + source_code_path)
        )
        code_window.overflow = ptg.Overflow.SCROLL

        # scroll down to target section
        code_window.get_lines()
        code_window._max_scroll = file_length  # required to allow scrolling, since window only contains one element
        code_window.scroll(start_line)

        manager.add(code_window, assign="body_2")

