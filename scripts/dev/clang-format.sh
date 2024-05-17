#!/usr/bin/env bash

# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License. See the LICENSE file in the package base
# directory for details.

# This script executes clang-format on all C/C++ files in the project

# Usage: ./clang-format.sh

# change directory to discopop
cd ../..

# loop over all C/C++ source and header files in the project
C_CPP_FILES=$(find . -name *.c -or -name *.cpp -or -name *.h -or -name *.hpp)
for file in $C_CPP_FILES; do
    # execute clang-format for each file

    # ignore third-party libraries
    if [[ "$file" == "./third_party/"* ]]; then
      echo "Skipping third-party file: $file"
      continue
    fi

    # ignore build folder
    if [[ "$file" == "./build/"* ]]; then
      echo "Skipping build file: $file"
      continue
    fi

    clang-format $file -i --verbose
done