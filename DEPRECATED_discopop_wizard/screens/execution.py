# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import subprocess
import tkinter as tk
from typing import Optional, cast

from DEPRECATED_discopop_wizard.classes.ProfilingContainer import ProfilingContainer
from DEPRECATED_discopop_wizard.screens.suggestions.overview import show_suggestions_overview_screen


class ExecutionView(object):
    def __init__(
        self,
        execution_configuration,
        wizard,
        details_frame: Optional[tk.Frame],
        headless_mode: bool = False,
    ):
        self.execution_configuration = execution_configuration
        self.wizard = wizard
        self.details_frame = details_frame
        self.headless_mode = headless_mode
        self.__execute()

    def __execute(self):
        # prepare environment
        if self.wizard.settings.use_docker_container_for_profiling:
            # start container if not already present. Required when enabling container usage after start of application.
            if self.wizard.profiling_container is None:
                self.wizard.profiling_container = ProfilingContainer(self.wizard)
            self.wizard.profiling_container.analyze_project(self)
            # todo add display of suggestions
            if not self.headless_mode:
                self.__show_suggestions()
        else:
            # prepare command
            command = self.__assemble_command_string()
            # execute command
            return_code = self.__execute_command(command)
            if return_code == 0:
                # show suggestions, stored in project_path/patterns.txt
                if not self.headless_mode:
                    self.__show_suggestions()

    def __assemble_command_string(self) -> str:
        # assemble command for regular execution
        command = ""
        # settings
        command = self.wizard.settings.discopop_build_dir + "/scripts/runDiscoPoP "
        command += '--llvm-clang "' + self.wizard.settings.clang + '" '
        command += '--llvm-clang++ "' + self.wizard.settings.clangpp + '" '
        command += '--llvm-ar "' + self.wizard.settings.llvm_ar + '" '
        command += '--llvm-link "' + self.wizard.settings.llvm_link + '" '
        command += '--llvm-dis "' + self.wizard.settings.llvm_dis + '" '
        command += '--llvm-opt "' + self.wizard.settings.llvm_opt + '" '
        command += '--llvm-llc "' + self.wizard.settings.llvm_llc + '" '
        command += '--gllvm "' + self.wizard.settings.go_bin + '" '
        # execution configuration
        command += '--project "' + self.execution_configuration.value_dict["project_path"] + '" '
        command += '--linker-flags "' + self.execution_configuration.value_dict["linker_flags"] + '" '
        command += '--executable-name "' + self.execution_configuration.value_dict["executable_name"] + '" '
        command += '--executable-arguments "' + self.execution_configuration.value_dict["executable_arguments"] + '" '
        command += '--make-flags "' + self.execution_configuration.value_dict["make_flags"] + '" '
        command += '--make-target "' + self.execution_configuration.value_dict["make_target"] + '" '
        command += (
            "--memory-profiling-skip-function-arguments "
            if self.execution_configuration.value_dict["memory_profiling_skip_function_parameters"] == 1
            else ""
        )
        command += '--explorer-flags "' + self.execution_configuration.value_dict["explorer_flags"] + '" '

        return command

    def __execute_command(self, command: str) -> int:
        with subprocess.Popen(command, stdout=subprocess.PIPE, bufsize=1, universal_newlines=True, shell=True) as p:
            if p.stdout is None:
                print("command execution was not successfull")
            else:
                for line in p.stdout:
                    line = line.replace("\n", "")
                    self.__print_to_console(line)
                    if not self.headless_mode:
                        self.wizard.console.print(line)
        if p.returncode != 0:
            self.__print_to_console("An error occurred during the execution!")  # Error message
            if not self.headless_mode:
                self.wizard.console.print("An error occurred during the execution!")
            for line in str(subprocess.CalledProcessError(p.returncode, p.args)).split("\n"):
                line = line.replace("\n", "")
                self.__print_to_console(line)
                if not self.headless_mode:
                    self.wizard.console.print(line)
        return p.returncode

    def __print_to_console(self, msg: str):
        print(msg)

    def __show_suggestions(self):
        show_suggestions_overview_screen(self.wizard, cast(tk.Frame, self.details_frame), self.execution_configuration)
