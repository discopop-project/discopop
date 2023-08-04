# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
from typing import Tuple, Optional

from discopop_explorer.PETGraphX import MemoryRegion


class ReadDataAccess(object):
    memory_region: MemoryRegion
    var_name: Optional[str]

    def __init__(self, memory_region: MemoryRegion, var_name: Optional[str]):
        self.memory_region = memory_region
        self.var_name = var_name

    def __str__(self):
        return "R(" + self.memory_region + ")"


class WriteDataAccess(object):
    memory_region: MemoryRegion
    unique_id: int
    var_name: Optional[str]

    def __init__(self, memory_region: MemoryRegion, unique_id: int, var_name: Optional[str]):
        self.memory_region = memory_region
        self.unique_id = unique_id
        self.var_name = var_name

    def __str__(self):
        return (
            "W(" + self.memory_region + "-" + str(self.unique_id) + ", --> " + self.var_name + ")"
        )

    def __hash__(self):
        return self.unique_id
