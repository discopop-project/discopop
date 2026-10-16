#include <gtest/gtest.h>

#include "runtimeFunctions.hpp"
#include "runtimeFunctionsGlobals.hpp"
#include "runtimeFunctionsTypes.hpp"

using namespace dp;

// mergeDeps moves the dependencies a worker thread collected (myMap) into allDeps and empties myMap.
class MergeDepsTest : public ::testing::Test {
protected:
  void SetUp() override {
    all_deps = new DepMap();
    my_map = new DepMap();
  }

  void TearDown() override {
    delete all_deps;
    delete my_map;
    all_deps = nullptr;
    my_map = nullptr;
  }

  static const char *var() {
    static const char name[] = "x";
    return name;
  }
};

TEST_F(MergeDepsTest, aNewSinkTakesOverTheThreadsDependencies) {
  (*my_map)[100].insert(Dep(kRaw, 11, var(), 0));

  MergeDeps();

  ASSERT_EQ(all_deps->size(), 1);
  EXPECT_EQ(all_deps->at(100).size(), 1);
  EXPECT_EQ(all_deps->at(100).count(Dep(kRaw, 11, var(), 0)), 1);
  EXPECT_TRUE(my_map->empty());
}

TEST_F(MergeDepsTest, aKnownSinkGetsTheUnion) {
  (*all_deps)[100].insert(Dep(kRaw, 11, var(), 0));
  (*my_map)[100].insert(Dep(kRaw, 11, var(), 0));
  (*my_map)[100].insert(Dep(kWar, 12, var(), 0));

  MergeDeps();

  EXPECT_EQ(all_deps->at(100).size(), 2);
  EXPECT_TRUE(my_map->empty());
}

TEST_F(MergeDepsTest, repeatedMergesAccumulateInAllDeps) {
  for (LID round = 0; round < 3; ++round) {
    (*my_map)[100].insert(Dep(kRaw, 20 + round, var(), 0));
    (*my_map)[200 + round].insert(Dep(kWaw, 30, var(), 0));

    MergeDeps();
    EXPECT_TRUE(my_map->empty());
  }

  EXPECT_EQ(all_deps->at(100).size(), 3);
  EXPECT_EQ(all_deps->size(), 4);
}
