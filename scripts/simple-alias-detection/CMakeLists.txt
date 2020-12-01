cmake_minimum_required(VERSION 3.5)
project(binmatcher)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_VERBOSE_MAKEFILE ON)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

find_package(Clang REQUIRED)

message(STATUS "Found LLVM/Clang version " ${LLVM_VERSION})
if(NOT ${LLVM_VERSION} VERSION_EQUAL 10)
  message(WARNING "Make sure to use Clang 10")
endif()


set(SOURCES
  src/main.cpp
        src/BinCallBack.h)

add_executable(getStatements ${SOURCES})

target_compile_options(getStatements PUBLIC
  -fno-rtti
)

target_include_directories(getStatements PUBLIC
  ${CLANG_INCLUDE_DIRS}
  ${PROJECT_SOURCE_DIR}/include
)

target_link_libraries(getStatements
  clangTooling
)

