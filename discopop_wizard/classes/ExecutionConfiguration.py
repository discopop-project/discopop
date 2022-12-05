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
import tkinter as tk
from json import JSONDecodeError
from tkinter import filedialog
from typing import TextIO

from discopop_wizard.screens.execution import ExecutionView
from discopop_wizard.screens.suggestions.overview import show_suggestions_overview_screen, get_suggestion_objects
from discopop_wizard.screens.utils import create_tool_tip


class ExecutionConfiguration(object):
    # required
    id: str = ""
    label: str = ""
    description: str = ""
    executable_name: str = ""
    executable_arguments: str = ""
    project_path: str = ""
    working_copy_path: str = ""
    linker_flags: str = ""
    make_flags: str = ""
    # optional
    notes: str = ""
    make_target: str = ""
    explorer_flags: str = "--json=patterns.json"

    def __init__(self, wizard):
        self.id = ''.join(random.choices(string.ascii_uppercase + string.digits, k=8))
        self.wizard = wizard

    def get_as_button(self, wizard, main_screen_obj, parent_frame: tk.Frame, ) -> tk.Button:
        button = tk.Button(parent_frame, text=self.label,
                           command=lambda: self.show_details_screen(wizard, main_screen_obj))
        return button

    def init_from_dict(self, loaded: dict):
        for key in loaded:
            self.__dict__[key] = loaded[key]

    def init_from_script(self, script: TextIO):
        for line in script.readlines():
            line = line.replace("\n", "")
            if line.startswith("#ID="):
                self.id = line[line.index("=") + 1:]
            if line.startswith("#LABEL="):
                self.label = line[line.index("=") + 1:]
            if line.startswith("#DESCRIPTION="):
                self.description = line[line.index("=") + 1:]
            if line.startswith("#EXE_NAME="):
                self.executable_name = line[line.index("=") + 1:]
            if line.startswith("#EXE_ARGS="):
                self.executable_arguments = line[line.index("=") + 1:]
            if line.startswith("#MAKE_FLAGS="):
                self.make_flags = line[line.index("=") + 1:]
            if line.startswith("#PROJECT_PATH="):
                self.project_path = line[line.index("=") + 1:]
                self.working_copy_path = self.project_path + "/.discopop"
            if line.startswith("#PROJECT_LINKER_FLAGS="):
                self.linker_flags = line[line.index("=") + 1:]
            if line.startswith("#MAKE_TARGET="):
                self.make_target = line[line.index("=") + 1:]
            if line.startswith("#NOTES="):
                self.notes = line[line.index("=") + 1:]

    def init_from_values(self, values: dict):
        """values stems from reading the 'add_configuration' form."""
        for key in values:
            values[key] = values[key].replace("\n", ";;")
        self.id = values["ID"]
        self.label = values["Label: "]
        self.description = values["Description: "]
        self.executable_name = values["Executable name: "]
        self.executable_arguments = values["Executable arguments: "]
        self.make_flags = values["Make flags: "]
        self.project_path = values["Project path: "]
        self.working_copy_path = self.project_path + "/.discopop"
        self.linker_flags = values["Project linker flags: "]
        self.notes = values["Additional notes:"]
        self.make_target = values["Make target: "]

    def get_as_executable_script(self) -> str:
        """returns a representation of the configuration which will be stored in a script file
         and thus can be executed by the wizard as well as via a regular invocation."""
        # define string representation of the current configuration
        config_str = "### BEGIN CONFIG ###\n"
        config_str += "#ID=" + self.id + "\n"
        config_str += "#LABEL=" + self.label + "\n"
        config_str += "#DESCRIPTION=" + self.description + "\n"
        config_str += "#EXE_NAME=" + self.executable_name + "\n"
        config_str += "#EXE_ARGS=" + self.executable_arguments + "\n"
        config_str += "#MAKE_FLAGS=" + self.make_flags + "\n"
        config_str += "#PROJECT_PATH=" + self.project_path + "\n"
        config_str += "#PROJECT_LINKER_FLAGS=" + self.linker_flags + "\n"
        config_str += "#MAKE_TARGET=" + self.make_target + "\n"
        config_str += "#NOTES=" + self.notes + "\n"
        config_str += "### END CONFIG ###\n\n"

        # assemble command for execution
        command = ""
        # settings
        command = self.wizard.settings.discopop_dir + "/scripts/runDiscoPoP "
        command += "--llvm-clang \"" + self.wizard.settings.clang + "\" "
        command += "--llvm-clang++ \"" + self.wizard.settings.clangpp + "\" "
        command += "--llvm-ar \"" + self.wizard.settings.llvm_ar + "\" "
        command += "--llvm-link \"" + self.wizard.settings.llvm_link + "\" "
        command += "--llvm-dis \"" + self.wizard.settings.llvm_dis + "\" "
        command += "--llvm-opt \"" + self.wizard.settings.llvm_opt + "\" "
        command += "--llvm-llc \"" + self.wizard.settings.llvm_llc + "\" "
        command += "--gllvm \"" + self.wizard.settings.go_bin + "\" "
        # execution configuration
        command += "--project \"" + self.project_path + "\" "
        command += "--linker-flags \"" + self.linker_flags + "\" "
        command += "--executable-name \"" + self.executable_name + "\" "
        command += "--executable-arguments \"" + self.executable_arguments + "\" "
        command += "--make-flags \"" + self.make_flags + "\" "
        command += "--explorer-flags \"" + self.explorer_flags + "\" "

        # add configuration to resulting string
        script_str = ""
        script_str += config_str
        # add invocation of actual executable to resulting string
        script_str += command
        return script_str

    def show_details_screen(self, wizard, main_screen_obj) -> tk.Frame:
        # delete previous frame contents
        for c in main_screen_obj.details_frame.winfo_children():
            c.destroy()

        frame = tk.Frame(main_screen_obj.details_frame)
        frame.grid(row=1, column=2)

        canvas = tk.Canvas(frame)
        canvas.grid(row=1)

        # show labels
        tk.Label(canvas, text="Label:", justify=tk.RIGHT, anchor="e", font=wizard.style_font_bold_small).grid(row=1,
                                                                                                              column=1,
                                                                                                              sticky='ew')
        tk.Label(canvas, text="Description", justify=tk.RIGHT, anchor="e").grid(row=2, column=1, sticky='ew')
        tk.Label(canvas, text="Executable name:", justify=tk.RIGHT, anchor="e", font=wizard.style_font_bold_small).grid(
            row=3, column=1, sticky='ew')
        tk.Label(canvas, text="Executable arguments:", justify=tk.RIGHT, anchor="e").grid(row=4, column=1, sticky='ew')
        tk.Label(canvas, text="Make flags:", justify=tk.RIGHT, anchor="e").grid(row=5, column=1, sticky='ew')
        tk.Label(canvas, text="Project path:", justify=tk.RIGHT, anchor="e", font=wizard.style_font_bold_small).grid(
            row=6, column=1, sticky='ew')
        tk.Label(canvas, text="Project linker flags:", justify=tk.RIGHT, anchor="e").grid(row=7, column=1, sticky='ew')
        tk.Label(canvas, text="Make target:", justify=tk.RIGHT, anchor="e").grid(row=8, column=1, sticky='ew')
        tk.Label(canvas, text="Additional notes:", justify=tk.RIGHT, anchor="e").grid(row=9, column=1, sticky='ew')

        # show input fields
        label = tk.Entry(canvas)
        label.grid(row=1, column=2, sticky='ew')
        label.insert(tk.END, self.label)
        create_tool_tip(label, "Name of the configuration. Used to distinguish configurations in the main menu.")

        description = tk.Entry(canvas)
        description.grid(row=2, column=2, sticky='ew')
        description.insert(tk.END, self.description)

        executable_name = tk.Entry(canvas)
        executable_name.insert(tk.END, self.executable_name)
        executable_name.grid(row=3, column=2, sticky='ew')
        create_tool_tip(executable_name,
                        "Name of the executable which is created when building the target project. The name will be "
                        "used to execute the configuration.")

        executable_args = tk.Entry(canvas)
        executable_args.grid(row=4, column=2, sticky='ew')
        executable_args.insert(tk.END, self.executable_arguments)
        create_tool_tip(executable_args,
                        "Specify arguments which shall be forwarded to the call of the created executable for the "
                        "profiling.")

        make_flags = tk.Entry(canvas)
        make_flags.grid(row=5, column=2, sticky='ew')
        make_flags.insert(tk.END, str(self.make_flags))
        create_tool_tip(make_flags, "Specified flags will be forwarded to Make during the build of the target project.")

        project_path = tk.Entry(canvas)
        project_path.grid(row=6, column=2, sticky='ew')
        project_path.insert(tk.END, self.project_path)
        create_tool_tip(project_path, "Path to the project which shall be analyzed for potential parallelism.")

        def overwrite_with_selection(target: tk.Entry):
            prompt_result = tk.filedialog.askdirectory()
            if len(prompt_result) != 0:
                target.delete(0, tk.END)
                target.insert(0, prompt_result)

        project_path_selector = tk.Button(canvas, text="Select", command=lambda: overwrite_with_selection(project_path))
        project_path_selector.grid(row=6, column=3)

        project_linker_flags = tk.Entry(canvas)
        project_linker_flags.grid(row=7, column=2, sticky='ew')
        project_linker_flags.insert(tk.END, self.linker_flags)
        create_tool_tip(project_linker_flags,
                        "Linker flags which need to be passed to the build system in order to create a valid "
                        "executable.")

        make_target = tk.Entry(canvas)
        make_target.grid(row=8, column=2, sticky='ew')
        make_target.insert(tk.END, self.make_target)

        additional_notes = tk.Text(canvas, height=10)
        additional_notes.grid(row=9, column=2, sticky='ew')
        additional_notes.insert(tk.END, self.notes)
        create_tool_tip(additional_notes, "Can be used to store notes regarding the configuration.")

        # show buttons
        button_canvas = tk.Canvas(frame)
        button_canvas.grid(row=2)
        save_button = tk.Button(button_canvas, text="Save",
                                command=lambda: self.save_changes(wizard, main_screen_obj, label,
                                                                  description, executable_name,
                                                                  executable_args, make_flags,
                                                                  project_path, project_linker_flags, make_target,
                                                                  additional_notes))
        save_button.grid(row=1, column=1)
        delete_button = tk.Button(button_canvas, text="Delete",
                                  command=lambda: self.delete_configuration(wizard, main_screen_obj, frame))
        delete_button.grid(row=1, column=2)

        execute_button = tk.Button(button_canvas, text="Execute",
                                   command=lambda: self.execute_configuration(wizard, main_screen_obj, label,
                                                                              description, executable_name,
                                                                              executable_args, make_flags,
                                                                              project_path, project_linker_flags,
                                                                              make_target,
                                                                              additional_notes))
        execute_button.grid(row=1, column=3)

        results_button = tk.Button(button_canvas, text="Show Results",
                                   state=self.__button_state_from_result_existence(),
                                   command=lambda: show_suggestions_overview_screen(wizard,
                                                                                    main_screen_obj.details_frame,
                                                                                    self))
        results_button.grid(row=1, column=4)

    def __button_state_from_result_existence(self) -> str:
        # check if suggestions can be loaded. If so, enable the button.
        # Else, disable it.
        try:
            suggestions = get_suggestion_objects(self)
        except FileNotFoundError:
            return "disabled"
        except JSONDecodeError:
            return "disabled"
        return "normal"

    def save_changes(self, wizard, main_screen_obj,
                     label: tk.Entry, description: tk.Entry, executable_name: tk.Entry, executable_args: tk.Entry,
                     make_flags: tk.Entry, project_path: tk.Entry, project_linker_flags: tk.Entry,
                     make_target: tk.Entry, additional_notes: tk.Entry):

        # update execution_configuration
        self.label = label.get()
        self.description = description.get()
        self.executable_name = executable_name.get()
        self.executable_arguments = executable_args.get()
        self.make_flags = make_flags.get()
        self.project_path = project_path.get()
        self.working_copy_path = self.project_path + "/.discopop"
        self.linker_flags = project_linker_flags.get()
        self.make_target = make_target.get()
        self.notes = additional_notes.get("1.0", tk.END)

        config_path = os.path.join(wizard.config_dir, "execution_configurations",
                                   str(self.id) + "_" + self.label + ".sh")
        # remove old config if present
        if os.path.exists(config_path):
            os.remove(config_path)
        # write config to file
        with open(config_path, "w+") as f:
            f.write(self.get_as_executable_script())

        main_screen_obj.build_configurations_frame(wizard)
        print("Saved configuration")

    def delete_configuration(self, wizard, main_screen_obj,
                             details_frame: tk.Frame):
        # delete configuration file if it exists
        config_path = os.path.join(wizard.config_dir, "execution_configurations",
                                   self.id + "_" + self.label + ".sh")
        if os.path.exists(config_path):
            os.remove(config_path)

        main_screen_obj.build_configurations_frame(wizard)
        # remove details view
        for c in details_frame.winfo_children():
            c.destroy()

    def execute_configuration(self, wizard, main_screen_obj,
                              label: tk.Entry, description: tk.Entry, executable_name: tk.Entry,
                              executable_args: tk.Entry,
                              make_flags: tk.Entry, project_path: tk.Entry, project_linker_flags: tk.Entry,
                              make_target: tk.Entry, additional_notes: tk.Entry):
        # save changes
        self.save_changes(wizard, main_screen_obj, label, description, executable_name,
                          executable_args, make_flags,
                          project_path, project_linker_flags, make_target,
                          additional_notes)

        # create execution view
        ExecutionView(self, wizard, main_screen_obj.details_frame)
