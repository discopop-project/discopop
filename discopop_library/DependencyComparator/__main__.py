# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

from argparse import ArgumentParser
from discopop_library.DependencyComparator.DependencyComparatorArguments import DependencyComparatorArguments
from discopop_library.DependencyComparator.dependency_comparator import run


def parse_args() -> DependencyComparatorArguments:
    parser = ArgumentParser(description="DiscoPoP dependency comparator")

    # fmt: off
    parser.add_argument(
        "-g", "--gold-standard", type=str, default="None",
        help="Dynamic dependency file for reference."
    )
    parser.add_argument(
        "-t", "--test-set", type=str, default="None",
        help="Dynamic dependency files under test."
    )
    parser.add_argument(
        "-o", "--output", type=str, default="None",
        help="Path to output JSON file."
    )
    # fmt: on

    arguments = parser.parse_args()

    return DependencyComparatorArguments(
        gold_standard=arguments.gold_standard, test_set=arguments.test_set, output=arguments.output
    )


def main() -> None:
    arguments = parse_args()
    run(arguments)


if __name__ == "__main__":
    main()
