# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
import json
import os
import subprocess
from pathlib import Path
from typing import Dict, List

from discopop_library.PatchApplicator.PatchApplicatorArguments import PatchApplicatorArguments


def rollback_patches(
    rollback: List[str],
    file_mapping: Dict[int, Path],
    arguments: PatchApplicatorArguments,
    applied_suggestions_file: str,
    patch_generator_dir: str,
):
    # get list of applicable suggestions
    applicable_suggestions = [name for name in os.listdir(patch_generator_dir)]

    # get already applied suggestions
    with open(applied_suggestions_file, "r") as f:
        applied_suggestions = json.loads(f.read())
        if arguments.verbose:
            print("Previously applied suggestions: ", applied_suggestions["applied"])

    for suggestion_id in rollback:
        if suggestion_id not in applied_suggestions["applied"]:
            if arguments.verbose:
                print("Skipping rollback of non-applied suggestion: ", suggestion_id)
            continue
        if suggestion_id in applicable_suggestions:
            if arguments.verbose:
                print("Rollback suggestion ", suggestion_id)
            successul = __rollback_file_patches(file_mapping, suggestion_id, patch_generator_dir, arguments)
            if successul:
                applied_suggestions["applied"].remove(suggestion_id)
                # write updated applied suggestions to file
                with open(applied_suggestions_file, "w") as f:
                    f.write(json.dumps(applied_suggestions))
            else:
                print("Rollback of suggestion", suggestion_id, "not successful.")
        else:
            if arguments.verbose:
                print("Nothing to rollback for suggestion ", suggestion_id)


def __rollback_file_patches(
    file_mapping: Dict[int, Path], suggestion_id: str, patch_generator_dir: str, arguments: PatchApplicatorArguments
) -> bool:
    # get a list of patches for the given suggestion
    patch_files = os.listdir(os.path.join(patch_generator_dir, suggestion_id))
    if arguments.verbose:
        print("\tFound patch files:", patch_files)

    encountered_error = False
    already_patched: List[str] = []
    for patch_file_name in patch_files:
        patch_file_id = int(patch_file_name.rstrip(".patch"))
        patch_target = file_mapping[patch_file_id]
        patch_file_path = os.path.join(patch_generator_dir, suggestion_id, patch_file_name)

        command = [
            "patch",
            "-R",
            patch_target.as_posix(),
            patch_file_path,
        ]
        if arguments.verbose:
            print("\tapplying: ", " ".join(command))
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
            encountered_error = True
            break
        else:
            already_patched.append(patch_file_name)

    # cleanup in case of an error
    if encountered_error:
        for patch_file_name in already_patched:
            patch_file_id = int(patch_file_name.rstrip(".patch"))
            patch_target = file_mapping[patch_file_id]
            patch_file_path = os.path.join(patch_generator_dir, suggestion_id, patch_file_name)
            command = [
                "patch",
                patch_target.as_posix(),
                patch_file_path,
            ]
            if arguments.verbose:
                print("\tcleanup: applying: ", " ".join(command))
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

    return not encountered_error
