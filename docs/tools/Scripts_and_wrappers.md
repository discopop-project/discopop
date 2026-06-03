---
layout: default
title: Scripts and wrappers
parent: Tools
nav_order: 8
---

# Scripts and wrappers
Several scripts, utilities and compiler wrappers are located in the `discopop/build/scripts` directory.
The following sections will give a brief overview over the individual scripts and their purpose.

## Compiler wrappers
To simplify the application of DiscoPoP's static analysis and code instrumentation, we provide wrapper scripts around the `clang`(CC_wrapper.sh) and `clang++`(CXX_wrapper.sh) compilers as well as a wrapper around `cmake`(CMAKE_wrapper.sh).
These scripts can be used instead of the original versions to build the instrumented version of the sequential program.
For examples how to use these wrappers, please refer to the [examples](../examples/examples.md).

## Utilities
### dp-fmap script
This script creates a [filemapping](../data/Filemapping.md) file. However, it is not necessary anymore since the filemapping is created during the static analysis. Using the script to create a filemapping manually is still possible, although not recommended.

## Developer utilities
Developer utilities are located inside the `dev` folder.
### check-license.sh
Checks if all files in the project start with the appropriate license header.
### create-release.sh
Original utility to create or prepare an new DiscoPoP release. It is not recommended to use this script to prepare a release. Follow the steps in [how to contribute](../How_to_contribute.md) instead.
### check-commit-msg.py
This script is part of the pre-commit checks described in [how to contribute](../How_to_contribute.md).
It validates commit messages before commiting and ensures a well-structured and uniform formatting of git commit messages.
