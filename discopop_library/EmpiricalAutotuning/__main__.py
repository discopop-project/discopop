# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

from argparse import ArgumentParser
import os
from discopop_library.EmpiricalAutotuning.ArgumentClasses import AutotunerArguments
from discopop_library.GlobalLogger.setup import setup_logger
from discopop_library.EmpiricalAutotuning.Autotuner import run


def parse_args() -> AutotunerArguments:
    """Parse the arguments passed to the discopop autotuner"""
    parser = ArgumentParser(description="DiscoPoP Autotuner")

    cpu_count = os.cpu_count()
    if cpu_count is None:
        non_null_default_core_count = 2
    else:
        non_null_default_core_count = int(cpu_count / 2)

    # fmt: off
    parser.add_argument("--dot-dp-path", type=str, default=os.getcwd(), help="Path to the .discopop folder. Default: $(cwd)")
    parser.add_argument("-c", "--config", default="tiny", help="Configurations to be used for the autotuning. Default: tiny")
    parser.add_argument("-s", "--suggestions", help="If specified, the comma separated list of suggestions will be applied and compared to the baseline.")
    parser.add_argument("-t", "--threads", type=int, default=non_null_default_core_count, help="Value of OMP_NUM_THREADS used during execution. Default: os.cpu_count()/2 = " + str(non_null_default_core_count))
    parser.add_argument("-ht", "--hotspot-types", type=str, default="yes,maybe", help="Hotspot types to be considered. If no hotspot information exists, all suggestions will be classified as 'yes'. Options: yes,no,maybe. Default: yes,maybe")
    parser.add_argument("--log", type=str, default="WARNING", help="Specify log level: DEBUG, INFO, WARNING, ERROR, CRITICAL")
    parser.add_argument("--write-log", action="store_true", help="Create Logfile.")
    parser.add_argument("-p", "--plot", action="store_true", help="Allow the creation of interactive plots.")
    parser.add_argument("-A", "--algorithm", type=int, default=0, help="Optimization algorithm. Values: 0: no combination of suggestions. 1: linear combination, 2: linear combination with refinement. Default: 0.")
#    parser.add_argument("--project-path", type=str, default=os.getcwd(), help="Root path of the project to be tuned. \
#                        Important: Project root will be copied multiple times! It has to contain the executable scripts DP_COMPILER.sh and DP_EXECUTE.sh! \
#                        DP_COMPILER.sh must allow the inclusion of OpenMP pragmas into the code. \
#                        DP_EXECUTE.sh may return not 0, if either the execution or validation of the result failed. \
#                        A third script DP_VALIDATE.sh might be added to add a validation step, where return code 0 is interpreted as a success, i.e. a valid result.")
    parser.add_argument("--skip-cleanup", action="store_true", help="Disable the deletion of created code variants. May require a lot of disk space." )
    parser.add_argument("--sanitize", action="store_true", help="Enable the invocation of ThreadSanitizer if DP_COMPILE_SANITIZE.sh and DP_EXECUTE_SANITIZE.sh are provided." )

    # fmt:  is provided.

    arguments = parser.parse_args()

    return AutotunerArguments(
        log_level=arguments.log.upper(),
        write_log=arguments.write_log,
        dot_dp_path=arguments.dot_dp_path,
        configuration=arguments.config,
        skip_cleanup=arguments.skip_cleanup,
        sanitize=arguments.sanitize,
        suggestions=arguments.suggestions,
        allow_plots=arguments.plot,
        thread_count=arguments.threads,
        hotspot_types=arguments.hotspot_types,
        algorithm=arguments.algorithm,
    )


def main() -> None:
    arguments = parse_args()
    setup_logger(arguments)
    arguments.log()
    run(arguments)


if __name__ == "__main__":
    main()
