message(STATUS "Found LLVM/Clang version " ${LLVM_VERSION})
if(NOT ${LLVM_VERSION} VERSION_EQUAL 8)
  message(WARNING "Make sure to use Clang 8")
endif()

find_package(Clang)

set(SOURCES
  main.cpp
        BinCallBack.h)

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