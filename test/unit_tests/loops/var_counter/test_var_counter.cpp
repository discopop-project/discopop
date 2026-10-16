#include <gtest/gtest.h>

#include "loop/VarCounter.hpp"

// Tests for old version (i.e., capturing functionality)

class VarCounterTest : public ::testing::Test {};

TEST_F(VarCounterTest, testZeroInitialization) {
  const auto vc = dp::VarCounter{};

  ASSERT_EQ(vc.counters[0], 0);
  ASSERT_EQ(vc.counters[1], 0);
  ASSERT_EQ(vc.mem_addr, 0);
  ASSERT_TRUE(vc.valid);
}

TEST_F(VarCounterTest, testInitialization) {
  const auto vc = dp::VarCounter{1, 2, 3, false};

  ASSERT_EQ(vc.counters[0], 1);
  ASSERT_EQ(vc.counters[1], 2);
  ASSERT_EQ(vc.mem_addr, 3);
  ASSERT_FALSE(vc.valid);
}

TEST_F(VarCounterTest, testNegativeInitialization) {
  const auto vc = dp::VarCounter{1, 2, -3, false};

  ASSERT_EQ(vc.counters[0], 1);
  ASSERT_EQ(vc.counters[1], 2);
  ASSERT_EQ(vc.mem_addr, -3);
  ASSERT_FALSE(vc.valid);
}

TEST_F(VarCounterTest, testEquality) {
  const auto vc1 = dp::VarCounter{1, 2, 3, false};
  const auto vc2 = dp::VarCounter{1, 2, 3, false};
  const auto vc3 = dp::VarCounter{1, 2, 4, false};
  const auto vc4 = dp::VarCounter{1, 3, 3, false};
  const auto vc5 = dp::VarCounter{2, 2, 3, false};
  const auto vc6 = dp::VarCounter{1, 2, 3, true};

  ASSERT_EQ(vc1, vc1);

  ASSERT_EQ(vc1, vc2);
  ASSERT_NE(vc1, vc3);
  ASSERT_NE(vc1, vc4);
  ASSERT_NE(vc1, vc5);
  ASSERT_NE(vc1, vc6);

  ASSERT_EQ(vc2, vc1);
  ASSERT_NE(vc3, vc1);
  ASSERT_NE(vc4, vc1);
  ASSERT_NE(vc5, vc1);
  ASSERT_NE(vc6, vc1);
}
