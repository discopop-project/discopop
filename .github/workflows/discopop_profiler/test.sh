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
CXX=clang++-8

tests="dependence reduction"  # TODO: "cu" yet missing because it fails

function test_cu {
  # CU Generation
  ${CXX} -g -O0 -fno-discard-value-names -Xclang -load -Xclang "${DISCOPOP_INSTALL}"/libi/LLVMCUGeneration.so -mllvm -fm-path -mllvm ./FileMapping.txt -c "$1" || return 1
}

function test_dependence {
  # Dependence Profiling
  ${CXX} -g -O0 -fno-discard-value-names -Xclang -load -Xclang "${DISCOPOP_INSTALL}"/libi/LLVMDPInstrumentation.so -mllvm -fm-path -mllvm ./FileMapping.txt -c "$1" -o out.o || return 1
  ${CXX} out.o -L"${DISCOPOP_INSTALL}"/rtlib -lDiscoPoP_RT -lpthread || return 1
  ./a.out || return 1
}

function test_reduction {
  # Identifying Reduction Operations
  ${CXX} -g -O0 -fno-discard-value-names -Xclang -load -Xclang "${DISCOPOP_INSTALL}"/libi/LLVMDPReduction.so -mllvm -fm-path -mllvm ./FileMapping.txt -c "$1" -o out.o || return 1
  ${CXX} out.o -L"${DISCOPOP_INSTALL}"/rtlib -lDiscoPoP_RT -lpthread || return 1
  ./a.out || return 1
}

exit_code=0
for target in ./test/*/; do
  pushd $target
  ${DISCOPOP_SRC}/scripts/dp-fmap
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
