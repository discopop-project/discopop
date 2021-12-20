from typing import Optional, List, Tuple
import json

from discopop_validation.classes.Configuration import Configuration

try:
    from discopop_explorer import run, DetectionResult, PETGraphX, utils, parser, json_serializer
except ModuleNotFoundError:
    from discopop.discopop_explorer import run
    from discopop.discopop_explorer import DetectionResult
    from discopop.discopop_explorer import utils
    from discopop.discopop_explorer import parser
    from discopop.discopop_explorer import json_serializer


def get_pet_graph(run_configuration: Configuration) -> PETGraphX:
    pet = PETGraphX.from_parsed_input(*parser.parse_inputs(run_configuration.cu_xml, run_configuration.dep_file,
                                                    run_configuration.loop_counter_file,
                                                        run_configuration.reduction_file))
    return pet


def load_parallelization_suggestions(suggestions_path: str):
    with open(suggestions_path, "r") as suggestions_file:
        print(json.load(suggestions_file, cls=json_serializer.PatternInfoSerializer))


is_loop_index_cache = dict()
def is_loop_index(pet: PETGraphX, root_loop, var_name: str):
    global is_loop_index_cache
    if (pet, root_loop, var_name) in is_loop_index_cache:
        return is_loop_index_cache[(pet, root_loop, var_name)]
    result = utils.is_loop_index2(pet, root_loop, var_name)
    is_loop_index_cache[(pet, root_loop, var_name)] = result
    return result