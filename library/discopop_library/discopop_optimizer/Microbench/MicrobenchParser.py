# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
import json
from dataclasses import dataclass
from typing import Dict, List, Tuple

from discopop_library.discopop_optimizer.Microbench.Microbench import (
    MicrobenchType,
    MicrobenchCoordinate,
    MicrobenchDimension,
)

# threads/workload/iterations
ParsedCoordinate = Tuple[int, int, int]


@dataclass
class ParsedMicrobenchResults:
    measurements: Dict[
        MicrobenchType,
        Dict[MicrobenchDimension, Dict[MicrobenchCoordinate, List[float]]],
    ]


def parseMicrobenchResults(jsonPath: str) -> ParsedMicrobenchResults:
    # Parse JSON into an object with attributes corresponding to dict keys.
    with open(jsonPath) as file:
        json_data = json.loads(file.read())

    measurements: Dict[
        MicrobenchType,
        Dict[MicrobenchDimension, Dict[MicrobenchCoordinate, List[float]]],
    ] = dict()
    for type_string, dim_map in json_data["measurements"].items():
        mb_type = MicrobenchType(type_string)
        measurements[mb_type] = dict()
        for dim_string, coord_list in dim_map.items():
            mb_dim = MicrobenchDimension(dim_string)
            measurements[mb_type][mb_dim] = dict()
            for obj in coord_list:
                coord = MicrobenchCoordinate(*obj["point"])
                values = obj["values"]
                measurements[mb_type][mb_dim][coord] = values
    return ParsedMicrobenchResults(measurements)
