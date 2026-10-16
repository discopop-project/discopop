#include <gtest/gtest.h>

#include "loop/LoopCounter.hpp"

// Tests for old version (i.e., capturing functionality)

class LoopCounterTest : public ::testing::Test {};

TEST_F(LoopCounterTest, testInit) {
  const auto lc = dp::LoopCounter{};

  const auto loop_counters = lc.GetLoopCounters();
  EXPECT_EQ(loop_counters.size(), 0);
}

TEST_F(LoopCounterTest, testIncreaseLoopCounter) {
  auto lc = dp::LoopCounter{};

  lc.IncrLoopCounter(0);
  lc.IncrLoopCounter(1);
  lc.IncrLoopCounter(0);

  const auto loop_counters = lc.GetLoopCounters();
  EXPECT_EQ(loop_counters.size(), 2);
  EXPECT_EQ(loop_counters[0], 2);
  EXPECT_EQ(loop_counters[1], 1);

  lc.IncrLoopCounter(4);
  lc.IncrLoopCounter(3);
  lc.IncrLoopCounter(9);

  const auto loop_counters2 = lc.GetLoopCounters();
  EXPECT_EQ(loop_counters2.size(), 10);
  EXPECT_EQ(loop_counters2[0], 2);
  EXPECT_EQ(loop_counters2[1], 1);
  EXPECT_EQ(loop_counters2[2], 0);
  EXPECT_EQ(loop_counters2[3], 1);
  EXPECT_EQ(loop_counters2[4], 1);
  EXPECT_EQ(loop_counters2[5], 0);
  EXPECT_EQ(loop_counters2[6], 0);
  EXPECT_EQ(loop_counters2[7], 0);
  EXPECT_EQ(loop_counters2[8], 0);
  EXPECT_EQ(loop_counters2[9], 1);
}

TEST_F(LoopCounterTest, testSparseLoopIds) {
  auto lc = dp::LoopCounter{};

  lc.IncrLoopCounter(1000);

  const auto &counters = lc.GetLoopCounters();
  EXPECT_EQ(counters.size(), 1001);
  EXPECT_EQ(counters[1000], 1);
  EXPECT_EQ(counters[0], 0);
  EXPECT_EQ(counters[999], 0);
}

TEST_F(LoopCounterTest, testDoesNotShrinkForASmallerId) {
  auto lc = dp::LoopCounter{};

  lc.IncrLoopCounter(5);
  EXPECT_EQ(lc.GetLoopCounters().size(), 6);

  lc.IncrLoopCounter(1);
  EXPECT_EQ(lc.GetLoopCounters().size(), 6);
  EXPECT_EQ(lc.GetLoopCounters()[1], 1);
  EXPECT_EQ(lc.GetLoopCounters()[5], 1);
}

TEST_F(LoopCounterTest, testRepeatedIncrements) {
  auto lc = dp::LoopCounter{};

  for (auto i = 0; i < 1000; ++i) {
    lc.IncrLoopCounter(3);
  }

  EXPECT_EQ(lc.GetLoopCounters().size(), 4);
  EXPECT_EQ(lc.GetLoopCounters()[3], 1000);
}
