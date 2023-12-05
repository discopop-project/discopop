# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
import json
import os.path
import shutil
from typing import Dict, List, Tuple, cast
import warnings

import jsonpickle  # type: ignore
from sympy import Float, Symbol  # type: ignore

from discopop_library.CodeGenerator.CodeGenerator import from_json_strings
from discopop_library.JSONHandler.JSONHandler import read_patterns_from_json_to_json
from discopop_library.PatchGenerator.PatchGeneratorArguments import PatchGeneratorArguments
from discopop_library.PatchGenerator.diffs import get_diffs_from_modified_code
from discopop_library.PathManagement.PathManagement import load_file_mapping
from discopop_library.discopop_optimizer.CostModels.DataTransfer.DataTransferCosts import add_data_transfer_costs
from discopop_library.discopop_optimizer.CostModels.utilities import get_performance_models_for_functions
from discopop_library.discopop_optimizer.DataTransfers.DataTransfers import calculate_data_transfers
from discopop_library.discopop_optimizer.OptimizerArguments import OptimizerArguments
from discopop_library.discopop_optimizer.PETParser.PETParser import PETParser
from discopop_library.discopop_optimizer.Variables.ExperimentUtils import (
    create_optimization_graph,
    export_to_json,
    get_sequential_cost_model,
    initialize_free_symbol_ranges_and_distributions,
)
from discopop_library.discopop_optimizer.classes.enums.Distributions import FreeSymbolDistribution
from discopop_library.discopop_optimizer.classes.nodes.FunctionRoot import FunctionRoot
from discopop_library.discopop_optimizer.gui.queries.ValueTableQuery import query_user_for_symbol_values
from discopop_library.discopop_optimizer.optimization.evaluate import evaluate_configuration
from discopop_library.discopop_optimizer.optimization.evaluate_all_decision_combinations import (
    evaluate_all_decision_combinations,
)
from discopop_library.discopop_optimizer.optimization.evolutionary_algorithm import perform_evolutionary_search
from discopop_library.result_classes.DetectionResult import DetectionResult
from discopop_library.discopop_optimizer.classes.system.System import System
from discopop_library.discopop_optimizer.Microbench.ExtrapInterpolatedMicrobench import (
    ExtrapInterpolatedMicrobench,
)
from discopop_library.discopop_optimizer.Microbench.Microbench import MicrobenchType
from discopop_library.discopop_optimizer.Variables.Experiment import Experiment
from discopop_library.discopop_optimizer.utilities.MOGUtilities import show
from discopop_library.discopop_optimizer.suggestions.importers.base import import_suggestions


def run(arguments: OptimizerArguments):
    # check prerequisites and setup folder structure
    if arguments.verbose:
        print("Started DiscoPoP Optimizer...")
        print("Creating optimizer directory...")
    optimizer_dir = os.path.join(os.getcwd(), "optimizer")
    if not os.path.exists(optimizer_dir):
        os.mkdir(optimizer_dir)

    explorer_dir = os.path.join(os.getcwd(), "explorer")
    profiler_dir = os.path.join(os.getcwd(), "profiler")
    pattern_file_path = os.path.join(explorer_dir, "patterns.json")
    if not os.path.exists(pattern_file_path):
        raise FileNotFoundError(
            "No pattern file found. Please execute the discopop_explorer in advance."
            + "\nExpected pattern file: "
            + pattern_file_path
        )
    file_mapping_path = os.path.join(os.getcwd(), "FileMapping.txt")
    if not os.path.exists(file_mapping_path):
        raise FileNotFoundError(
            "No file mapping found. Please execute the discopop_explorer in advance."
            + "\nExpected file: "
            + file_mapping_path
        )

    # create a new session, load data from previous steps)
    if arguments.verbose:
        print("Loading file mapping...", end="")
    file_mapping = load_file_mapping(file_mapping_path)
    if arguments.verbose:
        print("Done.")

    if arguments.verbose:
        print("Loading patterns...", end="")
    patterns_by_type = read_patterns_from_json_to_json(pattern_file_path, [])
    if arguments.verbose:
        print("Done.")

    if arguments.verbose:
        print("Loading detection result and PET...", end="")
    detection_result_dump_str = ""
    with open(os.path.join(explorer_dir, "detection_result_dump.json")) as f:
        detection_result_dump_str = f.read()
    detection_result: DetectionResult = jsonpickle.decode(detection_result_dump_str)
    if arguments.verbose:
        print("Done")

    # define System
    # todo make system user-configurable, or detect it using a set of benchmarks
    system = System(arguments)

    # todo connections between devices might happen as update to host + update to second device.
    #  As of right now, connections between two devices are implemented in this manner.
    # todo check if OpenMP allows direct data transfers between devices

    # load overhead measurements into system if existent
    if arguments.doall_microbench_file != "None":
        # construct and set overhead model for doall suggestions
        system.set_device_doall_overhead_model(
            system.get_device(0),
            ExtrapInterpolatedMicrobench(arguments.doall_microbench_file).getFunctionSympy(),
        )
    if arguments.reduction_microbench_file != "None":
        # construct and set overhead model for reduction suggestions
        system.set_reduction_overhead_model(
            system.get_device(0),
            ExtrapInterpolatedMicrobench(arguments.reduction_microbench_file).getFunctionSympy(
                benchType=MicrobenchType.FOR
            ),
        )

    # define Experiment
    experiment = Experiment(file_mapping, system, detection_result, profiler_dir)

    # build optimization graph
    if arguments.verbose:
        print("Creating optimization graph...")
    create_optimization_graph(experiment, arguments)
    if arguments.verbose:
        print("Done.")

    # import parallelization suggestions
    experiment.optimization_graph = import_suggestions(experiment)

    if arguments.plot:
        show(experiment.optimization_graph)

    if arguments.verbose:
        print("# SUGGESTION ID -> NODE ID MAPPING")
        for suggestion_id in experiment.suggestion_to_node_ids_dict:
            print("#", suggestion_id, "->", experiment.suggestion_to_node_ids_dict[suggestion_id])
        print()

    # get values for free symbols
    initialize_free_symbol_ranges_and_distributions(experiment, arguments, system)

    if arguments.verbose:
        print("# SUBSTITUTIONS:")
        for key in experiment.substitutions:
            print("#", key, " ->", experiment.substitutions[key])
        print()

    # calculate function performance models
    warnings.warn("TODO BEGIN REPLACE WITH CALCULATION OF DECISIONS ONLY")
    if arguments.verbose:
        print("Calculating performance models...", end="")
    function_performance_models_without_context = get_performance_models_for_functions(
        experiment, experiment.optimization_graph
    )
    if arguments.verbose:
        print("Done.")
    function_performance_models = calculate_data_transfers(
        experiment.optimization_graph, function_performance_models_without_context
    )
    function_performance_models = add_data_transfer_costs(
        experiment.optimization_graph,
        function_performance_models,
        experiment,
    )

    # get available decisions per function
    # preapare available decisions
    available_decisions: Dict[FunctionRoot, List[List[int]]] = dict()
    for function in function_performance_models:
        available_decisions[function] = []
        for entry in function_performance_models[function]:
            available_decisions[function].append(entry[0].path_decisions)

    warnings.warn("TODO END REPLACE WITH CALCULATION OF DECISIONS ONLY")

    #    if arguments.verbose:
    #        print("# Identified paths per function:")
    #        for function in function_performance_models_without_context:
    #            print("#", function.name)
    #            for cost in function_performance_models_without_context[function]:
    #                print("#..", cost.path_decisions)
    #        print()

    # calculate costs for all combinations of decisions
    if arguments.exhaustive:
        evaluate_all_decision_combinations(experiment, available_decisions, arguments, optimizer_dir)
    else:
        # perform evolutionary search
        perform_evolutionary_search(
            experiment,
            available_decisions,
            arguments,
            optimizer_dir,
        )

    # save experiment to disk
    export_to_json(experiment, optimizer_dir)
