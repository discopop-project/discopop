# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

from typing import Dict, Set
from discopop_explorer.aliases.NodeID import NodeID
from discopop_library.result_classes.DetectionResult import DetectionResult


def get_suggestion_immediate_lines_of_code(res: DetectionResult) -> Dict[int, int]:  # pattern_id: lines of code
    # immediate lines of code --> scope size without following function calls
    res_dict: Dict[int, int] = dict()

    # collect scope sizes without following function calls
    for pattern_type in res.patterns.__dict__:
        for pattern in res.patterns.__dict__[pattern_type]:
            start_line_num = int(pattern.start_line.split(":")[1])
            end_line_num = int(pattern.end_line.split(":")[1])
            res_dict[pattern.pattern_id] = end_line_num - start_line_num

    return res_dict
