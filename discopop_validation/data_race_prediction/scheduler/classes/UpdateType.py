from enum import Enum


class UpdateType(Enum):
    READ = "R"
    WRITE = "W"
    LOCK = "L"
    UNLOCK = "U"
    ENTERPARALLEL = "ENTER"
    EXITPARALLEL = "EXIT"
