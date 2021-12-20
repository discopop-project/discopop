from typing import Dict, List, Tuple

def identify_target_sections_from_suggestion(suggestion_type, suggestion) -> List[Tuple[str, str, str, str, str, str]]:
    """extracts relevant section in the original source code from the given suggestion and reports it as a tuple.
    Output format: [(<section_id>, <start_line>, <end_line>, <var_name>, <cu_id>, <suggestion_type>)]
    TODO: For now, only Do-All pattern is reported!
    """
    interim_result: List[Tuple[str, str, str, str, str]] = []
    # include do-all suggestions
    if suggestion_type == "do_all":
        start_line = suggestion["start_line"]
        end_line = suggestion["end_line"]
        for var in suggestion["shared"]:
            interim_result.append((start_line, end_line, var, suggestion["node_id"], "do_all"))
        interim_result = list(set(interim_result))
        result: List[Tuple[str, str, str, str, str, str]] = []
        for idx, r in enumerate(interim_result):
            result.append((str(idx), r[0], r[1], r[2], r[3], r[4]))
        return result
    else:
        return []

