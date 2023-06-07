import os
import shlex
import shutil
import statistics
import subprocess
import time
import warnings
from datetime import datetime
from pathlib import Path
from typing import Dict, cast, List

import jsonpickle  # type: ignore

from discopop_library.FileMapping.FileMapping import load_file_mapping
from discopop_library.discopop_optimizer.bindings.CodeStorageObject import CodeStorageObject


def execute_stored_models(arguments: Dict):
    """Collects and executes all models stored in the current project path"""
    print("Executing stored models...")

    # collect models to be executed
    working_copy_dir = os.path.join(arguments["--project"], ".discopop_optimizer_code_copy")
    for file_name in os.listdir(str(arguments["--code-export-path"])):
        print("\t", file_name)
        __create_project_copy(arguments["--project"], working_copy_dir)
        code_modifications = __load_code_storage_object(
            os.path.join(str(arguments["--code-export-path"]), file_name)
        )
        __apply_modifications(
            arguments["--project"],
            working_copy_dir,
            code_modifications,
            load_file_mapping(arguments["--file-mapping"]),
        )
        __compile(arguments, working_copy_dir)
        __execute(arguments, working_copy_dir)
        __cleanup(working_copy_dir)


def execute_single_model(arguments: Dict):
    """Executes the single models specified by the given arguments"""
    print("Executing stored model...")

    # collect model to be executed
    working_copy_dir = os.path.join(arguments["--project"], ".discopop_optimizer_code_copy")
    file_name = arguments["--execute-single-model"]
    print("\t", file_name)
    __create_project_copy(arguments["--project"], working_copy_dir)
    code_modifications = __load_code_storage_object(
        os.path.join(str(arguments["--code-export-path"]), file_name)
    )
    __apply_modifications(
        arguments["--project"],
        working_copy_dir,
        code_modifications,
        load_file_mapping(arguments["--file-mapping"]),
    )
    __compile(arguments, working_copy_dir)
    __execute(arguments, working_copy_dir)
    __cleanup(working_copy_dir)


def __execute(arguments: Dict, working_copy_dir):
    print("\t\texecuting...")
    command = ["./" + arguments["--executable-name"], arguments["--executable-arguments"]]
    clean_command = [c for c in command if len(c) != 0]
    execution_times: List[float] = []
    for execution_idx in range(0, int(arguments["--execution-repetitions"])):
        start_time = time.time()
        result = subprocess.run(
            clean_command,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            universal_newlines=True,
            cwd=working_copy_dir,
        )
        end_time = time.time()
        execution_times.append(end_time - start_time)
        if str(result.returncode) != "0":
            warnings.warn("ERROR DURING EXECUTION...\n" + result.stderr)
        print("STDOUT: ")
        print(result.stdout)
        print("STDERR: ")
        print(result.stderr)
    print("\t\t\tREPS: ", len(execution_times))
    print("\t\t\tAVG: ", sum(execution_times) / len(execution_times))
    if len(execution_times) >= 2:
        print("\t\t\tVariance: ", statistics.variance(execution_times))


def __compile(arguments: Dict, working_copy_dir):
    print("\t\tbuilding...")
    command = ["make"]
    if len(arguments["--make-flags"]) != 0:
        command += shlex.split(arguments["--make-flags"])  # split string, consider quotes

    if len(arguments["--make-target"]) != 0:
        command += shlex.split(arguments["--make-target"])  # split string, consider quotes
    clean_command = [c for c in command if len(c) != 0]
    print("\t\t\tCommand: ", clean_command)
    result = subprocess.run(
        clean_command,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        universal_newlines=True,
        cwd=working_copy_dir,
    )
    print("STDOUT: ")
    print(result.stdout)
    print("STDERR: ")
    print(result.stderr)
    if str(result.returncode) != "0":
        warnings.warn("ERROR / WARNING DURING Compilation...\n" + result.stderr)


def __apply_modifications(
    project_folder,
    working_copy_dir,
    modifications: CodeStorageObject,
    file_mapping: Dict[int, Path],
):
    print("\t\tApplying code modifications...")
    print("\t\t\tFunction: ", modifications.parent_function.name)
    for file_id in modifications.modified_code:
        file_mapping_path = str(file_mapping[int(file_id)])
        # remove /.discopop/ from pat if it occurs
        if "/.discopop/" in file_mapping_path:
            file_mapping_path = file_mapping_path.replace("/.discopop/", "/")
        # get file to be overwritten
        replace_path = file_mapping_path.replace(project_folder, working_copy_dir)
        # overwrite file
        if not os.path.exists(replace_path):
            raise FileNotFoundError(replace_path)
        with open(replace_path, "w") as f:
            modified_code = modifications.modified_code[file_id]
            for line in modified_code.split("\n"):
                if "#pragma omp" in line:
                    print("\t\t\t--> ", line)

            f.write(modified_code)
            f.flush()
            f.close()


def __load_code_storage_object(file_path) -> CodeStorageObject:
    json_contents = ""
    with open(file_path, "r") as f:
        json_contents = f.read()
    return cast(CodeStorageObject, jsonpickle.decode(json_contents))


def __create_project_copy(source, target):
    print("\t\tCreating a working copy of the project...", end="")
    if os.path.exists(target):
        shutil.rmtree(target)
    shutil.copytree(str(source), target, ignore=shutil.ignore_patterns(".discopop*"))
    print("Done")


def __cleanup(working_copy_dir: str):
    # remove working copy to free space
    print("\t\tRemoving working copy of the project...", end="")
    shutil.rmtree(working_copy_dir)
    print("Done.")
