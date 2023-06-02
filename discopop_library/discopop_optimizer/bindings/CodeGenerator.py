from typing import List, Optional, Tuple

import networkx as nx  # type: ignore

from discopop_library.discopop_optimizer.CostModels.CostModel import CostModel
from discopop_library.discopop_optimizer.Variables.Environment import Environment
from discopop_library.discopop_optimizer.classes.system.devices.Device import Device
from discopop_library.discopop_optimizer.utilities.MOGUtilities import data_at
from discopop_explorer.pattern_detectors.PatternInfo import PatternInfo


def export_code(graph: nx.DiGraph, environment: Environment, cost_model: CostModel):
    """Provides a binding to the discopop code generator and exports the code corresponding to the given cost model"""
    # collect suggestions to be applied
    suggestions: List[Tuple[Device, PatternInfo, str]] = []
    for decision in cost_model.path_decisions:
        graph_node = data_at(graph, decision)
        device: Device = environment.get_system().get_device(
            0 if graph_node.device_id is None else graph_node.device_id
        )
        if graph_node.suggestion is None:
            continue
        suggestion, suggestion_type = device.get_device_specific_pattern_info(
            graph_node.suggestion, graph_node.suggestion_type
        )
        suggestions.append((device, suggestion, suggestion_type))

    print("Suggestions: ")
    print(suggestions)

    # todo collect updates to be applied

    # invoke the discopop code generator
