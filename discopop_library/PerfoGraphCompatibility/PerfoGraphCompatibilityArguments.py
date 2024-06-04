# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
import os.path
from dataclasses import dataclass

from discopop_library.ArgumentClasses.GeneralArguments import GeneralArguments


@dataclass
class PerforGraphCompatibilityArguments(GeneralArguments):
    """Container Class for the arguments passed to the perfograph compatibility tool"""

    llvm_ir_file: str
    dynamic_deps_file: str
    output_file: str
    force_output: bool

    def __post_init__(self):
        self.__validate()

    def __validate(self):
        """Validate the arguments passed to the discopop_explorer, e.g check if given files exist"""
        pass
        # check if input files exist
        if not os.path.exists(self.llvm_ir_file):
            raise FileNotFoundError(self.llvm_ir_file)
        if not os.path.exists(self.dynamic_deps_file):
            raise FileNotFoundError(self.dynamic_deps_file)
        # raise warning if output file exists already
        if os.path.exists(self.output_file):
            if self.force_output:
                pass
            else:
                raise FileExistsError(self.output_file)
        pass
