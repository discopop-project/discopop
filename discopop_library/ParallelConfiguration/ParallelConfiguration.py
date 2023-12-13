# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import json
from typing import List, Tuple, Any, Dict, Optional
import warnings

from discopop_library.discopop_optimizer.classes.context.Update import Update, construct_update_from_dict
from discopop_library.discopop_optimizer.classes.system.devices.DeviceTypeEnum import DeviceTypeEnum
from discopop_library.discopop_optimizer.classes.types.Aliases import DeviceID

SuggestionId = int


class ParallelConfiguration(object):
    """Object to store, save and reconstruct configurations and suggestions to be applied by the patch applicator."""

    applied_patterns: List[Dict[str, Any]]
    data_movement: List[Update]
    pattern_id: Optional[int]  # used for the representation via the patch generator

    def __init__(self):
        self.applied_patterns = []
        self.data_movement = []
        self.pattern_id = None

    def reconstruct_from_file(self, file_path: str):
        with open(file_path, "r") as f:
            loaded_data = json.load(f)
        self.applied_patterns = loaded_data["applied_patterns"]
        self.pattern_id = loaded_data["pattern_id"]

        for values in loaded_data["data_movement"]:
            self.data_movement.append(construct_update_from_dict(values))

    def dump_to_file(self, file_path: str):
        dumpable_dict: Dict[str, Any] = dict()
        dumpable_dict["applied_patterns"] = self.applied_patterns
        dumpable_dict["data_movement"] = [update.toDict() for update in self.data_movement]
        dumpable_dict["pattern_id"] = self.pattern_id

        with open(file_path, "w") as f:
            json.dump(dumpable_dict, f)

        test = ParallelConfiguration()
        test.reconstruct_from_file(file_path)

    def add_pattern(self, pattern_id: SuggestionId, target_device_id: DeviceID, device_type: DeviceTypeEnum):
        if self.pattern_id is None:
            # get a unique pattern_id
            with open("next_free_pattern_id.txt", "r") as f:
                self.pattern_id = int(f.read())
            with open("next_free_pattern_id.txt", "w") as f:
                f.write(str(self.pattern_id + 1))
        tmp_dict = {"pattern_id": pattern_id, "device_id": target_device_id, "device_type": device_type}
        self.applied_patterns.append(tmp_dict)

    def add_data_movement(self, update: Update):
        self.data_movement.append(update)
