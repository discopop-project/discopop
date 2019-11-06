include_directories(..)

# Runtime library sources and build flags.
set(CUInstantiation_SOURCES
  iFunctions.cpp
  )
  
set(CUInstantiation_CFLAGS
  -O2
  -std=c++11
  -pthread
  -fno-rtti
  -fPIE
  # Prevent clang from generating libc calls.
  -ffreestanding)

filter_available_targets(CUInstantiation_SUPPORTED_ARCH x86_64 i386)

add_custom_target(CUInstantiation)

# Static runtime library.
# set(CUInstantiation_LIBRARIES)
if(APPLE)
  add_compiler_rt_osx_static_runtime(clang_rt.CUInstantiation_osx
    ARCH ${CUInstantiation_SUPPORTED_ARCH}
    SOURCES ${CUInstantiation_SOURCES}
    CFLAGS ${CUInstantiation_CFLAGS})
  add_dependencies(CUInstantiation clang_rt.CUInstantiation_osx)
else()
  foreach(arch ${CUInstantiation_SUPPORTED_ARCH})
    add_compiler_rt_runtime(clang_rt.CUInstantiation-${arch} ${arch} STATIC
      SOURCES ${CUInstantiation_SOURCES}
      CFLAGS ${CUInstantiation_CFLAGS})
    add_dependencies(CUInstantiation clang_rt.CUInstantiation-${arch})
#   list(APPEND CUInstantiation_LIBRARIES clang_rt.CUInstantiation-${arch})
  endforeach()
endif()

add_dependencies(compiler-rt CUInstantiation)
