from typing import List, cast

from discopop_explorer import PETGraphX
from discopop_explorer.PETGraphX import EdgeType, NodeType
from discopop_explorer.pattern_detectors.PatternInfo import PatternInfo
from discopop_explorer.pattern_detectors.task_parallelism.classes import TaskParallelismInfo
from discopop_explorer.pattern_detectors.task_parallelism.tp_utils import line_contained_in_region


def suggest_shared_clauses_for_all_tasks_in_function_body(pet: PETGraphX, suggestions: List[PatternInfo]) \
        -> List[PatternInfo]:
    """Marks unmentioned variables as shared, if they occur as shared in a different task suggestions
    inside the parent functions body.
    :param: pet: PET graph
    :param: suggestions: List[PatternInfo]
    :return: List[PatternInfo]
    """
    task_suggestions = [s for s in [cast(TaskParallelismInfo, t) for t in suggestions
                                    if type(t) == TaskParallelismInfo] if s.pragma[0] == "task"]
    for ts in task_suggestions:
        if ts.shared:
            # iterate over parent function(s)
            for parent_function in [pet.node_at(e[0]) for e in pet.in_edges(ts._node.id, EdgeType.CHILD)
                                    if pet.node_at(e[0]).type == NodeType.FUNC]:
                # get task suggestions in parent functions scope
                for other_suggestion in task_suggestions:
                    if not (line_contained_in_region(other_suggestion.start_line, parent_function.start_position(),
                                                     parent_function.end_position())
                            and
                            line_contained_in_region(other_suggestion.end_line, parent_function.start_position(),
                                                     parent_function.end_position())):
                        # other suggestion not part of parent function
                        continue
                    # mark shared variables of ts as shared in other_suggestion, if not already mentioned
                    for var in ts.shared:
                        if var in other_suggestion.shared:
                            continue
                        if var in other_suggestion.private:
                            continue
                        if var in other_suggestion.first_private:
                            continue
                        other_suggestion.shared.append(var)

    return suggestions