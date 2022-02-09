from typing import Dict, List, Tuple
from discopop_validation.classes.OmpPragma import PragmaType
from discopop_validation.classes.OmpPragma import OmpPragma

def identify_target_sections_from_pragma(pragma: OmpPragma) -> List[Tuple[str, str, str, str, str, str]]:
    """extracts relevant section in the original source code from the given suggestion and reports it as a tuple.
    Output format: [(<section_id>, <file_id>, <start_line>, <end_line>, <var_name>, <suggestion_type>)]
    TODO: For now, only Do-All pattern is reported!
    """
    interim_result: List[Tuple[str, str, str, str, str]] = []
    # include parallel for pragmas
    if pragma.get_type() == PragmaType.PARALLEL_FOR:
        # list of variable names must end with ','!
        interim_result.append((pragma.file_id, pragma.start_line, pragma.end_line, ",".join(pragma.get_variables_listed_as("shared"))+",", pragma.get_type()))
        interim_result = list(set(interim_result))
        result: List[Tuple[str, str, str, str, str]] = []
        for idx, r in enumerate(interim_result):
            result.append((str(idx), str(r[0]), str(r[1]), str(r[2]), str(r[3]), str(r[4])))
        return result
    else:
        return []

