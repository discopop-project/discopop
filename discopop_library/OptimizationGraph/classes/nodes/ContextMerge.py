# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
from discopop_library.OptimizationGraph.Variables.Environment import Environment
from discopop_library.OptimizationGraph.classes.nodes.ContextNode import ContextNode


class ContextMerge(ContextNode):
    def __init__(self, node_id: int, environment: Environment):
        super().__init__(node_id, environment)

    def get_plot_label(self) -> str:
        return str(self.node_id) + "\nCTX\nmerge"
