#!/bin/bash

# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License. See the LICENSE file in the package base
# directory for details.

SCRIPT_PATH="$(readlink -fm "$0")"

# ensure that copy of script in build folder is invoked instead of the "original"
if [[ "${SCRIPT_PATH}" == *"discopop/scripts/"* ]]; then
  echo "ERROR: Invoked script directly from source folder:"
  echo "    ${SCRIPT_PATH}"
  echo "Use the copy located in the DiscoPoP build folder instead."
  echo ""
  exit 1
fi

# SETTINGS
DP_BUILD="$(dirname "$(dirname ${SCRIPT_PATH})")"
DP_SCRIPTS=${DP_BUILD}/scripts


# original arguments: "$@"
echo "WRAPPED LINKING...."
echo "ARGS: $@"

echo "clang++ ${@} -L${DP_BUILD}/rtlib -lDiscoPoP_RT -lpthread -v"

#clang++ --language=ir "$@" -L${DP_BUILD}/rtlib -lDiscoPoP_RT -lpthread -v
clang++ "$@" -L${DP_BUILD}/rtlib -lDiscoPoP_RT -lpthread -fPIC -v