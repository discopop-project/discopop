from typing import Dict, List

from discopop_explorer.pattern_detectors.PatternInfo import PatternInfo


def from_pattern_info(file_mapping: Dict[int, str], patterns: List[PatternInfo]) -> Dict[int, str]:
    """Insert the given parallel patterns into the original source code.
    Returns a dictionary which maps the ID of every modified file to the updated contents of the file.
    This method does not modify the original source code.
    Only fileIDs of files which would be modified occur as keys in the returned dictionary."""
    pass


def from_json_strings(
    file_mapping: Dict[int, str], pattern_json_strings: List[str]
) -> Dict[int, str]:
    """Insert the parallel patterns described by the given json strings into the original source code.
    Returns a dictionary which maps the ID of every modified file to the updated contents of the file.
    This method does not modify the original source code.
    Only fileIDs of files which would be modified occur as keys in the returned dictionary."""
    pass
