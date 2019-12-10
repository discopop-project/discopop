cmake_minimum_required(VERSION 3.1)

project(ModuleFunc CXX)

find_package(LLVM REQUIRED CONFIG)
add_definitions(${LLVM_DEFINITIONS})
include_directories(${LLVM_INCLUDE_DIRS})
link_directories(${LLVM_LIBRARY_DIRS})

add_library(ModuleFunc MODULE ModuleFunc.cpp Util.cpp)
target_compile_features(ModuleFunc PRIVATE cxx_range_for cxx_auto_type)
set_target_properties(ModuleFunc PROPERTIES COMPILE_FLAGS "-fno-rtti")
