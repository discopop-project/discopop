# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import warnings
from discopop_explorer.aliases.LineID import LineID


def get_clang_interleave_factor(loop_position: LineID) -> int:
    warnings.warn("STUB: get_clang_interleave_factor not implemented!")
    return 1337
