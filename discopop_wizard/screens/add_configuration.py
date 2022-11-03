import os
import string
import random
from typing import List

import jsons
import pytermgui as ptg

from discopop_wizard.classes.ExecutionConfiguration import ExecutionConfiguration
from discopop_wizard.screens.utils import exit_program


def push_add_configuration_screen(manager: ptg.WindowManager, config_dir: str, wizard):
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
            ptg.InputField("path", prompt="Project base path: "),
            ptg.InputField("path", prompt="Project source path: "),
            ptg.InputField("path", prompt="Project build path: "),
            ptg.InputField("text", prompt="Project configure options: "),
            ptg.InputField("text", prompt="Project linker flags: "),
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
    wizard.show_body_windows(manager, [(body, 0.6), (dp_options, 0.2), (buttons, 0.2)])


def save_configuration(manager: ptg.WindowManager, window: ptg.Window, config_dir: str, wizard):
    values = dict()
    values["ID"] = ''.join(random.choices(string.ascii_uppercase + string.digits, k=8))
    for widget in window:
        if isinstance(widget, ptg.InputField):
            values[widget.prompt] = widget.value
            continue

        if isinstance(widget, ptg.Container):
            label, field = iter(widget)
            values[label.value] = field.value
    new_config = ExecutionConfiguration()
    new_config.init_from_values(values)

    config_path = os.path.join(config_dir, new_config.id + "_" + new_config.label + ".sh")
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
