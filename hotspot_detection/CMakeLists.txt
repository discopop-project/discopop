cmake_minimum_required(VERSION 3.4.3)
project(HotspotDetection)

# support C++14 features used by LLVM 10.0.0
set(CMAKE_CXX_STANDARD 14)

if (POLICY CMP0077)
	cmake_policy(SET CMP0077 NEW)
endif()

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

set(LLVM_RUNTIME_OUTPUT_INTDIR ${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_CFG_INTDIR}/bin)
set(LLVM_LIBRARY_OUTPUT_INTDIR ${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_CFG_INTDIR}/libi)

list(APPEND CMAKE_MODULE_PATH "${LLVM_CMAKE_DIR}")
include(HandleLLVMOptions)
include(AddLLVM)

add_definitions(${LLVM_DEFINITIONS})
include_directories(${LLVM_INCLUDE_DIRS})

add_subdirectory(HotspotDetection)

add_subdirectory(rtlib)

add_subdirectory(scripts)

# install Hotspot Analyzer python modules
find_package(Python3 REQUIRED COMPONENTS Interpreter)
message(STATUS "Installing Hotspot Analyzer python modules")
execute_process(
        COMMAND ${Python3_EXECUTABLE} -m pip install ${HotspotDetection_SOURCE_DIR}
        RESULT_VARIABLE HD_INSTALLATION_EXIT_CODE
        OUTPUT_VARIABLE HD_INSTALLATION_OUTPUT
)
# check if installation of DiscoPoP Modules was successful
if(${HD_INSTALLATION_EXIT_CODE})
    message(FATAL_ERROR "${HD_INSTALLATION_OUTPUT}")
endif()


# save build configuration to build/build_config.txt
file(REMOVE "${HotspotDetection_BINARY_DIR}/build_config.txt")
file(TOUCH "${HotspotDetection_BINARY_DIR}/build_config.txt")
file(APPEND "${HotspotDetection_BINARY_DIR}/build_config.txt" "HOTSPOT_DETECTION_BUILD=${HotspotDetection_BINARY_DIR}\n")
file(APPEND "${HotspotDetection_BINARY_DIR}/build_config.txt" "HOTSPOT_DETECTION_SOURCE=${HotspotDetection_SOURCE_DIR}\n")
file(APPEND "${HotspotDetection_BINARY_DIR}/build_config.txt" "LLVM_BIN_DIR=${LLVM_TOOLS_BINARY_DIR}\n")
