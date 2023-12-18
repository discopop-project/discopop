# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
import json
from typing import Any, Dict, Optional, cast
from discopop_explorer.PEGraphX import NodeID, PEGraphX
from discopop_library.discopop_optimizer.classes.types.Aliases import DeviceID
from discopop_library.discopop_optimizer.classes.types.DataAccessType import (
    WriteDataAccess,
    write_data_access_from_dict,
)


class Update(object):
    source_node_id: int
    target_node_id: int
    source_device_id: DeviceID
    target_device_id: DeviceID
    write_data_access: WriteDataAccess
    is_first_data_occurrence: bool
    source_cu_id: Optional[NodeID]
    target_cu_id: Optional[NodeID]

    def __init__(
        self,
        source_node_id: int,
        target_node_id: int,
        source_device_id: DeviceID,
        target_device_id: DeviceID,
        write_data_access: WriteDataAccess,
        is_first_data_occurrence: bool,
        source_cu_id: Optional[NodeID],
        target_cu_id: Optional[NodeID],
    ):
        self.source_node_id = source_node_id
        self.target_node_id = target_node_id
        self.source_device_id = source_device_id
        self.target_device_id = target_device_id
        self.write_data_access = write_data_access
        self.is_first_data_occurrence = is_first_data_occurrence
        self.source_cu_id = source_cu_id
        self.target_cu_id = target_cu_id

    def __str__(self):
        result_str = "First" if self.is_first_data_occurrence else ""
        return (
            result_str
            + "Update("
            + str(self.source_node_id)
            + "@"
            + str(self.source_device_id)
            + ", "
            + str(self.target_node_id)
            + "@"
            + str(self.target_device_id)
            + ", "
            + " : "
            + str(self.write_data_access.memory_region)
            + " --> "
            + str(self.write_data_access.var_name)
            + ")"
        )

    def get_pattern_string(self, pet: PEGraphX) -> str:
        result_dict: Dict[str, Any] = dict()
        result_dict["source_device_id"] = self.source_device_id
        result_dict["target_device_id"] = self.target_device_id
        result_dict["openmp_source_device_id"] = self.source_device_id
        result_dict["openmp_target_device_id"] = self.target_device_id
        result_dict["is_first_data_occurrence"] = self.is_first_data_occurrence
        result_dict["var_name"] = self.write_data_access.var_name
        result_dict["start_line"] = pet.node_at(cast(NodeID, self.source_cu_id)).start_position()
        result_dict["end_line"] = pet.node_at(cast(NodeID, self.target_cu_id)).start_position()
        return json.dumps(result_dict)

    def toDict(self) -> Dict[str, Any]:
        result_dict: Dict[str, Any] = {}
        result_dict["source_node_id"] = self.source_node_id
        result_dict["target_node_id"] = self.target_node_id
        result_dict["source_device_id"] = self.source_device_id
        result_dict["target_device_id"] = self.target_device_id
        result_dict["is_first_data_occurrence"] = self.is_first_data_occurrence
        result_dict["write_data_access"] = self.write_data_access.toDict()
        result_dict["source_cu_id"] = self.source_cu_id
        result_dict["target_cu_id"] = self.target_cu_id
        return result_dict


def construct_update_from_dict(values: Dict[str, Any]) -> Update:
    update = Update(
        values["source_node_id"],
        values["target_node_id"],
        values["source_device_id"],
        values["target_device_id"],
        write_data_access_from_dict(values["write_data_access"]),
        values["is_first_data_occurrence"],
        values["source_cu_id"],
        values["target_cu_id"],
    )
    return update
