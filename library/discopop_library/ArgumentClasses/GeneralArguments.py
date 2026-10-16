# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
from dataclasses import dataclass


@dataclass
class GeneralArguments(object):
    """Container Class for the arguments passed to tools in the DiscoPoP framework"""

    log_level: str
    write_log: bool
