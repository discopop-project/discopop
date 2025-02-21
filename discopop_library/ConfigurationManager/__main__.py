# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

from argparse import ArgumentParser
import os
from discopop_library.GlobalLogger.setup import setup_logger
from discopop_library.ConfigurationManager.ConfigurationManagerArguments import ConfigurationManagerArguments
from discopop_library.ConfigurationManager.ConfigurationManager import run


def parse_args() -> ConfigurationManagerArguments:
    """Parse the arguments passed to the discopop_configuration_manager"""
    parser = ArgumentParser(description="Initialize and prepare projects for the use in the DiscoPoP framework.")
    # all flags that are not considered stable should be added to the experimental_parser
    experimental_parser = parser.add_argument_group(
        "EXPERIMENTAL",
        "Arguments for configuration manager and other experimental features. These arguments are considered EXPERIMENTAL and they may or may not be removed or modified in the near future.",
    )

    # fmt: off
    parser.add_argument("-v", "--verbose", action="store_true",
                        help="Enable verbose output.")
    parser.add_argument("-p", "--project", default=os.getcwd(), help="Path to the projects root folder. Important: it must be possible to create a copy of this folder and compile / execute the copy with the definitions from compile.sh, execute.sh, and settings.json. Please refer to the wiki pages (https://discopop-project.github.io/discopop/) for further details. Default: $(cwd)")
    parser.add_argument("--init", action="store_true", help="Initialize the .discopop directory in the specified project path")
    parser.add_argument("-x", "--execute", default="tiny", help="Comma separated list of configurations to be executed. Format: <config_name>[:<mode>] . Modes: dp,hd,seq,par. Default: tiny")
    parser.add_argument("-xf", "--execute-full", action="store_true", help="Execute all configurations for validation purposes.")
    parser.add_argument("-a", "--apply-suggestions", help="Comma separated list of suggestions ids to be applied before the specified execution. Use the keyword 'auto' to load the configuration determined by the autotuner (if multiple configurations exist, union will be considered).")
    parser.add_argument('-l', '--list', action="store_true", help="Show a list of available configurations. If set, nothing else will be done.")
    parser.add_argument("-i", "--inplace", action="store_true", help="Prevents the creation of project copies when code configurations are executed. Instead, executes the configuration in the project root folder.")
    parser.add_argument("--skip-cleanup", action="store_true", help="Prevents the deletion of created project copies. May requires high amount of disk space.")
    parser.add_argument("--report", action="store_true", help="Generate and show a report of the stored execution results.")
    parser.add_argument("-r", "--reset", action="store_true", help="Reset the .discopop folder except configurations in project subdirectory.")

    parser.add_argument("--log", type=str, default="WARNING", help="Specify log level: DEBUG, INFO, WARNING, ERROR, CRITICAL")
    parser.add_argument("--write-log", action="store_true", help="Create Logfile.")
    # EXPERIMENTAL FLAGS:
    # fmt: on

    arguments = parser.parse_args()

    return ConfigurationManagerArguments(
        project_root=arguments.project,
        full_execute=arguments.execute_full,
        list=arguments.list,
        execute_configurations=arguments.execute,
        execute_inplace=arguments.inplace,
        skip_cleanup=arguments.skip_cleanup,
        generate_report=arguments.report,
        initialize_directory=arguments.init,
        apply_suggestions=arguments.apply_suggestions,
        reset=arguments.reset,
        log_level=arguments.log.upper(),
        write_log=arguments.write_log,
    )


def main() -> None:
    arguments = parse_args()
    setup_logger(arguments)
    run(arguments)


if __name__ == "__main__":
    main()
