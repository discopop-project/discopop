# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

install: venv
# install discopop_explorer, library and profiler
	venv/bin/pip install -e ./explorer ./library ./GUI
	venv/bin/pip install ./profiler
	venv/bin/pip install -e .

install_gui: venv
	venv/bin/pip install -e ./GUI

venv:
	python3 -m venv venv

uninstall:
	venv/bin/pip uninstall . ./profiler ./explorer ./library ./GUI

veryclean:
	rm -rf venv
	rm -rf build
