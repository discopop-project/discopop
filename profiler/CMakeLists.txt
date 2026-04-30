# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

cmake_minimum_required(VERSION 3.28.0)
project(DiscoPopProfiler)

set(CMAKE_CXX_STANDARD 17)

if (POLICY CMP0077)
	cmake_policy(SET CMP0077 NEW)
endif()

# Check for clang-19
find_program(CLANG_19_EXECUTABLE NAMES clang-19)
if(NOT CLANG_19_EXECUTABLE)
	message(FATAL_ERROR "clang-19 is required but was not found. Please install clang-19 before building the DiscoPoP profiler.")
endif()
message(STATUS "Found clang-19: ${CLANG_19_EXECUTABLE}")

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
	# search for llvm 19 installations
	find_package(LLVM 19.0 CONFIG QUIET)
	if(NOT LLVM_FOUND)
		find_package(LLVM 19.1 CONFIG QUIET)
		if(NOT LLVM_FOUND)
			message(FATAL_ERROR "\
No supported LLVM Version found. \
Version 19.0 or 19.1 required! \
If a supported LLVM Version is installed, consider specifying the -DLLVM_DIST_PATH flag. \
For more information, please refer to https://discopop-project.github.io/discopop/setup/discopop. \
")
		endif()
	endif()
endif()

find_package(Boost REQUIRED)

message(STATUS "Using LLVM version ${LLVM_PACKAGE_VERSION}")
message(STATUS "Using LLVMConfig.cmake in: ${LLVM_DIR}")
list(APPEND CMAKE_MODULE_PATH ${LLVM_CMAKE_DIR})

set(LLVM_RUNTIME_OUTPUT_INTDIR ${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_CFG_INTDIR}/bin)
set(LLVM_LIBRARY_OUTPUT_INTDIR ${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_CFG_INTDIR}/libi)

list(APPEND CMAKE_MODULE_PATH "${LLVM_CMAKE_DIR}")
include(HandleLLVMOptions)
include(AddLLVM)

add_definitions(${LLVM_DEFINITIONS})
include_directories(${LLVM_INCLUDE_DIRS})


add_subdirectory(DiscoPoP)

add_subdirectory(rtlib)

add_subdirectory(scripts)
