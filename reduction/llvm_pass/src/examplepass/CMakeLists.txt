project(ModuleFunc CXX)

#add_library(DataSharingClausePass MODULE
#    DataSharingClausePass.cpp
#)
#add_library(UseDefPass MODULE
#    UseDefPass.cpp
#)
add_library(ModuleFunc MODULE
    ModuleFunc.cpp
)
add_library(ReductionPass MODULE
    ReductionPass.cpp
)


# Use C++11 to compile our pass (i.e., supply -std=c++11).
#target_compile_features(DataSharingClausePass PRIVATE cxx_range_for cxx_auto_type)
target_compile_features(ModuleFunc PRIVATE cxx_range_for cxx_auto_type)
target_compile_features(ReductionPass PRIVATE cxx_range_for cxx_auto_type)

# LLVM is (typically) built with no C++ RTTI. We need to match that;
# otherwise, we'll get linker errors about missing RTTI data.
#set_target_properties(DataSharingClausePass PROPERTIES
#    COMPILE_FLAGS "-fno-rtti"
#)
set_target_properties(ModuleFunc PROPERTIES
    COMPILE_FLAGS "-fno-rtti"
)
set_target_properties(ReductionPass PROPERTIES
    COMPILE_FLAGS "-fno-rtti"
)

