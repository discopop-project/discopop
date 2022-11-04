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

tests="discopopPass reductionPass"

function test_discopopPass {
  cp ${DISCOPOP_SRC}/scripts/dp-fmap .
  ./dp-fmap
  clang++ -g -c -O0 -S -emit-llvm -fno-discard-value-names "$1" -o out.ll || return 1
  opt-11 -S -load=${DISCOPOP_INSTALL}/libi/LLVMDiscoPoP.so --DiscoPoP out.ll -o out_dp.ll --fm-path FileMapping.txt || return 1
  clang++ out_dp.ll -o out_prof -L${DISCOPOP_INSTALL}/rtlib -lDiscoPoP_RT -lpthread || return 1
  ./out_prof || return 1
}

function test_reductionPass {
  # Identifying Reduction Operations
  python -m discopop_profiler -v --DPReduction -c "$1" -o out.o || return 1
  python -m discopop_profiler -v --DPReduction out.o || return 1
  ./a.out || return 1
}

exit_code=0
for target in ./test/*/; do
  pushd $target
  for test in ${tests}; do
    echo "###"
    echo "### ${target} ${test}"
    echo "###"
    if ! test_$test "$(ls ./*.c ./*.cpp 2>/dev/null)"; then
      exit_code=1
      echo -e "\e[31m### ${target} ${test} failed.\e[0m"
    fi
  done
  popd
done

exit $exit_code
