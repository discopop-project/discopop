# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

from enum import IntEnum


class HotspotType(IntEnum):
    NO = 0
    YES = 1
    MAYBE = 2
    
    
def get_HotspotType_from_string(input: str) -> HotspotType:
    if input == "NO":
        return HotspotType.NO
    if input == "YES": 
        return HotspotType.YES
    if input == "MAYBE":
        return HotspotType.MAYBE
    raise ValueError("Unknown Hotspot type: " + input)