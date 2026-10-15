#!/usr/bin/env bash

# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

# Checks the profiler's C++ code (profiler/DiscoPoP, profiler/rtlib, profiler/share) against the
# Google C++ Style Guide: clang-format (profiler/.clang-format), cpplint (profiler/CPPLINT.cfg) and
# clang-tidy (profiler/.clang-tidy). Run it from anywhere in the repository.
#
# usage: scripts/dev/check_cpp_style.sh [build dir]
#   [build dir]  default: build_tests, configured as for the unit tests; clang-tidy takes the compile
#                commands of its compile_commands.json
#
# The tools are pinned in requirements-dev.txt: venv/bin/pip install -r requirements-dev.txt
# Exits with 1 if one of them reports a finding.

set -uo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
BUILD_DIR="${1:-${REPO_ROOT}/build_tests}"
BIN="${REPO_ROOT}/venv/bin"
cd "${REPO_ROOT}"

mapfile -t FILES < <(git ls-files 'profiler/DiscoPoP/*' 'profiler/rtlib/*' 'profiler/share/*' \
    | grep -E '\.(c|cpp|h|hpp)$')
FAILED=""

echo "== clang-format"
"${BIN}/clang-format" --dry-run --Werror "${FILES[@]}" || FAILED="${FAILED} clang-format"

echo "== cpplint"
"${BIN}/cpplint" --quiet "${FILES[@]}" || FAILED="${FAILED} cpplint"

echo "== clang-tidy"
if [ ! -f "${BUILD_DIR}/compile_commands.json" ]; then
  echo "missing ${BUILD_DIR}/compile_commands.json, configure the build directory first"
  FAILED="${FAILED} clang-tidy"
else
  # LLVM's CMake adds -fno-lifetime-dse for GCC, which clang rejects (see .clangd)
  DB_DIR="$(mktemp -d)"
  trap 'rm -rf "${DB_DIR}"' EXIT
  sed 's/ -fno-lifetime-dse//g' "${BUILD_DIR}/compile_commands.json" > "${DB_DIR}/compile_commands.json"
  # the translation units of the pass and the runtime; their headers are checked through them
  "${BIN}/run-clang-tidy.py" -quiet -warnings-as-errors="*" -clang-tidy-binary "${BIN}/clang-tidy" \
      -config-file "${REPO_ROOT}/profiler/.clang-tidy" -p "${DB_DIR}" \
      -j "$(nproc)" "${REPO_ROOT}/profiler/(DiscoPoP|rtlib|share)/.*\.(c|cpp)$" \
      || FAILED="${FAILED} clang-tidy"
fi

if [ -n "${FAILED}" ]; then
  echo "FAILED:${FAILED}"
  exit 1
fi
echo "OK"
