# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
from discopop_library.OptimizationGraph.classes.edges.GenericEdge import GenericEdge
from discopop_library.OptimizationGraph.classes.edges.SuccessorEdge import SuccessorEdge


class TemporaryEdge(GenericEdge):
    pass

    def convert_to_successor_edge(self) -> SuccessorEdge:
        return SuccessorEdge()
