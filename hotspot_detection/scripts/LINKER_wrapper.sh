#!/bin/bash

# This script is based on a script from the discopop project
# https://github.com/discopop-project/discopop

SCRIPT_PATH="$(readlink -fm "$0")"
LIBS_DIR="$(dirname ${SCRIPT_PATH})"

LLVM_CLANGPP=""
for _v in 22 21 20 19; do
    if command -v clang++-$_v &> /dev/null; then
        LLVM_CLANGPP=$(which clang++-$_v)
        break
    fi
done
if [ -z "$LLVM_CLANGPP" ]; then
    echo "ERROR: No supported clang version (19-22) found in PATH"
    exit 1
fi

${LLVM_CLANGPP} "$@" -L${LIBS_DIR} -lHotspotDetection_RT -lpthread -fPIC -v
