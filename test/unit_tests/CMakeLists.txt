include(FetchContent)

enable_testing()

FetchContent_Declare(
        googletest
        GIT_REPOSITORY https://github.com/google/googletest
        GIT_TAG release-1.12.1)

# google test
set(gtest_force_shared_crt
        ON
        CACHE BOOL "" FORCE)
FetchContent_MakeAvailable(googletest)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

get_target_property(gtest_main_includes gtest_main
        INTERFACE_INCLUDE_DIRECTORIES)
set_target_properties(gtest_main PROPERTIES INTERFACE_SYSTEM_INCLUDE_DIRECTORIES
        "${gtest_main_includes}")

add_executable(DiscoPoP_UT)
target_sources(
  DiscoPoP_UT
  PRIVATE 
  tests.cpp
  perfect_shadow/test_perfect_shadow.cpp)

target_include_directories(DiscoPoP_UT PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
target_link_libraries(DiscoPoP_UT PRIVATE DiscoPoP_RT)
target_link_libraries(DiscoPoP_UT PRIVATE gtest)
set_target_properties(DiscoPoP_UT PROPERTIES CXX_STANDARD 20)
set_target_properties(DiscoPoP_UT PROPERTIES ENABLE_EXPORTS 1)
