from typing import List, Tuple

from discopop_validation.data_race_prediction.behavior_modeller.classes.BBNode import BBNode
from discopop_validation.data_race_prediction.behavior_modeller.classes.Operation import Operation


def convert_bb_path_to_operations(bb_path_to_operations_cache, section_id: int, bb_path: List[BBNode]) -> List[Tuple[int, Operation]]:
    """Converts a given list of BB Nodes which represent a path in the BB graph into a list of tuples containing
    the id of the parent BB node and an Operation."""
    cache_tuple = (section_id, tuple(bb_path))
    if cache_tuple in bb_path_to_operations_cache:
        return bb_path_to_operations_cache[cache_tuple]
    op_path: List[Tuple[int, Operation]] = []
    for bb_node in bb_path:
        for op in bb_node.operations:
            # only consider the relevant section id
            if op.section_id == section_id or op.section_id is None:
                op_path.append((bb_node.id, op))
    bb_path_to_operations_cache[cache_tuple] = op_path
    return op_path