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
HSD_SCRIPTS=${HSD_BUILD}/scripts

# original arguments: "$@"
#echo "WRAPPED CMAKE BUILD..."
#echo "ARGS: ${@}"

# execute cmake using CC, CXX and LINKER wrappers
# re-define structure of the link-executable to include the updated linker
cmake \
  -DCMAKE_C_COMPILER_WORKS=1 \
  -DCMAKE_CXX_COMPILER_WORKS=1 \
  -DCMAKE_CXX_COMPILER=${HSD_SCRIPTS}/CXX_wrapper.sh \
  -DCMAKE_C_COMPILER=${HSD_SCRIPTS}/CC_wrapper.sh \
  -DCMAKE_LINKER=${HSD_SCRIPTS}/LINKER_wrapper.sh \
  -DCMAKE_CXX_LINK_EXECUTABLE="<CMAKE_LINKER> <FLAGS> <CMAKE_CXX_LINK_FLAGS> <LINK_FLAGS> <OBJECTS> -o <TARGET> <LINK_LIBRARIES>" \
  -DCMAKE_C_LINK_EXECUTABLE="<CMAKE_LINKER> <FLAGS> <CMAKE_C_LINK_FLAGS> <LINK_FLAGS> <OBJECTS> -o <TARGET> <LINK_LIBRARIES>" \
  "$@"
