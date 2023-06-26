import os
import shlex
import shutil
import statistics
import string
import subprocess
import time
import warnings
from pathlib import Path
import random
from typing import Dict, cast, List, TextIO, Tuple

import jsonpickle  # type: ignore

from discopop_library.FileMapping.FileMapping import load_file_mapping
from discopop_library.discopop_optimizer.bindings.CodeStorageObject import CodeStorageObject


def execute_stored_models(arguments: Dict):
    """Collects and executes all models stored in the current project path"""
    print("Cleaning environment...")
    __initialize_measurement_directory(arguments)
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
        __compile(arguments, working_copy_dir, arguments["--compile-command"])
        __measure_and_execute(
            arguments, working_copy_dir, code_modifications.model_id, code_modifications.label
        )
        # __cleanup(working_copy_dir)


def execute_single_model(arguments: Dict):
    """Executes the single models specified by the given arguments"""
    print("Cleaning environment...")
    __initialize_measurement_directory(arguments)

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
    __compile(arguments, working_copy_dir, arguments["--compile-command"])
    __measure_and_execute(
        arguments, working_copy_dir, code_modifications.model_id, code_modifications.label
    )
    # __cleanup(working_copy_dir)


def __initialize_measurement_directory(arguments: Dict):
    measurement_dir = os.path.join(arguments["--project"], ".discopop_optimizer_measurements")
    if not arguments["--execution-append-measurements"]:
        # delete measurement directory
        if os.path.exists(measurement_dir):
            shutil.rmtree(measurement_dir)
    if not os.path.exists(measurement_dir):
        os.makedirs(measurement_dir)
    __initialize_measurement_file(os.path.join(measurement_dir, "measurements.csv"))


def __initialize_measurement_file(measurement_file: str):
    if not os.path.exists(measurement_file):
        with open(measurement_file, "w+") as f:
            # write file header
            header_line = "Test_case_id;Model_ID;Model_Label;return_code;Executable_name;Executable_arguments;execution_time;\n"
            f.write(header_line)


def __measure_and_execute(arguments: Dict, working_copy_dir: str, model_id: str, model_label: str):
    """Setup measurements, execute the compiled program and output the measurement results to a file"""
    measurement_dir = os.path.join(arguments["--project"], ".discopop_optimizer_measurements")
    # create output file for specific model measurement
    measurement_file = os.path.join(measurement_dir, "measurements.csv")

    with open(measurement_file, "a") as f:
        execution_times: List[float] = []
        test_case_id = "".join(random.choices(string.ascii_uppercase + string.digits, k=8))
        for execution_idx in range(0, int(arguments["--execution-repetitions"])):
            return_code, start_time, end_time = __execute(arguments, working_copy_dir, f)
            execution_time = end_time - start_time
            execution_times.append(execution_time)
            # write execution result
            execution_line = (
                test_case_id
                + ";"
                + model_id
                + ";"
                + model_label
                + ";"
                + str(return_code)
                + ";"
                + arguments["--executable-name"]
                + ";"
                + arguments["--executable-arguments"]
                + ";"
                + str(execution_time).replace(".", ",")
                + "\n"
            )
            f.write(execution_line)
            f.flush()

        print("\t\t\tREPS: ", len(execution_times))
        print("\t\t\tAVG: ", sum(execution_times) / len(execution_times))
        if len(execution_times) >= 2:
            print("\t\t\tVariance: ", statistics.variance(execution_times))


def __execute(
    arguments: Dict, working_copy_dir: str, measurements_file: TextIO
) -> Tuple[int, float, float]:
    """Executes the current model and returns the exit code as well as the start and end time of the execution"""
    print("\t\texecuting...")
    command = ["./" + arguments["--executable-name"], arguments["--executable-arguments"]]
    clean_command = [c for c in command if len(c) != 0]
    start_time = time.time()
    result = subprocess.run(
        clean_command,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        universal_newlines=True,
        cwd=working_copy_dir,
    )
    end_time = time.time()
    if str(result.returncode) != "0":
        warnings.warn("ERROR DURING EXECUTION...\n" + result.stderr)
    print("STDOUT: ")
    print(result.stdout)
    print("STDERR: ")
    print(result.stderr)
    return result.returncode, start_time, end_time


def __compile(arguments: Dict, working_copy_dir, compile_command):
    print("\t\tbuilding...")
    # command = compile_command
    command = shlex.split(compile_command)
    if len(arguments["--make-flags"]) != 0:
        command += shlex.split(arguments["--make-flags"])  # split string, consider quotes

    if len(arguments["--make-target"]) != 0:
        command += shlex.split(arguments["--make-target"])  # split string, consider quotes
    clean_command = [c for c in command if len(c) != 0]
    print("\t\t\tCommand: ", " ".join(clean_command))
    result = subprocess.run(
        clean_command,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        universal_newlines=True,
        cwd=working_copy_dir,
        shell=True
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
    for file_id in modifications.patches:
        file_mapping_path = str(file_mapping[int(file_id)])
        # remove /.discopop/ from path if it occurs
        if "/.discopop/" in file_mapping_path:
            file_mapping_path = file_mapping_path.replace("/.discopop/", "/")
        # get file to be overwritten
        replace_path = file_mapping_path.replace(project_folder, working_copy_dir)
        # apply patch to the file
        if not os.path.exists(replace_path):
            raise FileNotFoundError(replace_path)
        # save patch to disk
        patch = replace_path + ".patch"
        with open(patch, "w+") as p:
            p.write(modifications.patches[file_id])
            p.flush()
            p.close()

        # check existence of files:
        if os.path.exists(patch):
            print("PATCH FILE EXISTS")
        if os.path.exists(replace_path):
            print("REPLACE PATH EXISTS")

        # command = ["patch", "-i", patch, "-o", replace_path]
        command = ["patch", replace_path, patch]
        print("Patch command: ", command)

        result = subprocess.run(
            command,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            universal_newlines=True,
            cwd=os.getcwd(),
        )
        print("RESULT: ", result.returncode)
        print("STDERR:")
        print(result.stderr)
        print("STDOUT: ")
        print(result.stdout)

        if result.returncode == 0:
            print("Applied Patch:")
            print(modifications.patches[file_id])


# remove temporary patch file
# todo re-enable cleanup


#        if os.path.exists(patch):
#            os.remove(patch)


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
