#!/bin/bash

# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License. See the LICENSE file in the package base
# directory for details.


# this script is given a list of filenames as arguments
# it checks if the files contain the license tag
# if not, it prints an error message and exits with exit code 1
# if all files contain the license tag, it exits with exit code 0
# some files are ignored, see below

ERROR=""

for file in "$@"; do
    # ignore .git folder
    if [[ "$file" = .git/* ]]; then
        continue
    fi

    # ignore test folders
    if [[ "$file" = test/* || "$file" = */test/* ]]; then
        continue
    fi

    # ignore docs folder
    if [[ "$file" = docs/* ]]; then
        continue
    fi

    # ignore LICENSE files
    if [[ "$file" = LICENSE || "$file" = */LICENSE ]]; then
        continue
    fi

    # ignore VERSION file
    if [[ $file = */VERSION ]]; then
        continue
    fi

    # ignore _version.py file
    if [[ "$file" = */_version.py ]]; then
        continue
    fi

    # ignore __init__.py file
    if [[ "$file" = */__init__.py ]]; then
        continue
    fi

    # ignore py.typed file
    if [[ "$file" = */py.typed ]]; then
        continue
    fi

    # ignore .png file
    if [[ "$file" = *.png ]]; then
        continue
    fi

    # ignore .svg file
    if [[ "$file" = *.svg ]]; then
        continue
    fi

    # ignore .ico file
    if [[ "$file" = *.ico ]]; then
        continue
    fi

    # check for the license tag in the first 20 lines of the file

    FILE_ERROR=""
    head -n 20 ${file} | grep -q "DiscoPoP software" || FILE_ERROR="yes"
    [ -z "$FILE_ERROR" ] || ERROR="yes"
    [ -z "$FILE_ERROR" ] || echo "Missing License tag at: ${file}"
    [ -z "$FILE_ERROR" ] || continue
    head -n 20 ${file} | grep -q "Technische Universitaet Darmstadt, Germany" || FILE_ERROR="yes"
    [ -z "$FILE_ERROR" ] || ERROR="yes"
    [ -z "$FILE_ERROR" ] || echo "Missing License tag at: ${file}"
    [ -z "$FILE_ERROR" ] || continue
    head -n 20 ${file} | grep -q "3-Clause BSD License" || FILE_ERROR="yes"
    [ -z "$FILE_ERROR" ] || ERROR="yes"
    [ -z "$FILE_ERROR" ] || echo "Missing License tag at: ${file}"


done

# Report error (1), if license tags are missing
[ -z "$ERROR" ] || exit 1

# Report success (0), if license tags are present
exit 0
