# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

from argparse import ArgumentParser

from discopop_library.PatchApplicator.PatchApplicatorArguments import PatchApplicatorArguments
from discopop_library.PatchApplicator.patch_applicator import run


def parse_args() -> PatchApplicatorArguments:
    """Parse the arguments passed to the discopop_explorer"""
    parser = ArgumentParser(description="DiscoPoP Patch Generator")
    # all flags that are not considered stable should be added to the experimental_parser
    experimental_parser = parser.add_argument_group(
        "EXPERIMENTAL",
        "Arguments for the task pattern detector and other experimental features. These flags are considered EXPERIMENTAL and they may or may not be removed or changed in the near future.",
    )

    # fmt: off
    parser.add_argument("-v", "--verbose", action="store_true",
        help="Enable verbose output.")
    parser.add_argument('-a', '--apply', nargs='+', default=[], help="Apply the parallelization suggestions with the "
                                                                     "given ids.")
    parser.add_argument('-r', '--rollback', nargs='+', default=[], help="Roll back the application of the "
                                                                        "parallelization suggestions with the given "
                                                                        "ids. If this process fails, all applied "
                                                                        "suggestions until the given ones will be "
                                                                        "rolled back as well.")
    parser.add_argument('-c', '--clear', action="store_true", help="Reset the code to it's original state. Preserves "
                                                                   "the list of applied suggestion for loading.")
    parser.add_argument('-l', '--load', action="store_true", help="Load a previous state after clearing.")
    # EXPERIMENTAL FLAGS:
    # fmt: on

    arguments = parser.parse_args()

    return PatchApplicatorArguments(
        verbose=arguments.verbose,
        apply=arguments.apply,
        rollback=arguments.rollback,
        clear=arguments.clear,
        load=arguments.load,
    )


def main():
    arguments = parse_args()
    run(arguments)


if __name__ == "__main__":
    main()
