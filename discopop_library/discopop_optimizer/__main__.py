# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
from argparse import ArgumentParser

from discopop_library.discopop_optimizer.optimizer import run
from discopop_library.discopop_optimizer.OptimizerArguments import OptimizerArguments


def parse_args() -> OptimizerArguments:
    """Parse the arguments passed to the discopop_optimizer"""
    parser = ArgumentParser(description="DiscoPoP Optimizer")
    # all flags that are not considered stable should be added to the experimental_parser
    experimental_parser = parser.add_argument_group(
        "EXPERIMENTAL",
        "Arguments marked as experimental features. These flags may or may not be removed or changed in the future.",
    )

    # fmt: off
    parser.add_argument("-v", "--verbose", action="store_true",
        help="Enable verbose output.")
    parser.add_argument("-x", "--exhaustive", action="store_true",
        help="Enable exhaustive search. By default, a greedy search is performed.")
    parser.add_argument("-e", "--evolutionary", type=str, default=None, nargs=2, metavar=("population_size", "generations"),
        help="Enable evolutionary search. By default, a greedy search is performed.")
    parser.add_argument("-g", "--greedy", action="store_true",
        help="Enable greedy search. (Default)")
    parser.add_argument("-o", "--optimize", action="store_true",
        help="Enable optimization.")
    parser.add_argument("-p", "--pruning-level", type=int, default=0,
        help="Program path pruning aggressiveness. 0: no pruning. 1: prune to most likely path.")
    parser.add_argument(
        "--doall-microbench-file", type=str, default="None",
        help="Do-All microbenchmark results"
    )
    parser.add_argument(
        "--reduction-microbench-file", type=str, default="None",
        help="Reduction microbenchmark results"
    )
    parser.add_argument(
        "--system-configuration", type=str, default="optimizer/system_configuration.json",
        help="System configuration file"
    )
    parser.add_argument("--profiling", action="store_true",
        help="Enable profiling.")
    # EXPERIMENTAL FLAGS:
    experimental_parser.add_argument("--allow-nested-parallelism", action="store_true",
        help="Allow the creation of nested parallelism suggestions. "
        + "WARNING: Cost estimations may not be accurrate due to potentially"
        + "high overhead introduced by entering nested parallelism!")
    experimental_parser.add_argument("--check-called-function-for-nested-parallelism", action="store_true", help="Extend the check for nested parallelism to called functions."
        + "WARNING: Execution time may increase significantly!")
    experimental_parser.add_argument("-i", "--interactive", action="store_true",
        help="Enable interactive execution.")
    experimental_parser.add_argument("--plot", action="store_true",
        help="Plot the internal graph.")
    # fmt: on

    arguments = parser.parse_args()

    return OptimizerArguments(
        verbose=arguments.verbose,
        interactive=arguments.interactive,
        exhaustive=arguments.exhaustive,
        evolutionary=arguments.evolutionary,
        doall_microbench_file=arguments.doall_microbench_file,
        reduction_microbench_file=arguments.reduction_microbench_file,
        allow_nested_parallelism=arguments.allow_nested_parallelism,
        plot=arguments.plot,
        system_configuration_path=arguments.system_configuration,
        check_called_function_for_nested_parallelism=arguments.check_called_function_for_nested_parallelism,
        profiling=arguments.profiling,
        greedy=arguments.greedy,
        optimization=arguments.optimize,
        pruning_level=arguments.pruning_level,
    )


def main():
    arguments = parse_args()
    run(arguments)


if __name__ == "__main__":
    main()
