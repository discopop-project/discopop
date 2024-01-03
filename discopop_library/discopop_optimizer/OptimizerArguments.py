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
    interactive: bool
    exhaustive: bool
    doall_microbench_file: str
    reduction_microbench_file: str
    allow_nested_parallelism: bool
    plot: bool
    system_configuration_path: str
    check_called_function_for_nested_parallelism: bool

    def __post_init__(self):
        self.__validate()

    def __validate(self):
        """Validate the arguments passed to the discopop_optimizer, e.g check if given files exist"""
        if self.doall_microbench_file is not "None":
            if not os.path.isfile(self.doall_microbench_file):
                raise FileNotFoundError(f"Microbenchmark file not found: {self.doall_microbench_file}")
        if self.reduction_microbench_file is not "None":
            if not os.path.isfile(self.reduction_microbench_file):
                raise FileNotFoundError(f"Microbenchmark file not found: {self.reduction_microbench_file}")
        pass
