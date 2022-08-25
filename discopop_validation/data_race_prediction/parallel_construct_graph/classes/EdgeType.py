from enum import Enum


class EdgeType(Enum):
    CONTAINS = "contains"
    SEQUENTIAL = "sequential"
    # VIRTUAL_SEQUENTIAL = "virtual_sequential"  # used to separate Predecessors and Successors of Taskwait / Barrier nodes
    CONCURRENT = "concurrent"  # currently unused
    DEPENDS = "depends"
    DATA_RACE = "data_race"
    CALLS = "calls"
    CALLS_RECURSIVE = "calls_recursive"
    BELONGS_TO = "belongs_to"
