from typing import List
import warnings
from discopop_validation.classes.OmpPragma import OmpPragma
from discopop_validation.discopop_suggestion_interpreter.do_all.core import interpret_do_all_suggestion
from discopop_validation.discopop_suggestion_interpreter.reduction.core import interpret_reduction_suggestion
from discopop_validation.discopop_suggestion_interpreter.task.core import interpret_task_suggestion


def get_omp_pragmas_from_dp_suggestions(dp_suggestions) -> List[List[OmpPragma]]:
    omp_pragma_list: List[List[OmpPragma]] = []
    for suggestion_type in dp_suggestions:
        if suggestion_type == "do_all":
            for do_all_suggestion in dp_suggestions[suggestion_type]:
                # construct omp pragma from do_all suggestion
                omp_pragmas = []
                omp_pragmas.append(interpret_do_all_suggestion(do_all_suggestion))
                omp_pragma_list.append(omp_pragmas)
        elif suggestion_type == "reduction":
            for reduction_suggestion in dp_suggestions[suggestion_type]:
                # construct omp pragma from reduction suggestion
                omp_pragmas = []
                omp_pragmas.append(interpret_reduction_suggestion(reduction_suggestion))
                omp_pragma_list.append(omp_pragmas)
        elif suggestion_type == "task":
            for task_suggestion in dp_suggestions[suggestion_type]:
                # construct omp pragma from task suggestion
                omp_pragmas = []
                omp_pragmas.append(interpret_task_suggestion(task_suggestion))
                omp_pragma_list.append(omp_pragmas)

        else:
            warnings.warn("Unsupported DiscoPoP suggestion type: \"" + suggestion_type +  "\". IGNORED -> TODO")
        # todo pipeline suggestions
        # todo geometric_decomposition suggestions
        # todo task suggestions
    return omp_pragma_list
