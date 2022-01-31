from typing import List
import warnings
from discopop_validation.classes.OmpPragma import OmpPragma
from discopop_validation.discopop_suggestion_interpreter.do_all.core import interpret_do_all_suggestion


def get_omp_pragmas_from_dp_suggestions(dp_suggestions) -> List[OmpPragma]:
    omp_pragmas: List[OmpPragma] = []
    for suggestion_type in dp_suggestions:
        # todo currently, only do_all suggestions are considered
        if suggestion_type == "do_all":
            for do_all_suggestion in dp_suggestions[suggestion_type]:
                # construct omp pragma from do_all suggestion
                omp_pragmas.append(interpret_do_all_suggestion(do_all_suggestion))
        else:
            warnings.warn("Unsupported DiscoPoP suggestion type: \"" + suggestion_type +  "\". IGNORED -> TODO")

    return omp_pragmas
