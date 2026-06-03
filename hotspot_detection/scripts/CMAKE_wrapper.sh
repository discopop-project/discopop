#!/bin/bash

# This script is based on a script from the discopop project
# https://github.com/discopop-project/discopop

SCRIPT_PATH="$(readlink -fm "$0")"
LIBS_DIR="$(dirname ${SCRIPT_PATH})"

cmake \
  -DCMAKE_C_COMPILER_WORKS=1 \
  -DCMAKE_CXX_COMPILER_WORKS=1 \
  -DCMAKE_CXX_COMPILER=${LIBS_DIR}/CXX_wrapper.sh \
  -DCMAKE_C_COMPILER=${LIBS_DIR}/CC_wrapper.sh \
  -DCMAKE_LINKER=${LIBS_DIR}/LINKER_wrapper.sh \
  -DCMAKE_CXX_LINK_EXECUTABLE="<CMAKE_LINKER> <FLAGS> <CMAKE_CXX_LINK_FLAGS> <LINK_FLAGS> <OBJECTS> -o <TARGET> <LINK_LIBRARIES>" \
  -DCMAKE_C_LINK_EXECUTABLE="<CMAKE_LINKER> <FLAGS> <CMAKE_C_LINK_FLAGS> <LINK_FLAGS> <OBJECTS> -o <TARGET> <LINK_LIBRARIES>" \
  "$@"
