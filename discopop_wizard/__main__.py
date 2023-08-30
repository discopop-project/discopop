# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import argparse
import os
from os.path import dirname

from discopop_wizard.classes.Arguments import Arguments
from discopop_wizard.headless.headless_execution import (
    execute_all_stored_configurations,
    execute_tag_filtered_configurations,
)
from discopop_wizard.wizard import main as wizard_main


def convert_args(namespace_args: argparse.Namespace) -> Arguments:
    """Stores args into an Arguments object."""
    return_arg = Arguments()
    return_arg.execute_configurations_with_tag = [
        tag for tag in namespace_args.execute_configurations_with_tag.split(",") if len(tag) > 0
    ]
    return_arg.execute_all_configurations = namespace_args.execute_all_configurations == "true"

    return return_arg


def main():
    parser = argparse.ArgumentParser(description="DiscoPoP Configuration Wizard")

    parser.add_argument(
        "--execute_all_configurations",
        help="Execute all stored configurations in a headless manner. [true / false]",
    )
    parser.add_argument(
        "--execute_configurations_with_tag",
        default="",
        help="Execute all stored configurations in a headless manner which have any of the given tags assigned. [comma-separated list of tags to be executed]",
    )

    args = convert_args(parser.parse_args())

    if args.execute_all_configurations:
        # start headless mode and execute all stored configurations
        source_dir = dirname(os.path.abspath(__file__))  # source_dir: discopop/discopop_wizard
        execute_all_stored_configurations(args, source_dir)
    elif len(args.execute_configurations_with_tag) > 0:
        # start headless mode and execute stored configurations with the suitable tags
        source_dir = dirname(os.path.abspath(__file__))  # source_dir: discopop/discopop_wizard
        execute_tag_filtered_configurations(args, source_dir)
    else:
        wizard_main(args)


if __name__ == "__main__":
    main()
