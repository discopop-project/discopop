include(FetchContent)

set(CMAKE_EXPORT_COMPILE_COMMANDS OFF)

set(BENCHMARK_ENABLE_TESTING
        OFF
        CACHE INTERNAL "")
FetchContent_Declare(
        googlebenchmark
        GIT_REPOSITORY https://github.com/google/benchmark.git
        GIT_TAG v1.6.1)

FetchContent_MakeAvailable(googlebenchmark)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

get_target_property(googlebenchmark_includes benchmark
        INTERFACE_INCLUDE_DIRECTORIES)
set_target_properties(benchmark PROPERTIES INTERFACE_SYSTEM_INCLUDE_DIRECTORIES
        "${googlebenchmark_includes}")

add_executable(DiscoPoP_BM)
target_sources(
  DiscoPoP_BM
  PRIVATE 
  benchmarks.cpp)

target_include_directories(DiscoPoP_BM PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
target_link_libraries(DiscoPoP_BM PRIVATE DiscoPoP_RT)
target_link_libraries(DiscoPoP_BM PRIVATE benchmark::benchmark)
set_target_properties(DiscoPoP_BM PROPERTIES CXX_STANDARD 20)
set_target_properties(DiscoPoP_UT PROPERTIES ENABLE_EXPORTS 1)
