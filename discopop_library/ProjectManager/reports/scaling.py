# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import json
import os

from tabulate import tabulate  # type: ignore
from discopop_library.ProjectManager.ProjectManagerArguments import ProjectManagerArguments

import logging

logger = logging.getLogger("ConfigurationManager")


def generate_scaling_report(arguments: ProjectManagerArguments) -> None:
    execution_results_path = os.path.join(arguments.project_config_dir, "execution_results.json")
    if not os.path.exists(execution_results_path):
        print("No execution data available to report generation.")
        return
    with open(execution_results_path, "r") as f:
        execution_results = json.load(f)

    # prepare table for display
    table = [["Configuration", "Script", "Setting", "Applied Suggestions", "Return code", "Time"]]
    for configuration in execution_results:
        configuration_first_occurrence = True
        for script in execution_results[configuration]:
            script_first_occurrence = True
            for setting in execution_results[configuration][script]:
                applied_suggestions_string = ""
                return_codes_string = ""
                times_string = ""
                for execution in execution_results[configuration][script][setting]:
                    applied_suggestions_string += str(execution["applied_suggestions"]) + "\n"
                    return_codes_string += str(execution["code"]) + "\n"
                    times_string += str(execution["time"]) + "\n"

                if configuration_first_occurrence:
                    clean_configuration_str = configuration
                    configuration_first_occurrence = False
                else:
                    clean_configuration_str = ""

                if script_first_occurrence:
                    clean_script_str = script
                    script_first_occurrence = False
                else:
                    clean_script_str = ""

                clean_setting_str = setting.replace("_settings.json", "")
                table_row = [
                    clean_configuration_str,
                    clean_script_str,
                    clean_setting_str,
                    applied_suggestions_string,
                    return_codes_string,
                    times_string,
                ]
                table.append(table_row)

    #    # display
    print(tabulate(table, tablefmt="grid"))
