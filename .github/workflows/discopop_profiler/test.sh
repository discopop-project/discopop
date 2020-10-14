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

tests="cu dependence reduction"

function test_cu {
  # CU Generation
  python -m discopop_cpp -v --CUGeneration -c "$1" || return 1
}

function test_dependence {
  # Dependence Profiling
  python -m discopop_cpp -v --DPInstrumentation -c "$1" -o out.o || return 1
  python -m discopop_cpp -v --DPInstrumentation out.o || return 1
  ./a.out || return 1
}

function test_reduction {
  # Identifying Reduction Operations
  python -m discopop_cpp -v --DPReduction -c "$1" -o out.o || return 1
  python -m discopop_cpp -v --DPReduction out.o || return 1
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
