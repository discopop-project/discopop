import json
import os.path
from pathlib import Path
import shutil
from typing import Dict, List
from discopop_library.CodeGenerator.CodeGenerator import from_json_strings
from discopop_library.PatchGenerator.PatchGeneratorArguments import PatchGeneratorArguments
from discopop_library.PatchGenerator.diffs import get_diffs_from_modified_code


def from_json_patterns(arguments: PatchGeneratorArguments, patterns_by_type: Dict[str, List[str]], file_mapping: List[Dict[int, Path]], patch_generator_dir: str):    
    # generate code modifications from each suggestion, create a patch and store the patch
    # using the suggestions unique id
    if arguments.verbose:
        print("Generating modified code...")
    for suggestion_type in patterns_by_type:
        for suggestion in patterns_by_type[suggestion_type]:
            if arguments.verbose:
                print("Suggestion: ", suggestion)
            file_id_to_modified_code: Dict[int, str] = from_json_strings(
                file_mapping,
                {suggestion_type: [suggestion]},
                CC=arguments.CC,
                CXX=arguments.CXX,
                skip_compilation_check=True,
            )
            # create patches from the modified codes
            file_id_to_patches: Dict[int, str] = get_diffs_from_modified_code(
                file_mapping, file_id_to_modified_code, arguments
            )
            if arguments.verbose:
                print("Patches: ", file_id_to_patches)
            # clear old results and save patches
            suggestion_dict = json.loads(suggestion)
            suggestion_id = suggestion_dict["pattern_id"]
            suggestion_folder_path = os.path.join(patch_generator_dir, str(suggestion_id))
            if arguments.verbose:
                print("Saving patches for suggestion: ", suggestion_id)
            if os.path.exists(suggestion_folder_path):
                shutil.rmtree(suggestion_folder_path)
            os.mkdir(suggestion_folder_path)
            for file_id in file_id_to_patches:
                patch_path = os.path.join(suggestion_folder_path, str(file_id) + ".patch")
                with open(patch_path, "w") as f:
                    f.write(file_id_to_patches[file_id])