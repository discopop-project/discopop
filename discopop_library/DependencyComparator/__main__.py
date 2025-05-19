# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

from argparse import ArgumentParser
import sys
from discopop_library.DependencyComparator.DependencyComparatorArguments import DependencyComparatorArguments
from discopop_library.DependencyComparator.dependency_comparator import run


def parse_args() -> DependencyComparatorArguments:
    parser = ArgumentParser(
        description="DiscoPoP dependency comparator.",
        epilog="Return codes: 0 -> no difference. 1xx -> missing dependencies. x1x -> additional non-init dependencies. xx1 -> additional init dependencies.",
    )

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
        help="Enable saving the comparison results in JSON format to the given path."
    )
    parser.add_argument(
        "-v", "--verbose", type=bool, default=False,
        help="Enable verbose output."
    )
    # fmt: on

    arguments = parser.parse_args()

    return DependencyComparatorArguments(
        gold_standard=arguments.gold_standard,
        test_set=arguments.test_set,
        output=arguments.output,
        verbose=arguments.verbose,
    )


def main() -> int:
    arguments = parse_args()
    sys.exit(run(arguments))


if __name__ == "__main__":
    main()
