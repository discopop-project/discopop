<!-- 
 /*
 * This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
 *
 * Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
 *
 * This software may be modified and distributed under the terms of
 * the 3-Clause BSD License. See the LICENSE file in the package base
 * directory for details.
 *
 */ 
 -->

 ---
layout: default
title: Setup
nav_order: 2
---

## Getting started
### Pre-requisites
Before doing anything, you need a basic development setup. We have tested DiscoPoP on Ubuntu, and the prerequisite packages should be installed using the following command:

	sudo apt-get install git build-essential cmake

Additionally, you need to install LLVM on your system. Currently, DiscoPoP only supports LLVM versions between 8.0 and 11.1. Due to API changes, which lead to compilation failures, it does not support lower and higher versions. Please follow the [installation tutorial](https://llvm.org/docs/GettingStarted.html), or install LLVM 11 via a package manager as shown in the following snippet, if you have not installed LLVM yet.

    apt-get install libclang-11-dev clang-11 llvm-11

### DiscoPoP profiler installation
First, clone the source code into the designated folder. Then, create a build directory:

	mkdir build; cd build;

Next, configure the project using CMake. The preferred LLVM installation path for DiscoPoP can be set using the -DLLVM_DIST_PATH=<PATH_TO_LLVM_BUILD_FOLDER> CMake variable.

	cmake -DLLVM_DIST_PATH=<PATH_TO_LLVM_BUILD_FOLDER> ..

Once the configuration process is successfully finished, run `make` to compile and obtain the DiscoPoP libraries. All the shared objects will be stored in the build directory under a folder named as `libi/`.