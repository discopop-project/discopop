# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import glob
import os
import pathlib
import shutil
import subprocess
import tkinter


class ProfilingContainer(object):
    def __init__(self, wizard):
        self.wizard = wizard
        self.start()

    def start(self):
        docker_context_path = os.path.join(
            pathlib.Path(__file__).parent.resolve(), "..", "assets", "profiling_container"
        )
        self.__execute_command("docker kill discopop_container")
        self.__execute_command("docker rm discopop_container")
        exit_code = self.__execute_command(
            "docker build -t discopop_container " + docker_context_path
        )
        assert exit_code == 0
        exit_code = self.__execute_command(
            "docker run --name discopop_container -d -t discopop_container"
        )
        assert exit_code == 0

    def stop(self):
        print("Stopping DiscoPoP profiling container...")
        self.__execute_command("docker kill discopop_container")
        print("Done.")

    def remove_project_folder(self):
        self.__execute_command("docker exec -it discopop_container rm -rvf /project")

    def remove_previous_results(self, target_folder):
        files = glob.glob(target_folder + "/*")
        for f in files:
            if os.path.exists(f):
                if os.path.isfile(f):
                    os.remove(f)
                else:
                    shutil.rmtree(f)

    def copy_project_folder_to_container(self, project_path: str):
        self.remove_project_folder()
        self.__execute_command("docker cp " + project_path + " discopop_container:/project")

    def copy_results_from_container(self, target_path: str, execution_view):
        result_files = [
            "FileMapping.txt",
            "Data.xml",
            "loop_counter_output.txt",
            "reduction.txt",
            execution_view.execution_configuration.value_dict["executable_name"] + "_dp_dep.txt",
            execution_view.execution_configuration.value_dict["executable_name"] + "_dp.ll",
            "patterns.txt",
            "patterns.json",
        ]
        for file in result_files:
            exit_code = self.__execute_command(
                "docker cp discopop_container:/project/.discopop/" + file + " " + target_path
            )
            assert exit_code == 0

    def analyze_project(self, execution_view):
        # copy project folder to container. Note: mounting would be nicer but requires restarting the container.
        # might be a nicer solution in the long run, especially for larger projects
        self.copy_project_folder_to_container(
            execution_view.execution_configuration.value_dict["project_path"]
        )

        # settings
        command = "/discopop/build/scripts/runDiscoPoP "
        command += "--llvm-clang clang-11 "
        command += "--llvm-clang++ clang++-11 "
        command += "--llvm-ar llvm-ar-11 "
        command += "--llvm-link llvm-link-11 "
        command += "--llvm-dis llvm-dis-11 "
        command += "--llvm-opt opt-11 "
        command += "--llvm-llc llc-11 "
        command += "--gllvm /software/go/bin "
        # execution configuration
        command += "--project /project "
        command += (
            '--linker-flags "'
            + execution_view.execution_configuration.value_dict["linker_flags"]
            + '" '
        )
        command += (
            '--executable-name "'
            + execution_view.execution_configuration.value_dict["executable_name"]
            + '" '
        )
        command += (
            '--executable-arguments "'
            + execution_view.execution_configuration.value_dict["executable_arguments"]
            + '" '
        )
        command += (
            '--make-flags "'
            + execution_view.execution_configuration.value_dict["make_flags"]
            + '" '
        )
        command += (
            '--make-target "'
            + execution_view.execution_configuration.value_dict["make_target"]
            + '" '
        )
        command += (
            '--explorer-flags "'
            + execution_view.execution_configuration.value_dict["explorer_flags"]
            + '" '
        )

        self.__execute_command("docker exec -it discopop_container " + command)

        # copy results from container into working copy path
        if not os.path.exists(
            execution_view.execution_configuration.value_dict["working_copy_path"]
        ):
            os.mkdir(execution_view.execution_configuration.value_dict["working_copy_path"])

        # remove previous results
        self.remove_previous_results(
            execution_view.execution_configuration.value_dict["working_copy_path"]
        )

        # copy results from container
        self.copy_results_from_container(
            execution_view.execution_configuration.value_dict["working_copy_path"], execution_view
        )

        # correct paths in generated FileMapping.txt
        self.__correct_file_mapping_paths(execution_view)

    def __correct_file_mapping_paths(self, execution_view):
        file_mapping_path = os.path.join(
            execution_view.execution_configuration.value_dict["working_copy_path"],
            "FileMapping.txt",
        )
        with open(file_mapping_path, "r") as file:
            contents = file.read()
        contents = contents.replace(
            "/project/.discopop", execution_view.execution_configuration.value_dict["project_path"]
        )
        with open(file_mapping_path, "w") as file:
            file.write(contents)

    def __execute_command(self, command: str) -> int:
        with subprocess.Popen(
            command, stdout=subprocess.PIPE, bufsize=1, universal_newlines=True, shell=True
        ) as p:
            if p.stdout is None:
                print("executing command was not successfull")
            else:
                for line in p.stdout:
                    line = line.replace("\n", "")
                    print(line)
                    try:
                        self.wizard.console.print(line)
                    except tkinter.TclError:
                        # happens when container is still shutting down but interface already closed.
                        pass
        if p.returncode != 0:
            print("An error occurred during the execution!")  # Error message
            self.wizard.console.print("An error occurred during the execution!")
            for line in str(subprocess.CalledProcessError(p.returncode, p.args)).split("\n"):
                line = line.replace("\n", "")
                print(line)
                self.wizard.console.print(line)
        return p.returncode
