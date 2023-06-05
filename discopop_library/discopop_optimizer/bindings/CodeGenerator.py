import os
from typing import List, Optional, Tuple, Dict

import networkx as nx  # type: ignore

from discopop_library.discopop_optimizer.CostModels.CostModel import CostModel
from discopop_library.discopop_optimizer.Variables.Experiment import Experiment
from discopop_library.discopop_optimizer.classes.system.devices.Device import Device
from discopop_library.discopop_optimizer.utilities.MOGUtilities import data_at
from discopop_explorer.pattern_detectors.PatternInfo import PatternInfo
from discopop_library.CodeGenerator.CodeGenerator import (
    from_pattern_info as code_gen_from_pattern_info,
)


def export_code(graph: nx.DiGraph, experiment: Experiment, cost_model: CostModel):
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

    # prepare patterns by type
    patterns_by_type: Dict[str, list[PatternInfo]] = dict()
    for _, pattern, type in suggestions:
        if type not in patterns_by_type:
            patterns_by_type[type] = []
        patterns_by_type[type].append(pattern)

    # invoke the discopop code generator
    modified_code = code_gen_from_pattern_info(
        experiment.file_mapping, patterns_by_type, skip_compilation_check=False
    )

    # save modified code
    export_dir = os.path.join(
        experiment.project_folder_path,
        ".discopop_optimizer",
        "code_exports",
        str(cost_model.path_decisions),
    )

    print("\n############################")
    print("Modified Code: Decisions: ", cost_model.path_decisions)
    print("Exporting to: ", export_dir)
    print("############################")
    for file_id in modified_code:
        print("#### File ID: ", file_id, " ####\n")
        print(modified_code[file_id])
        print("\n")

    if os.path.exists(export_dir):
        os.rmdir(export_dir)
    os.makedirs(export_dir)
    for file_id in modified_code:
        code_path = os.path.join(export_dir, str(file_id).replace(" ", ""))
        with open(code_path, "w+") as f:
            f.write(modified_code[file_id])
            f.flush()
            f.close()
