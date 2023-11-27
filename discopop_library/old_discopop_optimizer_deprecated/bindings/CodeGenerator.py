# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
import os
import random
import string
import subprocess
import warnings
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
from discopop_library.discopop_optimizer.classes.system.devices.GPU import GPU
from discopop_library.discopop_optimizer.utilities.MOGUtilities import (
    data_at,
    get_parents,
)


def export_code(
    pet: PETGraphX,
    graph: nx.DiGraph,
    experiment: Experiment,
    cost_model: CostModel,
    context: ContextObject,
    label: str,
    parent_function: FunctionRoot,
):
    """Provides a binding to the discopop code generator and exports the code corresponding to the given cost model"""
    # only consider "empty", i.e. sequential cases, if they are either the sequential or the locally optimized option
    if len(cost_model.path_decisions) == 0:
        if label not in ["Sequential", "Locally Optimized"]:
            print("warning: skipped empty model in code export.")

    # collect suggestions to be applied
    suggestions: List[Tuple[Device, PatternInfo, str, Optional[int]]] = []
    for decision in cost_model.path_decisions:
        graph_node = data_at(graph, decision)
        device: Device = experiment.get_system().get_device(0 if graph_node.device_id is None else graph_node.device_id)
        if graph_node.suggestion is None:
            continue
        suggestion, suggestion_type = device.get_device_specific_pattern_info(
            graph_node.suggestion, graph_node.suggestion_type
        )
        suggestions.append((device, suggestion, suggestion_type, decision))

    # todo collect updates to be applied
    for update in context.necessary_updates:
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
                    [s_node_id for _, sugg, s_type, s_node_id in suggestions if s_type.startswith("gpu_")],
                ):
                    tmp_parents = get_parents(graph, cur_node)
                    if len(tmp_parents) != 0:
                        unchecked_target_nodes += [
                            p for p in tmp_parents if p not in checked_target_nodes and p not in unchecked_target_nodes
                        ]

                else:
                    if cur_node not in checked_target_nodes:
                        checked_target_nodes.append(cur_node)

            for checked_node_id in checked_target_nodes:
                start_line = pet.node_at(cast(NodeID, data_at(graph, checked_node_id).original_cu_id)).start_position()
                end_line = start_line

                # register update
                source_cu_id = cast(NodeID, data_at(graph, update.source_node_id).original_cu_id)
                target_cu_id = cast(NodeID, data_at(graph, update.target_node_id).original_cu_id)

                if source_cu_id is None or target_cu_id is None:
                    warnings.warn("Could not register update: " + str(update) + " @ Line: " + start_line)
                else:
                    # get updated variable
                    var_obj = pet.get_variable(target_cu_id, cast(str, update.write_data_access.var_name))
                    if var_obj is None:
                        raise ValueError(
                            "Could not find variable object for: "
                            + str(update)
                            + "  ->  "
                            + str(update.write_data_access.var_name)
                        )

                    # get amount of elements targeted by the update
                    update_elements = int(
                        int(experiment.get_memory_region_size(update.write_data_access.memory_region)[0].evalf())
                        / var_obj.sizeInByte
                    )

                    # debug!
                    # add memory access to var_name
                    dbg_info = (
                        "-"
                        + str(update.write_data_access.memory_region)
                        + "-"
                        + str(update.write_data_access.unique_id)
                        + "-vartype:"
                        + var_obj.type
                    )

                    # add range to updated var name if necessary
                    if update_elements > 1 and update.write_data_access.var_name is not None and "**" in var_obj.type:
                        updated_var_name: Optional[str] = (
                            str(update.write_data_access.var_name)
                            + "[:"
                            + str(update_elements)
                            + "]"
                            # + dbg_info
                        )
                    else:
                        updated_var_name = update.write_data_access.var_name

                    suggestions.append(
                        (
                            experiment.get_system().get_device(update.source_device_id),
                            DeviceUpdateInfo(
                                pet,
                                pet.node_at(source_cu_id),
                                pet.node_at(target_cu_id),
                                update.write_data_access.memory_region,
                                updated_var_name,
                                0 if update.source_device_id is None else update.source_device_id,
                                0 if update.source_device_id is None else cast(int, update.target_device_id),
                                start_line,
                                end_line,
                                update.is_first_data_occurrence,
                                cast(GPU, experiment.get_system().get_device(update.source_device_id)).openmp_device_id,
                                cast(GPU, experiment.get_system().get_device(update.target_device_id)).openmp_device_id,
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

    # remove updates, if an identical entry exists
    to_be_removed = []
    for entry_1 in suggestions:
        if not isinstance(entry_1[1], DeviceUpdateInfo):
            continue
        entry_str_1 = (
            str(entry_1[0])
            + ";"
            + (
                entry_1[1].get_str_without_first_data_occurrence()
                if isinstance(entry_1[1], DeviceUpdateInfo)
                else str(entry_1[1])
            )
            + ";"
            + str(entry_1[2])
            + ";"
            + str(entry_1[3])
        )
        for entry_2 in suggestions:
            if not isinstance(entry_1[1], DeviceUpdateInfo):
                continue
            entry_str_2 = (
                str(entry_2[0])
                + ";"
                + (
                    entry_2[1].get_str_without_first_data_occurrence()
                    if isinstance(entry_2[1], DeviceUpdateInfo)
                    else str(entry_2[1])
                )
                + ";"
                + str(entry_2[2])
                + ";"
                + str(entry_2[3])
            )
            if entry_str_1 == entry_str_2:
                if (
                    entry_1[1].is_first_data_occurrence
                    and not cast(DeviceUpdateInfo, entry_2[1]).is_first_data_occurrence
                ):
                    to_be_removed.append(entry_2)
    for entry in to_be_removed:
        if entry in suggestions:
            suggestions.remove(entry)

    if False:
        # todo cleanup
        for sugg in suggestions:
            if type(sugg[1]) == DeviceUpdateInfo:
                tmp = cast(DeviceUpdateInfo, sugg[1])
                print(
                    "First" if tmp.is_first_data_occurrence else "",
                    "Update: ",
                    tmp.start_line,
                    "@",
                    tmp.source_device_id,
                    "->",
                    tmp.start_line,
                    "@",
                    tmp.target_device_id,
                    "|",
                    tmp.mem_reg,
                    "|",
                    tmp.var_name,
                )

    # prepare patterns by type
    patterns_by_type: Dict[str, List[PatternInfo]] = dict()
    for device, pattern, s_type, s_node_id in suggestions:
        if s_type not in patterns_by_type:
            patterns_by_type[s_type] = []
        # add device id to pattern
        pattern.dp_optimizer_device_id = device.openmp_device_id
        patterns_by_type[s_type].append(pattern)

    # invoke the discopop code generator
    modified_code = code_gen_from_pattern_info(
        experiment.file_mapping,
        patterns_by_type,
        skip_compilation_check=True,  # False,
        compile_check_command=experiment.compile_check_command,
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

    code_storage = CodeStorageObject(cost_model, patches, parent_function, hash_name, label)

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


def __convert_modified_code_to_patch(experiment: Experiment, modified_code: Dict[int, str]) -> Dict[int, str]:
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
        if result.returncode != 0:
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

    return patches
