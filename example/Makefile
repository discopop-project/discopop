# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

# make <=3.8 does not respect .DEFAULT_GOAL, so we specify a 'default' target as first target
.DEFAULT_GOAL := default
.PHONY: default
default: example

.PHONY: all
all: example solution1 solution2

example: example.cpp
	$(CXX) -o example example.cpp

solution1: solution1.cpp
	$(CXX) -o solution1 solution1.cpp -fopenmp

solution2: solution2.cpp
	$(CXX) -o solution2 solution2.cpp -fopenmp

.PHONY: help
.SILENT: help
help:
	@echo "This makefile builds the quickstart example (without any parallelization) by default.
	@echo "It is also possible to build the suggested solutions."
	@echo "Do NOT use any target other than the default (example) when analyzing this project with DiscoPoP."
	@echo "The following make targets are available:"
	@echo " example         builds the quickstart example application"
	@echo " solution1       builds the quickstart example application with both do-all patterns implemented"
	@echo " solution2		builds the quickstart example application with the geometric decomposition implemented"
	@echo " all				builds all the above executables"
	@echo " help			show this message"
	@echo " clean			remove all build and analysis artefacts from this directory. Only the provided files will survive."
	
clean:
	find . -type f -not -name 'example.cpp' -not -name 'Makefile' -not -name 'solution1.cpp' -not -name 'solution2.cpp' -delete