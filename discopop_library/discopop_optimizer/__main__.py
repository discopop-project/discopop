# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

"""Discopop Suggestion Optimizer

Usage:
    discopop_optimizer [--project <path>] [--file-mapping <path>] [--detection-result-dump <path>]
        [--execute-created-models] [--execute-single-model <path>] [--clean-created-code] [--code-export-path <path>] [--dp-output-path <path>]
        [--executable-arguments <string>] [--linker-flags <string>] [--make-target <string>] [--make-flags <string>]
        [--executable-name <string>] [--execution-repetitions <int>]

OPTIONAL ARGUMENTS:
    --project=<path>            Path to the directory that contains your makefile [default: .]
    --file-mapping=<path>       Path to the FileMapping.txt. [default: FileMapping.txt]
    --detection-result-dump=<path>  Path to the dumped detection result JSON. [default: detection_result_dump.json]
    --execute-created-models    Compiles, executes and measures models already stored in the project folder.
                                Does not start the optimization pipeline.
                                Required: --executable-name
    --execute-single-model=<path>       Execute the given model only. Path to the JSON or filename, if the model is located in --code-export-path.
                                        Does not start the optimization pipeline.
                                        Required: --executable-name [default: ]
    --execution-repetitions=<int>       Repeat measurements [default: 1]
    --clean-created-code        Removes all stored code modifications.
    --code-export-path=<path>   Directory where generated CodeStorageObjects are located. [default: .discopop_optimizer/code_exports]
    --dp-output-path=<path>     Directory where output files of DiscoPoP are located. [default: .discopop]
    --executable-name=<string>  Name of the executable generate by your makefile.
                                Must be specified if --execute-created-models is used! [default: ]
    --executable-arguments=<string>
                                run your application with these arguments [default: ]
    --linker-flags=<string>     if your build requires to link other libraries
                                please provide the necessary linker flags. e.g. -lm [default: ]
    --make-target=<string>      specify a specific Make target to be built,
                                if not specified the default make target is used. [default: ]
    --make-flags=<string>       specify flags which will be passed through to make. [default: ]
    -h --help                   Show this screen
"""
import os
import shutil
import sys

import jsonpickle  # type: ignore
import pstats2  # type:ignore
from docopt import docopt  # type:ignore
from schema import Schema, Use, SchemaError  # type:ignore
from sympy import Symbol, Integer

from discopop_explorer import DetectionResult
from discopop_library.discopop_optimizer.OptimizationGraph import OptimizationGraph
from discopop_library.discopop_optimizer.Variables.Experiment import Experiment
from discopop_library.discopop_optimizer.Variables.ExperimentUtils import (
    restore_session,
    show_function_models,
    export_to_json,
)
from discopop_library.discopop_optimizer.classes.system.System import System
from discopop_library.discopop_optimizer.classes.system.devices.CPU import CPU
from discopop_library.discopop_optimizer.classes.system.devices.GPU import GPU
from discopop_library.discopop_optimizer.execution.stored_models import (
    execute_stored_models,
    execute_single_model,
)
import tkinter.messagebox

docopt_schema = Schema(
    {
        "--project": Use(str),
        "--file-mapping": Use(str),
        "--detection-result-dump": Use(str),
        "--execute-created-models": Use(str),
        "--clean-created-code": Use(str),
        "--code-export-path": Use(str),
        "--dp-output-path": Use(str),
        "--executable-arguments": Use(str),
        "--executable-name": Use(str),
        "--linker-flags": Use(str),
        "--make-target": Use(str),
        "--make-flags": Use(str),
        "--execution-repetitions": Use(str),
        "--execute-single-model": Use(str),
    }
)


def get_path(base_path: str, file_name: str) -> str:
    """Combines path and filename if it is not absolute

    :param base_path: path
    :param file_name: file name
    :return: path to file
    """
    result_path = file_name if os.path.isabs(file_name) else os.path.join(base_path, file_name)
    return os.path.normpath(result_path)


def main():
    """Invokes the discopop_optimizer using the given parameters"""
    arguments = docopt(__doc__)

    try:
        arguments = docopt_schema.validate(arguments)
    except SchemaError as e:
        exit(e)

    # prepare arguments
    arguments["--project"] = get_path(os.getcwd(), arguments["--project"])
    arguments["--execute-created-models"] = (
        False if arguments["--execute-created-models"] == "False" else True
    )
    arguments["--clean-created-code"] = (
        False if arguments["--clean-created-code"] == "False" else True
    )
    arguments["--code-export-path"] = get_path(
        arguments["--project"], arguments["--code-export-path"]
    )
    arguments["--dp-output-path"] = get_path(arguments["--project"], arguments["--dp-output-path"])
    arguments["--file-mapping"] = get_path(
        arguments["--dp-output-path"], arguments["--file-mapping"]
    )
    arguments["--detection-result-dump"] = get_path(
        arguments["--dp-output-path"], arguments["--detection-result-dump"]
    )
    arguments["--dp-optimizer-path"] = os.path.join(arguments["--project"], ".discopop_optimizer")
    arguments["--make-target"] = (
        None if arguments["--make-target"] == "None" else arguments["--make-target"]
    )
    arguments["--execute-single-model"] = (
        None
        if len(arguments["--execute-single-model"]) == 0
        else get_path(arguments["--code-export-path"], arguments["--execute-single-model"])
    )

    print("Starting discopop_optimizer...")
    for arg_name in arguments:
        print("\t", arg_name, "=", arguments[arg_name])

    if arguments["--execute-created-models"] or arguments["--execute-single-model"] is not None:
        if arguments["--executable-name"] == "":
            raise ValueError("Please specify the name of your executable using --executable-name!")
        if arguments["--execute-single-model"] is None:
            execute_stored_models(arguments)
        else:
            execute_single_model(arguments)
        sys.exit(0)

    if arguments["--clean-created-code"]:
        # remove stored parallel code if requested
        print("Removing old exported code...", end="")
        if os.path.exists(arguments["--code-export-path"]):
            shutil.rmtree(arguments["--code-export-path"])
        os.makedirs(arguments["--code-export-path"])
        print("Done.")

    # ask if previous session should be loaded
    load_result: bool = False
    if os.path.exists(os.path.join(arguments["--dp-optimizer-path"], "last_experiment.json")):
        load_result = tkinter.messagebox.askyesno(
            title="Restore Results?",
            message="Do you like to load the experiment from the previous session?",
        )
    if load_result:
        # load results from previous session
        experiment = restore_session(
            os.path.join(arguments["--dp-optimizer-path"], "last_experiment.pickle")
        )
        show_function_models(
            experiment,
        )
        # save experiment to disk
        export_to_json(experiment)

    else:
        # create a new session
        # load detection result
        print("Loading detection result and PET...", end="")
        detection_result_dump_str = ""
        with open(arguments["--detection-result-dump"], "r") as f:
            detection_result_dump_str = f.read()
        detection_result: DetectionResult = jsonpickle.decode(detection_result_dump_str)
        print("Done")

        # define System
        system = System()
        device_0 = CPU(
            Symbol("CPU_thread_num"), Symbol("CPU_thread_num"), openmp_device_id=-1
        )  # Device 0 always acts as the host system
        device_1 = GPU(Symbol("GPU_thread_num"), Symbol("GPU_thread_num"), openmp_device_id=0)
        device_2 = GPU(Symbol("GPU_thread_num"), Symbol("GPU_thread_num"), openmp_device_id=1)
        system.add_device(device_0)
        system.add_device(device_1)
        system.add_device(device_2)
        # define Network
        network = system.get_network()
        network.add_connection(device_0, device_0, Integer(100000), Integer(0))
        network.add_connection(device_0, device_1, Integer(10), Integer(1000000))
        network.add_connection(device_1, device_0, Integer(10), Integer(1000000))
        network.add_connection(device_1, device_1, Integer(100000), Integer(0))

        network.add_connection(device_0, device_2, Integer(10), Integer(10000000))
        network.add_connection(device_2, device_0, Integer(10), Integer(10000000))
        network.add_connection(device_2, device_2, Integer(1000), Integer(0))

        network.add_connection(device_1, device_2, Integer(100), Integer(500000))
        network.add_connection(device_2, device_1, Integer(100), Integer(500000))

        # todo connections between devices might happen as update to host + update to second device.
        #  As of right now, connections between two devices are implemented in this manner.
        # todo check if OpenMP allows direct data transfers between devices

        # define Environment
        experiment = Experiment(
            arguments["--project"],
            arguments["--dp-output-path"],
            arguments["--dp-optimizer-path"],
            arguments["--code-export-path"],
            arguments["--file-mapping"],
            system,
            detection_result,
        )

        # invoke optimization graph
        optimization_graph = OptimizationGraph(arguments["--dp-output-path"], experiment)

    if __name__ == "__main__":
        main()
