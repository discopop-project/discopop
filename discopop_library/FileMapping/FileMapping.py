# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import os.path
from pathlib import Path
from typing import Dict


def load_file_mapping(fmap_path: str) -> Dict[int, Path]:
    if not os.path.exists(fmap_path):
        raise ValueError("Path does not exist! ", fmap_path)

    file_mapping: Dict[int, Path] = dict()

    with open(fmap_path, "r") as f:
        for line in f.readlines():
            line = line.replace("\n", "")
            split_line = line.split("\t")
            file_id = int(split_line[0])
            file_path = split_line[1]
            file_mapping[file_id] = Path(file_path)
    return file_mapping
