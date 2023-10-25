# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

from argparse import ArgumentParser

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
    # EXPERIMENTAL FLAGS:
    # fmt: on

    arguments = parser.parse_args()

    return PatchGeneratorArguments(verbose=arguments.verbose)


def main():
    arguments = parse_args()
    run(arguments)


if __name__ == "__main__":
    main()
