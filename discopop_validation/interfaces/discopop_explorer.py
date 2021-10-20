from typing import Optional, List, Tuple
import json

try:
    from discopop_explorer import run, DetectionResult, PETGraphX, utils, parser, json_serializer
except ModuleNotFoundError:
    from discopop.discopop_explorer import run
    from discopop.discopop_explorer import DetectionResult
    from discopop.discopop_explorer import utils
    from discopop.discopop_explorer import parser
    from discopop.discopop_explorer import json_serializer


def get_pet_graph(cu_xml: str, dep_file: str, loop_counter_file: str, reduction_file: str) -> PETGraphX:
    pet = PETGraphX.from_parsed_input(*parser.parse_inputs(cu_xml, dep_file,
                                                    loop_counter_file, reduction_file))
    return pet


def load_parallelization_suggestions(suggestions_path: str):
    with open(suggestions_path, "r") as suggestions_file:
        print(json.load(suggestions_file, cls=json_serializer.PatternInfoSerializer))


def is_loop_index(pet: PETGraphX, root_loop, var_name: str):
    return utils.is_loop_index2(pet, root_loop, var_name)