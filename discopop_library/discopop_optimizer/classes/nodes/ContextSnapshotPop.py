# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
import networkx as nx  # type: ignore

from discopop_library.discopop_optimizer.CostModels.CostModel import CostModel
from discopop_library.discopop_optimizer.classes.context.ContextObject import ContextObject
from discopop_library.discopop_optimizer.classes.nodes.ContextNode import ContextNode


class ContextSnapshotPop(ContextNode):
    def __init__(self, node_id: int, experiment):
        super().__init__(node_id, experiment)

    def get_plot_label(self) -> str:
        return str(self.node_id) + "\nCTX\nsnap pop"

    def get_modified_context(
        self, node_id: int, graph: nx.DiGraph, model: CostModel, context: ContextObject
    ) -> ContextObject:
        context.snapshot_stack.pop()
        context.save_stack.pop()
        return context
