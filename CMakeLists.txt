# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

cmake_minimum_required(VERSION 3.4.3)
project(DiscoPoP)

set(CMAKE_CXX_STANDARD 14)


if(NOT ${LLVM_DIST_PATH} STREQUAL "")
    # manually specify path to LLVM installation, used for builds from source
    if(NOT EXISTS ${LLVM_DIST_PATH})
        message(FATAL_ERROR "The specified LLVM_DIST_PATH=${LLVM_DIST_PATH} does not exist!")
    endif()
    set(LLVM_DIR ${LLVM_DIST_PATH}/lib/cmake/llvm)
    find_package(LLVM PATHS ${LLVM_DIR})
elseif(NOT ${USE_LLVM_VERSION} STREQUAL "")
    # search for specified llvm version
    find_package(LLVM ${USE_LLVM_VERSION} REQUIRED)
else()
    # search for llvm 11 installations
    find_package(LLVM 11.0 CONFIG QUIET)
    if(NOT LLVM_FOUND)
        find_package(LLVM 11.1 CONFIG QUIET)
        if(NOT LLVM_FOUND)
            message(FATAL_ERROR "No supported LLVM Version found. Version 11.0 or 11.1 required!")
        endif()
    endif()
endif()

message(STATUS "Using LLVM version ${LLVM_PACKAGE_VERSION}")
message(STATUS "Using LLVMConfig.cmake in: ${LLVM_DIR}")
list(APPEND CMAKE_MODULE_PATH ${LLVM_CMAKE_DIR})

set(LLVM_RUNTIME_OUTPUT_INTDIR ${CMAKE_BINARY_DIR}/${CMAKE_CFG_INTDIR}/bin)
set(LLVM_LIBRARY_OUTPUT_INTDIR ${CMAKE_BINARY_DIR}/${CMAKE_CFG_INTDIR}/libi)

list(APPEND CMAKE_MODULE_PATH "${LLVM_CMAKE_DIR}")
include(HandleLLVMOptions)
include(AddLLVM)

add_definitions(${LLVM_DEFINITIONS})
include_directories(${LLVM_INCLUDE_DIRS})

add_subdirectory(DiscoPoP)

add_subdirectory(rtlib)

add_subdirectory(scripts)

# install DiscoPoP python modules
find_package(Python3 REQUIRED COMPONENTS Interpreter)
# check if python modules are installed already
message(STATUS "Installing DiscoPoP python modules")
execute_process(
        COMMAND ${Python3_EXECUTABLE} -m pip install ${DiscoPoP_SOURCE_DIR}
        RESULT_VARIABLE DP_INSTALLATION_EXIT_CODE
        OUTPUT_VARIABLE DP_INSTALLATION_OUTPUT
        COMMAND_ECHO STDOUT
)
# check if installation of DiscoPoP Modules was successful
if(${DP_INSTALLATION_EXIT_CODE})
    message(STATUS "${DP_INSTALLATION_CMD_ECHO}")
    message(FATAL_ERROR "${DP_INSTALLATION_OUTPUT}")
endif()

# save build configuration to build/build_config.txt
file(TOUCH "${DiscoPoP_BINARY_DIR}/build_config.txt")
file(APPEND "${DiscoPoP_BINARY_DIR}/build_config.txt" "DP_BUILD=${DiscoPoP_BINARY_DIR}\n")
file(APPEND "${DiscoPoP_BINARY_DIR}/build_config.txt" "DP_SOURCE=${DiscoPoP_SOURCE_DIR}\n")
file(APPEND "${DiscoPoP_BINARY_DIR}/build_config.txt" "LLVM_BIN_DIR=${LLVM_TOOLS_BINARY_DIR}\n")
file(APPEND "${DiscoPoP_BINARY_DIR}/build_config.txt" "PYTHON_EXECUTABLE=${Python3_EXECUTABLE}\n")