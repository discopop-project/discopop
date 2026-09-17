# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
import json
import os

from discopop_library.FolderStructure.setup import setup_patch_applicator
from discopop_library.PatchApplicator.PatchApplicatorArguments import PatchApplicatorArguments
from discopop_library.PatchApplicator.apply import apply_patches
from discopop_library.PatchApplicator.clear import clear_patches
from discopop_library.PatchApplicator.list import list_applied_suggestions
from discopop_library.PatchApplicator.load import load_patches
from discopop_library.PatchApplicator.rollback import rollback_patches
from discopop_library.PathManagement.PathManagement import load_file_mapping


def run(arguments: PatchApplicatorArguments) -> int:
    """Return values:"
    "0: Applied successfully"
    "1: Nothing applied, error"
    "2: Some changes applied successfully"
    "3: Nothing to roll back, trivially successful"
    """

    if arguments.verbose:
        print("Started DiscoPoP Patch Applicator...")
        print("Working directory: ", os.getcwd())
        print(arguments)

    setup_patch_applicator(os.getcwd())
    patch_applicator_dir = os.path.join(os.getcwd(), "patch_applicator")
    applied_suggestions_file = os.path.join(patch_applicator_dir, "applied_suggestions.json")

    # load file mapping
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

    # check if patches have been generated
    patch_generator_dir = os.path.join(os.getcwd(), "patch_generator")
    if not os.path.exists(patch_generator_dir):
        raise FileNotFoundError(
            "No patches have been generated.\n"
            + "Please execute the discopop_patch_generator in advance.\n"
            + "Expected folder: "
            + patch_generator_dir
        )

    # handle arguments
    retval = 0
    if len(arguments.apply) > 0:
        retval = apply_patches(arguments.apply, file_mapping, arguments, applied_suggestions_file, patch_generator_dir)
    elif len(arguments.rollback) > 0:
        retval = rollback_patches(
            arguments.rollback, file_mapping, arguments, applied_suggestions_file, patch_generator_dir
        )
    elif arguments.clear:
        retval = clear_patches(file_mapping, arguments, applied_suggestions_file, patch_generator_dir)
    elif arguments.load:
        retval = load_patches(file_mapping, arguments, applied_suggestions_file, patch_generator_dir)
    elif arguments.list:
        print("Applied suggestions: ", list_applied_suggestions(arguments, applied_suggestions_file))

    if arguments.verbose:
        print("Done.")

    return retval
