#include_directories(
#    ../share/include
#    )

# Runtime library sources and build flags.
set(DiscoPoP_SOURCES
  iFunctions.cpp
  signature.cpp
  loop_counter.cpp
  #../share/lib/DPUtils.cpp
  )
  
set(CMAKE_CXX_FLAGS
  "-O2 -std=c++11 -pthread -fno-rtti -fPIE -ffreestanding")

# add_custom_target(DiscoPoP)

add_library(DiscoPoP_RT STATIC
    ${DiscoPoP_SOURCES})
install(TARGETS DiscoPoP_RT ARCHIVE DESTINATION lib)

# add_subdirectory(simple-alias-detection)
# add_subdirectory(omp-pragma-extraction)

# current dir: ${CMAKE_CURRENT_SOURCE_DIR}
execute_process(
    COMMAND echo ${CMAKE_CURRENT_SOURCE_DIR}
)
execute_process(
    COMMAND echo ${CMAKE_BINARY_DIR}
)

# compile omp-pragma-extraction
exec_program(${CMAKE_CURRENT_SOURCE_DIR}/omp-pragma-extraction/compile.sh
    ARGS ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_BINARY_DIR} ${CMAKE_CURRENT_BINARY_DIR}
)