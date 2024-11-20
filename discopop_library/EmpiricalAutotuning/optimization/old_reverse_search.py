# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

from logging import Logger
from typing import Callable, Dict, List, Set, Tuple, cast
from discopop_library.EmpiricalAutotuning.ArgumentClasses import AutotunerArguments
from discopop_library.EmpiricalAutotuning.output.intermediate import show_info_stats
from discopop_library.EmpiricalAutotuning.Classes.CodeConfiguration import CodeConfiguration
from discopop_library.EmpiricalAutotuning.Classes.ExecutionResult import ExecutionResult
from discopop_library.EmpiricalAutotuning.Types import SUGGESTION_ID
from discopop_library.EmpiricalAutotuning.output.intermediate import show_debug_stats
from discopop_library.EmpiricalAutotuning.priorities import get_patterns_by_hotspot_type
from discopop_library.HostpotLoader.HotspotNodeType import HotspotNodeType
from discopop_library.HostpotLoader.HotspotType import HotspotType
from discopop_library.HostpotLoader.hostpot_loader import AVERAGE_RUNTIME, FILEID, NAME, STARTLINE
from discopop_library.result_classes.DetectionResult import DetectionResult

import time


def execute_binary_combination(
    detection_result: DetectionResult,
    hotspot_information: Dict[HotspotType, List[Tuple[FILEID, STARTLINE, HotspotNodeType, NAME, AVERAGE_RUNTIME]]],
    logger: Logger,
    time_limit_s: int,
    reference_configuration: CodeConfiguration,
    arguments: AutotunerArguments,
    timeout_after: float,
    debug_stats: List[Tuple[List[SUGGESTION_ID], float, int, bool, bool, str]],
    get_unique_configuration_id: Callable[[], int],
) -> None:
    # time limited reverse greedy search in hotspot parallelizations
    patterns_by_hotspot_type = get_patterns_by_hotspot_type(detection_result, hotspot_information)
    logger.debug("Patterns by hotspot type")
    logger.debug(str(patterns_by_hotspot_type))

    start_time = time.time()
    visited = []

    # initialize with all YES and MAYBE hotspot suggestions
    configuration = patterns_by_hotspot_type[HotspotType.YES]  # + patterns_by_hotspot_type[HotspotType.MAYBE]
    tmp_config = reference_configuration.create_copy(get_unique_configuration_id)
    tmp_config.apply_suggestions(arguments, configuration)
    tmp_config.execute(arguments, timeout=timeout_after)
    tmp_config.deleteFolder()
    debug_stats.append(
        (
            configuration,
            cast(ExecutionResult, tmp_config.execution_result).runtime,
            cast(ExecutionResult, tmp_config.execution_result).return_code,
            cast(ExecutionResult, tmp_config.execution_result).result_valid,
            cast(ExecutionResult, tmp_config.execution_result).thread_sanitizer,
            tmp_config.root_path,
        )
    )
    visited.append(configuration)

    # step 1: identify valid suggestions
    valid: Set[int] = set()
    queue: List[List[int]] = [[suggestion] for suggestion in configuration]  # [configuration]
    logger.info("Identifying valid suggestions:")
    logger.info("Press CTRL+C to manually stop the search.")
    try:
        dbg_initial_queue_len = len(queue)
        while queue:
            logger.info("--- " + str(len(queue)) + " / " + str(dbg_initial_queue_len))
            current = queue.pop()
            # execute current and check validity
            tmp_config = reference_configuration.create_copy(get_unique_configuration_id)
            tmp_config.apply_suggestions(arguments, current)
            tmp_config.execute(arguments, timeout=timeout_after)
            tmp_config.deleteFolder()
            debug_stats.append(
                (
                    current,
                    cast(ExecutionResult, tmp_config.execution_result).runtime,
                    cast(ExecutionResult, tmp_config.execution_result).return_code,
                    cast(ExecutionResult, tmp_config.execution_result).result_valid,
                    cast(ExecutionResult, tmp_config.execution_result).thread_sanitizer,
                    tmp_config.root_path,
                )
            )
            visited.append(current)

            # if invalid, split current into two parts and put into queue
            exec_res = cast(ExecutionResult, tmp_config.execution_result)
            if exec_res.return_code == 0 and (
                (exec_res.thread_sanitizer and exec_res.result_valid)
                or (not exec_res.thread_sanitizer and exec_res.result_valid)
            ):
                # result valid
                valid = valid.union(current)
                show_debug_stats(debug_stats, logger)
            else:
                # result invalid
                continue
    except KeyboardInterrupt:
        logger.info("Manually stopped search for valid suggestions.")
        show_info_stats(debug_stats, logger)
        pass

    logger.info("Valid: " + str(valid))
    logger.info("List VALID: " + str(list(valid)))

    # todo: export list of valid suggestions
    tmp_config = reference_configuration.create_copy(get_unique_configuration_id)
    tmp_config.apply_suggestions(arguments, list(valid))
    tmp_config.execute(arguments, timeout=timeout_after)
    tmp_config.deleteFolder()
    debug_stats.append(
        (
            list(valid),
            cast(ExecutionResult, tmp_config.execution_result).runtime,
            cast(ExecutionResult, tmp_config.execution_result).return_code,
            cast(ExecutionResult, tmp_config.execution_result).result_valid,
            cast(ExecutionResult, tmp_config.execution_result).thread_sanitizer,
            tmp_config.root_path,
        )
    )
    visited.append(list(valid))

    show_debug_stats(debug_stats, logger)

    # step 3: global optimization
    try:
        logger.info(
            "Starting global optimization. Time remaining: "
            + str((int((start_time + time_limit_s) - time.time())))
            + "s"
        )
        logger.info("Press CTRL+C to stop the optimization manually.")
        while time.time() < (start_time + time_limit_s):
            show_debug_stats(debug_stats, logger)

            # select the best configuration and spawn it's siblings
            sorted_stats = sorted(debug_stats, key=lambda x: (x[1]), reverse=False)
            configuration_2 = None
            for stat_entry in sorted_stats:
                if (
                    len(stat_entry[0]) != 0
                    and stat_entry[2] == 0
                    and stat_entry[3] == True
                    and stat_entry[4] == True
                    and stat_entry[0] not in visited
                ):
                    configuration_2 = stat_entry[0]
                    break
                else:
                    if stat_entry[0] not in visited:
                        configuration_2 = stat_entry[0]

            valid_non_trivial_config_found = False
            for stat_entry in sorted_stats:
                if len(stat_entry[0]) != 0 and stat_entry[2] == 0 and stat_entry[3] == True and stat_entry[4] == True:
                    valid_non_trivial_config_found = True

            if not valid_non_trivial_config_found and configuration_2 is None:
                # second try with relaxed conditions
                if configuration_2 is None:
                    logger.debug("Searching with relaxed conditions")
                    for stat_entry in sorted_stats:
                        if len(stat_entry[0]) != 0 and stat_entry[2] == 0 and stat_entry[0] not in visited:
                            configuration_2 = stat_entry[0]
                            break
                        else:
                            if stat_entry[0] not in visited:
                                configuration_2 = stat_entry[0]

                # third try with even more relaxed conditions
                if configuration_2 is None:
                    logger.debug("Searching with strongly relaxed conditions")
                    for stat_entry in sorted_stats:
                        if len(stat_entry[0]) != 0 and stat_entry[0] not in visited:
                            configuration_2 = stat_entry[0]
                            break
                        else:
                            if stat_entry[0] not in visited:
                                configuration_2 = stat_entry[0]

            if configuration_2 is None:
                logger.info("No further configuration found.")
                break
            visited.append(configuration_2)
            logger.debug("Selected: " + str(configuration_2))

            # spawn siblings
            siblings = []
            for i in range(0, len(configuration_2)):
                siblings.append(configuration_2[:i] + configuration_2[(i + 1) :])
            logger.debug("Siblings: " + str(siblings))

            time_limit_reached = False
            for sibling in siblings:
                if len(sibling) == 0:
                    continue
                if time.time() > (start_time + time_limit_s):
                    logger.info("Reached time limit of " + str(time_limit_s) + "s")
                    time_limit_reached = True
                    break
                sibling_config = reference_configuration.create_copy(get_unique_configuration_id)
                sibling_config.apply_suggestions(arguments, sibling)
                sibling_config.execute(arguments, timeout=timeout_after)
                sibling_config.deleteFolder()
                debug_stats.append(
                    (
                        sibling,
                        cast(ExecutionResult, sibling_config.execution_result).runtime,
                        cast(ExecutionResult, sibling_config.execution_result).return_code,
                        cast(ExecutionResult, sibling_config.execution_result).result_valid,
                        cast(ExecutionResult, sibling_config.execution_result).thread_sanitizer,
                        sibling_config.root_path,
                    )
                )
                show_debug_stats(debug_stats, logger)
            if time_limit_reached:
                break
    except KeyboardInterrupt:
        logger.info("Manually interupted the global optimization.")
        pass
