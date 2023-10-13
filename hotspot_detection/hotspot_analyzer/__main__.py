# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

from argparse import ArgumentParser
from pathlib import Path

from .hotspot_analyzer import HotspotAnalyzerArguments, run


def parse_args() -> HotspotAnalyzerArguments:
    """Parse the arguments passed to the hotspot_analyzer"""
    parser = ArgumentParser(description="Hotspot Analyzer")
    # all flags that are not considered stable should be added to the experimental_parser
    experimental_parser = parser.add_argument_group(
        "EXPERIMENTAL",
        "Arguments for experimental features. These flags are considered EXPERIMENTAL and they may or may not be removed or changed in the near future.",
    )

    # fmt: off
    # fmt: on

    arguments = parser.parse_args()

    return HotspotAnalyzerArguments()


def main():
    arguments = parse_args()
    run(arguments)


if __name__ == "__main__":
    main()
