# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

from logging import Logger
import subprocess
from typing import Callable, Dict, List, Set, Tuple, cast
from discopop_library.EmpiricalAutotuning.ArgumentClasses import AutotunerArguments
from discopop_library.EmpiricalAutotuning.output.intermediate import show_info_stats
from discopop_library.EmpiricalAutotuning.Classes.CodeConfiguration import CodeConfiguration
from discopop_library.EmpiricalAutotuning.Classes.ExecutionResult import ExecutionResult
from discopop_library.EmpiricalAutotuning.Types import SUGGESTION_ID
from discopop_library.EmpiricalAutotuning.output.intermediate import show_debug_stats
from discopop_library.HostpotLoader.utilities import get_patterns_by_hotspot_type
from discopop_library.HostpotLoader.HotspotNodeType import HotspotNodeType
from discopop_library.HostpotLoader.HotspotType import HotspotType
from discopop_library.HostpotLoader.hostpot_loader import AVERAGE_RUNTIME, FILEID, NAME, STARTLINE
from discopop_library.result_classes.DetectionResult import DetectionResult

import time


def check_single_combination(
    detection_result: DetectionResult,
    hotspot_information: Dict[HotspotType, List[Tuple[FILEID, STARTLINE, HotspotNodeType, NAME, AVERAGE_RUNTIME]]],
    logger: Logger,
    time_limit_s: int,
    reference_configuration: CodeConfiguration,
    arguments: AutotunerArguments,
    timeout_after: float,
    debug_stats: List[Tuple[List[SUGGESTION_ID], float, int, bool, bool, str]],
    get_unique_configuration_id: Callable[[], int],
    applied_suggestions: list[int],
) -> None:
    # time limited reverse greedy search in hotspot parallelizations
    patterns_by_hotspot_type = get_patterns_by_hotspot_type(detection_result, hotspot_information)
    logger.debug("Patterns by hotspot type")
    logger.debug(str(patterns_by_hotspot_type))

    start_time = time.time()

    # initialize with all hotspot suggestions
    configuration = patterns_by_hotspot_type[HotspotType.YES]

    # step 1: identify valid suggestions
    logger.info("Checking applied suggestions: " + str(applied_suggestions))
    logger.info("Press CTRL+C to manually stop.")
    try:
        # execute current and check validity
        tmp_config = reference_configuration.create_copy(arguments, "par_settings.json", get_unique_configuration_id)
        tmp_config.apply_suggestions(arguments, applied_suggestions)
        tmp_config.execute(arguments, timeout=timeout_after, thread_count=arguments.thread_count)
        if not arguments.skip_cleanup:
            tmp_config.deleteFolder()
        debug_stats.append(
            (
                applied_suggestions,
                cast(ExecutionResult, tmp_config.execution_result).runtime,
                cast(ExecutionResult, tmp_config.execution_result).return_code,
                cast(ExecutionResult, tmp_config.execution_result).result_valid,
                cast(ExecutionResult, tmp_config.execution_result).thread_sanitizer,
                tmp_config.root_path,
            )
        )

        show_debug_stats(debug_stats, logger)
    except KeyboardInterrupt:
        logger.info("Manually stopped search for valid suggestions.")
        show_info_stats(debug_stats, logger)
        pass

    show_debug_stats(debug_stats, logger)

    # step 2: refinement

    # get hotspot measurement of created configuration
    sibling_config = reference_configuration.create_copy(arguments, "hd_settings.json", get_unique_configuration_id)
    sibling_config.apply_suggestions(arguments, applied_suggestions)
    sibling_config.execute(arguments, timeout=None, thread_count=arguments.thread_count)

    # prepare creation of cleaned results
    cleaned_config = reference_configuration.create_copy(arguments, "par_settings.json", get_unique_configuration_id)

    # get baseline hotspot measurement of reference_configuration
    baseline_configuration = reference_configuration.create_copy(
        arguments, "hd_settings.json", get_unique_configuration_id
    )
    baseline_configuration.execute(arguments, timeout=None, thread_count=arguments.thread_count)

    # compare measurements and apply refinement
    cmd = (
        "hotspot_comparator -b "
        + baseline_configuration.config_dot_dp_path
        + " -u "
        + sibling_config.config_dot_dp_path
    )
    if arguments.allow_plots:
        cmd += " --plot"

    logger.debug("CMD: " + cmd)

    raw_slow_suggestions = subprocess.run(cmd, executable="/bin/bash", shell=True, capture_output=True)
    logger.getChild("hotspotComparatorReturnCode").info(str(raw_slow_suggestions.returncode))
    logger.getChild("hotspotComparatorOutput").info(str(raw_slow_suggestions.stdout.decode("utf-8")))
    logger.getChild("hotspotComparatorError").info(str(raw_slow_suggestions.stderr.decode("utf-8")))
    raw_slow_suggestions_str = raw_slow_suggestions.stdout.decode("utf-8")
    raw_slow_suggestions_str = (
        raw_slow_suggestions_str.replace(" ", "").replace("[", "").replace("]", "").replace("\n", "")
    )
    slow_suggestions = [int(id_str) for id_str in raw_slow_suggestions_str.split(",") if len(id_str) > 0]
    logger.info("Slow suggestions: " + str(slow_suggestions))

    # create cleaned configuration
    cleaned_config.apply_suggestions(arguments, [id for id in applied_suggestions if id not in slow_suggestions])
    cleaned_config.execute(arguments, timeout=timeout_after, thread_count=arguments.thread_count)

    debug_stats.append(
        (
            [id for id in applied_suggestions if id not in slow_suggestions],
            cast(ExecutionResult, cleaned_config.execution_result).runtime,
            cast(ExecutionResult, cleaned_config.execution_result).return_code,
            cast(ExecutionResult, cleaned_config.execution_result).result_valid,
            cast(ExecutionResult, cleaned_config.execution_result).thread_sanitizer,
            cleaned_config.root_path,
        )
    )

    # cleanup
    sibling_config.deleteFolder()
    baseline_configuration.deleteFolder()
    cleaned_config.deleteFolder()

    logger.info("DEBUG STATS AFTER REFINEMENT")
    show_debug_stats(debug_stats, logger)
