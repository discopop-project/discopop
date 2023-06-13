import os
import random
import string
import subprocess
from typing import List, Tuple, Dict, cast, Optional

import jsonpickle  # type: ignore
import jsons  # type: ignore
import networkx as nx  # type: ignore

from discopop_explorer.PETGraphX import NodeID, PETGraphX
from discopop_explorer.pattern_detectors.PatternInfo import PatternInfo
from discopop_explorer.pattern_detectors.device_updates import DeviceUpdateInfo
from discopop_library.CodeGenerator.CodeGenerator import (
    from_pattern_info as code_gen_from_pattern_info,
)
from discopop_library.discopop_optimizer.CostModels.CostModel import CostModel
from discopop_library.discopop_optimizer.Variables.Experiment import Experiment
from discopop_library.discopop_optimizer.bindings.CodeStorageObject import CodeStorageObject
from discopop_library.discopop_optimizer.bindings.utilities import is_child_of_any
from discopop_library.discopop_optimizer.classes.context.ContextObject import ContextObject
from discopop_library.discopop_optimizer.classes.nodes.FunctionRoot import FunctionRoot
from discopop_library.discopop_optimizer.classes.system.devices.Device import Device
from discopop_library.discopop_optimizer.utilities.MOGUtilities import data_at, get_parents


def export_code(
    pet: PETGraphX,
    graph: nx.DiGraph,
    experiment: Experiment,
    cost_model: CostModel,
    context: ContextObject,
    parent_function: FunctionRoot,
):
    """Provides a binding to the discopop code generator and exports the code corresponding to the given cost model"""
    # collect suggestions to be applied
    suggestions: List[Tuple[Device, PatternInfo, str, Optional[int]]] = []
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
        suggestions.append((device, suggestion, suggestion_type, decision))

    # todo collect updates to be applied
    for update in context.necessary_updates:
        print("ALL UPDATE: VAR_NAME: ", update.write_data_access.var_name)
        if update.source_device_id != update.target_device_id:
            # calculate correct position for update (updates inside target regions are NOT allowed by OpenMP!)
            # insert pragma before the usage position of the data
            unchecked_target_nodes: List[int] = [update.target_node_id]
            checked_target_nodes: List[int] = []

            while len(unchecked_target_nodes) != 0:
                cur_node = unchecked_target_nodes.pop()
                if is_child_of_any(
                    graph,
                    cur_node,
                    [
                        s_node_id
                        for _, sugg, s_type, s_node_id in suggestions
                        if s_type.startswith("gpu_")
                    ],
                ):
                    tmp_parents = get_parents(graph, cur_node)
                    if len(tmp_parents) != 0:
                        unchecked_target_nodes += [
                            p
                            for p in tmp_parents
                            if p not in checked_target_nodes and p not in unchecked_target_nodes
                        ]

                else:
                    if cur_node not in checked_target_nodes:
                        checked_target_nodes.append(cur_node)

            for checked_node_id in checked_target_nodes:
                start_line = pet.node_at(
                    cast(NodeID, data_at(graph, checked_node_id).original_cu_id)
                ).start_position()
                end_line = start_line

                # register update
                suggestions.append(
                    (
                        experiment.get_system().get_device(update.source_device_id),
                        DeviceUpdateInfo(
                            pet,
                            pet.node_at(
                                cast(NodeID, data_at(graph, update.source_node_id).original_cu_id)
                            ),
                            pet.node_at(
                                cast(NodeID, data_at(graph, update.target_node_id).original_cu_id)
                            ),
                            update.write_data_access.memory_region,
                            update.write_data_access.var_name,
                            0
                            if update.source_device_id is None
                            else cast(int, update.source_device_id),
                            0
                            if update.source_device_id is None
                            else cast(int, update.target_device_id),
                            start_line,
                            end_line,
                        ),
                        "device_update",
                        None,
                    )
                )

    # remove duplicates
    to_be_removed = []
    buffer = []
    for entry in suggestions:
        entry_str = str(entry[0]) + ";" + str(entry[1]) + ";" + str(entry[2]) + ";" + str(entry[3])
        if entry_str not in buffer:
            buffer.append(entry_str)
        else:
            to_be_removed.append(entry)
    for entry in to_be_removed:
        if entry in suggestions:
            suggestions.remove(entry)

    # prepare patterns by type
    patterns_by_type: Dict[str, list[PatternInfo]] = dict()
    for _, pattern, s_type, s_node_id in suggestions:
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
