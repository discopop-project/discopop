message(STATUS "Found LLVM/Clang version " ${LLVM_VERSION})
if(NOT ${LLVM_VERSION} VERSION_EQUAL 11)
  message(WARNING "Make sure to use Clang 11")
endif()

project(OMP_pragma_extraction)

find_package(Clang)

set(SOURCES
  main.cpp
        BinCallBack.h)

add_executable(getOmpPragmas ${SOURCES})

target_compile_options(getOmpPragmas PUBLIC
  -fno-rtti
  -fopenmp
)

target_include_directories(getOmpPragmas PUBLIC
  ${CLANG_INCLUDE_DIRS}
  ${PROJECT_SOURCE_DIR}/include
)

target_link_libraries(getOmpPragmas
  PRIVATE
  clangAST
  clangASTMatchers
  clangBasic
  clangFrontend
  clangSerialization
  clangTooling
)
