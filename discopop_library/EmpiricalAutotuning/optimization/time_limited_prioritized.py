# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

from logging import Logger
from typing import Callable, Dict, List, Tuple, cast
from discopop_library.EmpiricalAutotuning.ArgumentClasses import AutotunerArguments
from discopop_library.EmpiricalAutotuning.output.intermediate import show_debug_stats
from discopop_library.EmpiricalAutotuning.Classes.CodeConfiguration import CodeConfiguration
from discopop_library.EmpiricalAutotuning.Classes.ExecutionResult import ExecutionResult
from discopop_library.EmpiricalAutotuning.Types import SUGGESTION_ID
from discopop_library.EmpiricalAutotuning.priorities import get_prioritized_configurations
from discopop_library.HostpotLoader.HotspotNodeType import HotspotNodeType
from discopop_library.HostpotLoader.HotspotType import HotspotType
from discopop_library.HostpotLoader.hostpot_loader import AVERAGE_RUNTIME, FILEID, NAME, STARTLINE
from discopop_library.result_classes.DetectionResult import DetectionResult

import time


def execute_time_limited_prioritized_search(
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
    # time limited, prioritized full search
    prioritized_configurations = get_prioritized_configurations(detection_result, hotspot_information)
    logger.debug("PRIORITIZED_CONFIGURATIONS:")
    for entry in prioritized_configurations:
        logger.debug("--> " + str(entry))

    start_time = time.time()
    for entry in prioritized_configurations:
        if time_limit_s is not None:
            if time.time() > (start_time + time_limit_s):
                # time limit reached
                logger.info("search time limit of " + str(time_limit_s) + "s reached!")
                break
        current_config = list(entry)
        tmp_config = reference_configuration.create_copy(get_unique_configuration_id)
        tmp_config.apply_suggestions(arguments, current_config)
        tmp_config.execute(arguments, timeout=timeout_after)
        # only consider valid code
        debug_stats.append(
            (
                current_config,
                cast(ExecutionResult, tmp_config.execution_result).runtime,
                cast(ExecutionResult, tmp_config.execution_result).return_code,
                cast(ExecutionResult, tmp_config.execution_result).result_valid,
                cast(ExecutionResult, tmp_config.execution_result).thread_sanitizer,
                tmp_config.root_path,
            )
        )
        if (
            cast(ExecutionResult, tmp_config.execution_result).result_valid
            and cast(ExecutionResult, tmp_config.execution_result).return_code == 0
        ):
            pass
        else:
            if arguments.skip_cleanup:
                continue
            # delete invalid code
            tmp_config.deleteFolder()

        show_debug_stats(debug_stats, logger)
