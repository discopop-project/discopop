from discopop_explorer.PETGraphX import EdgeType, NodeType
from discopop_explorer.pattern_detectors.task_parallelism.tp_utils import get_parent_of_type
from discopop_validation.interfaces.discopop_explorer import is_loop_index
from discopop_validation.data_race_prediction.vc_data_race_detector.classes.DataRace import DataRace


def __check_pragma_for_exception_rules(data_race: DataRace, pet, task_graph) -> bool:
    """Checks if the given data race is valid according to the parallel_for exception rules.
    Returns True, if the data race is valid and should be kept.
    Returns False, if the data race is invalid and should be removed."""
    is_valid = True
    is_valid = is_valid and __for_exception_rule_1(data_race, pet)
    is_valid = is_valid and __for_exception_rule_2(data_race, pet, task_graph)
    return is_valid


def __for_exception_rule_1(data_race: DataRace, pet) -> bool:
    """exception 1: If only one index is used and it is a loop index of parent suggestion loop, the data race can be removed."""
    if len(data_race.get_used_indices()) > 1:
        return True
    else:
        for index in data_race.get_used_indices():
            parent_loop_node = get_parent_of_type(pet, pet.node_at(data_race.get_cu_id(pet)), NodeType.LOOP, EdgeType.CHILD, True)
            if len(parent_loop_node) != 1:
                return False
            parent_loop_node_cu = parent_loop_node[0][0]
            if is_loop_index(pet, parent_loop_node_cu, index):
                return False
        return True


def __for_exception_rule_2(data_race: DataRace, pet, task_graph) -> bool:
    """exception 1: If multiple loop indices are used and no inner index is shared, the data race can be removed.
    shared: either explicitly mentioned as shared, or not mentioned as private / firstprivate"""
    if len(data_race.get_used_indices()) <= 1:
        return True
    else:
        # get data race location
        dr_file_ids = data_race.schedule_element.get_file_ids()
        dr_lines = data_race.schedule_element.get_operation_lines()

        # get pragmas containing the current data race
        parent_pragmas = []
        for node in task_graph.graph.nodes:
            pragma = task_graph.graph.nodes[node]["data"].pragma
            if pragma is None:
                continue
            if pragma.file_id in dr_file_ids:
                for dr_line in dr_lines:
                    if dr_line >= pragma.start_line and dr_line <= pragma.end_line:
                        parent_pragmas.append(pragma)
        parent_pragmas = list(dict.fromkeys(parent_pragmas))

        for ct, index in enumerate(data_race.get_used_indices()):
            # ignore first index
            if ct == 0:
                continue
            # check if shared inner index existst
            parent_loop_node = get_parent_of_type(pet, pet.node_at(data_race.get_cu_id(pet)), NodeType.LOOP,
                                                  EdgeType.CHILD, True)
            if len(parent_loop_node) != 1:
                return False
            parent_loop_node_cu = parent_loop_node[0][0]
            if is_loop_index(pet, parent_loop_node_cu, index):
                # check if index is shared in one of the parents
                for pragma in parent_pragmas:
                    if index in pragma.get_variables_listed_as("shared"):
                        return True
        # no shared index used
        return False