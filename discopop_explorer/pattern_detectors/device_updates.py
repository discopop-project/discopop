# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
from typing import Optional

from .PatternInfo import PatternInfo
from ..PETGraphX import (
    PETGraphX,
    Node,
    LineID,
    MemoryRegion,
)


class DeviceUpdateInfo(PatternInfo):
    """Class, that contains omp device updates"""

    def __init__(
        self,
        pet: PETGraphX,
        source_node: Node,
        target_node: Node,
        mem_reg: MemoryRegion,
        var_name: Optional[str],
        source_device_id: int,
        target_device_id: int,
        start_line: LineID,
        end_line: LineID,
    ):
        """
        :param pet: PET graph
        :param source_node: node, where data originates
        :param target_node: node, where data is required
        """
        PatternInfo.__init__(self, source_node)
        self.source_node_id = source_node.id
        self.target_node_id = target_node.id
        self.mem_reg = mem_reg
        self.var_name = var_name
        self.source_device_id = source_device_id
        self.target_device_id = target_device_id
        # overwrite start and end lines set by PatternInfo
        self.start_line = start_line
        self.end_line = end_line

    def __str__(self):
        return (
            f"Do-all at: {self.node_id}\n"
            f"Start line: {self.start_line}\n"
            f"End line: {self.end_line}\n"
            # f"iterations: {self.iterations_count}\n"
            # f"instructions: {self.instructions_count}\n"
            # f"workload: {self.workload}\n"
            f"source_node: {self.source_node_id}\n"
            f"target_node: {self.target_node_id}\n"
            f"source_device: {self.source_device_id}\n"
            f"target_device: {self.target_device_id}\n"
            f"mem_reg: {self.mem_reg}\n"
            f"var_name: {self.var_name}"
        )
