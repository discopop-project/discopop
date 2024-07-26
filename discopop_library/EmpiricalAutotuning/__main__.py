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

    # fmt: off
    
    parser.add_argument("--log", type=str, default="WARNING", help="Specify log level: DEBUG, INFO, WARNING, ERROR, CRITICAL")
    parser.add_argument("--write-log", action="store_true", help="Create Logfile.")
    parser.add_argument("--project-path", type=str, default=os.getcwd(), help="Root path of the project to be tuned. \
                        Important: Project root will be copied multiple times! It has to contain the executable scripts DP_COMPILER.sh and DP_EXECUTE.sh! \
                        DP_COMPILER.sh must allow the inclusion of OpenMP pragmas into the code. \
                        DP_EXECUTE.sh may return not 0, if either the execution or validation of the result failed. \
                        A third script DP_VALIDATE.sh might be added to add a validation step, where return code 0 is interpreted as a success, i.e. a valid result.")
    parser.add_argument("--dot-dp-path", type=str, default=os.path.join(os.getcwd(), ".discopop"), help="Path to the .discopop folder.")
    parser.add_argument("--skip-cleanup", action="store_true", help="disable the deletion of created code variants. May require a lot of disk space." )
    # fmt: on

    arguments = parser.parse_args()

    return AutotunerArguments(
        log_level=arguments.log.upper(),
        write_log=arguments.write_log,
        project_path=arguments.project_path,
        dot_dp_path=arguments.dot_dp_path,
        skip_cleanup=arguments.skip_cleanup,
    )


def main() -> None:
    arguments = parse_args()
    setup_logger(arguments)
    arguments.log()
    run(arguments)


if __name__ == "__main__":
    main()
