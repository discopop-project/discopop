# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
import json
import os
import textwrap
from typing import Any, Dict

from tabulate import tabulate  # type: ignore

from discopop_library.ProjectManager.ProjectManagerArguments import ProjectManagerArguments


def print_console_report(arguments: ProjectManagerArguments) -> None:
    execution_results_path = os.path.join(arguments.project_dir, "execution_results.json")
    if not os.path.exists(execution_results_path):
        print("No execution data available to report generation.")
        return
    with open(execution_results_path, "r") as f:
        execution_results = json.load(f)

    __print_table(execution_results)


def __print_table(execution_results: Dict[str, Any]) -> None:
    # prepare table for display
    table = [["Config", "Script", "Setting", "Applied Suggestions", "Threads", "Code", "Time", "Speedup", "Efficiency"]]
    for configuration in execution_results:
        configuration_first_occurrence = True
        for script in execution_results[configuration]:
            script_first_occurrence = True
            for setting in execution_results[configuration][script]:
                applied_suggestions_string = ""
                return_codes_string = ""
                times_string = ""
                thread_counts_string = ""
                speedup_string = ""
                efficiency_string = ""

                # get sequential runtime for speedup calculation
                seq_runtime: float = -1.0
                if "seq_settings.json" in execution_results[configuration][script]:
                    for execution in execution_results[configuration][script]["seq_settings.json"]:
                        if execution["code"] == 0:
                            seq_runtime = execution["time"]

                for execution in execution_results[configuration][script][setting]:
                    applied_suggestions_string += (
                        textwrap.shorten(str(execution["applied_suggestions"]), width=20, placeholder="...]") + "\n"
                    )
                    return_codes_string += str(execution["code"]) + "\n"
                    times_string += str(execution["time"]) + "\n"
                    thread_counts_string += str(execution["thread_count"]) + "\n"
                    speedup = seq_runtime / execution["time"]
                    speedup_string += str(round(speedup, 3)) + "\n"
                    efficiency = speedup / execution["thread_count"]
                    efficiency_string += str(round(efficiency, 3)) + "\n"

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
                    thread_counts_string,
                    return_codes_string,
                    times_string,
                    speedup_string,
                    efficiency_string,
                ]
                table.append(table_row)

    #    # display
    print(tabulate(table, tablefmt="grid"))
