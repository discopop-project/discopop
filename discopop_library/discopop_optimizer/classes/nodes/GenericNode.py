# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
from typing import Optional, List, Set

from sympy import Symbol, Function, Integer  # type: ignore

from discopop_explorer.PETGraphX import NodeID
from discopop_library.discopop_optimizer.Variables.Experiment import Experiment
from discopop_library.discopop_optimizer.classes.types.Aliases import DeviceID
from discopop_library.discopop_optimizer.classes.types.DataAccessType import (
    ReadDataAccess,
    WriteDataAccess,
)


class GenericNode(object):
    node_id: int  # id of the node in the nx.DiGraph which stores this object  # environment object to retrieve and store free symbols and other configurable values
    ## Data transfer calculation
    written_memory_regions: Set[WriteDataAccess]
    read_memory_regions: Set[ReadDataAccess]
    device_id: DeviceID

    branch_affiliation: List[int]
    experiment: Experiment

    def __init__(
        self,
        node_id: int,
        experiment,
        cu_id: Optional[NodeID] = None,
        written_memory_regions: Optional[Set[WriteDataAccess]] = None,
        read_memory_regions: Optional[Set[ReadDataAccess]] = None,
        device_id: DeviceID = None,
    ):
        self.experiment = experiment
        self.node_id = node_id
        self.cu_id = cu_id  # used to differentiate between "legacy" and suggestion nodes
        self.original_cu_id = cu_id  # used for the creation of update suggestions
        self.suggestion = None
        self.suggestion_type: Optional[str] = None
        self.branch_affiliation = []

        if written_memory_regions is None:
            self.written_memory_regions = set()
        else:
            self.written_memory_regions = written_memory_regions

        if read_memory_regions is None:
            self.read_memory_regions = set()
        else:
            self.read_memory_regions = read_memory_regions

        self.device_id = device_id

    def get_plot_label(self) -> str:
        return ""

    def get_hover_text(self) -> str:
        return ""

    def get_delta_workload(self) -> int:
        """calculates the deviation in possible workloads represented by the current node (e.g. due to branching)
        and returns the absolute difference value"""

        raise NotImplementedError(
            "This function needs to be implemented in every inheriting class!"
        )
