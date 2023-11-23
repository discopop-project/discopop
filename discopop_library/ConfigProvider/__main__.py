# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

from argparse import ArgumentParser
from discopop_library.ConfigProvider.ConfigProviderArguments import ConfigProviderArguments
from discopop_library.ConfigProvider.config_provider import run


def parse_args() -> ConfigProviderArguments:
    """Parse the arguments passed to the discopop_config_provider"""
    parser = ArgumentParser(description="DiscoPoP Config Provider")
    # all flags that are not considered stable should be added to the experimental_parser
    experimental_parser = parser.add_argument_group(
        "EXPERIMENTAL",
        "Arguments for experimental features. Experimental arguments may or may not be removed or changed in the future.",
    )

    # fmt: off
    parser.add_argument("-b", "--dp-build-dir", action="store_true",
                        help="Return the path to the DiscoPoP build directory")
    parser.add_argument("-s", "--dp-source-dir", action="store_true",
                        help="Return the path to the DiscoPoP source directory")
    parser.add_argument("--llvm-bin-dir", action="store_true",
                        help="Return the path to the LLVM bin directory")
    # EXPERIMENTAL FLAGS:
    # fmt: on

    arguments = parser.parse_args()

    return ConfigProviderArguments(
        return_dp_build_dir=arguments.dp_build_dir,
        return_dp_source_dir=arguments.dp_source_dir,
        return_llvm_bin_dir=arguments.llvm_bin_dir,
    )


def main() -> str:
    arguments = parse_args()
    retval = run(arguments)
    return retval


if __name__ == "__main__":
    main()
