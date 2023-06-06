# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

"""Discopop Suggestion Optimizer

Usage:
    discopop_optimizer [--project-folder <path>] [--file-mapping <path>] [--detection-result-dump <path>]
        [--execute-created-models]

OPTIONAL ARGUMENTS:
    --project-folder=<path>     Directory where the DiscoPoP outputs are located. [default: .]
    --file-mapping=<path>       Path to the FileMapping.txt. [default: FileMapping.txt]
    --detection-result-dump=<path>  Path to the dumped detection result JSON. [default: detection_result_dump.json]
    --execute-created-models    Compiles, executes and measures models already stored in the project folder.
    -h --help                   Show this screen
"""
import os

import jsonpickle  # type: ignore
import pstats2  # type:ignore
from docopt import docopt  # type:ignore
from schema import Schema, Use, SchemaError  # type:ignore
from sympy import Symbol, Integer

from discopop_explorer import DetectionResult
from discopop_library.discopop_optimizer.OptimizationGraph import OptimizationGraph
from discopop_library.discopop_optimizer.Variables.Experiment import Experiment
from discopop_library.discopop_optimizer.classes.system.System import System
from discopop_library.discopop_optimizer.classes.system.devices.CPU import CPU
from discopop_library.discopop_optimizer.classes.system.devices.GPU import GPU

docopt_schema = Schema(
    {
        "--project-folder": Use(str),
        "--file-mapping": Use(str),
        "--detection-result-dump": Use(str),
        "--execute-created-models": Use(str),
    }
)


def get_path(base_path: str, file_name: str) -> str:
    """Combines path and filename if it is not absolute

    :param base_path: path
    :param file_name: file name
    :return: path to file
    """
    return file_name if os.path.isabs(file_name) else os.path.join(base_path, file_name)


def main():
    """Invokes the discopop_optimizer using the given parameters"""
    arguments = docopt(__doc__)

    try:
        arguments = docopt_schema.validate(arguments)
    except SchemaError as e:
        exit(e)

    # prepare arguments
    arguments["--project-folder"] = get_path(os.getcwd(), arguments["--project-folder"])
    arguments["--file-mapping"] = get_path(os.getcwd(), arguments["--file-mapping"])
    arguments["--detection-result-dump"] = get_path(
        arguments["--project-folder"], arguments["--detection-result-dump"]
    )
    arguments["--execute-created-models"] = (
        False if ["--execute-created-models"] == "False" else True
    )

    print("Starting discopop_optimizer...")
    for arg_name in arguments:
        print("\t", arg_name, "=", arguments[arg_name])

    # load detection result
    print("Loading detection result and PET...", end="")
    detection_result_dump_str = ""
    with open(arguments["--detection-result-dump"], "r") as f:
        detection_result_dump_str = f.read()
    detection_result: DetectionResult = jsonpickle.decode(detection_result_dump_str)
    print("Done")

    # define System
    system = System()
    device_0 = CPU(Symbol("CPU_thread_num"), Symbol("CPU_thread_num"))
    device_1 = GPU(Symbol("GPU_thread_num"), Symbol("GPU_thread_num"))
    system.add_device(device_0)
    system.add_device(device_1)
    # define Network
    network = system.get_network()
    network.add_connection(device_0, device_0, Integer(100000), Integer(0))
    network.add_connection(device_0, device_1, Integer(10), Integer(1000000))
    network.add_connection(device_1, device_0, Integer(10), Integer(1000000))
    network.add_connection(device_1, device_1, Integer(100000), Integer(0))

    # define Environment
    # todo rename to Experiment
    environment = Experiment(arguments["--project-folder"], arguments["--file-mapping"], system)

    # invoke optimization graph
    optimization_graph = OptimizationGraph(
        detection_result, arguments["--project-folder"], environment
    )


if __name__ == "__main__":
    main()
