#include <gtest/gtest.h>

#include <cstdint>
#include <unordered_set>

#include "memory/PerfectShadow.hpp"
#include "memory/ShadowMemory.hpp"
#include "runtimeFunctions.hpp"
#include "runtimeFunctionsGlobals.hpp"

using namespace dp;

// What __dp_init sets up and __dp_finalize tears down again when the runtime profiles without
// worker threads: one shadow memory for the whole program instead of one per worker, and the
// per-thread dependency map the callbacks fill. Finalizing has to merge that map into the global
// one, because nothing else does it in this configuration.
class SingleThreadedExecutionTest : public ::testing::Test {
protected:
  DepMap collected_dependencies;

  void SetUp() override {
    previous_all_deps = all_deps;
    previous_shadow = single_threaded_execution_smem;
    previous_map = my_map;
    previous_use_perfect = use_perfect;
    previous_sig_elem_bit = sig_elem_bit;
    previous_sig_num_elem = sig_num_elem;
    previous_sig_num_hash = sig_num_hash;

    all_deps = &collected_dependencies;
    single_threaded_execution_smem = nullptr;
    my_map = nullptr;
  }

  void TearDown() override {
    delete single_threaded_execution_smem;
    single_threaded_execution_smem = previous_shadow;
    delete my_map;
    my_map = previous_map;

    all_deps = previous_all_deps;
    use_perfect = previous_use_perfect;
    sig_elem_bit = previous_sig_elem_bit;
    sig_num_elem = previous_sig_num_elem;
    sig_num_hash = previous_sig_num_hash;
  }

private:
  DepMap *previous_all_deps = nullptr;
  AbstractShadow *previous_shadow = nullptr;
  DepMap *previous_map = nullptr;
  bool previous_use_perfect = true;
  std::int32_t previous_sig_elem_bit = 0;
  std::int32_t previous_sig_num_elem = 0;
  std::int32_t previous_sig_num_hash = 0;
};

TEST_F(SingleThreadedExecutionTest, testInitializingCreatesTheShadowMemoryAndTheDependencyMap) {
  InitSingleThreadedExecution();

  EXPECT_NE(single_threaded_execution_smem, nullptr);
  EXPECT_NE(my_map, nullptr);
}

TEST_F(SingleThreadedExecutionTest, testTheNewDependencyMapIsEmpty) {
  InitSingleThreadedExecution();

  EXPECT_TRUE(my_map->empty());
}

TEST_F(SingleThreadedExecutionTest, testTheNewShadowMemoryKnowsNoAccess) {
  InitSingleThreadedExecution();

  EXPECT_EQ(single_threaded_execution_smem->TestInRead(0x1000), 0);
  EXPECT_EQ(single_threaded_execution_smem->TestInWrite(0x1000), 0);
}

// Which of the two shadow memories was created is told apart by what they can do rather than by
// their type: the runtime library is built without RTTI, so a dynamic_cast across it is not an
// option. A perfect shadow keeps every address and can enumerate them again; a signature keeps
// none and reports an empty range.
TEST_F(SingleThreadedExecutionTest, testThePerfectShadowIsUsedByDefault) {
  use_perfect = true;
  InitSingleThreadedExecution();

  single_threaded_execution_smem->InsertToWrite(0x1000, 1);

  EXPECT_EQ(single_threaded_execution_smem->GetAddrsInRange(0x0, 0x2000), (std::unordered_set<ADDR>{0x1000}));
}

// the signature based alternative, sized from the three shadow memory parameters
TEST_F(SingleThreadedExecutionTest, testTheSignatureShadowIsUsedWhenThePerfectOneIsTurnedOff) {
  use_perfect = false;
  sig_elem_bit = 56;
  sig_num_elem = 1024;
  sig_num_hash = 2;
  InitSingleThreadedExecution();

  single_threaded_execution_smem->InsertToWrite(0x1000, 1);

  EXPECT_EQ(single_threaded_execution_smem->TestInWrite(0x1000), 1);
  EXPECT_TRUE(single_threaded_execution_smem->GetAddrsInRange(0x0, 0x2000).empty());
}

TEST_F(SingleThreadedExecutionTest, testFinalizingReleasesTheShadowMemoryAndTheDependencyMap) {
  InitSingleThreadedExecution();

  FinalizeSingleThreadedExecution();

  EXPECT_EQ(single_threaded_execution_smem, nullptr);
  EXPECT_EQ(my_map, nullptr);
}

// nothing else merges the per-thread map in this configuration, so what the callbacks recorded
// would never reach the report if finalizing skipped it
TEST_F(SingleThreadedExecutionTest, testFinalizingMergesWhatWasRecordedIntoTheGlobalDependencies) {
  InitSingleThreadedExecution();
  (*my_map)[42].insert(Dep(kRaw, 7, "x", 3));

  FinalizeSingleThreadedExecution();

  ASSERT_EQ(collected_dependencies.count(42), 1u);
  EXPECT_EQ(collected_dependencies[42].size(), 1u);
}

TEST_F(SingleThreadedExecutionTest, testFinalizingKeepsTheDependenciesThatWereAlreadyGlobal) {
  collected_dependencies[42].insert(Dep(kWar, 8, "y", 4));
  InitSingleThreadedExecution();
  (*my_map)[42].insert(Dep(kRaw, 7, "x", 3));

  FinalizeSingleThreadedExecution();

  EXPECT_EQ(collected_dependencies[42].size(), 2u);
}

TEST_F(SingleThreadedExecutionTest, testFinalizingWithoutRecordedDependenciesChangesNothing) {
  InitSingleThreadedExecution();

  FinalizeSingleThreadedExecution();

  EXPECT_TRUE(collected_dependencies.empty());
}
