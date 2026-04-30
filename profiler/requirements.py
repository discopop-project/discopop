# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.


# Maps display name → executable that must be on PATH.
REQUIRED_EXECUTABLES: dict[str, str] = {
    "clang-19": "clang-19",
    "python3": "python3",
}

# Apt packages to verify via dpkg regardless of whether they provide an executable.
# Maps display name → apt package name.
REQUIRED_APT_PACKAGES: dict[str, str] = {
    # "libclang-19-dev": "libclang-19-dev",
    "python3": "python3",
    "python3-pip": "python3-pip",
    "python3-venv": "python3-venv",
    "python3-tk": "python3-tk",
    "build-essential": "build-essential",
    "make": "make",
    "cmake": "cmake",
    "git": "git",
    "llvm-19-dev": "llvm-19-dev",
    "clang-19": "clang-19",
    "libomp-19-dev": "libomp-19-dev",
    "libboost-all-dev": "libboost-all-dev",
}
