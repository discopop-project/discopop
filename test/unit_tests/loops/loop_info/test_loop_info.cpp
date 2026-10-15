#include <gtest/gtest.h>

#include "loop/LoopInfo.hpp"

// Tests for old version (i.e., capturing functionality)

class LoopInfoTest : public ::testing::Test {};

TEST_F(LoopInfoTest, testZeroInitialization) {
  const auto li = dp::LoopInfoT{};

  ASSERT_EQ(li.line_nr, 0);
  ASSERT_EQ(li.loop_id, 0);
  ASSERT_EQ(li.file_id, 0);
}

TEST_F(LoopInfoTest, testInitialization) {
  const auto li = dp::LoopInfoT{1, 2, 3};

  ASSERT_EQ(li.line_nr, 1);
  ASSERT_EQ(li.loop_id, 2);
  ASSERT_EQ(li.file_id, 3);
}

TEST_F(LoopInfoTest, testInitializationWithNegativeValues) {
  const auto li = dp::LoopInfoT{-1, -2, -3};

  ASSERT_EQ(li.line_nr, -1);
  ASSERT_EQ(li.loop_id, -2);
  ASSERT_EQ(li.file_id, -3);
}

TEST_F(LoopInfoTest, testEquality) {
  const auto li1 = dp::LoopInfoT{1, 2, 3};
  const auto li2 = dp::LoopInfoT{1, 2, 3};
  const auto li3 = dp::LoopInfoT{1, 2, 4};
  const auto li4 = dp::LoopInfoT{1, 3, 3};
  const auto li5 = dp::LoopInfoT{2, 2, 3};

  ASSERT_EQ(li1, li1);

  ASSERT_EQ(li1, li2);
  ASSERT_NE(li1, li3);
  ASSERT_NE(li1, li4);
  ASSERT_NE(li1, li5);

  ASSERT_EQ(li2, li1);
  ASSERT_NE(li3, li1);
  ASSERT_NE(li4, li1);
  ASSERT_NE(li5, li1);
}
