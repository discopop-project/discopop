# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

from typing import cast
from discopop_library.ConfigProvider.ConfigProviderArguments import ConfigProviderArguments
from discopop_library.ConfigProvider.assets.build_config import DP_BUILD, DP_SOURCE, LLVM_BIN_DIR  # type: ignore


def run(arguments: ConfigProviderArguments) -> str:
    """Returns the contents of the written build_config.txt"""

    if arguments.return_dp_build_dir:
        return cast(str, DP_BUILD)  # type: ignore
    elif arguments.return_dp_source_dir:
        return cast(str, DP_SOURCE)  # type: ignore
    elif arguments.return_llvm_bin_dir:
        return cast(str, LLVM_BIN_DIR)  # type: ignore
    else:
        raise ValueError("No valid operation for execution configuration: \n" + str(arguments))
