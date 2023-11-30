# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

from argparse import ArgumentParser

from .hotspot_analyzer import HotspotAnalyzerArguments, run


def parse_args() -> HotspotAnalyzerArguments:
    """Parse the arguments passed to the hotspot_analyzer"""
    parser = ArgumentParser(description="Hotspot Analyzer")
    arguments = parser.parse_args()
    return HotspotAnalyzerArguments()


def main():
    arguments = parse_args()
    run(arguments)


if __name__ == "__main__":
    main()
