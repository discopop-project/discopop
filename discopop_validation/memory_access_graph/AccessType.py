from enum import Enum


class AccessType(Enum):
    READ = "contains"
    WRITE = "sequential"
