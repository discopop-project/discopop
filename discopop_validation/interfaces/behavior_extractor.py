from typing import List, Tuple
from ...discopop_explorer import DetectionResult


def get_relevant_sections_from_suggestions(suggestions: DetectionResult) -> List[Tuple[int, int, str]]:
    """extracts relevant sections in the original source code from the gathered suggestions and reports them in tuples.
    Output format: [(<start_line>, <end_line>, <var_name>)]
    TODO: For now, only Do-All pattern is reported!
    """
    result: List[Tuple[int, int, str]] = []
    # include do-all suggestions
    for do_all_sug in suggestions.do_all:
        start_line = do_all_sug.start_line
        end_line = do_all_sug.end_line
        for var in do_all_sug.shared:
            result.append((start_line, end_line, var.name))
    return result
