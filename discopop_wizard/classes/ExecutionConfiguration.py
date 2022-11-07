# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import os
import random
import string

import jsons
from typing import List, TextIO

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

    def init_from_script(self, script: TextIO):
        for line in script.readlines():
            line = line.replace("\n", "")
            if line.startswith("ID="):
                self.id = line[line.index("=")+1:]
            if line.startswith("LABEL="):
                self.label = line[line.index("=")+1:]
            if line.startswith("DESCRIPTION="):
                self.description = line[line.index("=")+1:]
            if line.startswith("EXE_NAME="):
                self.executable_name = line[line.index("=")+1:]
            if line.startswith("EXE_ARGS="):
                self.executable_arguments = line[line.index("=")+1:]
            if line.startswith("THREAD_NUM="):
                self.threads = line[line.index("=")+1:]
            if line.startswith("PROJECT_BASE="):
                self.project_base_path = line[line.index("=")+1:]
            if line.startswith("PROJECT_SOURCE="):
                self.project_source = line[line.index("=")+1:]
            if line.startswith("PROJECT_BUILD="):
                self.project_build = line[line.index("=")+1:]
            if line.startswith("PROJECT_CONFIGURE_OPTIONS="):
                self.project_configure_options = line[line.index("=")+1:]
            if line.startswith("PROJECT_LINKER_FLAGS="):
                self.linker_flags = line[line.index("=")+1:]
            if line.startswith("NOTES="):
                self.notes = line[line.index("=")+1:]

    def init_from_values(self, values: dict):
        """values stems from reading the 'add_configuration' form."""
        for key in values:
            values[key] = values[key].replace("\n", ";;")
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

    def get_as_executable_script(self) -> str:
        """returns a representation of the configuration which will be stored in a script file
         and thus can be executed by the wizard as well as via a regular invocation."""
        # define string representation of the current configuration
        config_str = "### BEGIN CONFIG ###\n"
        config_str += "ID=" + self.id + "\n"
        config_str += "LABEL=" + self.label + "\n"
        config_str += "DESCRIPTION=" + self.description + "\n"
        config_str += "EXE_NAME=" + self.executable_name + "\n"
        config_str += "EXE_ARGS=" + self.executable_arguments + "\n"
        config_str += "THREAD_NUM=" + self.threads + "\n"
        config_str += "PROJECT_BASE=" + self.project_base_path + "\n"
        config_str += "PROJECT_SOURCE=" + self.project_source + "\n"
        config_str += "PROJECT_BUILD=" + self.project_build + "\n"
        config_str += "PROJECT_CONFIGURE_OPTIONS=" + self.project_configure_options + "\n"
        config_str += "PROJECT_LINKER_FLAGS=" + self.linker_flags + "\n"
        config_str += "NOTES=" + self.notes + "\n"
        config_str += "### END CONFIG ###\n\n"

        # define invocation string
        invocation_str = 'echo "HELLO WORLD FROM CONFIGURATION: ${LABEL}"\n'

        # add configuration to resulting string
        script_str = ""
        script_str += config_str
        # add invocation of actual executable to resulting string
        script_str += invocation_str
        return script_str



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

    buttons = (ptg.Window(
        ptg.Label(value="[orange bold]Warning:"),
        ""
        "Execute will overwrite the current configuration and execute the modified version.",
        "If the label has been modified, Save will result in a newly created run configuration.",
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
    wizard.show_body_windows(manager, [(body, 0.8), (buttons, 0.2)])


def save_changes(manager: ptg.WindowManager, window: ptg.Window, config_dir: str, wizard, execution_configuration, restart_wizard=True):
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

    config_path = os.path.join(config_dir, execution_configuration.id + "_" + execution_configuration.label + ".sh")
    # remove old config if present
    if os.path.exists(config_path):
        os.remove(config_path)
    # write config to file
    with open(config_path, "w+") as f:
        f.write(execution_configuration.get_as_executable_script())
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
    config_path = os.path.join(config_dir, new_config.id + "_" + new_config.label + ".sh")
    # remove old config if present
    if os.path.exists(config_path):
        os.remove(config_path)
    # write config to file
    with open(config_path, "w+") as f:
        f.write(new_config.get_as_executable_script())
    # output to console
    wizard.print_to_console(manager, "Created copied configuration " + values["ID"])
    # restart Wizard to load new execution configurations
    manager.stop()
    wizard.clear_window_stacks()
    wizard.initialize_screen(config_dir)


def delete_configuration(manager: ptg.WindowManager, window: ptg.Window, config_dir: str, wizard, execution_configuration):

    # delete configuration file if it exists
    config_path = os.path.join(config_dir, execution_configuration.id + "_" + execution_configuration.label + ".sh")
    if os.path.exists(config_path):
        os.remove(config_path)

    # output to console
    wizard.print_to_console(manager, "Deleted configuration " + execution_configuration.id)
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
    command = "sleep 0.1 && echo 0.1 && sleep 0.1 && echo 2 && sleep 1 && echo 3 && sleep 1 && echo 4 && sleep 0.1 && echo 5 && 1"
    # output to console
    wizard.print_to_console(manager, "Executing command: " + str(command.split(" ")))

    import subprocess
    with subprocess.Popen(command, stdout=subprocess.PIPE, bufsize=1, universal_newlines=True, shell=True) as p:
        for line in p.stdout:
            line = line.replace("\n", "")
            wizard.print_to_console(manager, line)
    if p.returncode != 0:
        wizard.print_to_console(manager, "An error occurred during the execution!", style=3)  # style 3 --> Error message
        for line in str(subprocess.CalledProcessError(p.returncode, p.args)).split("\n"):
            line = line.replace("\n", "")
            wizard.print_to_console(manager, line)

    # restart Wizard to load new execution configurations
    manager.stop()
    wizard.clear_window_stacks()
    wizard.initialize_screen(config_dir)