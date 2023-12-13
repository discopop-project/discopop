# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import json
from typing import List, Tuple, Any, Dict
import warnings

from discopop_library.discopop_optimizer.classes.context.Update import Update, construct_update_from_dict
from discopop_library.discopop_optimizer.classes.types.Aliases import DeviceID

SuggestionId = int


class ParallelConfiguration(object):
    """Object to store, save and reconstruct configurations and suggestions to be applied by the patch applicator."""

    __applied_patterns: List[Dict[str, Any]]
    __data_movement: List[Update]

    def __init__(self):
        self.__applied_patterns = []
        self.__data_movement = []

    def reconstruct_from_file(self, file_path: str):
        with open(file_path, "r") as f:
            loaded_data = json.load(f)
        self.__applied_patterns = loaded_data["applied_patterns"]

        for values in loaded_data["data_movement"]:
            self.__data_movement.append(construct_update_from_dict(values))

    def dump_to_file(self, file_path: str):
        dumpable_dict = dict()
        dumpable_dict["applied_patterns"] = self.__applied_patterns
        dumpable_dict["data_movement"] = [update.toDict() for update in self.__data_movement]

        with open(file_path, "w") as f:
            json.dump(dumpable_dict, f)

        test = ParallelConfiguration()
        test.reconstruct_from_file(file_path)

    def add_pattern(self, pattern_id: SuggestionId, target_device_id: DeviceID):
        tmp_dict = {"pattern_id": pattern_id, "device_id": target_device_id}
        self.__applied_patterns.append(tmp_dict)

    def add_data_movement(self, update: Update):
        self.__data_movement.append(update)
