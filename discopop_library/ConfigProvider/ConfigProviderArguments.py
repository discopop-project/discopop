# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
from dataclasses import dataclass


@dataclass
class ConfigProviderArguments(object):
    """Container Class for the arguments passed to the discopop_config_provider"""

    return_dp_build_dir: bool
    return_dp_source_dir: bool
    return_llvm_bin_dir: bool
    return_full_config: bool
    return_version_string: bool

    def __post_init__(self):
        self.__validate()

    def __validate(self):
        pass

    def __str__(self):
        return str(self.__dict__)
