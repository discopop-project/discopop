# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
import os.path
import subprocess
from pathlib import Path
from typing import Dict

from discopop_library.PatchGenerator.patch_generator import PatchGeneratorArguments


def get_diffs_from_modified_code(
    file_mapping: Dict[int, Path], file_id_to_modified_code: Dict[int, str], arguments: PatchGeneratorArguments
) -> Dict[int, str]:
    patches: Dict[int, str] = dict()
    for file_id in file_id_to_modified_code:
        # get path to original code
        original_file_path = file_mapping[file_id]
        # create temporary modified code
        modified_file_path = original_file_path.parent / (original_file_path.name + ".discopop_patch_generator.temp")
        if arguments.verbose:
            print("Original: ", original_file_path)
            print("Modified:  ", modified_file_path)

        with open(modified_file_path, "w") as f:
            f.write(file_id_to_modified_code[file_id])

        # calculate diff
        diff_name = original_file_path.parent / (original_file_path.name + ".discopop_patch_generator.diff")
        command = [
            "diff",
            "-Naru",
            original_file_path.as_posix(),
            modified_file_path.as_posix(),
        ]
        result = subprocess.run(
            command,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            universal_newlines=True,
            cwd=os.getcwd(),
        )
        if result.returncode != 0:
            if arguments.verbose:
                print("RESULT: ", result.returncode)
                print("STDERR:")
                print(result.stderr)
                print("STDOUT: ")
                print(result.stdout)

        # save diff
        patches[file_id] = result.stdout

        # cleanup environment
        if os.path.exists(modified_file_path):
            os.remove(modified_file_path)
        if os.path.exists(diff_name):
            os.remove(diff_name)

    return patches
