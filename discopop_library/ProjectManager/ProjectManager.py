# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
import json
import os

from discopop_library.ProjectManager.ProjectManagerArguments import ProjectManagerArguments

import logging

from discopop_library.ProjectManager.reports.full import generate_full_report
from discopop_library.ProjectManager.utilities.CLI.listConfiguration import (
    show_configurations_with_execution,
    show_configurations_without_execution,
)
from discopop_library.ProjectManager.utilities.deriveSettingsFiles import derive_settings_files
from discopop_library.ProjectManager.utilities.initializeDirectories import initialize_directories
from discopop_library.ProjectManager.utilities.initializeFiles import initialize_configuration_files
from discopop_library.ProjectManager.utilities.reset import reset_project

logger = logging.getLogger("ProjectManager")


def run(arguments: ProjectManagerArguments) -> None:
    arguments.log_config(logger, mode="debug")

    if arguments.reset:
        reset_project(arguments)
        return

    if arguments.initialize_directory:
        print("Initializing project directory:", arguments.dot_dp)
        initialize_directories(arguments)
        initialize_configuration_files(arguments)
        return

    derive_settings_files(arguments)

    if arguments.list:
        show_configurations_without_execution(arguments)
        return
    elif arguments.generate_report:
        generate_full_report(arguments)
    elif arguments.full_execute:
        show_configurations_with_execution(arguments)
    else:
        show_configurations_with_execution(
            arguments, restricted_configurations=arguments.execute_configurations.split(",")
        )
