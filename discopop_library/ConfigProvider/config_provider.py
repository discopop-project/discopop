# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

from discopop_library.ConfigProvider.ConfigProviderArguments import ConfigProviderArguments
from discopop_library.ConfigProvider.assets import build_config # DP_BUILD, DP_SOURCE, LLVM_BIN_DIR  # type: ignore
from discopop_library.global_data.version.utils import get_version


def run(arguments: ConfigProviderArguments) -> str:
    """Returns the contents of the written build_config.txt"""

    if arguments.return_dp_build_dir:
        return build_config.DP_BUILD  # type: ignore
    elif arguments.return_dp_source_dir:
        return build_config.DP_SOURCE  # type: ignore
    elif arguments.return_llvm_bin_dir:
        return build_config.LLVM_BIN_DIR  # type: ignore
    elif arguments.return_full_config:
        ret_str = ""
        for name in [n for n in build_config.__dict__ if not n.startswith("_")]:
            if len(ret_str) != 0:
                ret_str += "\n"
            ret_str += name +": " + build_config.__dict__[name]
        return ret_str
    elif arguments.return_version_string:
        return get_version()
    else:
        raise ValueError("No valid operation for execution configuration: \n" + str(arguments))
