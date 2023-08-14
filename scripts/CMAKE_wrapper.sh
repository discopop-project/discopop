#!/bin/bash

# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License. See the LICENSE file in the package base
# directory for details.

# SETTINGS
DP_BUILD="$(dirname "$(dirname "$(readlink -fm "$0")")")"
DP_SCRIPTS=${DP_BUILD}/scripts

# original arguments: "$@"
echo "WRAPPED CMAKE BUILD..."
echo "ARGS: ${@}"

# execute cmake using CC, CXX and LINKER wrappers
# re-define structure of the link-executable to include the updated linker
cmake \
  -DCMAKE_C_COMPILER_WORKS=1 \
  -DCMAKE_CXX_COMPILER_WORKS=1 \
  -DCMAKE_CXX_COMPILER=${DP_SCRIPTS}/CXX_wrapper.sh \
  -DCMAKE_C_COMPILER=${DP_SCRIPTS}/CC_wrapper.sh \
  -DCMAKE_LINKER=${DP_SCRIPTS}/LINKER_wrapper.sh \
  -DCMAKE_CXX_LINK_EXECUTABLE="<CMAKE_LINKER> <FLAGS> <CMAKE_CXX_LINK_FLAGS> <LINK_FLAGS> <OBJECTS> -o <TARGET> <LINK_LIBRARIES>" \
  "$@"

