include_directories(
    ../share/include
    )

add_llvm_library(LLVMCUGeneration MODULE
    CUGenerationPass.cpp
	../share/lib/DPUtils.cpp
    )
