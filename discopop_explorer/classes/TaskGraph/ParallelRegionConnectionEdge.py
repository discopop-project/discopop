# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
from discopop_explorer.classes.TaskGraph.Edge import Edge


class ParallelRegionConnectionEdge(Edge):
    # connects entry of a parallel region to the respective exit to allow skipping the search
    def __init__(self) -> None:
        super().__init__()
