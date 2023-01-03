from enum import IntEnum
from typing import Optional, List, Any


class PragmaPosition(IntEnum):
    BEFORE_START = 0
    AFTER_START = 1
    BEFORE_END = 2
    AFTER_END = 3


class Pragma(object):
    pragma_str: str = ""
    file_id: Optional[int] = None
    start_line: Optional[int] = None
    end_line: Optional[int] = None
    pragma_position: PragmaPosition = PragmaPosition.BEFORE_START
    parent_cu_id: str = ""
    children: List[Any] = []
