# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

#include_directories(
#    ../share/include
#    )

# Runtime library sources and build flags.
set(DiscoPoP_SOURCES
        iFunctions.cpp
        signature.cpp
        loop_counter.cpp
        cu_taken_branch_counter.cpp
        #../share/lib/DPUtils.cpp
        MemoryRegionTree.cpp
        )

set(CMAKE_CXX_FLAGS
        "-O2 -std=c++11 -pthread -fno-rtti -fPIE -fPIC -ffreestanding")

# add_custom_target(DiscoPoP)

add_library(DiscoPoP_RT STATIC
        ${DiscoPoP_SOURCES})

# forward compiler flags
if(DEFINED DP_PTHREAD_COMPATIBILITY_MODE)
        if(NOT ${DP_PTHREAD_COMPATIBILITY_MODE} EQUAL 0)
                target_compile_definitions(DiscoPoP_RT PUBLIC DP_PTHREAD_COMPATIBILITY_MODE=${DP_PTHREAD_COMPATIBILITY_MODE})
        endif()
endif()

if(DEFINED DP_RTLIB_VERBOSE)
        if(NOT ${DP_RTLIB_VERBOSE} EQUAL 0)
                target_compile_definitions(DiscoPoP_RT PUBLIC DP_RTLIB_VERBOSE=${DP_RTLIB_VERBOSE})
        endif()
endif()

if(DEFINED DP_NUM_WORKERS)
        if(NOT ${DP_NUM_WORKERS} EQUAL 0)
                target_compile_definitions(DiscoPoP_RT PUBLIC DP_NUM_WORKERS=${DP_NUM_WORKERS})
        endif()
endif()

# end of compiler flags

install(TARGETS DiscoPoP_RT ARCHIVE DESTINATION lib)

# compile simple-alias-detection
#exec_program(${CMAKE_CURRENT_SOURCE_DIR}/simple-alias-detection/compile.sh
#    ARGS ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_CURRENT_BINARY_DIR}
#)
