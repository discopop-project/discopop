# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

install: venv
# install discopop_explorer, library and profiler
	venv/bin/pip install -e . ./profiler

install_deps:
# install operating system packages required. OS dependent!
	sudo apt install libc6 python3 python3-pip python3-venv python3-tk build-essential make cmake git llvm-19-dev clang-19 libomp-19-dev libboost-all-dev

venv:
	python3 -m venv venv

uninstall:
	venv/bin/pip uninstall . ./profiler

veryclean:
	rm -rf venv
	rm -rf build
