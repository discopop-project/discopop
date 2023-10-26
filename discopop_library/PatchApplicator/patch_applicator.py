# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
import json
import os

from discopop_library.PatchApplicator.PatchApplicatorArguments import PatchApplicatorArguments
from discopop_library.PatchApplicator.apply import apply_patches
from discopop_library.PatchApplicator.clear import clear_patches
from discopop_library.PatchApplicator.load import load_patches
from discopop_library.PatchApplicator.rollback import rollback_patches
from discopop_library.PathManagement.PathManagement import load_file_mapping


def run(arguments: PatchApplicatorArguments):
    if arguments.verbose:
        print("Started DiscoPoP Patch Applicator...")
        print("Working directory: ", os.getcwd())
        print(arguments)

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

    # handle arguments
    if len(arguments.apply) > 0:
        apply_patches(file_mapping, arguments)
    elif len(arguments.rollback) > 0:
        rollback_patches()
    elif arguments.clear:
        clear_patches()
    elif arguments.load:
        load_patches()

    if arguments.verbose:
        print("Done.")
