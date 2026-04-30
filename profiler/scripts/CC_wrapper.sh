#!/bin/bash

# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License. See the LICENSE file in the package base
# directory for details.

SCRIPT_PATH="$(readlink -fm "$0")"

# ensure that copy of script in build folder is invoked instead of the "original"
if [[ "${SCRIPT_PATH}" == *"discopop/scripts/"* ]]; then
  echo "ERROR: Invoked script directly from source folder:"
  echo "    ${SCRIPT_PATH}"
  echo "Use the copy located in the DiscoPoP build folder instead."
  echo ""
  exit 1
fi

# SETTINGS
DP_BUILD="$(dirname "$(dirname ${SCRIPT_PATH})")"
LLVM_CLANG=$(which clang-19)
LLVM_CLANGPP=$(which clang++-19)

# original arguments: "$@"
#echo "WRAPPED CC COMPILE..."
#echo "ARGS: ${@}"

# script will be located alongside LLVMDiscoPoP.so and libDiscoPoP_RT.a in the python venv/lib/../discopop-profiler.libs
PARENT_PATH=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
${LLVM_CLANG} "$@" -g -O0 -fno-discard-value-names -Xclang -load -Xclang ${PARENT_PATH}/LLVMDiscoPoP.so -Xclang -fpass-plugin=${PARENT_PATH}/LLVMDiscoPoP.so -fPIC -Xlinker -L${PARENT_PATH} -Xlinker -lDiscoPoP_RT -Xlinker -lpthread -Xlinker -v -Xlinker -lstdc++

# WARNING: OUTPUT IS A .ll FILE, ENDING IS .o
