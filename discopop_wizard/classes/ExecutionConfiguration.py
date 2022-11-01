import os

import jsons
from typing import List

from pytermgui import Collapsible, Container, Splitter, Window, Button
import pytermgui as ptg


class ExecutionConfiguration(object):
    id: str
    label: str
    description: str
    executable_name: str
    executable_arguments: str
    project_base_path: str
    project_source: str
    project_build: str
    project_configure_options: str
    linker_flags: str
    threads: str
    notes: str

    def get_as_widget(self, manager: ptg.WindowManager, config_dir: str, wizard):
#        widget = Collapsible(self.label + ": " + self.description)
        widget = ptg.Container()
        details = ptg.Button(
            label="Label: " + self.label + "    " + "Description: " + self.description,
            onclick=lambda *_: push_execution_configuration_screen(manager, config_dir, self, wizard)
#            "Executable name: " + self.executable_name,
#            "Executable arguments: " + self.executable_arguments,
#            "Available threads: " + self.threads,
#            "Project base path: " + self.project_base_path,
#            "Project source path: " + self.project_source,
#            "Project build path: " + self.project_build,
#            "Project configure options: " + self.project_configure_options,
#            "Project linker flags: " + self.linker_flags,
#            "Additional notes: " + self.notes
        )
        widget.lazy_add(details)
        return widget


    def init_from_dict(self, loaded: dict):
        for key in loaded:
            self.__dict__[key] = loaded[key]

    def init_from_values(self, values: dict):
        """values stems from reading the 'add_configuration' form."""
        self.id = values["ID"]
        self.label = values["Label: "]
        self.description = values["Description: "]
        self.executable_name = values["Executable name: "]
        self.executable_arguments = values["Executable arguments: "]
        self.threads = values["Available threads: "]
        self.project_base_path = values["Project base path: "]
        self.project_source = values["Project source path: "]
        self.project_build = values["Project build path: "]
        self.project_configure_options = values["Project configure options: "]
        self.linker_flags = values["Project linker flags: "]
        self.notes = values["Additional notes:"]


def push_execution_configuration_screen(manager: ptg.WindowManager, config_dir: str,
                                        execution_configuration, wizard):
    body = (
        ptg.Window(
            "",
            "Show saved Configuration - " + execution_configuration.id,
            "",
            ptg.InputField(execution_configuration.label, prompt="Label: "),
            ptg.InputField(execution_configuration.description, prompt="Description: "),
            ptg.InputField(execution_configuration.executable_name, prompt="Executable name: "),
            ptg.InputField(execution_configuration.executable_arguments, prompt="Executable arguments: "),
            ptg.InputField(execution_configuration.threads, prompt="Available threads: "),
            ptg.InputField(execution_configuration.project_base_path, prompt="Project base path: "),
            ptg.InputField(execution_configuration.project_source, prompt="Project source path: "),
            ptg.InputField(execution_configuration.project_build, prompt="Project build path: "),
            ptg.InputField(execution_configuration.project_configure_options, prompt="Project configure options: "),
            ptg.InputField(execution_configuration.linker_flags, prompt="Project linker flags: "),
            ptg.Container(
                "Additional notes:",
                ptg.InputField(
                    execution_configuration.notes, multiline=True
                ),
                box="EMPTY_VERTICAL",
            ),
            box="DOUBLE",
        )
        .set_title("[210 bold]Show execution configuration")
    )
    manager.add(body, assign="body")
    wizard.push_body_window(body)

    buttons = (ptg.Window(
        ["Save", lambda *_: save_changes(manager, body, config_dir, wizard, execution_configuration)],
        ""
    ))
    manager.add(buttons, assign="body_buttons")
    wizard.push_body_buttons(buttons)


def save_changes(manager: ptg.WindowManager, window: ptg.Window, config_dir: str, wizard, execution_configuration):
    execution_configs = []
    values = dict()
    # update execution_configuration
    for widget in window:
        if isinstance(widget, ptg.InputField):
            values[widget.prompt] = widget.value
            continue

        if isinstance(widget, ptg.Container):
            label, field = iter(widget)
            values[label.value] = field.value
    values["ID"] = execution_configuration.id
    execution_configuration.init_from_values(values)

    #execution_configs.append(new_config)

    # load old configs and overwrite the modified config
    with open(os.path.join(config_dir, "run_configurations.txt"), "r") as f:
        file_contents = f.read()
    loaded_dicts: List[dict] = []
    if len(file_contents) > 0:
        loaded_dicts = jsons.loads(file_contents)
    for config in loaded_dicts:
        exec_config = ExecutionConfiguration()
        exec_config.init_from_dict(config)
        if exec_config.id == execution_configuration.id:
            # add updated execution_configuration instead of loaded version
            execution_configs.append(execution_configuration)
        else:
            # add loaded exec_config
            execution_configs.append(exec_config)
    # overwrite configs file
    json_dump_str = jsons.dumps(execution_configs)

    if not os.path.isfile(os.path.join(config_dir, "run_configurations.txt")):
        raise ValueError(os.path.join(config_dir, "run_configurations.txt"))
    os.remove(os.path.join(config_dir, "run_configurations.txt"))
    with open(os.path.join(config_dir, "run_configurations.txt"), "w+") as f:
        f.write(json_dump_str)
    # restart Wizard to load new execution configurations
    manager.stop()
    wizard.clear_window_stacks()
    wizard.initialize_screen(config_dir)
