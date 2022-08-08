message(STATUS "Found LLVM/Clang version " ${LLVM_VERSION})
if(NOT ${LLVM_VERSION} VERSION_EQUAL 14)
  message(WARNING "Make sure to use Clang 14")
endif()

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
  clangTooling
)