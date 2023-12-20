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
from discopop_library.ConfigProvider.config_provider import run as run_config_provider
from discopop_library.ConfigProvider.ConfigProviderArguments import ConfigProviderArguments


def parse_args() -> PatchGeneratorArguments:
    """Parse the arguments passed to the discopop_explorer"""
    parser = ArgumentParser(description="DiscoPoP Patch Generator")
    # all flags that are not considered stable should be added to the experimental_parser
    experimental_parser = parser.add_argument_group(
        "EXPERIMENTAL",
        "Arguments marked as experimental features. These flags may or may not be removed or changed in the future.",
    )

    # fmt: off
    parser.add_argument("-v", "--verbose", action="store_true",
        help="Enable verbose output.")
    parser.add_argument(
        "-a", "--add-from-json", type=str, default="None",
        help="Add additional patches specified in the given patterns.json file."
    )
    # EXPERIMENTAL FLAGS:
    # fmt: on

    arguments = parser.parse_args()

    # determine DP build path
    arguments.dp_build_path = run_config_provider(
        ConfigProviderArguments(return_dp_build_dir=True, return_dp_source_dir=False, return_llvm_bin_dir=False)
    )

    # determine LLVM_BIN_DIR
    llvm_bin_dir = run_config_provider(
        ConfigProviderArguments(return_dp_build_dir=False, return_dp_source_dir=False, return_llvm_bin_dir=True)
    )
    # determine CC
    if os.path.exists(os.path.join(llvm_bin_dir, "clang")):
        arguments.cc = os.path.join(llvm_bin_dir, "clang")
    elif os.path.exists(os.path.join(llvm_bin_dir, "clang-11")):
        arguments.cc = os.path.join(llvm_bin_dir, "clang-11")
    else:
        raise ValueError("Could not determine CC from LLVM_BIN_DIR: ", llvm_bin_dir)

    # determine CXX
    if os.path.exists(os.path.join(llvm_bin_dir, "clang++")):
        arguments.cxx = os.path.join(llvm_bin_dir, "clang++")
    elif os.path.exists(os.path.join(llvm_bin_dir, "clang++-11")):
        arguments.cxx = os.path.join(llvm_bin_dir, "clang++-11")
    else:
        raise ValueError("Could not determine CXX from LLVM_BIN_DIR: ", llvm_bin_dir)

    return PatchGeneratorArguments(
        verbose=arguments.verbose,
        discopop_build_path=arguments.dp_build_path,
        CC=arguments.cc,
        CXX=arguments.cxx,
        add_from_json=arguments.add_from_json,
    )


def main():
    arguments = parse_args()
    run(arguments)


if __name__ == "__main__":
    main()
