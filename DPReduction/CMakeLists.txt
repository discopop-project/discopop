include_directories(
    ../share/include
    )

add_llvm_library(LLVMDPReduction MODULE
	DPReduction.cpp
	Utils.cpp
    )

