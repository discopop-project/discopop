# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import json
import os.path
from pathlib import Path
from typing import Dict


def initialize_line_mapping(
    file_mapping: Dict[int, Path],
    discopop_path: str = ".discopop",
):
    """initializes the line mapping dictionary to track line shifts due to inserted pragmas.
    The Dictionary will be stored in .discopop/line_mapping.json.
    Line ids start with 1."""
    line_mapping_dict: Dict[int, Dict[int, int]] = dict()

    # initialize line mapping (1->1, 2->2, ...)
    for file_id in file_mapping:
        if file_id not in line_mapping_dict:
            line_mapping_dict[file_id] = dict()
        line_id = 1
        with open(file_mapping[file_id], "r") as f:
            for line in f.readlines():
                line_mapping_dict[file_id][line_id] = line_id
                line_id += 1

    # dump line mapping to json file
    with open(os.path.join(discopop_path, "line_mapping.json"), "w+") as f:
        json.dump(line_mapping_dict, f)
