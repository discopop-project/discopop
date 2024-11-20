# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

from discopop_library.EmpiricalAutotuning.Types import SUGGESTION_ID


import logging
from typing import List, Tuple


def show_debug_stats(
    debug_stats: List[Tuple[List[SUGGESTION_ID], float, int, bool, bool, str]], logger: logging.Logger
) -> None:
    # show debug stats
    stats_str = "Configuration measurements:\n"
    stats_str += "[time]\t[applied suggestions]\t[return code]\t[result valid]\t[thread sanitizer]\t[path]\n"
    for stats in sorted(debug_stats, key=lambda x: (x[1]), reverse=True):
        stats_str += (
            str(round(stats[1], 3))
            + "s"
            + "\t"
            + str(stats[0])
            + "\t"
            + str(stats[2])
            + "\t"
            + str(stats[3])
            + "\t"
            + str(stats[4])
            + "\t"
            + str(stats[5])
            + "\n"
        )
    logger.debug(stats_str)


def show_info_stats(
    debug_stats: List[Tuple[List[SUGGESTION_ID], float, int, bool, bool, str]], logger: logging.Logger
) -> None:
    # show debug stats
    stats_str = "Configuration measurements:\n"
    stats_str += "[time]\t[applied suggestions]\t[return code]\t[result valid]\t[thread sanitizer]\n"
    for stats in sorted(debug_stats, key=lambda x: (x[1]), reverse=True):
        stats_str += (
            str(round(stats[1], 3))
            + "s"
            + "\t"
            + str(stats[0])
            + "\t"
            + str(stats[2])
            + "\t"
            + str(stats[3])
            + "\t"
            + str(stats[4])
            + "\n"
        )
    logger.info(stats_str)
