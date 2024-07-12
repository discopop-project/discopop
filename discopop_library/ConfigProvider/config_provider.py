# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import os
from pathlib import Path
from discopop_library.ConfigProvider.ConfigProviderArguments import ConfigProviderArguments
from discopop_library.ConfigProvider.assets.build_config import DP_BUILD, DP_SOURCE, LLVM_BIN_DIR
from discopop_library.global_data.version.utils import get_version


def run(arguments: ConfigProviderArguments) -> str:
    """Returns the contents of the written build_config.txt"""

    if arguments.return_dp_build_dir:
        return DP_BUILD
    elif arguments.return_dp_source_dir:
        return DP_SOURCE
    elif arguments.return_llvm_bin_dir:
        return LLVM_BIN_DIR
    elif arguments.return_full_config:
        ret_str = ""
        assets_path = os.path.join(Path(__file__).parent.absolute(), "assets", "build_config.py")
        with open(assets_path, "r") as f:
            for line in f.readlines():
                ret_str += line
        # remove trailing \n
        if ret_str[-1] == "\n":
            ret_str = ret_str[:-1]
        return ret_str
    elif arguments.return_version_string:
        return get_version()
    else:
        raise ValueError("No valid operation for execution configuration: \n" + str(arguments))
