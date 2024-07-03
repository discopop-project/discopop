# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

cmake_minimum_required(VERSION 3.4.3)
project(DiscoPoP)

set(CMAKE_CXX_STANDARD 17)

if (POLICY CMP0077)
	cmake_policy(SET CMP0077 NEW)
endif()

# Print DiscoPoP version to be installed
file(READ ${CMAKE_CURRENT_LIST_DIR}/discopop_library/global_data/version/VERSION DiscoPoP_VERSION)
string(REGEX REPLACE "\n$" "" DiscoPoP_VERSION "${DiscoPoP_VERSION}")
message(STATUS "DiscoPoP version: ${DiscoPoP_VERSION}")

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
            message(FATAL_ERROR "\
No supported LLVM Version found. \
Version 11.0 or 11.1 required! \
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

add_subdirectory(test/unit_tests)

#add_subdirectory(benchmark)

##### DEPRECATED #####
# save build configuration to build/build_config.txt
file(REMOVE "${DiscoPoP_BINARY_DIR}/build_config.txt")
file(TOUCH "${DiscoPoP_BINARY_DIR}/build_config.txt")
file(APPEND "${DiscoPoP_BINARY_DIR}/build_config.txt" "DP_BUILD=${DiscoPoP_BINARY_DIR}\n")
file(APPEND "${DiscoPoP_BINARY_DIR}/build_config.txt" "DP_SOURCE=${DiscoPoP_SOURCE_DIR}\n")
file(APPEND "${DiscoPoP_BINARY_DIR}/build_config.txt" "LLVM_BIN_DIR=${LLVM_TOOLS_BINARY_DIR}\n")
file(APPEND "${DiscoPoP_BINARY_DIR}/build_config.txt" "PYTHON_EXECUTABLE=${Python3_EXECUTABLE}\n")
##### END OF DEPRECATED #####

# save build_config.py to discopop_library/ConfigProvider/assets for easy accessibility and global use
file(REMOVE "${DiscoPoP_SOURCE_DIR}/discopop_library/ConfigProvider/assets/build_config.py")
file(TOUCH "${DiscoPoP_SOURCE_DIR}/discopop_library/ConfigProvider/assets/build_config.py")
file(APPEND "${DiscoPoP_SOURCE_DIR}/discopop_library/ConfigProvider/assets/build_config.py" "DP_VERSION=\"${DiscoPoP_VERSION}\"\n")
file(APPEND "${DiscoPoP_SOURCE_DIR}/discopop_library/ConfigProvider/assets/build_config.py" "DP_BUILD=\"${DiscoPoP_BINARY_DIR}\"\n")
file(APPEND "${DiscoPoP_SOURCE_DIR}/discopop_library/ConfigProvider/assets/build_config.py" "DP_SOURCE=\"${DiscoPoP_SOURCE_DIR}\"\n")
file(APPEND "${DiscoPoP_SOURCE_DIR}/discopop_library/ConfigProvider/assets/build_config.py" "LLVM_BIN_DIR=\"${LLVM_TOOLS_BINARY_DIR}\"\n")
file(APPEND "${DiscoPoP_SOURCE_DIR}/discopop_library/ConfigProvider/assets/build_config.py" "PYTHON_EXECUTABLE=\"${Python3_EXECUTABLE}\"\n")
file(APPEND "${DiscoPoP_SOURCE_DIR}/discopop_library/ConfigProvider/assets/build_config.py" "DP_HYBRID_PROFILING=\"${DP_HYBRID_PROFILING}\"\n")
file(APPEND "${DiscoPoP_SOURCE_DIR}/discopop_library/ConfigProvider/assets/build_config.py" "DP_PTHREAD_COMPATIBILITY_MODE=\"${DP_PTHREAD_COMPATIBILITY_MODE}\"\n")
file(APPEND "${DiscoPoP_SOURCE_DIR}/discopop_library/ConfigProvider/assets/build_config.py" "DP_RTLIB_VERBOSE=\"${DP_RTLIB_VERBOSE}\"\n")
file(APPEND "${DiscoPoP_SOURCE_DIR}/discopop_library/ConfigProvider/assets/build_config.py" "DP_NUM_WORKERS=\"${DP_NUM_WORKERS}\"\n")
file(APPEND "${DiscoPoP_SOURCE_DIR}/discopop_library/ConfigProvider/assets/build_config.py" "DP_INTERNAL_TIMER=\"${DP_INTERNAL_TIMER}\"\n")
file(APPEND "${DiscoPoP_SOURCE_DIR}/discopop_library/ConfigProvider/assets/build_config.py" "DP_CALLTREE_PROFILING=\"${DP_CALLTREE_PROFILING}\"\n")
file(APPEND "${DiscoPoP_SOURCE_DIR}/discopop_library/ConfigProvider/assets/build_config.py" "DP_MEMORY_REGION_DEALIASING=\"${DP_MEMORY_REGION_DEALIASING}\"\n")



# print DiscoPoP configuration
file(READ ${DiscoPoP_SOURCE_DIR}/discopop_library/ConfigProvider/assets/build_config.py DiscoPoP_CONFIGURATION)
string(REGEX REPLACE "\n$" "" DiscoPoP_CONFIGURATION "${DiscoPoP_CONFIGURATION}")
string(REGEX REPLACE "\n" "\n    " DiscoPoP_CONFIGURATION "${DiscoPoP_CONFIGURATION}")
message(STATUS "DiscoPoP configuration:\n    ${DiscoPoP_CONFIGURATION}")

# install DiscoPoP python modules
find_package(Python3 REQUIRED COMPONENTS Interpreter)

# check if python tkinter module is available
execute_process(
    COMMAND ${Python3_EXECUTABLE} -c "import tkinter"
    RESULT_VARIABLE TKINTER_AVAILABLE_EXIT_CODE
)
if(${TKINTER_AVAILABLE_EXIT_CODE})
    message(FATAL_ERROR "Python module 'tkinter' not found. Please install the 'python3-tk' package via a package manager.")
endif()

# install DiscoPoP python modules
message(STATUS "Installing DiscoPoP python modules")
execute_process(
        COMMAND ${Python3_EXECUTABLE} -m pip install ${DiscoPoP_SOURCE_DIR}
        RESULT_VARIABLE DP_INSTALLATION_EXIT_CODE
        OUTPUT_VARIABLE DP_INSTALLATION_OUTPUT
)
# check if installation of DiscoPoP Modules was successful
if(${DP_INSTALLATION_EXIT_CODE})
    message(FATAL_ERROR "${DP_INSTALLATION_OUTPUT}")
endif()
