import json
import os
import pickle
from typing import List, Optional, cast

import jsonpickle  # type: ignore
import jsons  # type: ignore

from discopop_library.discopop_optimizer.Variables.Experiment import Experiment
from discopop_library.discopop_optimizer.classes.nodes.FunctionRoot import FunctionRoot
from discopop_library.discopop_optimizer.gui.presentation.OptionTable import show_options
from discopop_library.discopop_optimizer.utilities.MOGUtilities import data_at


def show_function_models(
    experiment: Experiment,
    show_functions: Optional[List[FunctionRoot]] = None,
):
    considered_functions = (
        show_functions if show_functions is not None else experiment.function_models
    )
    for function in considered_functions:
        print("FUNCTION: ", function)
        print("\ttype: ", type(function))
        print("Showing function models: ", function.name)
        print("IN OPTIONS: ", len(experiment.function_models[function]))
        options = show_options(  # random options might be added by show_options
            experiment.detection_result.pet,
            experiment.optimization_graph,
            experiment,
            experiment.function_models[function],
            experiment.substitutions,
            experiment.sorted_free_symbols,
            experiment.free_symbol_ranges,
            experiment.free_symbol_distributions,
            function,
            window_title="Function: " + function.name,
        )
        print("OUT OPTIONS: ", len(options))


def export_to_json(experiment: Experiment):
    # convert functionRoot in function_models to node ids
    to_be_added = []
    to_be_deleted = []
    for old_key in experiment.function_models:
        print("OLD KEY: ", old_key)
        print("NODE_ID: ", old_key.node_id)
        print("Tyoe: ", type(old_key))
        new_key = old_key.node_id
        print("--> New key: ", new_key)
        print("--> Type: ", type(new_key))
        to_be_added.append((new_key, experiment.function_models[old_key]))
        to_be_deleted.append(old_key)

    for k1 in to_be_deleted:
        del experiment.function_models[k1]
    for k2, v in to_be_added:
        experiment.function_models[k2] = v  # type: ignore

    print("FUNCTION MODELS: ")
    print(experiment.function_models)

    experiment_dump_path: str = os.path.join(
        experiment.discopop_optimizer_path, "last_experiment.pickle"
    )
    if not os.path.exists(experiment.discopop_optimizer_path):
        os.makedirs(experiment.discopop_optimizer_path)
    # with open(experiment_dump_path, "w+") as f:
    #    f.write(jsonpickle.encode(experiment))
    #    print("Saved experiment to: ", experiment_dump_path)
    pickle.dump(experiment, open(experiment_dump_path, "wb"))


def restore_session(json_file: str) -> Experiment:
    # with open(json_file, "r") as f:
    #    experiment = jsonpickle.decode(f.read())
    experiment = pickle.load(open(json_file, "rb"))

    # convert keys of function_models to FunctionRoot objects
    to_be_added = []
    to_be_deleted = []
    for old_key in experiment.function_models:
        print("TYPE: ", type(old_key))
        print("GRAPH NODES: ")
        print(experiment.optimization_graph.nodes)
        for node in experiment.optimization_graph.nodes:
            print("Node: ", node)
            print("\ttype: ", type(data_at(experiment.optimization_graph, node)))
        new_key = cast(FunctionRoot, data_at(experiment.optimization_graph, old_key))
        to_be_added.append((new_key, experiment.function_models[old_key]))
        to_be_deleted.append(old_key)

    for k, v in to_be_added:
        experiment.function_models[k] = v
    for k in to_be_deleted:
        del experiment.function_models[k]

    return experiment
