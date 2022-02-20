from enum import Enum


class EdgeType(Enum):
    CONTAINS = "contains"
    SUCCESSOR = "successor"
    DEPENDS = "depends"