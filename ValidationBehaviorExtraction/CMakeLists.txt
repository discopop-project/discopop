include_directories(
    ../share/include
    )

add_llvm_library(ValidationBehaviorExtraction MODULE
	BehaviorExtraction.cpp
	../share/lib/DPUtils.cpp
    )
