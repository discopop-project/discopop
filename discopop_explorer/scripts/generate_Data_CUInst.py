# TODO update help string
"""Discopop explorer

Usage:
    discopop_explorer [--path <path>] [--cu-xml <cuxml>] [--dep-file <depfile>] [--plugins <plugs>] \
[--loop-counter <loopcount>] [--reduction <reduction>] [--json <json_out>] [--fmap <fmap>] \
[--cu-inst-res <cuinstres>]

Options:
    --path=<path>               Directory with input data [default: ./]
    --cu-xml=<cuxml>            CU node xml file [default: Data.xml]
    --dep-file=<depfile>        Dependencies text file [default: dp_run_dep.txt]
    --loop-counter=<loopcount>  Loop counter data [default: loop_counter_output.txt]
    --reduction=<reduction>     Reduction variables file [default: reduction.txt]
    --output-dir=<path>         Directory which should be used to store the resulting Data_CUInst.txt
    -h --help                   Show this screen
"""

from docopt import docopt  # type:ignore
from schema import Schema, Use, SchemaError  # type:ignore
from ..parser import parse_inputs
from .. import __version__
from ..PETGraphX import PETGraphX, NodeType, CUNode, DepType, EdgeType, MWType
import os
import sys
from typing import List, Tuple, Dict, Optional, cast

docopt_schema = Schema({
    '--path': Use(str),
    '--cu-xml': Use(str),
    '--dep-file': Use(str),
    '--loop-counter': Use(str),
    '--reduction': Use(str),
    '--output-dir': Use(str),
})


def __search_recursive_calls(pet: PETGraphX, output_file, node: CUNode):
    """TODO"""
    if node.type != NodeType.CU:
        return
    for recursive_function_call in node.recursive_function_calls:
        print("\t", recursive_function_call)


def cu_instantiation_input_cpp(pet: PETGraphX, output_dir: str):
    """translation of CUInstantiationInput.cpp, previously contained in discopop-analyzer/analyzer/src.
    TODO documentation"""
    output_dir = output_dir if output_dir.endswith("/") else output_dir + "/"
    data_cu_inst_file = open(output_dir + "Data_CUInst.txt", "w+") if output_dir is not None else open(
        "Data_CUInst.txt", "w+")
    for node in pet.all_nodes():
        __search_recursive_calls(pet, data_cu_inst_file, node)
    data_cu_inst_file.flush()
    data_cu_inst_file.close()


def get_path(base_path: str, file_name: str) -> str:
    """Combines path and filename if it is not absolute

    :param base_path: path
    :param file_name: file name
    :return: path to file
    """
    return file_name if os.path.isabs(file_name) else os.path.join(base_path, file_name)


def main():
    """Wrapper to generate the Data_CUInst.txt file, required for the generation of CUInstResult.txt"""
    # 1. generate PET Graph
    arguments = docopt(__doc__, version=f"DiscoPoP Version {__version__}")
    try:
        arguments = docopt_schema.validate(arguments)
    except SchemaError as e:
        exit(e)
    path = arguments['--path']
    cu_xml = get_path(path, arguments['--cu-xml'])
    dep_file = get_path(path, arguments['--dep-file'])
    loop_counter_file = get_path(path, arguments['--loop-counter'])
    reduction_file = get_path(path, arguments['--reduction'])
    output_dir = get_path(path, arguments['--output-dir'])
    for file in [cu_xml, dep_file, loop_counter_file, reduction_file]:
        if not os.path.isfile(file):
            print(f"File not found: \"{file}\"")
            sys.exit()
    cu_dict, dependencies, loop_data, reduction_vars = parse_inputs(cu_xml, dep_file,
                                                                    loop_counter_file, reduction_file)
    pet = PETGraphX(cu_dict, dependencies, loop_data, reduction_vars)
    # 2. Generate Data_CUInst.txt
    cu_instantiation_input_cpp(pet, output_dir)


if __name__ == "__main__":
    main()
