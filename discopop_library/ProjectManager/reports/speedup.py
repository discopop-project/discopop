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

logger = logging.getLogger("ProjectManager")


def generate_speedup_report(arguments: ProjectManagerArguments, timestamp: str) -> None:
    execution_results_path = os.path.join(arguments.project_dir, "execution_results.json")
    if not os.path.exists(execution_results_path):
        print("No execution data available to report generation.")
        return
    with open(execution_results_path, "r") as f:
        execution_results = json.load(f)

    __plot_output(arguments, execution_results, timestamp)


def __plot_output(arguments: ProjectManagerArguments, execution_results: Dict[str, Any], timestamp: str) -> None:
    fig, ax = plt.subplots(layout="constrained")  # type: ignore
    configuration_names: List[str] = []
    tmp_values: Dict[str, Dict[int, Dict[str, float]]] = dict()
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

                # get sequential runtime for speedup calculation
                seq_runtime: float = -1.0
                if "seq_settings.json" in execution_results[configuration][script]:
                    for execution in execution_results[configuration][script]["seq_settings.json"]:
                        if execution["code"] == 0:
                            seq_runtime = execution["time"]

                best_speedup: Optional[float] = None
                best_thread_count: int = 1
                for execution in execution_results[configuration][script][setting]:
                    applied_suggestions_string += str(execution["applied_suggestions"]) + "\n"
                    return_codes_string += str(execution["code"]) + "\n"
                    times_string += str(execution["time"]) + "\n"
                    if execution["code"] == 0:
                        speedup = round(seq_runtime / execution["time"], 3)
                        if best_speedup is None:
                            best_speedup = speedup
                            best_thread_count = execution["thread_count"]
                        if speedup > best_speedup:
                            best_speedup = speedup
                            best_thread_count = execution["thread_count"]

                if best_speedup is None:
                    best_speedup = 0.0

                clean_setting_str = setting.replace("_settings.json", "")

                # collect, filter, and add values for plotting
                # only plot the best found option
                if "seq" not in clean_setting_str and "par" not in clean_setting_str:
                    continue
                if clean_setting_str not in tmp_values:
                    tmp_values[clean_setting_str] = dict()
                if best_thread_count not in tmp_values[clean_setting_str]:
                    tmp_values[clean_setting_str][best_thread_count] = dict()
                tmp_values[clean_setting_str][best_thread_count][configuration] = best_speedup

    # prepare values for plotting
    list_values: Dict[str, Dict[int, List[float]]] = dict()
    for setting in tmp_values:
        if setting not in list_values:
            list_values[setting] = dict()
        for thread_count in tmp_values[setting]:
            if thread_count not in list_values[setting]:
                list_values[setting][thread_count] = []
            for spec in configuration_names:
                if spec in tmp_values[setting][thread_count]:
                    list_values[setting][thread_count].append(tmp_values[setting][thread_count][spec])
                else:
                    # fill missing values
                    list_values[setting][thread_count].append(0.0)
    # convert lists to tuples
    for setting in list_values:
        for thread_count in list_values[setting]:
            values[setting + "(" + str(thread_count) + ")"] = tuple(list_values[setting][thread_count])

    # get max y value
    max_y_value = 0.0
    for setting in list_values:
        for thread_count in list_values[setting]:
            for val in list_values[setting][thread_count]:
                if val > max_y_value:
                    max_y_value = val

    x = np.arange(len(configuration_names))  # the label locations
    width = 0.25  # the width of the bars
    multiplier = 0

    for attribute, measurement in values.items():
        offset = width * multiplier
        rects = ax.bar(x + offset, measurement, width, label=attribute)
        ax.bar_label(rects, padding=3)
        multiplier += 1

    # Add some text for labels, title and custom x-axis tick labels, etc.
    ax.set_ylabel("Speedup")
    ax.set_title("Speedups of best valid configurations")
    ax.set_xticks(x + width, configuration_names)
    ax.legend(loc="upper left", ncols=3)
    ax.set_ylim(0, max_y_value + max_y_value * 0.15)

    reports_dir = os.path.join(arguments.project_dir, "reports")
    if not os.path.exists(reports_dir):
        os.mkdir(reports_dir)
    timestamp_dir = os.path.join(reports_dir, timestamp)
    if not os.path.exists(timestamp_dir):
        os.mkdir(timestamp_dir)
    plt.savefig(os.path.join(timestamp_dir, "speedups.pdf"))
