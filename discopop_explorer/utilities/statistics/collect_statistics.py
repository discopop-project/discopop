# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

from __future__ import annotations
from typing import TYPE_CHECKING
import logging

from discopop_explorer.utilities.statistics.maximum_call_path_depth import get_maximum_call_path_depth
from discopop_explorer.utilities.statistics.num_function_calls import get_suggestion_num_function_calls
from discopop_explorer.utilities.statistics.suggestion_call_path_depths import get_suggestion_call_path_depths

if TYPE_CHECKING:
    from discopop_explorer.discopop_explorer import ExplorerArguments
    from discopop_library.result_classes.DetectionResult import DetectionResult

logger = logging.getLogger("statistics")


def collect_statistics(arguments: ExplorerArguments, res: DetectionResult) -> None:
    logger.info("Collecting code statistics...")
    maximum_call_path_depth = get_maximum_call_path_depth(res.pet)
    logger.debug("--> maximum_call_path_depth: " + str(maximum_call_path_depth))
    suggestion_call_path_depths = get_suggestion_call_path_depths(res)
    logger.debug(
        "--> suggestion_call_path_depths: "
        + str(
            [
                res.pet.node_at(key).start_position() + " => " + str(suggestion_call_path_depths[key])
                for key in suggestion_call_path_depths
            ]
        )
    )
    suggestion_num_function_calls = get_suggestion_num_function_calls(res)
    logger.debug(
        "--> suggestion_num_function_calls: "
        + str(
            [
                res.pet.node_at(key).start_position() + " => " + str(suggestion_num_function_calls[key])
                for key in suggestion_num_function_calls
            ]
        )
    )
