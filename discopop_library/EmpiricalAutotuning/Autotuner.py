import logging
import os
from typing import List, Optional, Set, Tuple, cast

import jsonpickle  # type: ignore
from discopop_library.EmpiricalAutotuning.ArgumentClasses import AutotunerArguments
from discopop_library.EmpiricalAutotuning.Classes.CodeConfiguration import CodeConfiguration
from discopop_library.EmpiricalAutotuning.Classes.ExecutionResult import ExecutionResult
from discopop_library.EmpiricalAutotuning.Types import SUGGESTION_ID
from discopop_library.EmpiricalAutotuning.utils import get_applicable_suggestion_ids
from discopop_library.HostpotLoader.HotspotLoaderArguments import HotspotLoaderArguments
from discopop_library.HostpotLoader.HotspotType import HotspotType
from discopop_library.HostpotLoader.hostpot_loader import run as load_hotspots
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
    debug_stats: List[Tuple[List[SUGGESTION_ID], float]] = []

    # get untuned reference result
    reference_configuration = CodeConfiguration(arguments.project_path, arguments.dot_dp_path)
    reference_configuration.execute(timeout=None)
    timeout_after = cast(ExecutionResult, reference_configuration.execution_result).runtime*2
    debug_stats.append(([], cast(ExecutionResult, reference_configuration.execution_result).runtime))

    # load hotspots
    hsl_arguments = HotspotLoaderArguments(
        arguments.log_level, arguments.write_log, False, arguments.dot_dp_path, True, False, True, True, True
    )
    hotspot_information = load_hotspots(hsl_arguments)
    logger.debug("loaded hotspots")
    # load suggestions
    with open(os.path.join(arguments.dot_dp_path, "explorer", "detection_result_dump.json"), "r") as f:
        tmp_str = f.read()
    detection_result: DetectionResult = jsonpickle.decode(tmp_str)
    logger.debug("loaded suggestions")

    # greedy search for best suggestion configuration:
    # for all hotspot types in descending importance:
    visited_configurations: List[List[SUGGESTION_ID]] = []
    best_suggestion_configuration: Tuple[List[SUGGESTION_ID], CodeConfiguration] = ([], reference_configuration)
    for hotspot_type in [HotspotType.YES, HotspotType.MAYBE, HotspotType.NO]:
        if hotspot_type not in hotspot_information:
            continue
        # for all loops in descending order by average execution time
        loop_tuples = hotspot_information[hotspot_type]
        sorted_loop_tuples = sorted(loop_tuples, key=lambda x: x[4], reverse=True)
        for loop_tuple in sorted_loop_tuples:
            # identify all applicable suggestions for this loop
            logger.debug(str(hotspot_type) + " loop: " + str(loop_tuple))
            # create code and execute for all applicable suggestions
            applicable_suggestions = get_applicable_suggestion_ids(loop_tuple[0], loop_tuple[1], detection_result)
            logger.debug("--> applicable suggestions: " + str(applicable_suggestions))
            suggestion_effects: List[Tuple[List[SUGGESTION_ID], CodeConfiguration]] = []
            for suggestion_id in applicable_suggestions:
                current_config = best_suggestion_configuration[0] + [suggestion_id]
                if current_config in visited_configurations:
                    continue
                visited_configurations.append(current_config)
                tmp_config = reference_configuration.create_copy(get_unique_configuration_id)
                tmp_config.apply_suggestions(arguments, current_config)
                tmp_config.execute(timeout=timeout_after)
                # only consider valid code
                if (
                    cast(ExecutionResult, tmp_config.execution_result).result_valid
                    and cast(ExecutionResult, tmp_config.execution_result).return_code == 0
                ):
                    suggestion_effects.append((current_config, tmp_config))
                    debug_stats.append((current_config, cast(ExecutionResult, tmp_config.execution_result).runtime))
            # add current best configuration for reference / to detect "no suggestions is beneficial"
            suggestion_effects.append(best_suggestion_configuration)

            logger.debug(
                "Suggestion effects:\n" + str([(str(t[0]), str(t[1].execution_result)) for t in suggestion_effects])
            )

            # select the best option and save it in the current best_configuration
            sorted_suggestion_effects = sorted(suggestion_effects, key=lambda x: cast(ExecutionResult, x[1].execution_result).runtime)
            buffer = sorted_suggestion_effects[0]
            best_suggestion_configuration = buffer
            sorted_suggestion_effects = sorted_suggestion_effects[1:]  # in preparation of cleanup step
            logger.debug(
                "Current best configuration: "
                + str(best_suggestion_configuration[0])
                + " stored at "
                + best_suggestion_configuration[1].root_path
            )
            # cleanup other configurations (excluding original version)
            logger.debug("Cleanup:")
            for _, config in sorted_suggestion_effects:
                if config.root_path == reference_configuration.root_path:
                    continue
                config.deleteFolder()

            # continue with the next loop

    # show debug stats
    stats_str = "Configuration measurements:\n"
    stats_str += "[time]\t[applied suggestions]\n"
    for stats in sorted(debug_stats, key=lambda x: x[1], reverse=True):
        stats_str += str(round(stats[1], 3)) + "s" + "\t" + str(stats[0]) + "\n"
    logger.info(stats_str)

    # calculate result statistics
    speedup = (
        cast(ExecutionResult, reference_configuration.execution_result).runtime
        / cast(ExecutionResult, best_suggestion_configuration[1].execution_result).runtime
    )
    parallel_efficiency = speedup*(1/cast(int, (0 if os.cpu_count() is None else os.cpu_count())))

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
