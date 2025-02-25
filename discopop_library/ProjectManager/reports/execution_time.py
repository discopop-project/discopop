# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import json
import os
from typing import Any, Dict, List, Optional, Tuple

from tabulate import tabulate  # type: ignore
from discopop_library.ProjectManager.ProjectManagerArguments import ProjectManagerArguments

import logging
import matplotlib.pyplot as plt
import numpy as np

logger = logging.getLogger("ConfigurationManager")


def generate_execution_time_report(arguments: ProjectManagerArguments) -> None:
    execution_results_path = os.path.join(arguments.project_config_dir, "execution_results.json")
    if not os.path.exists(execution_results_path):
        print("No execution data available to report generation.")
        return
    with open(execution_results_path, "r") as f:
        execution_results = json.load(f)

    __console_output(execution_results)
    __plot_output(execution_results, arguments)


def __console_output(execution_results: Dict[str, Any]) -> None:
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


def __plot_output(execution_results: Dict[str, Any], arguments: ProjectManagerArguments) -> None:
    configuration_names: List[str] = []
    tmp_values: Dict[str, Dict[str, float]] = dict()
    values: Dict[str, Tuple[float, ...]] = dict()
    # collect data for plot
    for configuration in execution_results:
        configuration_names.append(configuration)
        for script in execution_results[configuration]:
            if script != "execute.sh":
                continue
            for setting in execution_results[configuration][script]:
                applied_suggestions_string = ""
                return_codes_string = ""
                times_string = ""
                best_execution_time: Optional[float] = None
                for execution in execution_results[configuration][script][setting]:
                    applied_suggestions_string += str(execution["applied_suggestions"]) + "\n"
                    return_codes_string += str(execution["code"]) + "\n"
                    times_string += str(execution["time"]) + "\n"
                    if execution["code"] == 0:
                        if best_execution_time is None:
                            best_execution_time = execution["time"]
                        if execution["time"] < best_execution_time:
                            best_execution_time = execution["time"]

                if best_execution_time is None:
                    best_execution_time = 0.0

                clean_setting_str = setting.replace("_settings.json", "")
                # collect, filter, and add values for plotting
                # only plot the best found option
                if clean_setting_str not in ["seq", "par"]:
                    continue
                if clean_setting_str not in tmp_values:
                    tmp_values[clean_setting_str] = dict()
                tmp_values[clean_setting_str][configuration] = best_execution_time
    # prepare values for plotting
    list_values: Dict[str, List[float]] = dict()
    for setting in tmp_values:
        if setting not in list_values:
            list_values[setting] = []
        for spec in configuration_names:
            if spec in tmp_values[setting]:
                list_values[setting].append(tmp_values[setting][spec])
            else:
                # fill missing values
                list_values[setting].append(0.0)
    # convert lists to tuples
    for key in list_values:
        values[key] = tuple(list_values[key])

    # get max y value
    max_y_value = 0.0
    for key in list_values:
        for val in list_values[key]:
            if val > max_y_value:
                max_y_value = val

    x = np.arange(len(configuration_names))  # the label locations
    width = 0.25  # the width of the bars
    multiplier = 0

    fig, ax = plt.subplots(layout="constrained")

    for attribute, measurement in values.items():
        offset = width * multiplier
        rects = ax.bar(x + offset, measurement, width, label=attribute)
        ax.bar_label(rects, padding=3)
        multiplier += 1

    # Add some text for labels, title and custom x-axis tick labels, etc.
    ax.set_ylabel("Execution time [s]")
    ax.set_title("Execution times of best valid configurations")
    ax.set_xticks(x + width, configuration_names)
    ax.legend(loc="upper left", ncols=3)
    ax.set_ylim(0, max_y_value + max_y_value * 0.15)

    reports_dir = os.path.join(arguments.project_config_dir, "reports")
    if not os.path.exists(reports_dir):
        os.mkdir(reports_dir)
    plt.savefig(os.path.join(reports_dir, "execution_time.png"))
