import json
import os.path

import jsonpickle

from typing import List, Tuple, cast, Dict, Any

from discopop_explorer.PETGraphX import CUNode, EdgeType
from discopop_validation.classes.Configuration import Configuration

try:
    from discopop_explorer import run, DetectionResult, PETGraphX, utils, parser, json_serializer  # type: ignore
except ModuleNotFoundError:
    from discopop.discopop_explorer import run  # type: ignore
    from discopop.discopop_explorer import DetectionResult  # type: ignore
    from discopop.discopop_explorer import utils  # type: ignore
    from discopop.discopop_explorer import parser  # type: ignore
    from discopop.discopop_explorer import json_serializer  # type: ignore


def get_pet_graph(run_configuration: Configuration) -> PETGraphX:
    # load pet from dump if existing
    if run_configuration.pet_dump_file != "None" and os.path.exists(run_configuration.pet_dump_file):
        # reconstruct from dump
        pet_dump = open(run_configuration.pet_dump_file, "r")
        pet: PETGraphX = jsonpickle.decode(pet_dump.read())
    else:
        # construct from raw files
        pet = PETGraphX.from_parsed_input(*parser.parse_inputs(run_configuration.cu_xml, run_configuration.dep_file,
                                                               run_configuration.loop_counter_file,
                                                               run_configuration.reduction_file,
                                                               run_configuration.file_mapping))
    return pet


def load_parallelization_suggestions(suggestions_path: str):
    with open(suggestions_path, "r") as suggestions_file:
        print(json.load(suggestions_file, cls=json_serializer.PatternInfoSerializer))  # type: ignore


is_loop_index_cache: Dict[Tuple[PETGraphX, Any, str], bool] = dict()


def is_loop_index(pet: PETGraphX, root_loop, var_name: str):
    global is_loop_index_cache
    if (pet, root_loop, var_name) in is_loop_index_cache:
        return is_loop_index_cache[(pet, root_loop, var_name)]
    result = utils.is_loop_index2(pet, root_loop, var_name)
    is_loop_index_cache[(pet, root_loop, var_name)] = result
    return result


def check_reachability(pet: PETGraphX, target: CUNode,
                       source: CUNode, edge_types: List[EdgeType]) -> bool:
    """check if target is reachable from source via edges of types edge_type.
    :param pet: PET graph
    :param source: CUNode
    :param target: CUNode
    :param edge_types: List[EdgeType]
    :return: Boolean"""
    if source == target:
        return True
    visited: List[str] = []
    queue = [target]
    while len(queue) > 0:
        cur_node = queue.pop(0)
        if type(cur_node) == list:
            cur_node_list = cast(List[CUNode], cur_node)
            cur_node = cur_node_list[0]
        visited.append(cur_node.id)
        tmp_list = [(s, t, e) for s, t, e in pet.in_edges(cur_node.id)
                    if s not in visited and
                    e.etype in edge_types]
        for e in tmp_list:
            if pet.node_at(e[0]) == source:
                return True
            else:
                if e[0] not in visited:
                    queue.append(pet.node_at(e[0]))
    return False


def get_called_functions(pet: PETGraphX, root: CUNode) -> CUNode:
    """returns a list of all functions CUNodes which are called inside the scope of root.
    The list is created by traversing the list of children nodes."""
    result_list: List[CUNode] = []
    queue: List[CUNode] = [root]
    visited: List[CUNode] = []
    while len(queue) > 0:
        current = queue.pop()
        visited.append(current)
        result_list += current.node_calls
        queue += [child for child in pet.direct_children(current) if child not in visited]

    return result_list
