from enum import Enum


class EdgeType(Enum):
    CONTAINS = "contains"
    SEQUENTIAL = "sequential"
    CONCURRENT = "concurrent"  # currently unused
    DEPENDS = "depends"