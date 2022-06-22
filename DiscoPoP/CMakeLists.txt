include_directories(
    ../share/include
    )

add_llvm_library(LLVMDiscoPoP MODULE
	DiscoPoP.cpp
    InstructionCFG.cpp
    InstructionDG.cpp
	../share/lib/DPUtils.cpp
    )
