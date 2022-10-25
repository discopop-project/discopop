# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

"""Call clang++ with DiscoPoP LLVM passes."""

import argparse
import logging
import shutil

from . import DiscopopCpp, __version__

PROG = "discopop_profiler"

USAGE = f"""{PROG} [--verbose] [--clang CLANG]
       {'':{len(PROG)}} (--CUGeneration | --DPInstrumentation | --DPReduction)
       {'':{len(PROG)}} <clang++ arguments>
"""


def main(args=None):
    parser = argparse.ArgumentParser(prog=PROG, description=__doc__, usage=USAGE, add_help=False)
    parser.add_argument("-h", "--help", action="help", help="Show this help message and exit.")
    parser.add_argument(
        "-V",
        "--version",
        action="version",
        version=f"%(prog)s {__version__}",
        help="Show version number and exit.",
    )
    parser.add_argument(
        "-v",
        "--verbose",
        action="store_true",
        help="Show additional information such as clang++ invocations.",
    )
    parser.add_argument("--clang", help="Path to clang++ executable.")
    action = parser.add_mutually_exclusive_group()
    action.add_argument(
        "--CUGeneration",
        "--cugeneration",
        action="store_true",
        help="Obtain the computational unit (CU) graph of the target application.",
    )
    action.add_argument(
        "--DPInstrumentation",
        "--dpinstrumentation",
        action="store_true",
        help="Instrument the target application to obtain data dependences.",
    )
    action.add_argument(
        "--DPReduction",
        "--dpreduction",
        action="store_true",
        help="Instrument the target application to obtain the list of reduction operations.",
    )
    parameters, clang_args = parser.parse_known_args(args)

    logging.basicConfig(
        format="%(message)s",
        level=logging.INFO if parameters.verbose else logging.WARNING,
    )

    if not any([parameters.CUGeneration, parameters.DPInstrumentation, parameters.DPReduction]):
        logging.warning(
            "Warning: Not using any DiscoPoP LLVM pass (specify either --CUGeneration, "
            "--DPInstrumentation or --DPReduction).",
        )
    clang_path = parameters.clang or shutil.which("clang++-8") or shutil.which("clang++")
    if not clang_path:
        raise SystemExit("clang++ executable not found in PATH. Specify --clang PATH/TO/CLANG++.")
    if not clang_args:
        logging.warning("Warning: No arguments to clang++ were given.")

    clang_proc = DiscopopCpp(
        cugeneration=parameters.CUGeneration,
        dpinstrumentation=parameters.DPInstrumentation,
        dpreduction=parameters.DPReduction,
        clang_path=clang_path,
    ).invoke(clang_args)
    if clang_proc.returncode != 0:
        raise SystemExit(clang_proc.returncode)


if __name__ == "__main__":
    main()
