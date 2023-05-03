from typing import Tuple

from discopop_explorer.PETGraphX import MemoryRegion


class ReadDataAccess(object):
    memory_region: MemoryRegion

    def __init__(self, memory_region: MemoryRegion):
        self.memory_region = memory_region

    def __str__(self):
        return "R(" + self.memory_region + ")"


class WriteDataAccess(object):
    memory_region: MemoryRegion
    unique_id: int

    def __init__(self, memory_region: MemoryRegion, unique_id: int):
        self.memory_region = memory_region
        self.unique_id = unique_id

    def __str__(self):
        return "W(" + self.memory_region + "-" + str(self.unique_id) + ")"
