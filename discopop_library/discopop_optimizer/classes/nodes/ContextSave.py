# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
import copy

import networkx as nx  # type: ignore

from discopop_library.discopop_optimizer.CostModels.CostModel import CostModel
from discopop_library.discopop_optimizer.Variables.Environment import Environment
from discopop_library.discopop_optimizer.classes.context.ContextObject import ContextObject
from discopop_library.discopop_optimizer.classes.nodes.ContextNode import ContextNode


class ContextSave(ContextNode):
    def __init__(self, node_id: int, environment: Environment):
        super().__init__(node_id, environment)

    def get_plot_label(self) -> str:
        return str(self.node_id) + "\nCTX\nsave"

    def get_modified_context(
        self, node_id: int, graph: nx.DiGraph, model: CostModel, context: ContextObject
    ) -> ContextObject:
        context.save_stack[-1].append(copy.deepcopy(context))
        return context
