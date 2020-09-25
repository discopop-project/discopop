# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

"""Call Clang++ with DiscoPoP LLVM passes."""

import argparse
import shutil
import sys

from . import DiscopopClang


def main(args=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("-v", "--verbose", action="store_true", help="Verbose output.")
    parser.add_argument("--clang", help="Path to clang++ executable.")
    parser.add_argument(
        "--CUGeneration",
        "--cugeneration",
        action="store_true",
        help="Obtain the computational unit (CU) graph of the target application.",
    )
    parser.add_argument(
        "--DPInstrumentation",
        "--dpinstrumentation",
        action="store_true",
        help="Instrument the target application to obtain data dependencies.",
    )
    parser.add_argument(
        "--DPReduction",
        "--dpreduction",
        action="store_true",
        help="Instrument the target application to obtain the list of reduction operations.",
    )
    parameters, clang_args = parser.parse_known_args(args)

    if not any([parameters.CUGeneration, parameters.DPInstrumentation, parameters.DPReduction]):
        print(
            "Warning: Not using any DiscoPoP LLVM pass (specify --CUGeneration, "
            "--DPInstrumentation or --DPReduction).",
            file=sys.stderr,
        )
    clang_path = parameters.clang or shutil.which("clang++-8") or shutil.which("clang++")
    if not clang_path:
        raise SystemExit("clang++ executable not found in PATH. Specify --clang PATH/TO/CLANG++.")
    if not clang_args:
        print("Warning: No arguments to clang++ were given.", file=sys.stderr)

    clang_proc = DiscopopClang(
        cugeneration=parameters.CUGeneration,
        dpinstrumentation=parameters.DPInstrumentation,
        dpreduction=parameters.DPReduction,
        clang_path=clang_path,
        verbose=parameters.verbose,
    ).invoke(clang_args)
    if clang_proc.returncode != 0:
        raise SystemExit(clang_proc.returncode)


if __name__ == "__main__":
    main()
