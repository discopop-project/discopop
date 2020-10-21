# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import os
import re
from typing import List, Iterator


def get_library(name: str) -> str:
    library_dirs: List[str]
    if os.getenv("DISCOPOP_INSTALL"):
        library_dirs = [
            os.path.expandvars("${DISCOPOP_INSTALL}"),
            os.path.expandvars("${DISCOPOP_INSTALL}/libi"),
            os.path.expandvars("${DISCOPOP_INSTALL}/rtlib"),
            os.path.expandvars("${DISCOPOP_INSTALL}/lib"),
        ]
    else:
        library_dirs = [
            os.path.expanduser("~/.local/lib"),
            "/usr/local/lib",
            "/usr/lib",
            "/lib",
        ]
    for library_dir in library_dirs:
        if os.path.exists(os.path.join(library_dir, name)):
            return os.path.join(library_dir, name)
    raise SystemExit(
        f"File {name} not found. Searched in: {', '.join(library_dirs)}.\n"
        f"Build DiscoPoP and set DISCOPOP_INSTALL environment variable."
    )


def is_compile(clang_args: List[str]) -> bool:
    return "-c" in clang_args or any(
        [re.match(r"^[^-].+\.(?:c|cc|cpp)$", arg) for arg in clang_args]
    )


def is_link(clang_args: List[str]) -> bool:
    return "-c" not in clang_args


def recursive_scandir(path: str) -> Iterator[os.DirEntry]:
    with os.scandir(path) as dir_iter:
        for entry in dir_iter:
            yield entry
            if entry.is_dir():
                yield from recursive_scandir(entry.path)
