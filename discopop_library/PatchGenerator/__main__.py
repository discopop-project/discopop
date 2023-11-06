# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
import os.path
from argparse import ArgumentParser
from pathlib import Path

from discopop_library.PatchGenerator.PatchGeneratorArguments import PatchGeneratorArguments
from discopop_library.PatchGenerator.patch_generator import run


def parse_args() -> PatchGeneratorArguments:
    """Parse the arguments passed to the discopop_explorer"""
    parser = ArgumentParser(description="DiscoPoP Patch Generator")
    # all flags that are not considered stable should be added to the experimental_parser
    experimental_parser = parser.add_argument_group(
        "EXPERIMENTAL",
        "Arguments for the task pattern detector and other experimental features. These flags are considered EXPERIMENTAL and they may or may not be removed or changed in the near future.",
    )

    # fmt: off
    parser.add_argument("--verbose", action="store_true",
        help="Enable verbose output.")
    parser.add_argument(
        "--dp-build-path", type=str, required=True,
        help="Path to DiscoPoP build folder"
    )
    # EXPERIMENTAL FLAGS:
    # fmt: on

    arguments = parser.parse_args()

    # determine CC and CXX
    with open(os.path.join(arguments.dp_build_path, "build_config.txt"), "r") as f:
        for line in f.readlines():
            if line.startswith("LLVM_BIN_DIR="):
                line = line.replace("\n", "")
                llvm_bin_dir = line[len("LLVM_BIN_DIR=") :]
                # determine CC
                if os.path.exists(os.path.join(llvm_bin_dir, "clang")):
                    arguments.cc = os.path.join(llvm_bin_dir, "clang")
                elif os.path.exists(os.path.join(llvm_bin_dir, "clang-11")):
                    arguments.cc = os.path.join(llvm_bin_dir, "clang-11")
                else:
                    raise ValueError("Could not determine CC from discopop build path: ", arguments.dp_build_path)

                # determine CXX
                if os.path.exists(os.path.join(llvm_bin_dir, "clang++")):
                    arguments.cxx = os.path.join(llvm_bin_dir, "clang++")
                elif os.path.exists(os.path.join(llvm_bin_dir, "clang++-11")):
                    arguments.cxx = os.path.join(llvm_bin_dir, "clang++-11")
                else:
                    raise ValueError("Could not determine CXX from discopop build path: ", arguments.dp_build_path)

                break

    return PatchGeneratorArguments(
        verbose=arguments.verbose, discopop_build_path=arguments.dp_build_path, CC=arguments.cc, CXX=arguments.cxx
    )


def main():
    arguments = parse_args()
    run(arguments)


if __name__ == "__main__":
    main()
