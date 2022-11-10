---
layout: default
title: Setup
nav_order: 2
---

# Setup
## Pre-requisites
Before doing anything, you need a basic development setup. We have tested DiscoPoP on Ubuntu, and the prerequisite packages can be installed using the following command:

	sudo apt-get install git build-essential cmake

Additionally, you need to install LLVM on your system. Currently, DiscoPoP only supports LLVM versions between 8.0 and 11.1. Due to API changes, which lead to compilation failures, it does not support lower and higher versions. Please follow the [installation tutorial](https://llvm.org/docs/GettingStarted.html), or install LLVM 11 via a package manager as shown in the following snippet, if you have not installed LLVM yet.

    sudo apt-get install libclang-11-dev clang-11 llvm-11

## DiscoPoP profiler installation
First, clone the source code into a designated folder. 

	git clone https://github.com/discopop-project/discopop.git

Then, create a build directory, for example inside the source folder:

	cd discopop
	mkdir build; cd build;

Next, configure the project using CMake. 
If you have installed LLVM <b>from the source</b> please specify the preferred LLVM installation path for DiscoPoP. This can be done using the `-DLLVM_DIST_PATH=<PATH_TO_LLVM_BUILD_FOLDER>` CMake variable.

	cmake -DLLVM_DIST_PATH=<PATH_TO_LLVM_BUILD_FOLDER> ..

If you have installed LLVM <b>using the package manager</b>, specifying this variable should not be necessary. In this case, please just use:

	cmake ..

Once the configuration process is successfully finished, compile the DiscoPoP libraries using `make`. All created shared objects will be stored in the build directory and can be found inside a folder named `libi/`.

	make