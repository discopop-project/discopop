# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.


import json
from typing import Any, Dict, List
from discopop_explorer.PEGraphX import Node
from discopop_explorer.pattern_detectors.PatternBase import PatternBase

from discopop_library.PatternIdManagement.unique_pattern_id import get_unique_pattern_id
from discopop_library.discopop_optimizer.classes.context.Update import Update, construct_update_from_dict
from discopop_library.discopop_optimizer.classes.system.devices.DeviceTypeEnum import DeviceTypeEnum
from discopop_library.discopop_optimizer.classes.types.Aliases import DeviceID

SuggestionId = int


class OptimizerOutputPattern(PatternBase):
    applied_patterns: List[Dict[str, Any]]
    data_movement: List[Update]
    decisions: List[int]
    host_device_id: int

    def __init__(self, node: Node, decisions: List[int], host_device_id: int):
        PatternBase.__init__(self, node)
        self.applied_patterns = []
        self.data_movement = []
        self.decisions = decisions
        self.host_device_id = host_device_id

    def reconstruct_from_file(self, file_path: str):  # todo remove?
        with open(file_path, "r") as f:
            loaded_data = json.load(f)
        self.applied_patterns = loaded_data["applied_patterns"]
        self.pattern_id = loaded_data["pattern_id"]
        self.host_device_id = loaded_data["host_device_id"]

        for values in loaded_data["data_movement"]:
            self.data_movement.append(construct_update_from_dict(values))

    def dump_to_file(self, file_path: str):  # todo remove?
        dumpable_dict: Dict[str, Any] = dict()
        dumpable_dict["applied_patterns"] = self.applied_patterns
        dumpable_dict["data_movement"] = [update.toDict() for update in self.data_movement]
        dumpable_dict["pattern_id"] = self.pattern_id
        dumpable_dict["host_device_id"] = self.host_device_id

        with open(file_path, "w") as f:
            json.dump(dumpable_dict, f)

    def add_pattern(self, pattern_id: SuggestionId, target_device_id: DeviceID, device_type: DeviceTypeEnum):
        if self.pattern_id is None:
            # get a unique pattern_id
            self.pattern_id = get_unique_pattern_id()
        tmp_dict = {"pattern_id": pattern_id, "device_id": target_device_id, "device_type": device_type}
        self.applied_patterns.append(tmp_dict)

    def add_data_movement(self, update: Update):
        self.data_movement.append(update)
