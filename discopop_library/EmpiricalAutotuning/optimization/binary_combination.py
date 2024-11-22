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
    configuration = patterns_by_hotspot_type[HotspotType.YES] + patterns_by_hotspot_type[HotspotType.MAYBE]

    # step 1: identify valid suggestions
    valid: Set[int] = set()
    queue: List[List[int]] = [[suggestion] for suggestion in configuration]
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
            if not arguments.skip_cleanup:
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

    # TODO: export list of valid suggestions
    # apply and test all valid suggesitons
    tmp_config = reference_configuration.create_copy(get_unique_configuration_id)
    tmp_config.apply_suggestions(arguments, sorted(list(valid)))
    tmp_config.execute(arguments, timeout=timeout_after)
    if not arguments.skip_cleanup:
        tmp_config.deleteFolder()
    debug_stats.append(
        (
            sorted(list(valid)),
            cast(ExecutionResult, tmp_config.execution_result).runtime,
            cast(ExecutionResult, tmp_config.execution_result).return_code,
            cast(ExecutionResult, tmp_config.execution_result).result_valid,
            cast(ExecutionResult, tmp_config.execution_result).thread_sanitizer,
            tmp_config.root_path,
        )
    )
    visited.append(sorted(list(valid)))

    show_debug_stats(debug_stats, logger)

    # step 2: pairwise combination
    try:
        logger.info(
            "Starting pairwise combination. Time remaining: "
            + str((int((start_time + time_limit_s) - time.time())))
            + "s"
        )
        logger.info("Press CTRL+C to stop the optimization manually.")
        combination_queue: List[List[SUGGESTION_ID]] = [[suggestion] for suggestion in valid]
        next_combination_queue: List[List[SUGGESTION_ID]] = []
        while time.time() < (start_time + time_limit_s):
            show_debug_stats(debug_stats, logger)
            if len(combination_queue) > 1:
                # get two suggestion configurations and and combine them
                combination_part_1 = combination_queue.pop()
                combination_part_2 = combination_queue.pop()
                current_combination = sorted(combination_part_1 + combination_part_2)
                if current_combination in visited:
                    continue
                # execute the new combination
                tmp_config = reference_configuration.create_copy(get_unique_configuration_id)
                tmp_config.apply_suggestions(arguments, current_combination)
                tmp_config.execute(arguments, timeout=timeout_after)
                if not arguments.skip_cleanup:
                    tmp_config.deleteFolder()
                exec_res = cast(ExecutionResult, tmp_config.execution_result)
                debug_stats.append(
                    (
                        current_combination,
                        exec_res.runtime,
                        exec_res.return_code,
                        exec_res.result_valid,
                        exec_res.thread_sanitizer,
                        tmp_config.root_path,
                    )
                )
                visited.append(current_combination)

                # if the result of the combination is valid, add it to next_combination queue for further combining
                # else, add the parts of the combination to the beginning and end of next_combination_queue to try
                # differing combinations and exclude invalid ones
                if exec_res.return_code == 0 and exec_res.result_valid and exec_res.thread_sanitizer:
                    next_combination_queue.append(current_combination)
                else:
                    next_combination_queue.insert(0, combination_part_1)  # prepend
                    next_combination_queue.append(combination_part_2)  # append

            elif len(combination_queue) == 1:
                next_combination_queue.append(combination_queue.pop())
                # enter next combination level, if more than one element in next_combination_queue
                if len(next_combination_queue) < 2:
                    logger.info("Pairwise combination finished.")
                    break
                else:
                    combination_queue = next_combination_queue
                    next_combination_queue = []
                    logger.info("ENTERING PAIRWISE COMBINATION LEVEL")

            else:
                # enter next combination level, if more than one element in next_combination_queue
                if len(next_combination_queue) < 2:
                    logger.info("Pairwise combination finished.")
                    break
                else:
                    combination_queue = next_combination_queue
                    next_combination_queue = []
                    logger.info("ENTERING PAIRWISE COMBINATION LEVEL")

    except KeyboardInterrupt:
        logger.info("Manually interupted the pairwise combination step.")
        pass

    # step 3: reverse global optimization from best pairwise combination
    # TODO
