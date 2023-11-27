# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
import os.path
from dataclasses import dataclass


@dataclass
class OptimizerArguments(object):
    """Container Class for the arguments passed to the discopop_optimizer"""

    verbose: bool

    def __post_init__(self):
        self.__validate()

    def __validate(self):
        """Validate the arguments passed to the discopop_optimizer, e.g check if given files exist"""
        pass
