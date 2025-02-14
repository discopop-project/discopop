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
    # TODO: switch loop_position to loop text + Path to .discopop-folder to extract File paths from FileMapping.txt (20.02.)
    # TODO: define + implement API for pre-trained model (@20.02 if possible)

    #    API:
    #    -> path to .discopop folder
    #    -> loop file id
    #    -> loop start line
    #    -> loop end line
    #    -> loop source code

    return 1337
