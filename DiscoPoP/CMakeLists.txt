# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

include_directories(
        ../share/include
)

add_llvm_library(LLVMDiscoPoP MODULE
        DiscoPoP.cpp
        InstructionCFG.cpp
        InstructionDG.cpp
        ../share/lib/DPUtils.cpp
        )

# forward compiler flags
if(DEFINED DP_HYBRID_PROFILING)
        message("Defined DP_HYBRID_PROFILING=" ${DP_HYBRID_PROFILING})
        target_compile_definitions(LLVMDiscoPoP PUBLIC DP_HYBRID_PROFILING=${DP_HYBRID_PROFILING})
else()
        target_compile_definitions(LLVMDiscoPoP PUBLIC DP_HYBRID_PROFILING=1)
        message("Default defined DP_HYBRID_PROFILING=1")
endif()
# end of compiler flags