# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

all: my_exe

my_exe:
	$(CXX) -o my_exe example.cpp
	
clean:
	find . -type f -not -name 'example.cpp' -not -name 'Makefile' -delete