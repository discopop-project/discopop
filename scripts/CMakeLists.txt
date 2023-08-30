# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

# copy scripts to build folder
message(STATUS "Copying scripts to: ${CMAKE_CURRENT_BINARY_DIR}")
configure_file(dp-fmap dp-fmap COPYONLY)
configure_file(runDiscoPoP runDiscoPoP COPYONLY)
configure_file(CC_wrapper.sh CC_wrapper.sh COPYONLY)
configure_file(CXX_wrapper.sh CXX_wrapper.sh COPYONLY)
configure_file(LINKER_wrapper.sh LINKER_wrapper.sh COPYONLY)
configure_file(CMAKE_wrapper.sh CMAKE_wrapper.sh COPYONLY)
configure_file(MPI_CC_wrapper.sh MPI_CC_wrapper.sh COPYONLY)
configure_file(MPI_CXX_wrapper.sh MPI_CXX_wrapper.sh COPYONLY)
configure_file(MPI_LINKER_wrapper.sh MPI_LINKER_wrapper.sh COPYONLY)
