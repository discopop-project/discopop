from typing import List
import warnings
from discopop_validation.classes.OmpPragma import OmpPragma
from discopop_validation.discopop_suggestion_interpreter.do_all.core import interpret_do_all_suggestion
from discopop_validation.discopop_suggestion_interpreter.reduction.core import interpret_reduction_suggestion


def get_omp_pragmas_from_dp_suggestions(dp_suggestions) -> List[OmpPragma]:
    omp_pragmas: List[OmpPragma] = []
    for suggestion_type in dp_suggestions:
        if suggestion_type == "do_all":
            for do_all_suggestion in dp_suggestions[suggestion_type]:
                # construct omp pragma from do_all suggestion
                omp_pragmas.append(interpret_do_all_suggestion(do_all_suggestion))
        elif suggestion_type == "reduction":
            for reduction_suggestion in dp_suggestions[suggestion_type]:
                # construct omp pragma from reduction suggestion
                omp_pragmas.append(interpret_reduction_suggestion(reduction_suggestion))
        else:
            warnings.warn("Unsupported DiscoPoP suggestion type: \"" + suggestion_type +  "\". IGNORED -> TODO")
        # todo pipeline suggestions
        # todo geometric_decomposition suggestions
        # todo task suggestions
    return omp_pragmas
