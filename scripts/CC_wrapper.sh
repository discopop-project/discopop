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
echo "WRAPPED CC COMPILE..."
echo "ARGS: ${@}"
echo "DP_FM_PATH: ${DP_FM_PATH}"

# check if environment is prepared
if [ -z ${DP_FM_PATH} ]; then
  echo "ERROR: DP_FM_PATH unspecified!"
  echo "\tGenerate a FileMapping.txt file and create an environment Variable which points to this file."
  exit 1
fi

echo "clang-11 -g -c -O0 -S -emit-llvm -fno-discard-value-names ${@} -Xclang -load -Xclang ${DP_BUILD}/libi/LLVMDiscoPoP.so -DiscoPoP -mllvm --fm-path -mllvm ${DP_FM_PATH}"
#clang-11 -g -c -O0 -S -emit-llvm -fno-discard-value-names "$@" -Xclang -load -Xclang ${DP_BUILD}/libi/LLVMDiscoPoP.so -DiscoPoP -mllvm --fm-path -mllvm ${DP_FM_PATH}
clang-11 "$@" -g -c -O0 -fno-discard-value-names -Xclang -load -Xclang ${DP_BUILD}/libi/LLVMDiscoPoP.so -DiscoPoP -mllvm --fm-path -mllvm ${DP_FM_PATH} -fPIC

# WARNING: OUTPUT IS A .ll FILE, ENDING IS .o
