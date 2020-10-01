# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
import json

from ..PETGraphX import CUNode


class PatternInfo(object):
    """Base class for pattern detection info
    """
    _node: CUNode
    node_id: str
    start_line: str
    end_line: str
    iterations_count: int
    instructions_count: int
    workload: int

    def __init__(self, node: CUNode):
        """
        :param node: node, where pipeline was detected
        """
        self._node = node
        self.node_id = node.id
        self.start_line = node.start_position()
        self.end_line = node.end_position()
        self.iterations_count = node.loop_iterations
        # TODO self.instructions_count = total_instructions_count(pet, node)
        self.instructions_count = 0
        self.workload = 0
        # TODO self.workload = calculate_workload(pet, node)

    def to_json(self):
        dic = self.__dict__
        keys = [k for k in dic.keys()]
        for key in keys:
            if key.startswith('_'):
                del dic[key]

        return json.dumps(dic, indent=2, default=lambda o: '<not serializable>')
