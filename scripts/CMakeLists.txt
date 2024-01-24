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

# create symlinks to files
set(DP_LOCAL_BIN_DIR "$ENV{HOME}/.local/bin")
if(EXISTS ${DP_LOCAL_BIN_DIR})
    message(STATUS "Creating symlink ${DP_LOCAL_BIN_DIR}/discopop_cc to ${CMAKE_CURRENT_BINARY_DIR}/CC_wrapper.sh")
    execute_process(COMMAND ln -sf ${CMAKE_CURRENT_BINARY_DIR}/CC_wrapper.sh ${DP_LOCAL_BIN_DIR}/discopop_cc)
    
    message(STATUS "Creating symlink ${DP_LOCAL_BIN_DIR}/discopop_cxx to ${CMAKE_CURRENT_BINARY_DIR}/CXX_wrapper.sh")
    execute_process(COMMAND ln -sf ${CMAKE_CURRENT_BINARY_DIR}/CXX_wrapper.sh ${DP_LOCAL_BIN_DIR}/discopop_cxx)
    
    message(STATUS "Creating symlink ${DP_LOCAL_BIN_DIR}/discopop_cmake to ${CMAKE_CURRENT_BINARY_DIR}/CMAKE_wrapper.sh")
    execute_process(COMMAND ln -sf ${CMAKE_CURRENT_BINARY_DIR}/CMAKE_wrapper.sh ${DP_LOCAL_BIN_DIR}/discopop_cmake)
else()
    message(WARNING "Creation of symlinks discopop_cc to ${CMAKE_CURRENT_BINARY_DIR}/CC_wrapper.sh not possible. Please create it manually.")
    message(WARNING "Creation of symlinks discopop_cxx to ${CMAKE_CURRENT_BINARY_DIR}/CXX_wrapper.sh not possible. Please create it manually.")
    message(WARNING "Creation of symlinks discopop_cmake to ${CMAKE_CURRENT_BINARY_DIR}/CMAKE_wrapper.sh not possible. Please create it manually.")
endif()
