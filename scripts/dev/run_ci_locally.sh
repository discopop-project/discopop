#!/usr/bin/env bash
# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

set -euo pipefail

# check if act is installed
if ! [ -x "$(command -v act)" ]; then
  echo 'Error: act is not installed.' >&2
  echo 'Visit https://github.com/nektos/act for more details'
  exit 1
fi


workflow=()
hasW=false

for arg in "$@"; do
  if [[ "$arg" == "-W" ]]; then
    hasW=true
    break
  fi
done

if ! $hasW; then
  workflow=(-W .github/workflows/ci.yml)
fi

groups=""
for gid in $(id -G); do
  groups+=" --group-add $gid"
done

act "$@" \
  "${workflow[@]}" \
  -P self-hosted=catthehacker/ubuntu:act-latest \
  --container-options "--user $(id -u):$(id -g)$groups"