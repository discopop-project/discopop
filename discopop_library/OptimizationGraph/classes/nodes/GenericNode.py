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
from discopop_library.OptimizationGraph.CostModels.CostModel import CostModel
from discopop_library.OptimizationGraph.classes.types.Aliases import DeviceID
from discopop_library.OptimizationGraph.classes.types.DataAccessType import (
    ReadDataAccess,
    WriteDataAccess,
)


class GenericNode(object):
    node_id: int  # id of the node in the nx.DiGraph which stores this object
    ## Performance modelling
    introduced_symbols: List[Symbol]
    performance_model: CostModel
    ## Data transfer calculation
    written_memory_regions: Set[WriteDataAccess]
    read_memory_regions: Set[ReadDataAccess]
    device_id: DeviceID

    def __init__(
        self,
        node_id: int,
        cu_id: Optional[NodeID] = None,
        written_memory_regions: Optional[Set[WriteDataAccess]] = None,
        read_memory_regions: Optional[Set[ReadDataAccess]] = None,
        device_id: DeviceID = 0,
    ):
        self.node_id = node_id
        self.cu_id = cu_id
        self.introduced_symbols = []
        self.performance_model = CostModel(Integer(0))
        self.suggestion = None

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

    def get_cost_model(self) -> CostModel:
        raise NotImplementedError(
            "Implementation needs to be provided by derived class: !", type(self)
        )
