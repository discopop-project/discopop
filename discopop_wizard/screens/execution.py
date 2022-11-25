import subprocess
import tkinter as tk

from discopop_wizard.screens.suggestions.overview import show_suggestions_overview_screen


class ExecutionView(object):

    def __init__(self, execution_configuration, wizard, details_frame: tk.Frame):
        self.execution_configuration = execution_configuration
        self.wizard = wizard
        self.details_frame = details_frame
        self.__execute()

    def __execute(self):
        # prepare command
        command = self.__assemble_command_string()
        # execute command
        return_code = self.__execute_command(command)
        print("Return Code: ", return_code)
        if return_code == 0:
            # show suggestions
            # suggestions are stored in project_path/patterns.txt
            self.__show_suggestions()
            # push_suggestion_overview_screen(manager, config_dir, wizard, execution_configuration)

    def __assemble_command_string(self) -> str:
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
        command += "--project \"" + self.execution_configuration.project_path + "\" "
        command += "--linker-flags \"" + self.execution_configuration.linker_flags + "\" "
        command += "--executable-name \"" + self.execution_configuration.executable_name + "\" "
        command += "--executable-arguments \"" + self.execution_configuration.executable_arguments + "\" "
        command += "--build-threads " + self.execution_configuration.build_threads + " "

        return command

    def __execute_command(self, command: str) -> int:
        with subprocess.Popen(command, stdout=subprocess.PIPE, bufsize=1, universal_newlines=True, shell=True) as p:
            for line in p.stdout:
                line = line.replace("\n", "")
                self.__print_to_console(line)
        if p.returncode != 0:
            self.__print_to_console("An error occurred during the execution!")  # Error message
            for line in str(subprocess.CalledProcessError(p.returncode, p.args)).split("\n"):
                line = line.replace("\n", "")
                self.__print_to_console(line)
        return p.returncode

    def __print_to_console(self, msg: str):
        print(msg)

    def __show_suggestions(self):
        show_suggestions_overview_screen(self)
