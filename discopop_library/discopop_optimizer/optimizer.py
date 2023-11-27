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
from discopop_library.PatchGenerator.diffs import get_diffs_from_modified_code
from discopop_library.PathManagement.PathManagement import load_file_mapping
from discopop_library.discopop_optimizer.OptimizerArguments import OptimizerArguments


def run(arguments: OptimizerArguments):
    if arguments.verbose:
        print("Started DiscoPoP Optimizer...")
    if arguments.verbose:
        print("Creating optimizer directory...")
    optimizer_dir = os.path.join(os.getcwd(), "optimizer")
    if not os.path.exists(optimizer_dir):
        os.mkdir(optimizer_dir)

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
        print("Done.")
