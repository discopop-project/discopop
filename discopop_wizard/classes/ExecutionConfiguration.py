import os
import random
import string

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
        ptg.Label(value="[orange bold]Warning:"),
        ""
        "Execute will overwrite the current configuration and execute the modified version.",
        "",
        "",
        ["Save", lambda *_: save_changes(manager, body, config_dir, wizard, execution_configuration)],
        "",
        ["Execute", lambda *_: execute_configuration(manager, body, config_dir, wizard, execution_configuration)],
        "",
        ["Copy", lambda *_: copy_configuration(manager, body, config_dir, wizard, execution_configuration)],
        "",
        "Saves the currently inserted values into a copy of the configuration.",
        "",
        "",
        ["Delete", lambda *_: delete_configuration(manager, body, config_dir, wizard, execution_configuration)]
    ))
    manager.add(buttons, assign="body_buttons")
    wizard.push_body_buttons(buttons)


def save_changes(manager: ptg.WindowManager, window: ptg.Window, config_dir: str, wizard, execution_configuration, restart_wizard=True):
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
    # output to console
    wizard.print_to_console(manager, "Saved configuration " + values["ID"])
    # restart Wizard to load new execution configurations

    if restart_wizard:
        manager.stop()
        wizard.clear_window_stacks()
        wizard.initialize_screen(config_dir)


def copy_configuration(manager: ptg.WindowManager, window: ptg.Window, config_dir: str, wizard, execution_configuration):
    execution_configs: List[ExecutionConfiguration] = []
    values = dict()
    values["ID"] = ''.join(random.choices(string.ascii_uppercase + string.digits, k=8))
    for widget in window:
        if isinstance(widget, ptg.InputField):
            values[widget.prompt] = widget.value
            continue

        if isinstance(widget, ptg.Container):
            label, field = iter(widget)
            values[label.value] = field.value
    values["Label: "] = "Copy of " + values["Label: "]
    new_config = ExecutionConfiguration()
    new_config.init_from_values(values)
    execution_configs.append(new_config)
    # load old configs
    with open(os.path.join(config_dir, "run_configurations.txt"), "r") as f:
        file_contents = f.read()
    loaded_dicts: List[dict] = []
    if len(file_contents) > 0:
        loaded_dicts = jsons.loads(file_contents)
    for config in loaded_dicts:
        exec_config = ExecutionConfiguration()
        exec_config.init_from_dict(config)
        execution_configs.append(exec_config)
    # overwrite configs file
    json_dump_str = jsons.dumps(execution_configs)

    if not os.path.isfile(os.path.join(config_dir, "run_configurations.txt")):
        raise ValueError(os.path.join(config_dir, "run_configurations.txt"))
    os.remove(os.path.join(config_dir, "run_configurations.txt"))
    with open(os.path.join(config_dir, "run_configurations.txt"), "w+") as f:
        f.write(json_dump_str)
    # output to console
    wizard.print_to_console(manager, "Created copied configuration " + values["ID"])
    # restart Wizard to load new execution configurations
    manager.stop()
    wizard.clear_window_stacks()
    wizard.initialize_screen(config_dir)

def delete_configuration(manager: ptg.WindowManager, window: ptg.Window, config_dir: str, wizard, execution_configuration):
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
            # do not add execution_configuration to execution_configs
            # this results in a deletion of the configuration, since it is not written to the configuration file
            pass
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
    # output to console
    wizard.print_to_console(manager, "Deleted configuration " + values["ID"])
    # restart Wizard to load new execution configurations
    manager.stop()
    wizard.clear_window_stacks()
    wizard.initialize_screen(config_dir)

def execute_configuration(manager: ptg.WindowManager, window: ptg.Window, config_dir: str, wizard, execution_configuration):
    # read values from updates
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

    save_changes(manager, window, config_dir, wizard, execution_configuration, restart_wizard=False)

    execution_configuration.init_from_values(values)

    # assemble command for execution
    command = "echo 'THIS IS MY CALLSTRING ID: " + execution_configuration.id + "'"
    command = "sleep 5 && echo 'Done'"
    # output to console
    wizard.print_to_console(manager, "Executing command: " + str(command.split(" ")))

    # execute command
    import subprocess
    process = subprocess.Popen(command,
                               stdout=subprocess.PIPE,
                               stderr=subprocess.PIPE,
                               shell=True)
    stdout, stderr = process.communicate()
    stdout = stdout.decode('utf-8')
    stderr = stderr.decode('utf-8')

    print(stdout, stderr)
    wizard.print_to_console(manager, "STDERR:")
    wizard.print_to_console(manager, stderr)
    wizard.print_to_console(manager, "STDOUT:")
    wizard.print_to_console(manager, stdout)


    # restart Wizard to load new execution configurations
    manager.stop()
    wizard.clear_window_stacks()
    wizard.initialize_screen(config_dir)