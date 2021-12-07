from typing import Dict, List, Tuple

def identify_target_sections_from_suggestions(suggestions: Dict) -> List[Tuple[str, str, str, str, str]]:
    """extracts relevant sections in the original source code from the gathered suggestions and reports them in tuples.
    Output format: [(<section_id>, <start_line>, <end_line>, <var_name>, <cu_id>, <suggestion_type>)]
    TODO: For now, only Do-All pattern is reported!
    """
    interim_result: List[Tuple[str, str, str]] = []
    # include do-all suggestions
    for do_all_sug in suggestions["do_all"]:
        start_line = do_all_sug["start_line"]
        end_line = do_all_sug["end_line"]
        for var in do_all_sug["shared"]:
            interim_result.append((start_line, end_line, var, do_all_sug["node_id"], "do_all"))
    interim_result = list(set(interim_result))
    result: List[Tuple[str, str, str, str]] = []
    for idx, r in enumerate(interim_result):
        result.append((str(idx), r[0], r[1], r[2], r[3], r[4]))
    return result