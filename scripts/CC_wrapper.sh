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
DP_BUILD_LLVM_BIN_DIR="$(cat ${DP_BUILD}/build_config.txt | grep -oP "(?<=LLVM_BIN_DIR=).*")"
DP_SCRIPTS=${DP_BUILD}/scripts
LLVM_CLANG=$DP_BUILD_LLVM_BIN_DIR/clang
LLVM_CLANGPP=$DP_BUILD_LLVM_BIN_DIR/clang++

# original arguments: "$@"
echo "WRAPPED CC COMPILE..."
echo "ARGS: ${@}"
echo "DP_FM_PATH: ${DP_FM_PATH}"

# check if environment is prepared
if [ -z ${DP_FM_PATH} ]; then
  echo "ERROR: DP_FM_PATH unspecified!"
  echo "\tGenerate a FileMapping.txt file and create an environment Variable which points to this file."
  exit 1
fi

echo "${LLVM_CLANG} -g -c -O0 -S -emit-llvm -fno-discard-value-names ${@} -Xclang -load -Xclang ${DP_BUILD}/libi/LLVMDiscoPoP.so -DiscoPoP -mllvm --fm-path -mllvm ${DP_FM_PATH}"
#clang-11 -g -c -O0 -S -emit-llvm -fno-discard-value-names "$@" -Xclang -load -Xclang ${DP_BUILD}/libi/LLVMDiscoPoP.so -DiscoPoP -mllvm --fm-path -mllvm ${DP_FM_PATH}
${LLVM_CLANG} "$@" -g -c -O0 -fno-discard-value-names -Xclang -load -Xclang ${DP_BUILD}/libi/LLVMDiscoPoP.so -DiscoPoP -mllvm --fm-path -mllvm ${DP_FM_PATH} -fPIC

# WARNING: OUTPUT IS A .ll FILE, ENDING IS .o
