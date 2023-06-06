import os
import shutil
from pathlib import Path
from typing import Dict, List


def execute_stored_models(arguments: Dict):
    """Collects and executes all models stored in the current project path"""
    print("Executing stored models...")

    # create a copy of the original code
    print("\tCreating a working copy of the project...", end="")
    working_copy_dir = os.path.join(arguments["--project"], ".discopop_optimizer_code_copy")
    if os.path.exists(working_copy_dir):
        shutil.rmtree(working_copy_dir)
    shutil.copytree(
        str(arguments["--project"]), working_copy_dir, ignore=shutil.ignore_patterns(".discopop*")
    )
    print("Done")

    # collect models from path
    collected_model_paths: List[str] = []

    # remove working copy to free space
    print("\tRemoving working copy of the project...", end="")
    shutil.rmtree(working_copy_dir)
    print("Done.")
