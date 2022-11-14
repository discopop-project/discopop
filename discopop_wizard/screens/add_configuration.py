# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import os
import string
import random
from typing import List

import pytermgui as ptg

from discopop_wizard.classes.ExecutionConfiguration import ExecutionConfiguration
from discopop_wizard.screens.utils import exit_program

from tkinter import filedialog


def push_add_configuration_screen(manager: ptg.WindowManager, config_dir: str, wizard):
    if wizard.arguments.no_gui:
        # show terminal input fields
        body = (
            ptg.Window(
                "",
                "Create a new execution configuration",
                "",
                ptg.InputField("text", prompt="Label: "),
                ptg.InputField("text", prompt="Description: "),
                ptg.InputField("text", prompt="Executable name: "),
                ptg.InputField("text", prompt="Executable arguments: "),
                ptg.InputField("int", prompt="Available threads: "),
                ptg.InputField("path", prompt="Project path: "),
                ptg.InputField("text", prompt="Project linker flags: "),
                ptg.InputField("text", prompt="Make target: "),
                ptg.Container(
                    "Additional notes:",
                    ptg.InputField(
                        "text", multiline=True
                    ),
                    box="EMPTY_VERTICAL",
                ),
                box="DOUBLE",
            )
            .set_title("[210 bold]Create execution configuration")
        )
    else:
        # show GUI prompts
        # define selectors
        selector_1 = ptg.Button(label="Project path: select")
        selector_1.onclick = lambda *_: file_selector(selector_1, "Project path: ")
        selector_1.parent_align = ptg.enums.HorizontalAlignment.LEFT
        # create assemble body
        body = (
            ptg.Window(
                "",
                "Create a new execution configuration",
                "",
                ptg.InputField("text", prompt="Label: ",),
                ptg.InputField("text", prompt="Description: "),
                ptg.InputField("text", prompt="Executable name: "),
                ptg.InputField("text", prompt="Executable arguments: "),
                ptg.InputField("int", prompt="Available threads: "),
                selector_1,
                ptg.InputField("text", prompt="Project linker flags: "),
                ptg.InputField("text", prompt="Make target: "),
                ptg.Container(
                    "Additional notes:",
                    ptg.InputField(
                        "text", multiline=True
                    ),
                    box="EMPTY_VERTICAL",
                ),
                box="DOUBLE",
            )
            .set_title("[210 bold]Create execution configuration")
        )

    dp_options = (ptg.Window(
        "Enable debug output",
        ptg.Checkbox(),
        "",
        "Enable hybrid dependency profiling",
        ptg.Checkbox()
    )
                  .set_title("DiscoPoP Options")
                  )
    buttons = (ptg.Window(
        ["Save", lambda *_: save_configuration(manager, body, config_dir, wizard)],
    ))
    wizard.show_body_windows(manager, [(body, 0.6), (dp_options, 0.15), (buttons, 0.2)])


def file_selector(button_obj, prompt_str):
    selected_dir = filedialog.askdirectory()
    if type(selected_dir) != str:
        return
    button_obj.label = prompt_str + selected_dir


def save_configuration(manager: ptg.WindowManager, window: ptg.Window, config_dir: str, wizard):
    values = dict()
    values["ID"] = ''.join(random.choices(string.ascii_uppercase + string.digits, k=8))
    for widget in window:
        if isinstance(widget, ptg.InputField):
            values[widget.prompt] = widget.value
            continue

        if isinstance(widget, ptg.Button):
            key = widget.label[0 : widget.label.index(":") + 2]
            value = widget.label[widget.label.index(":") + 2 : ]
            values[key] = value
            continue

        if isinstance(widget, ptg.Container):
            label, field = iter(widget)
            values[label.value] = field.value
    new_config = ExecutionConfiguration()
    new_config.init_from_values(values)

    config_path = os.path.join(config_dir, "execution_configurations", new_config.id + "_" + new_config.label + ".sh")
    # remove old config if present
    if os.path.exists(config_path):
        os.remove(config_path)
    # write config to file
    with open(config_path, "w+") as f:
        f.write(new_config.get_as_executable_script())

    # output to console
    wizard.print_to_console(manager, "Created configuration " + values["ID"])
    # restart Wizard to load new execution configurations
    manager.stop()
    wizard.clear_window_stacks()
    wizard.initialize_screen(config_dir)


def submit(manager: ptg.WindowManager, window: ptg.Window, values: dict) -> None:
    for widget in window:
        if isinstance(widget, ptg.InputField):
            values[widget.prompt] = widget.value
            continue

        if isinstance(widget, ptg.Container):
            label, field = iter(widget)
            values[label.value] = field.value
    manager.stop()
