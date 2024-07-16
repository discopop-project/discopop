import logging
from typing import List

from discopop_library.EmpiricalAutotuning.Types import SUGGESTION_ID
from discopop_library.result_classes.DetectionResult import DetectionResult

logger = logging.getLogger("uitls")

def get_applicable_suggestion_ids(file_id: int, start_line: int, dtres: DetectionResult )-> List[SUGGESTION_ID]:
    """Identify suggestions where start position matches the given start position and return their ids."""
    res: List[int] = []
    for pattern_type in dtres.patterns.__dict__:
        for pattern in dtres.patterns.__dict__[pattern_type]:
            if pattern.start_line == str(file_id) + ":" + str(start_line) and pattern.applicable_pattern:
                res.append(pattern.pattern_id)
    return res