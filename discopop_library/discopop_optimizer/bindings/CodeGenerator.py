import json
import os
import random
import string
import shutil
import subprocess
from typing import List, Optional, Tuple, Dict

import jsonpickle  # type: ignore
import jsons  # type: ignore
import networkx as nx  # type: ignore

from discopop_library.discopop_optimizer.CostModels.CostModel import CostModel
from discopop_library.discopop_optimizer.Variables.Experiment import Experiment
from discopop_library.discopop_optimizer.bindings.CodeStorageObject import CodeStorageObject
from discopop_library.discopop_optimizer.classes.context.ContextObject import ContextObject
from discopop_library.discopop_optimizer.classes.nodes.FunctionRoot import FunctionRoot
from discopop_library.discopop_optimizer.classes.system.devices.Device import Device
from discopop_library.discopop_optimizer.utilities.MOGUtilities import data_at
from discopop_explorer.pattern_detectors.PatternInfo import PatternInfo
from discopop_library.CodeGenerator.CodeGenerator import (
    from_pattern_info as code_gen_from_pattern_info,
)


def export_code(
    graph: nx.DiGraph,
    experiment: Experiment,
    cost_model: CostModel,
    context: ContextObject,
    parent_function: FunctionRoot,
):
    """Provides a binding to the discopop code generator and exports the code corresponding to the given cost model"""
    # collect suggestions to be applied
    suggestions: List[Tuple[Device, PatternInfo, str]] = []
    for decision in cost_model.path_decisions:
        graph_node = data_at(graph, decision)
        device: Device = experiment.get_system().get_device(
            0 if graph_node.device_id is None else graph_node.device_id
        )
        if graph_node.suggestion is None:
            continue
        suggestion, suggestion_type = device.get_device_specific_pattern_info(
            graph_node.suggestion, graph_node.suggestion_type
        )
        suggestions.append((device, suggestion, suggestion_type))

    # todo collect updates to be applied
    for update in context.necessary_updates:
        print("type: ", type(update))
        print(str(update))

    # prepare patterns by type
    patterns_by_type: Dict[str, list[PatternInfo]] = dict()
    for _, pattern, s_type in suggestions:
        if s_type not in patterns_by_type:
            patterns_by_type[s_type] = []
        patterns_by_type[s_type].append(pattern)

    # invoke the discopop code generator
    modified_code = code_gen_from_pattern_info(
        experiment.file_mapping, patterns_by_type, skip_compilation_check=False
    )
    # create patches from the modified code
    patches = __convert_modified_code_to_patch(experiment, modified_code)

    # save modified code as CostStorageObject
    export_dir = os.path.join(experiment.discopop_optimizer_path, "code_exports")
    if not os.path.exists(export_dir):
        os.makedirs(export_dir)

    # generate unique hash name
    hash_name = "".join(random.choices(string.ascii_uppercase + string.digits, k=8))
    while os.path.exists(os.path.join(export_dir, hash_name)):
        hash_name = "".join(random.choices(string.ascii_uppercase + string.digits, k=8))

    code_storage = CodeStorageObject(cost_model, patches, parent_function)

    # export code_storage object to json
    print("Export JSON TO: ", os.path.join(export_dir, hash_name + ".json"))
    with open(os.path.join(export_dir, hash_name + ".json"), "w+") as f:
        f.write(jsonpickle.dumps(code_storage))
        f.flush()
        f.close()

    print("\n############################")
    print("Modified Code: Decisions: ", cost_model.path_decisions)
    print("Exporting to: ", export_dir)
    print("############################")
    for file_id in patches:
        print("#### File ID: ", file_id, " ####\n")
        print(patches[file_id])
        print("\n")


def __convert_modified_code_to_patch(
    experiment: Experiment, modified_code: Dict[int, str]
) -> Dict[int, str]:
    patches: Dict[int, str] = dict()
    hash_name = "".join(random.choices(string.ascii_uppercase + string.digits, k=8))
    tmp_file_name = os.path.join(os.getcwd(), hash_name + ".tmp")
    for file_id in modified_code:
        # write modified code to file
        with open(tmp_file_name, "w+") as f:
            f.write(modified_code[file_id])
            f.flush()
            f.close()

        # generate diff
        diff_name = tmp_file_name + ".diff"
        command = [
            "diff",
            "-Naru",
            str(experiment.file_mapping[file_id]),
            tmp_file_name,
        ]
        result = subprocess.run(
            command,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            universal_newlines=True,
            cwd=os.getcwd(),
        )
        print("RESULT: ", result.returncode)
        print("STDERR:")
        print(result.stderr)
        print("STDOUT: ")
        print(result.stdout)

        # save diff
        patches[file_id] = result.stdout

        # cleanup environment
        if os.path.exists(tmp_file_name):
            os.remove(tmp_file_name)
        if os.path.exists(diff_name):
            os.remove(diff_name)

    print("PATCHES:")
    print(patches)

    return patches
