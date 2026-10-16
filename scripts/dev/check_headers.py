#!/usr/bin/env python3

# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

"""Checks that every header of the profiler compiles on its own.

A header that relies on what its includer included before (a missing #include, a name that only resolves
through a `using namespace` of another header) compiles today and breaks as soon as the includes change. This
compiles each header as the only content of a translation unit (-fsyntax-only), with the compile command of
a source file of the same target taken from compile_commands.json, so the flags are the ones of the real build.

usage: scripts/dev/check_headers.py [build dir]
  [build dir]  a configured CMake build directory with compile_commands.json, default: build_tests
"""

import json
import shlex
import subprocess
import sys
from pathlib import Path
from typing import Dict, List

REPO_ROOT = Path(__file__).resolve().parents[2]

# headers below the key are checked with the compile command of the value (a source file of the same target)
TARGETS: Dict[str, str] = {
    "profiler/rtlib": "profiler/rtlib/runtimeFunctions.cpp",
    "profiler/DiscoPoP": "profiler/DiscoPoP/DiscoPoP.cpp",
    "profiler/share/include": "profiler/DiscoPoP/DiscoPoP.cpp",
}


def tracked_headers(directory: str) -> List[str]:
    # safe.directory: in the CI containers the checkout belongs to another user than the one running
    # the script, which makes git refuse to work in it ("dubious ownership", exit status 128)
    result = subprocess.run(
        ["git", "-c", f"safe.directory={REPO_ROOT}", "ls-files", f"{directory}/*.hpp"],
        cwd=REPO_ROOT,
        capture_output=True,
        text=True,
    )
    if result.returncode != 0:
        sys.exit(f"git ls-files failed ({result.returncode}): {result.stderr.strip()}")
    return result.stdout.split()


def syntax_only_command(command: str, header: Path) -> List[str]:
    """The compile command with its source file and output replaced by the header."""
    args = shlex.split(command)
    result: List[str] = []
    skip = False
    for arg in args:
        if skip:
            skip = False
        elif arg in ("-o", "-c"):
            skip = True
        else:
            result.append(arg)
    return result + ["-fsyntax-only", "-x", "c++", str(header)]


def main() -> int:
    build_dir = Path(sys.argv[1]) if len(sys.argv) > 1 else REPO_ROOT / "build_tests"
    database = build_dir / "compile_commands.json"
    if not database.is_file():
        print(f"{database} not found: configure the build directory with CMake first", file=sys.stderr)
        return 2
    commands = {Path(entry["file"]): entry for entry in json.loads(database.read_text())}

    failed: List[str] = []
    checked = 0
    for directory, reference in TARGETS.items():
        entry = commands.get(REPO_ROOT / reference)
        if entry is None:
            print(f"{reference} is not in {database}", file=sys.stderr)
            return 2
        for header in tracked_headers(directory):
            checked += 1
            result = subprocess.run(
                syntax_only_command(entry["command"], REPO_ROOT / header),
                cwd=entry["directory"],
                capture_output=True,
                text=True,
            )
            if result.returncode != 0:
                errors = [line for line in result.stderr.splitlines() if "error" in line]
                print(f"FAILED: {header}")
                print("\n".join(errors[:5]))
                failed.append(header)

    if failed:
        print(f"{len(failed)} of {checked} headers do not compile on their own", file=sys.stderr)
        return 1
    print(f"All {checked} headers compile on their own.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
