---
layout: default
title: Manual Setup
parebt: Manual Quickstart
nav_order: 2
---

# Manual Setup
## Pre-requisites
Before doing anything, you need a basic development setup. We have tested DiscoPoP on Ubuntu, and the prerequisite packages can be installed using the following command:

	sudo apt-get install git build-essential cmake

Additionally, you need to install LLVM on your system. Currently, DiscoPoP only supports LLVM versions between 8.0 and 11.1. Due to API changes, which lead to compilation failures, it does not support lower and higher versions. Please follow the [installation tutorial](https://llvm.org/docs/GettingStarted.html), or install LLVM 11 via a package manager as shown in the following snippet, if you have not installed LLVM yet.

    sudo apt-get install libclang-11-dev clang-11 llvm-11

If you want to make use of the [Configuration](../Tutorials/Configuration_Wizard.md) or [Execution Wizard](../Tutorials/Execution_Wizard.md) for a simplified analysis of your project, you additionally need a working installation of [gllvm](https://github.com/SRI-CSL/gllvm) and [go](https://go.dev/doc/install).

The Configuration Wizard uses Tkinter for its GUI functionality. It can be installed using

    sudo apt-get install python3-tk


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

Note: In case you want to use a specific Version of LLVM, it is possible to specify the `-DUSE_LLVM_VERSION=<version>` flag.

Note: In case your application uses PThreads, please specify `-DDP_PTHREAD_COMPATIBILITY_MODE=1`. Note, however, that this can influence the runtime of the profiling.

Once the configuration process is successfully finished, compile the DiscoPoP libraries using `make`. All created shared objects will be stored in the build directory and can be found inside a folder named `libi/`.

	make


## Installation of Python Modules
The included Python modules `discopop_explorer` and `discopop_wizard` will be installed during the `cmake` build process,
but they can also be installed using `pip` by executing the following command in the base directory of DiscoPoP:

	pip install .

Installing the modules allows the simple invocation of those via

	discopop_explorer

and

	discopop_wizard

respectively. The [manual quickstart example](Manual_Example.md) will assume this kind of installation.
However, if you do not want to install the modules, they can be invoked using:

	python3 -m discopop_explorer

and

	python3 -m discopop_wizard

respectively.
