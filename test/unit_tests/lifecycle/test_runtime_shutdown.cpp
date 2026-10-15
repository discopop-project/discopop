#include <gtest/gtest.h>

#include <cstdint>
#include <cstdlib>
#include <fstream>
#include <sstream>
#include <string>
#include <sys/stat.h>
#include <unistd.h>

#include "hybrid_analysis/bb_deps.hpp"
#include "lifecycle/runtime_shutdown.hpp"
#include "output_paths.hpp"
#include "runtimeFunctions.hpp"
#include "runtimeFunctionsGlobals.hpp"

using namespace dp;

// The three steps __dp_finalize performs, in order. They run from the .fini_array entry of the
// runtime, after every handler the target registered with __cxa_atexit, and are the only place
// that turns what was profiled into the files the explorer reads. An end-to-end run reaches them
// but cannot observe them in isolation -- and a coverage build cannot even see them, because the
// profile is written before the finalization array is processed.
//
// The runtime is brought up here the way __dp_init does it for a target profiled without worker
// threads, into an output directory of this test's own.
class RuntimeShutdownTest : public ::testing::Test {
protected:
  void SetUp() override {
    previous_state = runtime_state;
    previous_num_workers = num_workers;
    previous_out = out;
    previous_all_deps = all_deps;
    previous_output_deps = out_put_deps;
    previous_bb_list = bb_list;
    previous_call_state_graph = call_state_graph;
    previous_shadow = single_threaded_execution_smem;
    previous_map = my_map;

    const char *const directory = getenv(output_directory_variable);
    had_output_directory = directory != nullptr;
    if (had_output_directory) {
      previous_output_directory = directory;
    }

    char pattern[] = "/tmp/discopop_shutdown_test_XXXXXX";
    ASSERT_NE(::mkdtemp(pattern), nullptr);
    output_directory = pattern;
    ASSERT_EQ(::mkdir((output_directory + "/statistics").c_str(), 0755), 0);
    setenv(output_directory_variable, output_directory.c_str(), 1);

    ConstructImmortalGlobals();

    // no workers, so the accesses are analyzed in the calling thread and merged by the shutdown
    num_workers = 0;
    InitSingleThreadedExecution();

    // objects in the runtime's own storage rather than pointers, so a fresh set means
    // destroying whatever an earlier test left behind
    DestroyManagerGlobals();
    ConstructManagerGlobals();
    call_state_graph = new CallStateGraph();

    all_deps = new DepMap();
    out_put_deps = new StringDepMap();
    bb_list = new ReportedBBRecorder();

    out = new std::ofstream();
    out->open(ProfilerOutputPath("dynamic_dependencies.txt").c_str(), std::ios::out);
    ASSERT_TRUE(out->is_open());

    runtime_state = RuntimeState::kRunning;
  }

  void TearDown() override {
    // whatever the test under way did not release
    delete out;
    delete all_deps;
    delete out_put_deps;
    delete bb_list;
    delete call_state_graph;
    delete single_threaded_execution_smem;
    delete my_map;

    // release_runtime() destroys them, and the rest of the suite expects them to exist
    ConstructImmortalGlobals();
    ConstructManagerGlobals();

    out = previous_out;
    all_deps = previous_all_deps;
    out_put_deps = previous_output_deps;
    bb_list = previous_bb_list;
    call_state_graph = previous_call_state_graph;
    single_threaded_execution_smem = previous_shadow;
    my_map = previous_map;
    runtime_state = previous_state;
    num_workers = previous_num_workers;

    remove_output_directory();

    if (had_output_directory) {
      setenv(output_directory_variable, previous_output_directory.c_str(), 1);
    } else {
      unsetenv(output_directory_variable);
    }
  }

  std::string read_output(const std::string &file) const {
    std::ifstream written(output_directory + "/" + file);
    std::stringstream contents;
    contents << written.rdbuf();
    return contents.str();
  }

  bool output_exists(const std::string &file) const {
    struct stat unused = {};
    return ::stat((output_directory + "/" + file).c_str(), &unused) == 0;
  }

  static constexpr const char *output_directory_variable = "DOT_DISCOPOP_PROFILER";

private:
  void remove_output_directory() const {
    for (const char *const file : {"dynamic_dependencies.txt", "loop_meta.txt", "loop_counter_output.txt",
                                   "cu_taken_branch_counter_output.txt"}) {
      ::remove((output_directory + "/" + file).c_str());
    }
    ::remove((output_directory + "/statistics/profiling_time.txt").c_str());
    ::rmdir((output_directory + "/statistics").c_str());
    ::rmdir(output_directory.c_str());
  }

  std::string output_directory;
  bool had_output_directory = false;
  std::string previous_output_directory;

  RuntimeState previous_state = RuntimeState::kNotInitialized;
  std::int32_t previous_num_workers = 0;
  std::ofstream *previous_out = nullptr;
  DepMap *previous_all_deps = nullptr;
  StringDepMap *previous_output_deps = nullptr;
  ReportedBBRecorder *previous_bb_list = nullptr;
  CallStateGraph *previous_call_state_graph = nullptr;
  AbstractShadow *previous_shadow = nullptr;
  DepMap *previous_map = nullptr;
};

// A target that leaves through exit() is still inside every function it was called from, and each
// of them has to be reported as left before the functions are written out.
TEST_F(RuntimeShutdownTest, testUnwindingReportsAnExitForEveryFunctionStillEntered) {
  function_manager->IncreaseStackLevel();
  function_manager->IncreaseStackLevel();

  UnwindFunctionStack(0);

  EXPECT_EQ(function_manager->GetCurrentStackLevel(), -1);
}

// A function manager starts at level 0, which is the entry of the outermost function, so even a
// target that announced nothing is left once.
TEST_F(RuntimeShutdownTest, testUnwindingATargetThatEnteredNothingStillPassesTheBase) {
  ASSERT_EQ(function_manager->GetCurrentStackLevel(), 0);

  UnwindFunctionStack(0);

  EXPECT_EQ(function_manager->GetCurrentStackLevel(), -1);
}

TEST_F(RuntimeShutdownTest, testUnwindingEmptiesTheLoopStack) {
  function_manager->IncreaseStackLevel();

  UnwindFunctionStack(0);

  EXPECT_TRUE(loop_manager->empty());
}

TEST_F(RuntimeShutdownTest, testTheDependencyFileEndsWithTheEndOfTheProgram) {
  WriteResults(0);

  EXPECT_NE(read_output("dynamic_dependencies.txt").find("* END program"), std::string::npos);
}

TEST_F(RuntimeShutdownTest, testTheRecordedDependenciesReachTheDependencyFile) {
  (*my_map)[10].insert(Dep(kRaw, 7, "x", 3));

  WriteResults(0);

  EXPECT_NE(read_output("dynamic_dependencies.txt").find("10@0 NOM  RAW 7@0|x(3)"), std::string::npos);
}

// the basic blocks whose instructions the pass omitted are only known to be complete now
TEST_F(RuntimeShutdownTest, testTheStaticallyDeterminedDependenciesReachTheDependencyFile) {
  bb_list->Record(4, 0, 0);
  RegisteredBbDepStrings().push_back("4=10 NOM RAW 7|x(3)");

  WriteResults(0);

  EXPECT_NE(read_output("dynamic_dependencies.txt").find("10@0 NOM  RAW 7@0|x(3)"), std::string::npos);
}

TEST_F(RuntimeShutdownTest, testTheProfilingTimeIsWritten) {
  WriteResults(0);

  EXPECT_NE(read_output("statistics/profiling_time.txt").find(" ms"), std::string::npos);
}

TEST_F(RuntimeShutdownTest, testTheLoopCountersAreWritten) {
  WriteResults(0);

  EXPECT_TRUE(output_exists("loop_counter_output.txt"));
}

// the loop counters are dumped once; a second shutdown must not overwrite them with nothing
TEST_F(RuntimeShutdownTest, testTheLoopCountersAreReportedAsDoneAfterwards) {
  WriteResults(0);

  EXPECT_TRUE(loop_manager->IsDone());
}

// __dp_incr_taken_branch_counter only exists in a pass built with DP_BRANCH_TRACKING, and an
// empty report would claim that every branch went untaken
TEST_F(RuntimeShutdownTest, testNoBranchCountersAreWrittenWhenNoneWereCounted) {
  WriteResults(0);

  EXPECT_FALSE(output_exists("cu_taken_branch_counter_output.txt"));
}

TEST_F(RuntimeShutdownTest, testTheCountedBranchesAreWritten) {
  char branch[] = "7";
  cuec[branch] = 3;

  WriteResults(0);

  EXPECT_NE(read_output("cu_taken_branch_counter_output.txt").find(";3"), std::string::npos);
}

TEST_F(RuntimeShutdownTest, testReleasingTheRuntimeDropsEverythingItCreated) {
  ReleaseRuntime();

  EXPECT_FALSE(ManagerGlobalsConstructed());
  EXPECT_EQ(call_state_graph, nullptr);
  EXPECT_EQ(all_deps, nullptr);
  EXPECT_EQ(out_put_deps, nullptr);
  EXPECT_EQ(bb_list, nullptr);
  EXPECT_EQ(out, nullptr);
}

// after this every callback returns without doing anything, which is what the instrumented
// destructors of the target's globals run into
TEST_F(RuntimeShutdownTest, testReleasingTheRuntimeStopsProfiling) {
  ReleaseRuntime();

  EXPECT_EQ(runtime_state, RuntimeState::kTerminated);
  EXPECT_FALSE(ProfilingActive());
}

TEST_F(RuntimeShutdownTest, testReleasingTheRuntimeDropsTheRegisteredBasicBlockDependencies) {
  RegisteredBbDepStrings().push_back("4=10 NOM RAW 7|x(3)");

  ReleaseRuntime();

  EXPECT_TRUE(RegisteredBbDepStrings().empty());
}
