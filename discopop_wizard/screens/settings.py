# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import pytermgui as ptg
from tkinter import filedialog
import os

from discopop_wizard.classes.Settings import Settings


def push_settings_screen(manager: ptg.WindowManager, config_dir: str, wizard):
    if wizard.arguments.no_gui:
        # show terminal input fields
        body = (
            ptg.Window(
                "",
                "Specify paths to the following executables and directories.",
                "",
                ptg.InputField(wizard.settings.discopop_dir, prompt="DiscoPoP directory: "),
                ptg.InputField(wizard.settings.discopop_build_dir, prompt="DiscoPoP build: "),
                ptg.InputField(wizard.settings.clang, prompt="clang (exe): "),
                ptg.InputField(wizard.settings.clangpp, prompt="clang++ (exe): "),
                ptg.InputField(wizard.settings.llvm_ar, prompt="llvm-ar (exe): "),
                ptg.InputField(wizard.settings.llvm_link, prompt="llvm-link (exe): "),
                ptg.InputField(wizard.settings.llvm_dis, prompt="llvm-dis (exe): "),
                ptg.InputField(wizard.settings.llvm_opt, prompt="llvm-opt (exe): "),
                ptg.InputField(wizard.settings.llvm_llc, prompt="llvm-llc (exe): "),
                ptg.InputField(wizard.settings.go_bin, prompt="go (bin directory): "),
                box="DOUBLE",
            )
            .set_title("[210 bold]DiscoPoP Settings")
        )
    else:
        # show GUI prompts
        # define selectors
        selector_1 = ptg.Button(label="clang (exe): " + wizard.settings.clang,
                                onclick=lambda *_: file_selector(selector_1, "clang (exe): "),
                                parent_align=ptg.enums.HorizontalAlignment.LEFT)

        selector_2 = ptg.Button(label="clang++ (exe): " + wizard.settings.clangpp,
                                onclick=lambda *_: file_selector(selector_2, "clang++ (exe): "),
                                parent_align=ptg.enums.HorizontalAlignment.LEFT)
        selector_3 = ptg.Button(label="llvm-ar (exe): " + wizard.settings.llvm_ar,
                                onclick=lambda *_: file_selector(selector_3, "llvm-ar (exe): "),
                                parent_align=ptg.enums.HorizontalAlignment.LEFT)

        selector_4 = ptg.Button(label="llvm-link (exe): " + wizard.settings.llvm_link,
                                onclick=lambda *_: file_selector(selector_4, "llvm-link (exe): "),
                                parent_align=ptg.enums.HorizontalAlignment.LEFT)

        selector_5 = ptg.Button(label="llvm-dis (exe): " + wizard.settings.llvm_dis,
                                onclick=lambda *_: file_selector(selector_5, "llvm-dis (exe): "),
                                parent_align=ptg.enums.HorizontalAlignment.LEFT)

        selector_6 = ptg.Button(label="llvm-opt (exe): " + wizard.settings.llvm_opt,
                                onclick=lambda *_: file_selector(selector_6, "llvm-opt (exe): "),
                                parent_align=ptg.enums.HorizontalAlignment.LEFT)

        selector_7 = ptg.Button(label="llvm-llc (exe): " + wizard.settings.llvm_llc,
                                onclick=lambda *_: file_selector(selector_7, "llvm-llc (exe): "),
                                parent_align=ptg.enums.HorizontalAlignment.LEFT)

        selector_8 = ptg.Button(label="go (bin directory): " + wizard.settings.go_bin,
                                onclick=lambda *_: directory_selector(selector_8, "go (bin directory): "),
                                parent_align=ptg.enums.HorizontalAlignment.LEFT)

        selector_9 = ptg.Button(label="DiscoPoP directory: " + wizard.settings.discopop_dir,
                                onclick=lambda *_: directory_selector(selector_9, "DiscoPoP directory: "),
                                parent_align=ptg.enums.HorizontalAlignment.LEFT)

        selector_10 = ptg.Button(label="DiscoPoP build: " + wizard.settings.discopop_build_dir,
                                 onclick=lambda *_: directory_selector(selector_10, "DiscoPoP build: "),
                                 parent_align=ptg.enums.HorizontalAlignment.LEFT)

        # create and assemble body
        body = (
            ptg.Window(
                "",
                "Specify paths to the following executables and directories.",
                "",
                selector_9,
                selector_10,
                selector_1,
                selector_2,
                selector_3,
                selector_4,
                selector_5,
                selector_6,
                selector_7,
                selector_8,
                box="DOUBLE",
            )
            .set_title("[210 bold]DiscoPoP Settings")
        )
    buttons = (ptg.Window(
        ["Save", lambda *_: save_settings(manager, body, config_dir, wizard)],
    ))
    wizard.show_body_windows(manager, [(body, 0.75), (buttons, 0.2)])


def save_settings(manager: ptg.WindowManager, window: ptg.Window, config_dir: str, wizard):
    values = dict()
    for widget in window:
        if isinstance(widget, ptg.InputField):
            values[widget.prompt] = widget.value
            continue

        if isinstance(widget, ptg.Button):
            key = widget.label[0: widget.label.index(":") + 2]
            value = widget.label[widget.label.index(":") + 2:]
            values[key] = value
            continue

        if isinstance(widget, ptg.Container):
            label, field = iter(widget)
            values[label.value] = field.value

    if __check_values(values, wizard, manager):

        settings = Settings()
        settings.init_from_values(values)

        settings_path = os.path.join(config_dir, "SETTINGS.txt")
        # remove old config if present
        if os.path.exists(settings_path):
            os.remove(settings_path)
        # write config to file
        with open(settings_path, "w+") as f:
            f.write(settings.get_as_json_string())

        # save settings in wizard
        wizard.settings = settings

        # output to console
        wizard.print_to_console(manager, "Saved SETTINGS")
        # restart Wizard to load new execution configurations
        manager.stop()
        wizard.clear_window_stacks()
        wizard.initialize_screen(config_dir)


def __check_values(values: dict, wizard, manager) -> bool:
    """returns true, if all settings have valid values.
    Returns false and prints error message to console, if not."""
    for key in values:
        value = values[key]
        # check if all values have been set
        if len(value) == 0:
            wizard.print_to_console(manager, "Setting not specified: " + key, style=3)
            return False
    return True


def file_selector(button_obj, prompt_str):
    selected_file = filedialog.askopenfilename()
    if type(selected_file) != str:
        return
    button_obj.label = prompt_str + selected_file


def directory_selector(button_obj, prompt_str):
    selected_dir = filedialog.askdirectory()
    if type(selected_dir) != str:
        return
    button_obj.label = prompt_str + selected_dir
