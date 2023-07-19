# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
from typing import Optional, Set, List, cast

from sympy import Integer, Expr  # type: ignore

from discopop_explorer.PETGraphX import NodeID, PETGraphX, EdgeType
from discopop_library.discopop_optimizer.CostModels.CostModel import CostModel
from discopop_library.discopop_optimizer.classes.nodes.GenericNode import GenericNode
from discopop_library.discopop_optimizer.classes.types.DataAccessType import (
    WriteDataAccess,
    ReadDataAccess,
)


class Workload(GenericNode):
    """This class represents a generic node in the Optimization Graph"""

    sequential_workload: Optional[int]
    parallelizable_workload: Optional[int]

    def __init__(
        self,
        node_id: int,
        experiment,
        cu_id: Optional[NodeID],
        sequential_workload: Optional[int],
        parallelizable_workload: Optional[int],
        written_memory_regions: Optional[Set[WriteDataAccess]] = None,
        read_memory_regions: Optional[Set[ReadDataAccess]] = None,
    ):
        super().__init__(
            node_id,
            experiment,
            cu_id,
            written_memory_regions=written_memory_regions,
            read_memory_regions=read_memory_regions,
        )
        self.sequential_workload = sequential_workload
        self.parallelizable_workload = parallelizable_workload

    def get_plot_label(self) -> str:
        if self.sequential_workload is not None:
            # return str(self.workload)
            return str(self.node_id)
        else:
            return "WL"

    def get_hover_text(self) -> str:
        return (
            "WL: " + str(self.sequential_workload) + "\n"
            "Read: " + str([str(e) for e in self.read_memory_regions]) + "\n"
            "Write: " + str([str(e) for e in self.written_memory_regions]) + "\n"
            "Branch: " + str(self.branch_affiliation)
        )
