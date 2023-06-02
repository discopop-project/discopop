# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
from typing import cast

import networkx as nx  # type: ignore

from discopop_library.OptimizationGraph.CostModels.CostModel import CostModel
from discopop_library.OptimizationGraph.Variables.Environment import Environment
from discopop_library.OptimizationGraph.classes.context.ContextObject import ContextObject
from discopop_library.OptimizationGraph.classes.nodes.ContextNode import ContextNode


class ContextMerge(ContextNode):
    def __init__(self, node_id: int, environment: Environment):
        super().__init__(node_id, environment)

    def get_plot_label(self) -> str:
        return str(self.node_id) + "\nCTX\nmerge"

    def get_modified_context(self, node_id: int, graph: nx.DiGraph, model: CostModel,
                             context: ContextObject) -> ContextObject:
        if len(context.snapshot_stack) < 1 or len(context.save_stack) < 1:
            raise ValueError("Context can not be merged before creating a snapshot!")

        context.last_seen_device_id = cast(ContextObject, context.snapshot_stack[-1]).last_seen_device_id
        for saved_contex in context.save_stack[-1]:
            context.necessary_updates.update(cast(ContextObject, saved_contex).necessary_updates)
            for device_id in cast(ContextObject, saved_contex).seen_writes_by_device:
                if device_id not in context.seen_writes_by_device:
                    context.seen_writes_by_device[device_id] = dict()
                for mem_reg_id in cast(ContextObject, saved_contex).seen_writes_by_device[device_id]:
                    if mem_reg_id not in context.seen_writes_by_device[device_id]:
                        context.seen_writes_by_device[device_id][mem_reg_id] = set()
                    context.seen_writes_by_device[device_id][mem_reg_id].update(cast(ContextObject, saved_contex).seen_writes_by_device[device_id][mem_reg_id])
        return context