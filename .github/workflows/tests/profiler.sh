#!/usr/bin/env bash

# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

cd "$(dirname "$0")/../../.." || exit 1

DISCOPOP_SRC=$(pwd)
DISCOPOP_INSTALL="$(pwd)/build"

export PYTHONPATH=${DISCOPOP_SRC}
export DISCOPOP_INSTALL

TARGET_NAME=$1
PASS_NAME=$2

function test_discopopPass {
   ${DISCOPOP_INSTALL}/scripts/CXX_wrapper.sh "$1" -o out_prof


#  cp ${DISCOPOP_SRC}/scripts/dp-fmap .
#  ./dp-fmap
#  clang++ -g -c -O0 -S -emit-llvm -fno-discard-value-names "$1" -o out.ll || return 1
#  opt-11 -S -load=${DISCOPOP_INSTALL}/libi/LLVMDiscoPoP.so --DiscoPoP out.ll -o out_dp.ll || return 1
#  clang++ out_dp.ll -o out_prof -L${DISCOPOP_INSTALL}/rtlib -lDiscoPoP_RT -lpthread || return 1
  ./out_prof || return 1
}

CUR_DIR=$PWD

cd ./test/${TARGET_NAME}

exit_code=0

echo "###"
echo "### ${TARGET_NAME} ${PASS_NAME}"
echo "###"
if ! test_${PASS_NAME} "$(ls ./*.c ./*.cpp 2>/dev/null)"; then
  exit_code=1
  echo -e "\e[31m### ${TARGET_NAME} ${PASS_NAME} failed.\e[0m"
fi

cd ${CUR_DIR}

exit $exit_code
