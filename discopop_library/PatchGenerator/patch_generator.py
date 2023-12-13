# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
import json
import os.path
import shutil
from typing import Dict

from discopop_library.CodeGenerator.CodeGenerator import from_json_strings
from discopop_library.JSONHandler.JSONHandler import read_patterns_from_json_to_json
from discopop_library.PatchGenerator.PatchGeneratorArguments import PatchGeneratorArguments
from discopop_library.PatchGenerator.from_configuration_file import from_configuration_file
from discopop_library.PatchGenerator.diffs import get_diffs_from_modified_code
from discopop_library.PathManagement.PathManagement import load_file_mapping


def run(arguments: PatchGeneratorArguments):
    if arguments.verbose:
        print("Started DiscoPoP Patch Generator...")
    if arguments.verbose:
        print("Creating patch_generator directory...")
    patch_generator_dir = os.path.join(os.getcwd(), "patch_generator")
    if not os.path.exists(patch_generator_dir):
        os.mkdir(patch_generator_dir)

    # for compatibility reasons, initialize the file to store applied patches if it doesn't exist already
    # create a directory for the patch applicator
    patch_applicator_dir = os.path.join(os.getcwd(), "patch_applicator")
    if not os.path.exists(patch_applicator_dir):
        if arguments.verbose:
            print("Creating patch_applicator directory...")
        os.mkdir(patch_applicator_dir)
    # create a file to store applied suggestions
    applied_suggestions_file = os.path.join(patch_applicator_dir, "applied_suggestions.json")
    if not os.path.exists(applied_suggestions_file):
        if arguments.verbose:
            print("Creating applied_suggestions.json file...")
        with open(applied_suggestions_file, "w+") as f:
            f.write(json.dumps({"applied": []}))

    pattern_file_path = os.path.join(os.getcwd(), "explorer", "patterns.json")
    if not os.path.exists(pattern_file_path):
        raise FileNotFoundError(
            "No pattern file found. Please execute the discopop_explorer in advance."
            + "\nExpected pattern file: "
            + pattern_file_path
        )
    file_mapping_path = os.path.join(os.getcwd(), "FileMapping.txt")
    if not os.path.exists(file_mapping_path):
        raise FileNotFoundError(
            "No file mapping found. Please execute the discopop_explorer in advance."
            + "\nExpected file: "
            + file_mapping_path
        )

    if arguments.verbose:
        print("Loading file mapping...")
    file_mapping = load_file_mapping(file_mapping_path)

    if arguments.verbose:
        print("Loading patterns...")
    patterns_by_type = read_patterns_from_json_to_json(pattern_file_path, [])
    if arguments.verbose:
        print("Patterns: ", patterns_by_type)

    # generate code modifications from configuration file if requested
    if arguments.from_configuration_file != "None":
        if arguments.verbose:
            print("Generating patches from configuration file...")
        from_configuration_file(file_mapping, patterns_by_type, arguments, patch_generator_dir)
        if arguments.verbose:
            print("Done.")
        return

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
    if arguments.verbose:
        print("Done.")
