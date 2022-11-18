# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

from discopop_wizard.classes.Arguments import Arguments
from discopop_wizard.wizard import main as wizard_main
import argparse


def convert_args(namespace_args: argparse.Namespace) -> Arguments:
    """Stores args into an Arguments object."""
    return_arg = Arguments()
    return_arg.no_gui = namespace_args.no_gui
    return return_arg


def main():
    parser = argparse.ArgumentParser(description='DiscoPoP Configuration Wizard')

    parser.add_argument('--no-gui', action='store_true',
                        help='Disable GUI prompts, used for headless environments.')

    args = parser.parse_args()

    wizard_main(convert_args(args))



if __name__ == "__main__":
    main()
