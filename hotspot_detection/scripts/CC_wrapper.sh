#!/bin/bash

# This script is based on a script from the discopop project
# https://github.com/discopop-project/discopop

SCRIPT_PATH="$(readlink -fm "$0")"
LIBS_DIR="$(dirname ${SCRIPT_PATH})"

LLVM_CLANG=""
LLVM_CLANGPP=""
for _v in 22 21 20 19; do
    if command -v clang-$_v &> /dev/null; then
        LLVM_CLANG=$(which clang-$_v)
        LLVM_CLANGPP=$(which clang++-$_v)
        break
    fi
done
if [ -z "$LLVM_CLANG" ]; then
    echo "ERROR: No supported clang version (19-22) found in PATH"
    exit 1
fi

${LLVM_CLANG} "$@" -g -fno-discard-value-names -O0 -Xclang -load -Xclang ${LIBS_DIR}/LLVMHotspotDetection.so -Xclang -fpass-plugin=${LIBS_DIR}/LLVMHotspotDetection.so -Xlinker -L${LIBS_DIR} -Xlinker -lHotspotDetection_RT -Xlinker -lpthread -Xlinker -v
