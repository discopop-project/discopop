# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
import warnings
from discopop_explorer.aliases.LineID import LineID
from discopop_library.Stubs.PerfoGraph.classes import PerfoGraphLoopTarget


def select_loop_target(loop_line: LineID) -> PerfoGraphLoopTarget:
    warnings.warn("STUB PerfoGraph.loopTargetSelection.select_loop_target not implemented")
    return PerfoGraphLoopTarget.OMP_FOR
