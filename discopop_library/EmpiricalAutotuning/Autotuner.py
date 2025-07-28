# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import itertools
import json
import logging
import os
import time
from typing import List, Set, Tuple, cast

import jsonpickle  # type: ignore
from discopop_explorer.classes.PEGraph.LoopNode import LoopNode
from discopop_explorer.functions.PEGraph.queries.nodes import all_nodes
from discopop_library.EmpiricalAutotuning.ArgumentClasses import AutotunerArguments
from discopop_library.EmpiricalAutotuning.Classes.CodeConfiguration import CodeConfiguration
from discopop_library.EmpiricalAutotuning.Classes.ExecutionResult import ExecutionResult
from discopop_library.EmpiricalAutotuning.Statistics.StatisticsGraph import NodeColor, NodeShape, StatisticsGraph
from discopop_library.EmpiricalAutotuning.Types import SUGGESTION_ID
from discopop_library.EmpiricalAutotuning.optimization.check_single_combination import check_single_combination
from discopop_library.EmpiricalAutotuning.optimization.evolutionary_combination import execute_evolutionary_combination
from discopop_library.EmpiricalAutotuning.optimization.linear_hotspot_combination import (
    execute_linear_hotspot_combination,
)
from discopop_library.EmpiricalAutotuning.optimization.linear_hotspot_combination_with_refinement import (
    execute_linear_hotspot_combination_with_refinement,
)

from discopop_library.EmpiricalAutotuning.optimization.measure_only import execute_measure_only

from discopop_library.EmpiricalAutotuning.optimization.parallel_region_combination_with_refinement import (
    execute_parallel_region_combination_with_refinement,
)
from discopop_library.EmpiricalAutotuning.output.intermediate import show_info_stats
from discopop_library.EmpiricalAutotuning.priorities import get_prioritized_configurations
from discopop_library.EmpiricalAutotuning.utils import get_applicable_suggestion_ids
from discopop_library.FolderStructure.setup import setup_auto_tuner
from discopop_library.HostpotLoader.HotspotLoaderArguments import HotspotLoaderArguments
from discopop_library.HostpotLoader.HotspotNodeType import HotspotNodeType
from discopop_library.HostpotLoader.HotspotType import HotspotType
from discopop_library.HostpotLoader.hostpot_loader import run as load_hotspots
from discopop_library.HostpotLoader.utilities import get_patterns_by_hotspot_type
from discopop_library.result_classes.DetectionResult import DetectionResult

logger = logging.getLogger("Autotuner")

configuration_counter = 1


def get_unique_configuration_id() -> int:
    global configuration_counter
    buffer = configuration_counter
    configuration_counter += 1
    return buffer


def run(arguments: AutotunerArguments) -> None:
    logger.info("Starting discopop autotuner.")
    debug_stats: List[Tuple[List[SUGGESTION_ID], float, int, bool, bool, str]] = []
    statistics_graph = StatisticsGraph()
    statistics_step_num = 0

    setup_auto_tuner(os.getcwd())
    auto_tuner_dir = os.path.join(os.getcwd(), "auto_tuner")

    # get untuned reference result
    reference_configuration = CodeConfiguration(arguments.project_path, arguments.dot_dp_path, "par_settings.json")
    reference_configuration.execute(arguments, timeout=None, thread_count=arguments.thread_count, is_initial=True)
    statistics_graph.set_root(
        reference_configuration.get_statistics_graph_label(),
        color=reference_configuration.get_statistics_graph_color(),
        shape=NodeShape.BOX,
    )
    timeout_after = max(3.0, cast(ExecutionResult, reference_configuration.execution_result).runtime * 2)
    debug_stats.append(
        (
            [],
            cast(ExecutionResult, reference_configuration.execution_result).runtime,
            cast(ExecutionResult, reference_configuration.execution_result).return_code,
            cast(ExecutionResult, reference_configuration.execution_result).result_valid,
            cast(ExecutionResult, reference_configuration.execution_result).thread_sanitizer,
            reference_configuration.root_path,
        )
    )

    # load hotspots
    hsl_arguments = HotspotLoaderArguments(
        "WARNING", arguments.write_log, False, arguments.dot_dp_path, True, False, True, True, True
    )
    hotspot_information = load_hotspots(hsl_arguments)
    logger.debug("loaded hotspots")
    # load suggestions
    with open(os.path.join(arguments.dot_dp_path, "explorer", "detection_result_dump.json"), "r") as f:
        tmp_str = f.read()
    detection_result: DetectionResult = jsonpickle.decode(tmp_str)
    logger.debug("loaded suggestions")

    # get metadata: highest average runtime in hotspot information. Used to filter relevant loops (1% runtime contribution)
    max_avg_runtime = 0.0
    for hotspot_type in [HotspotType.YES, HotspotType.MAYBE, HotspotType.NO]:
        if hotspot_information:
            if hotspot_type not in hotspot_information:
                continue
            for info in hotspot_information[hotspot_type]:
                if info[4] > max_avg_runtime:
                    max_avg_runtime = info[4]

    # identify the best suggestion
    visited_configurations: List[List[SUGGESTION_ID]] = []
    best_suggestion_configuration: Tuple[List[SUGGESTION_ID], CodeConfiguration] = ([], reference_configuration)

    time_limit_s = 3600  # seconds

    if arguments.suggestions is None:
        if arguments.algorithm == 1:
            execute_linear_hotspot_combination(
                detection_result,
                hotspot_information,
                logger,
                time_limit_s,
                reference_configuration,
                arguments,
                timeout_after,
                debug_stats,
                get_unique_configuration_id,
            )
        elif arguments.algorithm == 2:
            execute_linear_hotspot_combination_with_refinement(
                detection_result,
                hotspot_information,
                logger,
                time_limit_s,
                reference_configuration,
                arguments,
                timeout_after,
                debug_stats,
                get_unique_configuration_id,
            )
        #        elif parallel_region_combination_with_refinement:
        #            execute_parallel_region_combination_with_refinement(
        #                detection_result,
        #                hotspot_information,
        #                logger,
        #                time_limit_s,
        #                reference_configuration,
        #                arguments,
        #                timeout_after,
        #                debug_stats,
        #                get_unique_configuration_id,
        #            )
        elif arguments.algorithm == 3:
            execute_evolutionary_combination(
                detection_result,
                hotspot_information,
                logger,
                time_limit_s,
                reference_configuration,
                arguments,
                timeout_after,
                debug_stats,
                get_unique_configuration_id,
            )
        else:
            execute_measure_only(
                detection_result,
                hotspot_information,
                logger,
                time_limit_s,
                reference_configuration,
                arguments,
                timeout_after,
                debug_stats,
                get_unique_configuration_id,
            )
    else:
        check_single_combination(
            detection_result,
            hotspot_information,
            logger,
            time_limit_s,
            reference_configuration,
            arguments,
            timeout_after,
            debug_stats,
            get_unique_configuration_id,
            [int(s) for s in arguments.suggestions.split(",")],
        )

    # select best option and create code folder
    if arguments.algorithm == 1:
        for stat_entry in sorted(debug_stats, key=lambda x: len(x[0]), reverse=True):
            if len(stat_entry[0]) != 0 and stat_entry[2] == 0 and stat_entry[3] == True and stat_entry[4] == True:
                sibling_config = reference_configuration.create_copy(
                    arguments, "par_settings.json", get_unique_configuration_id
                )
                sibling_config.apply_suggestions(arguments, stat_entry[0])
                sibling_config.execute(arguments, timeout=timeout_after, thread_count=arguments.thread_count)
                best_suggestion_configuration = (stat_entry[0], sibling_config)
                if not arguments.skip_cleanup:
                    sibling_config.deleteFolder()
                break
    elif arguments.algorithm == 2:
        sibling_config = reference_configuration.create_copy(
            arguments, "par_settings.json", get_unique_configuration_id
        )
        sibling_config.apply_suggestions(arguments, debug_stats[-1][0])
        sibling_config.execute(arguments, timeout=timeout_after, thread_count=arguments.thread_count)
        best_suggestion_configuration = (debug_stats[-1][0], sibling_config)
        if not arguments.skip_cleanup:
            sibling_config.deleteFolder()
    else:
        for stat_entry in sorted(debug_stats, key=lambda x: (x[1])):
            if len(stat_entry[0]) != 0 and stat_entry[2] == 0 and stat_entry[3] == True and stat_entry[4] == True:
                sibling_config = reference_configuration.create_copy(
                    arguments, "par_settings.json", get_unique_configuration_id
                )
                sibling_config.apply_suggestions(arguments, stat_entry[0])
                sibling_config.execute(arguments, timeout=timeout_after, thread_count=arguments.thread_count)
                best_suggestion_configuration = (stat_entry[0], sibling_config)
                if not arguments.skip_cleanup:
                    sibling_config.deleteFolder()
                break

    show_info_stats(debug_stats, logger)

    # export measurements for pdf creation
    if False:  # export all measurements
        with open("measurements.csv", "w+") as f:
            f.write("ID; time; return_code; thread_sanitizer\n")
            for stats in sorted(debug_stats, key=lambda x: x[1], reverse=True):
                f.write(str(stats[0]) + "; " + str(round(stats[1], 3)) + "; " + str(stats[2]) + ";" + "\n")
    else:  # export only sequential and best measurement
        with open("measurements.csv", "w+") as f:
            f.write("ID; time; return_code; thread_sanitizer\n")
            # write sequential measurement
            for stats in sorted(debug_stats, key=lambda x: x[1], reverse=True):
                if str(stats[0]) == "[]":
                    f.write(str(stats[0]) + "; " + str(round(stats[1], 3)) + "; " + str(stats[2]) + ";" + "\n")
            # write best measurement
            for stats in sorted(debug_stats, key=lambda x: x[1], reverse=False):
                if str(stats[2]) != "0":
                    continue
                if stats[3] == False:  # skip invalid results
                    continue
                f.write(str(stats[0]) + "; " + str(round(stats[1], 3)) + "; " + str(stats[2]) + ";" + "\n")
                break

    # calculate result statistics
    speedup = (
        cast(ExecutionResult, reference_configuration.execution_result).runtime
        / cast(ExecutionResult, best_suggestion_configuration[1].execution_result).runtime
    )
    parallel_efficiency = speedup * (1 / arguments.thread_count)

    # show result and statistics
    if best_suggestion_configuration[1] is None:
        print("No valid configuration found!")
    else:
        print("##############################")
        print("Best configuration located at: " + best_suggestion_configuration[1].root_path)
        print("Applied suggestions: " + str(best_suggestion_configuration[0]))
        print("Speedup: ", round(speedup, 3))
        print("Parallel efficiency: ", round(parallel_efficiency, 3))
        print("##############################")

        # export results to result.json
        results_json_path = os.path.join(auto_tuner_dir, "results.json")
        if os.path.exists(results_json_path):
            with open(results_json_path, "r") as f:
                results_dict = json.load(f)
        else:
            results_dict = dict()

        if arguments.configuration not in results_dict:
            results_dict[arguments.configuration] = dict()
        results_dict[arguments.configuration]["applied_suggestions"] = [
            str(s) for s in best_suggestion_configuration[0]
        ]
        results_dict[arguments.configuration]["speedup"] = round(speedup, 3)
        results_dict[arguments.configuration]["efficiency"] = round(parallel_efficiency, 3)
        results_dict[arguments.configuration]["time"] = cast(
            ExecutionResult, best_suggestion_configuration[1].execution_result
        ).runtime

        with open(results_json_path, "w+") as f:
            json.dump(results_dict, f, sort_keys=True, indent=4)

    # output statistics graph
    statistics_graph.output()
