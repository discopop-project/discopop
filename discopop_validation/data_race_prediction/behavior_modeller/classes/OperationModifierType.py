from enum import IntEnum


class OperationModifierType(IntEnum):
    REDUCTION_OPERATION = 1
    CRITICAL_SECTION_OPERATION = 2
    MUTEX = 3
    LOOP_OPERATION = 4
