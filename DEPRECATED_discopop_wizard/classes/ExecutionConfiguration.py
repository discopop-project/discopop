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
import subprocess
import tkinter as tk
from json import JSONDecodeError
from tkinter import filedialog
from typing import TextIO, List, Dict, Tuple, Any

import jsons  # type:ignore

from DEPRECATED_discopop_wizard.screens.execution import ExecutionView
from DEPRECATED_discopop_wizard.screens.optimizer.binding import create_optimizer_screen
from DEPRECATED_discopop_wizard.screens.suggestions.overview import (
    show_suggestions_overview_screen,
    get_suggestion_objects,
)
from DEPRECATED_discopop_wizard.screens.utils import create_tool_tip


class ExecutionConfiguration(object):
    button: tk.Button
    value_dict: Dict[str, Any]

    def __init__(self, wizard):
        self.value_dict = {
            "label": "",
            "description": "",
            "executable_name": "",
            "executable_arguments": "",
            "make_flags": "",
            "project_path": "",
            "linker_flags": "",
            "make_target": "",
            "memory_profiling_skip_function_parameters": 0,
            "notes": "",
            "working_copy_path": "",
            "tags": "",
            "explorer_flags": "--json=patterns.json --dump-detection-result",
        }
        self.value_dict["id"] = "".join(random.choices(string.ascii_uppercase + string.digits, k=8))
        self.wizard = wizard

        # self.__extract_values_from_help_string()

    def __extract_values_from_help_string(self):
        """Read help strings of:
        - DiscoPoP Explorer
        - runDiscoPoP script
        in order to automatically determine the required and optional arguments"""
        targets: List[Tuple[str, str]] = [  # [(name, executable)]
            ("rundiscopop", self.wizard.settings.discopop_build_dir + "/scripts/runDiscoPoP"),
            ("explorer", "discopop_explorer"),
        ]
        for target_name, target_executable in targets:
            # get help string
            tmp = subprocess.run([target_executable, "--help"], stdout=subprocess.PIPE)
            help_string = tmp.stdout.decode("utf-8")
            for line in help_string.split("\n"):
                line = line.replace("\t", " ")
                while "  " in line:
                    line = line.replace("  ", " ")
                if line.startswith(" "):
                    line = line[1:]
                if not line.startswith("* --"):
                    continue
                line = line[4:]  # cut off '* --'
                # extract name and type
                name_cutoff_index = len(line)
                if " " in line:
                    name_cutoff_index = min(name_cutoff_index, line.index(" "))
                if "=" in line:
                    name_cutoff_index = min(name_cutoff_index, line.index("="))
                value_name = line[:name_cutoff_index]
                if value_name == "help":
                    continue
                line = line[name_cutoff_index:]
                # extract type if present
                value_type = "bool"
                if "<" in line and ">" in line:
                    left_index = line.index("<") + 1
                    right_index = line.index(">")
                    value_type = line[left_index:right_index]
                # add value to dictionaries
                self.value_dict[target_name + "_" + value_name] = ""
                # self.type_dict[target_name + "_" + value_name] = value_type

    def get_as_button(self, wizard, main_screen_obj, parent_frame: tk.Frame, all_buttons: List[tk.Button]) -> tk.Button:
        button = tk.Button(parent_frame, text=self.value_dict["label"])
        button.config(
            command=lambda: self.highlight_and_update_notebook_screens(wizard, main_screen_obj, button, all_buttons)
        )
        self.button = button
        return button

    def init_from_json(self, json_file: TextIO):
        json_str = ""
        for line in json_file.readlines():
            json_str += line
        self.value_dict = {**self.value_dict, **jsons.loads(json_str)}  # merge both dictionaries

    def get_values_as_json_string(self):
        """returns a representation of the settings which will be stored in a configuration file."""
        return jsons.dumps(self.value_dict)

    def highlight_and_update_notebook_screens(
        self, wizard, main_screen_obj, pressed_button: tk.Button, all_buttons: List[tk.Button]
    ):
        # remove previous highlights
        for configuration_button in all_buttons:
            configuration_button.configure(state=tk.NORMAL)

        # highlight pressed configuration button
        pressed_button.configure(state=tk.DISABLED)

        # update details screen of pressed configuration button
        self.show_details_screen(wizard, main_screen_obj)

        # update results screen of pressed configuration button and set results tab state based on result existence
        main_screen_obj.notebook.tab(main_screen_obj.results_frame, state=self.__button_state_from_result_existence())
        main_screen_obj.notebook.tab(main_screen_obj.optimizer_frame, state=self.__button_state_from_result_existence())

        if self.__button_state_from_result_existence() == "normal":
            show_suggestions_overview_screen(wizard, main_screen_obj.results_frame, self)
        if self.__button_state_from_result_existence() == "normal":
            create_optimizer_screen(wizard, main_screen_obj.optimizer_frame, self)

    def show_details_screen(self, wizard, main_screen_obj):
        # delete previous frame contents
        for c in main_screen_obj.details_frame.winfo_children():
            c.destroy()

        frame = tk.Frame(main_screen_obj.details_frame)
        frame.grid(row=1, column=2)

        canvas = tk.Canvas(frame)
        canvas.grid(row=1)

        # show labels
        tk.Label(canvas, text="Label:", justify=tk.RIGHT, anchor="e", font=wizard.style_font_bold_small).grid(
            row=1, column=1, sticky="ew"
        )
        tk.Label(canvas, text="Description", justify=tk.RIGHT, anchor="e").grid(row=2, column=1, sticky="ew")
        tk.Label(
            canvas,
            text="Executable name:",
            justify=tk.RIGHT,
            anchor="e",
            font=wizard.style_font_bold_small,
        ).grid(row=3, column=1, sticky="ew")
        tk.Label(canvas, text="Executable arguments:", justify=tk.RIGHT, anchor="e").grid(row=4, column=1, sticky="ew")
        tk.Label(canvas, text="Make flags:", justify=tk.RIGHT, anchor="e").grid(row=5, column=1, sticky="ew")
        tk.Label(
            canvas,
            text="Project path:",
            justify=tk.RIGHT,
            anchor="e",
            font=wizard.style_font_bold_small,
        ).grid(row=6, column=1, sticky="ew")
        tk.Label(canvas, text="Project linker flags:", justify=tk.RIGHT, anchor="e").grid(row=7, column=1, sticky="ew")
        tk.Label(canvas, text="Make target:", justify=tk.RIGHT, anchor="e").grid(row=8, column=1, sticky="ew")
        tk.Label(
            canvas,
            text="Memory Profiling:",
            justify=tk.RIGHT,
            anchor="e",
            font=wizard.style_font_bold_small,
        ).grid(row=9, column=1, sticky="ew")
        tk.Label(canvas, text="Skip function params:", justify=tk.RIGHT, anchor="e").grid(row=10, column=1, sticky="ew")
        tk.Label(
            canvas,
            text="Additional:",
            justify=tk.RIGHT,
            anchor="e",
            font=wizard.style_font_bold_small,
        ).grid(row=11, column=1, sticky="ew")
        tk.Label(canvas, text="Tags:", justify=tk.RIGHT, anchor="e").grid(row=12, column=1, sticky="ew")
        tk.Label(canvas, text="Notes:", justify=tk.RIGHT, anchor="e").grid(row=13, column=1, sticky="ew")

        # show input fields
        label = tk.Entry(canvas)
        label.grid(row=1, column=2, sticky="ew")
        label.insert(tk.END, self.value_dict["label"])
        create_tool_tip(label, "Name of the configuration. Used to distinguish configurations in the main menu.")

        description = tk.Entry(canvas)
        description.grid(row=2, column=2, sticky="ew")
        description.insert(tk.END, self.value_dict["description"])

        executable_name = tk.Entry(canvas)
        executable_name.insert(tk.END, self.value_dict["executable_name"])
        executable_name.grid(row=3, column=2, sticky="ew")
        create_tool_tip(
            executable_name,
            "Name of the executable which is created when building the target project. The name will be "
            "used to execute the configuration.",
        )

        executable_args = tk.Entry(canvas)
        executable_args.grid(row=4, column=2, sticky="ew")
        executable_args.insert(tk.END, self.value_dict["executable_arguments"])
        create_tool_tip(
            executable_args,
            "Specify arguments which shall be forwarded to the call of the created executable for the " "profiling.",
        )

        make_flags = tk.Entry(canvas)
        make_flags.grid(row=5, column=2, sticky="ew")
        make_flags.insert(tk.END, str(self.value_dict["make_flags"]))
        create_tool_tip(
            make_flags,
            "Specified flags will be forwarded to Make during the build of the target project.",
        )

        project_path = tk.Entry(canvas)
        project_path.grid(row=6, column=2, sticky="ew")
        project_path.insert(tk.END, self.value_dict["project_path"])
        create_tool_tip(project_path, "Path to the project which shall be analyzed for potential parallelism.")

        def overwrite_with_selection(target: tk.Entry):
            prompt_result = tk.filedialog.askdirectory()
            if len(prompt_result) != 0:
                target.delete(0, tk.END)
                target.insert(0, prompt_result)

        project_path_selector = tk.Button(canvas, text="Select", command=lambda: overwrite_with_selection(project_path))
        project_path_selector.grid(row=6, column=3)

        project_linker_flags = tk.Entry(canvas)
        project_linker_flags.grid(row=7, column=2, sticky="ew")
        project_linker_flags.insert(tk.END, self.value_dict["linker_flags"])
        create_tool_tip(
            project_linker_flags,
            "Linker flags which need to be passed to the build system in order to create a valid " "executable.",
        )

        make_target = tk.Entry(canvas)
        make_target.grid(row=8, column=2, sticky="ew")
        make_target.insert(tk.END, self.value_dict["make_target"])
        create_tool_tip(make_target, "Space-separated list of make targets to be created.")

        mpsfp_var = tk.IntVar()
        mpsfp_var.set(self.value_dict["memory_profiling_skip_function_parameters"])
        memory_profiling_skip_function_parameters = tk.Checkbutton(canvas, onvalue=1, offvalue=0, variable=mpsfp_var)
        memory_profiling_skip_function_parameters.grid(row=10, column=2, sticky="w")
        create_tool_tip(
            memory_profiling_skip_function_parameters,
            "Disables the memory profiling for function arguments.\n\n"
            "Depending on the application, this may lead to significant profiling runtime\n"
            "improvements, but the correctness of the results can not be guaranteed anymore!\n"
            "Use this mode with caution, and be aware of potential issues!",
        )

        tags = tk.Entry(canvas)
        tags.grid(row=12, column=2, sticky="ew")
        tags.insert(tk.END, self.value_dict["tags"])
        create_tool_tip(tags, "Space-separated list of tags for identification.")

        additional_notes = tk.Text(canvas, height=10)
        additional_notes.grid(row=13, column=2, sticky="ew")
        additional_notes.insert(tk.END, self.value_dict["notes"])
        create_tool_tip(additional_notes, "Can be used to store notes regarding the configuration.")

        # show buttons
        button_canvas = tk.Canvas(frame)
        button_canvas.grid(row=2)
        # Create "Save" button
        save_button = tk.Button(
            button_canvas,
            text="Save",
            command=lambda: self.save_changes(
                wizard,
                main_screen_obj,
                label,
                description,
                executable_name,
                executable_args,
                make_flags,
                project_path,
                project_linker_flags,
                make_target,
                mpsfp_var,
                tags,
                additional_notes,
            ),
        )
        save_button.grid(row=1, column=1)

        # Create "Delete" button
        delete_button = tk.Button(
            button_canvas,
            text="Delete",
            command=lambda: self.delete_configuration(wizard, main_screen_obj, frame),
        )
        delete_button.grid(row=1, column=2)

        # Create "Open Folder" button
        if os.path.exists(os.path.join(project_path.get(), ".discopop")):
            target_path = os.path.join(project_path.get(), ".discopop")
        else:
            target_path = project_path.get()
        open_project_folder_button = tk.Button(
            button_canvas,
            text="Open Folder",
            command=lambda: os.system(
                "xdg-open "
                + str(
                    os.path.join(project_path.get(), ".discopop")
                    if os.path.exists(os.path.join(project_path.get(), ".discopop"))
                    else project_path.get()
                )
            ),
        )
        open_project_folder_button.grid(row=1, column=3)

        # Create "Execute" button
        execute_button = tk.Button(
            button_canvas,
            text="Execute",
            command=lambda: self.execute_configuration(
                wizard,
                main_screen_obj,
                label,
                description,
                executable_name,
                executable_args,
                make_flags,
                project_path,
                project_linker_flags,
                make_target,
                mpsfp_var,
                tags,
                additional_notes,
            ),
        )
        execute_button.grid(row=1, column=4)

    def __button_state_from_result_existence(self) -> str:
        # check if suggestions can be loaded. If so, enable the button.
        # Else, disable it.
        try:
            suggestions = get_suggestion_objects(self.wizard, self)
        except FileNotFoundError:
            return "disabled"
        except JSONDecodeError:
            return "disabled"
        return "normal"

    def save_changes(
        self,
        wizard,
        main_screen_obj,
        label,
        description,
        executable_name,
        executable_args,
        make_flags,
        project_path,
        project_linker_flags,
        make_target,
        memory_profiling_skip_function_parameters,
        tags,
        additional_notes,
        rebuild_configurations_frame=True,
    ):
        # update execution configuration
        self.value_dict["label"] = label.get()
        self.value_dict["description"] = description.get()
        self.value_dict["executable_name"] = executable_name.get()
        self.value_dict["executable_arguments"] = executable_args.get()
        self.value_dict["make_flags"] = make_flags.get()
        self.value_dict["project_path"] = project_path.get()
        self.value_dict["working_copy_path"] = self.value_dict["project_path"] + "/.discopop"
        self.value_dict["linker_flags"] = project_linker_flags.get()
        self.value_dict["make_target"] = make_target.get()
        self.value_dict["memory_profiling_skip_function_parameters"] = memory_profiling_skip_function_parameters.get()
        self.value_dict["tags"] = tags.get()
        self.value_dict["notes"] = additional_notes.get("1.0", tk.END)

        # construct config path
        config_path = os.path.join(
            wizard.config_dir,
            "execution_configurations",
            str(self.value_dict["id"]) + "_" + self.value_dict["label"] + ".json",
        )
        # remove old config if present
        if os.path.exists(config_path):
            os.remove(config_path)
        # write config to file
        with open(config_path, "w+") as f:
            f.write(self.get_values_as_json_string())

        if rebuild_configurations_frame:  # used to prevent de-selecting button on execution
            main_screen_obj.build_configurations_frame(wizard)
        print("Saved configuration")
        self.wizard.console.print("Saved configuration")

    def delete_configuration(self, wizard, main_screen_obj, details_frame: tk.Frame):
        # delete configuration file if it exists
        config_path = os.path.join(
            wizard.config_dir,
            "execution_configurations",
            str(self.value_dict["id"]) + "_" + self.value_dict["label"] + ".json",
        )
        if os.path.exists(config_path):
            os.remove(config_path)

        main_screen_obj.build_configurations_frame(wizard)
        # remove details view
        for c in details_frame.winfo_children():
            c.destroy()

    def execute_configuration(
        self,
        wizard,
        main_screen_obj,
        label,
        description,
        executable_name,
        executable_args,
        make_flags,
        project_path,
        project_linker_flags,
        make_target,
        memory_profiling_skip_function_parameters,
        tags,
        additional_notes,
    ):
        # save changes
        self.save_changes(
            wizard,
            main_screen_obj,
            label,
            description,
            executable_name,
            executable_args,
            make_flags,
            project_path,
            project_linker_flags,
            make_target,
            memory_profiling_skip_function_parameters,
            tags,
            additional_notes,
            rebuild_configurations_frame=False,
        )

        # create execution view and update results frame
        ExecutionView(self, wizard, main_screen_obj.results_frame)
        # set results tab state based on result existence
        main_screen_obj.notebook.tab(main_screen_obj.results_frame, state=self.__button_state_from_result_existence())
        main_screen_obj.notebook.tab(main_screen_obj.optimizer_frame, state=self.__button_state_from_result_existence())

        # show results tab
        main_screen_obj.notebook.select(main_screen_obj.results_frame)
        # initialize optimizer tab
        create_optimizer_screen(wizard, main_screen_obj.optimizer_frame, self)

    def get_tags(self) -> List[str]:
        """Returns a list of strings which represents the tags assigned to the configuration."""
        return [tag for tag in self.value_dict["tags"].split(" ") if len(tag) != 0]
