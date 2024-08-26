#!/bin/bash

# This script is based on a script from the discopop project
# https://github.com/discopop-project/discopop

SCRIPT_PATH="$(readlink -fm "$0")"

# ensure that copy of script in build folder is invoked instead of the "original"
if [[ "${SCRIPT_PATH}" == *"Hotspot-Detection/scripts/"* ]]; then
  echo "ERROR: Invoked script directly from source folder:"
  echo "    ${SCRIPT_PATH}"
  echo "Use the copy located in the Hotspot-Detection build folder instead."
  echo ""
  exit 1
fi

# SETTINGS
HSD_BUILD="$(dirname "$(dirname ${SCRIPT_PATH})")"
HSD_BUILD_LLVM_BIN_DIR="$(cat ${HSD_BUILD}/build_config.txt | grep -oP "(?<=LLVM_BIN_DIR=).*")"
HSD_SCRIPTS=${HSD_BUILD}/scripts
LLVM_CLANG=$HSD_BUILD_LLVM_BIN_DIR/clang
LLVM_CLANGPP=$HSD_BUILD_LLVM_BIN_DIR/clang++


# original arguments: "$@"
#echo "WRAPPED LINKING...."
#echo "ARGS: $@"
#
#echo "${LLVM_CLANGPP} ${@} -L${HSD_BUILD}/rtlib -lHotspotDetection_RT -lpthread -v"

${LLVM_CLANGPP} "$@" -L${HSD_BUILD}/rtlib -lHotspotDetection_RT -lpthread -fPIC -v
