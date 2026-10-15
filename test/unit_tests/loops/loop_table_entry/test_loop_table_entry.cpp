#include <gtest/gtest.h>

#include "loop/LoopTableEntry.hpp"

// Tests for old version (i.e., capturing functionality)

class LoopTableEntryTest : public ::testing::Test {};

TEST_F(LoopTableEntryTest, testInitialization) {
  const auto lte = dp::LoopTableEntry{1, 2, 3, 4};

  ASSERT_EQ(lte.func_level, 1);
  ASSERT_EQ(lte.loop_id, 2);
  ASSERT_EQ(lte.GetCount(), 3);
  ASSERT_EQ(lte.begin, 4);
}

TEST_F(LoopTableEntryTest, testNegativeInitialization) {
  const auto lte = dp::LoopTableEntry{-1, -2, -3, -4};

  ASSERT_EQ(lte.func_level, -1);
  ASSERT_EQ(lte.loop_id, -2);
  ASSERT_EQ(lte.GetCount(), -3);
  ASSERT_EQ(lte.begin, -4);
}

TEST_F(LoopTableEntryTest, testLongInitialization) {
  const auto lte = dp::LoopTableEntry{1'000'000'000, 1'500'000'000, 2'000'000'000, 4'000'000'000LL};

  ASSERT_EQ(lte.func_level, 1'000'000'000);
  ASSERT_EQ(lte.loop_id, 1'500'000'000);
  ASSERT_EQ(lte.GetCount(), 2'000'000'000);
  ASSERT_EQ(lte.begin, 4'000'000'000LL);
}

TEST_F(LoopTableEntryTest, testNegativeLongInitialization) {
  const auto lte = dp::LoopTableEntry{-1'000'000'000, -1'500'000'000, -2'000'000'000, -4'000'000'000LL};

  ASSERT_EQ(lte.func_level, -1'000'000'000);
  ASSERT_EQ(lte.loop_id, -1'500'000'000);
  ASSERT_EQ(lte.GetCount(), -2'000'000'000);
  ASSERT_EQ(lte.begin, -4'000'000'000LL);
}

TEST_F(LoopTableEntryTest, testEquality) {
  const auto lte1 = dp::LoopTableEntry{1, 2, 3, 4};
  const auto lte2 = dp::LoopTableEntry{1, 2, 3, 4};
  const auto lte3 = dp::LoopTableEntry{1, 2, 3, 5};
  const auto lte4 = dp::LoopTableEntry{1, 2, 4, 4};
  const auto lte5 = dp::LoopTableEntry{1, 3, 3, 4};
  const auto lte6 = dp::LoopTableEntry{2, 2, 3, 4};

  ASSERT_EQ(lte1, lte1);

  ASSERT_EQ(lte1, lte2);
  ASSERT_NE(lte1, lte3);
  ASSERT_NE(lte1, lte4);
  ASSERT_NE(lte1, lte5);
  ASSERT_NE(lte1, lte6);

  ASSERT_EQ(lte2, lte1);
  ASSERT_NE(lte3, lte1);
  ASSERT_NE(lte4, lte1);
  ASSERT_NE(lte5, lte1);
  ASSERT_NE(lte6, lte1);
}

TEST_F(LoopTableEntryTest, testIncrementCount) {
  auto lte = dp::LoopTableEntry{1, 2, 3, 4};

  ASSERT_EQ(lte.GetCount(), 3);

  lte.IncrementCount();
  ASSERT_EQ(lte.GetCount(), 4);

  lte.IncrementCount();
  lte.IncrementCount();
  ASSERT_EQ(lte.GetCount(), 6);

  // the count takes part in the comparison although it is not reachable as a member
  ASSERT_NE(lte, dp::LoopTableEntry(1, 2, 3, 4));
  ASSERT_EQ(lte, dp::LoopTableEntry(1, 2, 6, 4));
}
