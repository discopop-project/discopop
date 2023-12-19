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
class PatchGeneratorArguments(object):
    """Container Class for the arguments passed to the discopop_patch_generator"""

    verbose: bool
    discopop_build_path: str
    CC: str
    CXX: str
    from_configuration_file: str
    add_from_json: str

    def __post_init__(self):
        self.__validate()

    def __validate(self):
        """Validate the arguments passed to the discopop_explorer, e.g check if given files exist"""
        if self.verbose:
            print("Configuration:")
            print("\tDP BUILD PATH: ", self.discopop_build_path)
            print("\tCC: ", self.CC)
            print("\tCXX: ", self.CXX)
        # check if build directory exists
        if not os.path.exists(self.discopop_build_path):
            raise FileNotFoundError(self.discopop_build_path)
        # check if CC and CXX exist
        if not os.path.exists(self.CC):
            raise FileNotFoundError(self.CC)
        if not os.path.exists(self.CXX):
            raise FileNotFoundError(self.CXX)

        pass
