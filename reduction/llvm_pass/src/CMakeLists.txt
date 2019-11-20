cmake_minimum_required(VERSION 3.1)

find_package(LLVM REQUIRED CONFIG)
add_definitions(${LLVM_DEFINITIONS})
include_directories(${LLVM_INCLUDE_DIRS})
link_directories(${LLVM_LIBRARY_DIRS})
#set (CMAKE_CXX_FLAGS "-std=c++0x -stdlib=libc++ -g3 -Wall -O0")

add_subdirectory(examplepass)  # Use your pass name here.
