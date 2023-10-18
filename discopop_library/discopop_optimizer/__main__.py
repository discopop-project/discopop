# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

"""Discopop Suggestion Optimizer

Usage:
    discopop_optimizer --compile-command <str> [--project <path>] [--file-mapping <path>] [--detection-result-dump <path>]
        [--execute-created-models] [--execute-single-model <path>] [--clean-created-code] [--code-export-path <path>] [--dp-output-path <path>]
        [--executable-arguments <string>] [--linker-flags <string>] [--make-target <string>] [--make-flags <string>]
        [--executable-name <string>] [--execution-repetitions <int>] [--execution-append-measurements]
        [--exhaustive-search] [--headless-mode] [--doall-microbench-file <string>] [--reduction-microbench-file <string>]

OPTIONAL ARGUMENTS:
    --project=<path>            Path to the directory that contains your makefile [default: .]
    --file-mapping=<path>       Path to the FileMapping.txt. [default: FileMapping.txt]
    --detection-result-dump=<path>  Path to the dumped detection result JSON. [default: explorer/detection_result_dump.json]
    --execute-created-models    Compiles, executes and measures models already stored in the project folder.
                                Does not start the optimization pipeline.
                                Required: --executable-name
    --execute-single-model=<path>       Execute the given model only. Path to the JSON or filename, if the model is located in --code-export-path.
                                        Does not start the optimization pipeline.
                                        Required: --executable-name [default: ]
    --execution-repetitions=<int>       Repeat measurements [default: 1]
    --execution-append-measurements     If set, measurement files from previous executions will be kept and new results
                                        will be appended.
    --clean-created-code        Removes all stored code modifications.
    --code-export-path=<path>   Directory where generated CodeStorageObjects are located. [default: optimizer/code_exports]
    --dp-output-path=<path>     Directory where output files of DiscoPoP are located. [default: .]
    --executable-name=<string>  Name of the executable generate by your makefile.
                                Must be specified if --execute-created-models is used! [default: ]
    --executable-arguments=<string>
                                run your application with these arguments [default: ]
    --linker-flags=<string>     if your build requires to link other libraries
                                please provide the necessary linker flags. e.g. -lm [default: ]
    --make-target=<string>      specify a specific Make target to be built,
                                if not specified the default make target is used. [default: ]
    --make-flags=<string>       specify flags which will be passed through to make. [default: ]
    --compile-command=<string>    specify a command which shall be executed to compile the application
    --exhaustive-search         Perform an exhaustive search for the optimal set of parallelization suggestions for the
                                given environment
    --headless-mode             Do not show any GUI prompts. Does not reuse prior results.
                                Uses the suggested default values. Creates random models.
                                Exports all models to code. Saves all models.
    --reduction-microbench-file=<string>     Path to the microbenchmark output which represents the overhead
                                             of reduction suggestions.
                                             Default model: 0
    --doall-microbench-file=<string>         Path to the microbenchmark output which represents the overhead
                                             of reduction suggestions.
                                             Default model: 0
    -h --help                   Show this screen
"""
import os
import shutil
import sys
import tkinter as tk
from typing import Optional, Union

import jsonpickle  # type: ignore
import pstats2  # type:ignore
from docopt import docopt  # type:ignore
from schema import Schema, Use, SchemaError  # type:ignore

from discopop_library.result_classes.DetectionResult import DetectionResult
from discopop_library.discopop_optimizer.Microbench.ExtrapInterpolatedMicrobench import (
    ExtrapInterpolatedMicrobench,
)
from discopop_library.discopop_optimizer.Microbench.Microbench import MicrobenchType
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
        "--compile-command": Use(str),
        "--execution-append-measurements": Use(str),
        "--exhaustive-search": Use(str),
        "--headless-mode": Use(str),
        "--doall-microbench-file": Use(str),
        "--reduction-microbench-file": Use(str),
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
    arguments["--execute-created-models"] = False if arguments["--execute-created-models"] == "False" else True
    arguments["--execution-append-measurements"] = (
        False if arguments["--execution-append-measurements"] == "False" else True
    )
    arguments["--clean-created-code"] = False if arguments["--clean-created-code"] == "False" else True
    arguments["--code-export-path"] = get_path(arguments["--project"], arguments["--code-export-path"])
    arguments["--exhaustive-search"] = False if arguments["--exhaustive-search"] == "False" else True
    arguments["--headless-mode"] = False if arguments["--headless-mode"] == "False" else True
    arguments["--dp-output-path"] = get_path(arguments["--project"], arguments["--dp-output-path"])
    arguments["--file-mapping"] = get_path(arguments["--dp-output-path"], arguments["--file-mapping"])
    arguments["--detection-result-dump"] = get_path(arguments["--dp-output-path"], arguments["--detection-result-dump"])
    arguments["--dp-optimizer-path"] = os.path.join(arguments["--project"], ".discopop_optimizer")
    arguments["--make-target"] = None if arguments["--make-target"] == "None" else arguments["--make-target"]
    arguments["--execute-single-model"] = (
        None
        if len(arguments["--execute-single-model"]) == 0
        else get_path(arguments["--code-export-path"], arguments["--execute-single-model"])
    )
    arguments["--compile-command"] = (
        None if len(arguments["--compile-command"]) == 0 else arguments["--compile-command"]
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

    start_optimizer(arguments)


def start_optimizer(arguments, parent_frame: Optional[tk.Frame] = None):
    # create gui frame if none given
    if parent_frame is None:
        tk_root: Union[tk.Tk, tk.Toplevel] = tk.Tk()
        # configure window size
        tk_root.geometry("1000x600")
        parent_frame = tk.Frame(tk_root)
        parent_frame.pack(fill=tk.BOTH)
        destroy_window_after_execution = True
    else:
        tk_root = parent_frame.winfo_toplevel()
        destroy_window_after_execution = False

    # ask if previous session should be loaded
    load_result: bool = False
    if (
        os.path.exists(os.path.join(arguments["--dp-optimizer-path"], "last_experiment.pickle"))
        and not arguments["--headless-mode"]
    ):
        load_result = tkinter.messagebox.askyesno(
            parent=parent_frame,
            title="Restore Results?",
            message="Do you like to load the experiment from the previous session?",
        )
    if load_result:
        # load results from previous session
        experiment = restore_session(os.path.join(arguments["--dp-optimizer-path"], "last_experiment.pickle"))
        show_function_models(experiment, parent_frame, destroy_window_after_execution)
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
        # todo make system user-configurable, or detect it using a set of benchmarks
        system = System()

        # todo connections between devices might happen as update to host + update to second device.
        #  As of right now, connections between two devices are implemented in this manner.
        # todo check if OpenMP allows direct data transfers between devices

        # load overhead measurements into system if existent
        if arguments["--doall-microbench-file"] != "None":
            microbench_file = arguments["--doall-microbench-file"]
            if not os.path.isfile(microbench_file):
                raise FileNotFoundError(f"Microbenchmark file not found: {microbench_file}")
            # construct and set overhead model for doall suggestions
            system.set_device_doall_overhead_model(
                system.get_device(0),
                ExtrapInterpolatedMicrobench(microbench_file).getFunctionSympy(),
            )
        if arguments["--reduction-microbench-file"] != "None":
            microbench_file = arguments["--reduction-microbench-file"]
            if not os.path.isfile(microbench_file):
                raise FileNotFoundError(f"Microbenchmark file not found: {microbench_file}")
            # construct and set overhead model for reduction suggestions
            system.set_reduction_overhead_model(
                system.get_device(0),
                ExtrapInterpolatedMicrobench(microbench_file).getFunctionSympy(benchType=MicrobenchType.FOR),
            )

        # define Environment
        experiment = Experiment(
            arguments["--project"],
            arguments["--dp-output-path"],
            arguments["--dp-optimizer-path"],
            arguments["--code-export-path"],
            arguments["--file-mapping"],
            system,
            detection_result,
            arguments,
        )

        # invoke optimization graph
        optimization_graph = OptimizationGraph(
            arguments["--dp-output-path"],
            experiment,
            arguments,
            parent_frame,
            destroy_window_after_execution,
        )

    if destroy_window_after_execution:
        try:
            tk_root.destroy()
        except tkinter.TclError:
            # Window has been destroyed already
            pass


if __name__ == "__main__":
    main()
