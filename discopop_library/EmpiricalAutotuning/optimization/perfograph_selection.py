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
from discopop_explorer.aliases.LineID import LineID
from discopop_explorer.classes.PEGraph.Node import Node
from discopop_explorer.pattern_detectors.clang_loop_vectorization_detector import ClangVectorizationInfo
from discopop_explorer.pattern_detectors.do_all_detector import DoAllInfo
from discopop_explorer.pattern_detectors.reduction_detector import ReductionInfo
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
from discopop_library.Stubs.PerfoGraph.classes import PerfoGraphLoopTarget
from discopop_library.Stubs.PerfoGraph.loopTargetSelection import select_loop_target
from discopop_library.result_classes.DetectionResult import DetectionResult

import time


def execute_perfograph_selection(
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
    # let perfograph classification decide where and which patterns to apply
    start_time = time.time()
    visited = []

    # initialize with all suggestions
    considered_pattern_ids = detection_result.patterns.get_pattern_ids()

    # collect loops to be classified
    loop_to_patterns_dict: Dict[Node, List[int]] = dict()
    for pattern_id in considered_pattern_ids:
        loop_node = detection_result.patterns.get_pattern_from_id(pattern_id)._node
        if loop_node not in loop_to_patterns_dict:
            loop_to_patterns_dict[loop_node] = []
        loop_to_patterns_dict[loop_node].append(pattern_id)
    print("Loop_to_patterns:", loop_to_patterns_dict)

    # get target selection from perfograph per loop
    target_by_loop: Dict[Node, PerfoGraphLoopTarget] = dict()
    for loop_node in loop_to_patterns_dict:
        if len(loop_to_patterns_dict) > 1:
            target_by_loop[loop_node] = select_loop_target(detection_result.pet, loop_node)
    print("target_by_loop: ", target_by_loop)

    # collect the suggestion for application
    configuration: List[int] = []
    for loop_node in loop_to_patterns_dict:
        if len(loop_to_patterns_dict[loop_node]) > 1:
            # select pattern representing the determined target
            found_match = False
            for pattern_id in loop_to_patterns_dict[loop_node]:
                pattern = detection_result.patterns.get_pattern_from_id(pattern_id)
                if target_by_loop[loop_node] == PerfoGraphLoopTarget.SEQUENTIAL:
                    # select nothing
                    found_match = True
                    break
                elif target_by_loop[loop_node] == PerfoGraphLoopTarget.OMP_FOR:
                    # select pattern of type doall or reduction
                    if type(pattern) == ReductionInfo or type(pattern) == DoAllInfo:
                        found_match = True
                        configuration.append(pattern_id)
                        break
                elif target_by_loop[loop_node] == PerfoGraphLoopTarget.CLANG_VECTORIZE:
                    # select pattern of type clang_vectorizable_loop
                    if type(pattern) == ClangVectorizationInfo:
                        found_match = True
                        configuration.append(pattern_id)
                        break
            if not found_match:
                raise ValueError(
                    "Could not find a pattern to implement the perfograph target selection: "
                    + str(target_by_loop[loop_node])
                    + " for loop at line "
                    + str(loop_node.start_position())
                )

        else:
            # selection is trivial
            configuration.append(loop_to_patterns_dict[loop_node][0])

    print("configuration:", configuration)

    # step 1: identify valid suggestions
    valid: Set[int] = set()
    queue: List[List[int]] = [[suggestion] for suggestion in configuration]
    logger.info("Identifying valid combination of perfograph-selected parallelization suggestions:")
    logger.info("Press CTRL+C to manually stop the search.")
    try:
        dbg_initial_queue_len = len(queue)
        while queue:
            logger.info("--- " + str(len(queue)) + " / " + str(dbg_initial_queue_len))
            current = queue.pop()
            # execute current and check validity
            tmp_config = reference_configuration.create_copy(
                arguments, "par_settings.json", get_unique_configuration_id
            )
            tmp_config.apply_suggestions(arguments, list(valid) + current)
            tmp_config.execute(arguments, timeout=timeout_after)
            if not arguments.skip_cleanup:
                tmp_config.deleteFolder()
            debug_stats.append(
                (
                    list(valid) + current,
                    cast(ExecutionResult, tmp_config.execution_result).runtime,
                    cast(ExecutionResult, tmp_config.execution_result).return_code,
                    cast(ExecutionResult, tmp_config.execution_result).result_valid,
                    cast(ExecutionResult, tmp_config.execution_result).thread_sanitizer,
                    tmp_config.root_path,
                )
            )
            visited.append(list(valid) + current)

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

    show_debug_stats(debug_stats, logger)
