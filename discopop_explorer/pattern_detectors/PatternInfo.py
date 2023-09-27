# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
import json
from typing import Optional

from ..utils import calculate_workload, calculate_per_iteration_workload_of_loop
from ..PETGraphX import LoopNode, Node, NodeID, LineID, PETGraphX


class PatternInfo(object):
    """Base class for pattern detection info"""

    _node: Node
    node_id: NodeID
    start_line: LineID
    end_line: LineID
    iterations_count: int
    average_iteration_count: int
    entries: int
    instructions_count: Optional[int]
    workload: Optional[int]
    per_iteration_workload: Optional[int]
    dp_optimizer_device_id: Optional[int] = None  # used by discopop_optimizer. unused by discopop_explorer.

    def __init__(self, node: Node):
        """
        :param node: node, where pipeline was detected
        """
        self._node = node
        self.node_id = node.id
        self.start_line = node.start_position()
        self.end_line = node.end_position()
        self.average_iteration_count = (
            node.loop_data.average_iteration_count
            if (isinstance(node, LoopNode) and node.loop_data is not None)
            else -1
        )
        self.iterations_count = (
            node.loop_data.total_iteration_count if (isinstance(node, LoopNode) and node.loop_data is not None) else -1
        )
        self.entries = node.loop_data.entry_count if (isinstance(node, LoopNode) and node.loop_data is not None) else -1

        # TODO self.instructions_count = total_instructions_count(pet, node)
        self.workload = None
        self.per_iteration_workload: Optional[int] = None
        # TODO self.workload = calculate_workload(pet, node)

    def to_json(self):
        dic = self.__dict__
        keys = [k for k in dic.keys()]
        for key in keys:
            if key.startswith("_"):
                del dic[key]

        return json.dumps(dic, indent=2, default=lambda o: o.toJSON())  # , default=lambda o: "<not serializable>")

    def get_workload(self, pet: PETGraphX) -> int:
        """returns the workload of self._node"""
        if self.workload is not None:
            return self.workload
        self.workload = calculate_workload(pet, self._node)
        return self.workload

    def get_per_iteration_workload(self, pet: PETGraphX) -> int:
        """returns the per iteration workload of self"""
        if self.per_iteration_workload is not None:
            return self.per_iteration_workload
        self.per_iteration_workload = calculate_per_iteration_workload_of_loop(pet, self._node)
        return self.per_iteration_workload
