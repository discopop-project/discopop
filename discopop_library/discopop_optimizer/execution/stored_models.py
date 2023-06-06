import os
import shutil
from pathlib import Path
from typing import Dict, cast

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
        __compile(arguments)
        __cleanup(working_copy_dir)


def __compile(arguments: Dict):
    pass


def __apply_modifications(
    project_folder,
    working_copy_dir,
    modifications: CodeStorageObject,
    file_mapping: Dict[int, Path],
):
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
            f.write(modifications.modified_code[file_id])
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
