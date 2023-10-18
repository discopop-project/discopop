# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.


# NOTE: This example requires an in-source build.
#       The build folder needs to be located inside the original `discopop` directory.

# prepare environment
EXAMPLE_DIR=$(pwd)
DISCOPOP_BUILD_DIR=$(pwd)/../build
rm -rf build
mkdir build

# Use DiscoPoP's compiler wrappers to build the cmake example
# CMAKE_wrapper.sh acts as a substitute for the `cmake` command
cd build
${DISCOPOP_BUILD_DIR}/scripts/CMAKE_wrapper.sh ..
make

# execute the example
./cmake_example
# Now, profiling results (e.g. dynamically identified data dependencies) are available
# The created output can be used for pattern detection using the discopop_explorer.
# Please refer to the Wiki for detailed information and instructions.
