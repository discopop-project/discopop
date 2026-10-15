#include <gtest/gtest.h>

#include "loop/LoopTable.hpp"

#include <iostream>
#include <sstream>
#include <string>

// Tests for old version (i.e., capturing functionality)

class LoopTableTest : public ::testing::Test {};

namespace {

// The debug output of the loop table goes to std::cout and is only written when DP_DEBUG is set,
// which is off for every other test. Both helpers put back what they found.
class CoutCapture {
public:
  CoutCapture() : previous(std::cout.rdbuf(buffer.rdbuf())) {}
  ~CoutCapture() { std::cout.rdbuf(previous); }

  CoutCapture(const CoutCapture &) = delete;
  CoutCapture &operator=(const CoutCapture &) = delete;

  std::string str() const { return buffer.str(); }

private:
  std::ostringstream buffer;
  std::streambuf *previous;
};

class DebugFlag {
public:
  explicit DebugFlag(bool value) : previous(dp::dp_debug) { dp::dp_debug = value; }
  ~DebugFlag() { dp::dp_debug = previous; }

  DebugFlag(const DebugFlag &) = delete;
  DebugFlag &operator=(const DebugFlag &) = delete;

private:
  const bool previous;
};

} // namespace

TEST_F(LoopTableTest, testInitialization) {
  const auto lt = dp::LoopTable{};

  ASSERT_EQ(lt.size(), 0);
  ASSERT_TRUE(lt.empty());

  for (auto lid = 0; lid < 10; ++lid) {
    ASSERT_TRUE(lt.IsSingleExit(lid));
  }

  ASSERT_NO_THROW(lt.DebugOutput());
}

TEST_F(LoopTableTest, testPushBack) {
  auto lt = dp::LoopTable{};

  lt.Push(dp::LoopTableEntry{1, 2, 3, 0});
  ASSERT_EQ(lt.size(), 1);
  ASSERT_FALSE(lt.empty());
  for (auto lid = 0; lid < 10; ++lid) {
    if (lid == 2) {
      continue;
    }
    ASSERT_TRUE(lt.IsSingleExit(lid));
  }
  ASSERT_FALSE(lt.IsSingleExit(2));

  lt.Push(dp::LoopTableEntry{4, 5, 6, 0});
  ASSERT_EQ(lt.size(), 2);
  ASSERT_FALSE(lt.empty());
  for (auto lid = 0; lid < 10; ++lid) {
    if (lid == 5) {
      continue;
    }
    ASSERT_TRUE(lt.IsSingleExit(lid));
  }
  ASSERT_FALSE(lt.IsSingleExit(5));

  ASSERT_NO_THROW(lt.DebugOutput());
}

TEST_F(LoopTableTest, testGetters) {
  auto lt = dp::LoopTable{};

  const auto first_entry = dp::LoopTableEntry{1, 2, 3, 0};
  const auto second_entry = dp::LoopTableEntry{4, 5, 6, 0};

  lt.Push(first_entry);
  lt.Push(second_entry);

  ASSERT_NO_THROW(lt.DebugOutput());

  const auto top_entry_from_lt = lt.Top();
  ASSERT_EQ(top_entry_from_lt, second_entry);

  const auto first_entry_from_lt = lt.First();
  ASSERT_EQ(first_entry_from_lt, first_entry);

  const auto top_minus_0_entry_from_lt = lt.TopMinusN(0);
  ASSERT_EQ(top_minus_0_entry_from_lt, second_entry);

  const auto top_minus_1_entry_from_lt = lt.TopMinusN(1);
  ASSERT_EQ(top_minus_1_entry_from_lt, first_entry);

  ASSERT_EQ(lt.size(), 2);
  ASSERT_FALSE(lt.empty());

  lt.Pop();

  const auto top_entry_from_lt_after_pop = lt.Top();
  ASSERT_EQ(top_entry_from_lt_after_pop, first_entry);

  const auto first_entry_from_lt_after_pop = lt.First();
  ASSERT_EQ(first_entry_from_lt_after_pop, first_entry);

  const auto top_minus_0_entry_from_lt_after_pop = lt.TopMinusN(0);
  ASSERT_EQ(top_minus_0_entry_from_lt_after_pop, first_entry);

  ASSERT_EQ(lt.size(), 1);
  ASSERT_FALSE(lt.empty());

  ASSERT_NO_THROW(lt.DebugOutput());

  lt.Pop();

  ASSERT_EQ(lt.size(), 0);
  ASSERT_TRUE(lt.empty());
}

TEST_F(LoopTableTest, testCorrectFunctionLevel) {
  auto lt = dp::LoopTable{};

  const auto first_entry = dp::LoopTableEntry{1, 2, 3, 0};
  const auto second_entry = dp::LoopTableEntry{4, 5, 6, 0};

  lt.Push(first_entry);
  lt.Push(second_entry);

  lt.CorrectFuncLevel(7);

  const auto top_entry_from_lt = lt.Top();
  ASSERT_EQ(top_entry_from_lt, dp::LoopTableEntry(7, 5, 6, 0));

  lt.Pop();

  const auto top_entry_from_lt_after_pop = lt.Top();
  ASSERT_EQ(top_entry_from_lt_after_pop, first_entry);

  lt.Pop();

  ASSERT_TRUE(lt.empty());

  lt.Push(first_entry);
  lt.Push(second_entry);

  lt.CorrectFuncLevel(4);

  const auto top_entry_from_lt_2 = lt.Top();
  ASSERT_EQ(top_entry_from_lt_2, second_entry);

  lt.Pop();

  const auto top_entry_from_lt_after_pop_2 = lt.Top();
  ASSERT_EQ(top_entry_from_lt_after_pop_2, first_entry);

  lt.Pop();

  ASSERT_TRUE(lt.empty());
}

TEST_F(LoopTableTest, testIncrementTopCount) {
  auto lt = dp::LoopTable{};

  const auto first_entry = dp::LoopTableEntry{1, 2, 3, 0};
  const auto second_entry = dp::LoopTableEntry{4, 5, 6, 0};

  lt.Push(first_entry);
  lt.Push(second_entry);

  lt.IncrementTopCount();

  const auto top_entry_from_lt = lt.Top();
  ASSERT_EQ(top_entry_from_lt, dp::LoopTableEntry(4, 5, 7, 0));

  lt.Pop();

  const auto top_entry_from_lt_after_pop = lt.Top();
  ASSERT_EQ(top_entry_from_lt_after_pop, first_entry);

  lt.Pop();

  ASSERT_TRUE(lt.empty());

  lt.Push(first_entry);
  lt.Push(second_entry);

  const auto top_entry_from_lt_2 = lt.Top();
  ASSERT_EQ(top_entry_from_lt_2, second_entry);

  lt.Pop();

  lt.IncrementTopCount();

  const auto top_entry_from_lt_after_pop_2 = lt.Top();
  ASSERT_EQ(top_entry_from_lt_after_pop_2, dp::LoopTableEntry(1, 2, 4, 0));

  lt.Pop();

  ASSERT_TRUE(lt.empty());
}

TEST_F(LoopTableTest, testUpdateLidSize0) {
  auto lt = dp::LoopTable{};

  const auto lid_1 = 0b0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000LL;
  const auto lid_2 = 0b1111'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000LL;
  const auto lid_3 = 0b0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'1111LL;
  const auto lid_4 = 0b0000'1111'0000'1111'0000'1111'0000'1111'0000'1111'0000'1111'0000'1111'0000'1111LL;
  const auto lid_5 = 0b1111'0000'1111'0000'1111'0000'1111'0000'1111'0000'1111'0000'1111'0000'1111'0000LL;
  const auto lid_6 = 0b0000'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111LL;
  const auto lid_7 = 0b1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'0000LL;
  const auto lid_8 = 0b1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111LL;

  const auto expected_lid_1 = 0b1111'1111'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000LL;
  const auto expected_lid_2 = 0b1111'1111'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000LL;
  const auto expected_lid_3 = 0b1111'1111'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'1111LL;
  const auto expected_lid_4 = 0b1111'1111'0000'1111'0000'1111'0000'1111'0000'1111'0000'1111'0000'1111'0000'1111LL;
  const auto expected_lid_5 = 0b1111'1111'1111'0000'1111'0000'1111'0000'1111'0000'1111'0000'1111'0000'1111'0000LL;
  const auto expected_lid_6 = 0b1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111LL;
  const auto expected_lid_7 = 0b1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'0000LL;
  const auto expected_lid_8 = 0b1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111LL;

  ASSERT_EQ(expected_lid_1, lt.UpdateLid(lid_1));
  ASSERT_EQ(expected_lid_2, lt.UpdateLid(lid_2));
  ASSERT_EQ(expected_lid_3, lt.UpdateLid(lid_3));
  ASSERT_EQ(expected_lid_4, lt.UpdateLid(lid_4));
  ASSERT_EQ(expected_lid_5, lt.UpdateLid(lid_5));
  ASSERT_EQ(expected_lid_6, lt.UpdateLid(lid_6));
  ASSERT_EQ(expected_lid_7, lt.UpdateLid(lid_7));
  ASSERT_EQ(expected_lid_8, lt.UpdateLid(lid_8));
}

TEST_F(LoopTableTest, testUpdateLidSize1) {
  auto lt = dp::LoopTable{};

  const auto first_entry = dp::LoopTableEntry{1, 2, 3, 0};

  lt.Push(first_entry);

  const auto lid_1 = 0b0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000LL;
  const auto lid_2 = 0b1111'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000LL;
  const auto lid_3 = 0b0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'1111LL;
  const auto lid_4 = 0b0000'1111'0000'1111'0000'1111'0000'1111'0000'1111'0000'1111'0000'1111'0000'1111LL;
  const auto lid_5 = 0b1111'0000'1111'0000'1111'0000'1111'0000'1111'0000'1111'0000'1111'0000'1111'0000LL;
  const auto lid_6 = 0b0000'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111LL;
  const auto lid_7 = 0b1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'0000LL;
  const auto lid_8 = 0b1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111LL;

  const auto expected_lid_1 = 0b0000'0010'1000'0011'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000LL;
  const auto expected_lid_2 = 0b1111'0010'1000'0011'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000LL;
  const auto expected_lid_3 = 0b0000'0010'1000'0011'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'1111LL;
  const auto expected_lid_4 = 0b0000'1111'1000'1111'0000'1111'0000'1111'0000'1111'0000'1111'0000'1111'0000'1111LL;
  const auto expected_lid_5 = 0b1111'0010'1111'0011'1111'0000'1111'0000'1111'0000'1111'0000'1111'0000'1111'0000LL;
  const auto expected_lid_6 = 0b0000'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111LL;
  const auto expected_lid_7 = 0b1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'0000LL;
  const auto expected_lid_8 = 0b1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111LL;

  ASSERT_EQ(expected_lid_1, lt.UpdateLid(lid_1));
  ASSERT_EQ(expected_lid_2, lt.UpdateLid(lid_2));
  ASSERT_EQ(expected_lid_3, lt.UpdateLid(lid_3));
  ASSERT_EQ(expected_lid_4, lt.UpdateLid(lid_4));
  ASSERT_EQ(expected_lid_5, lt.UpdateLid(lid_5));
  ASSERT_EQ(expected_lid_6, lt.UpdateLid(lid_6));
  ASSERT_EQ(expected_lid_7, lt.UpdateLid(lid_7));
  ASSERT_EQ(expected_lid_8, lt.UpdateLid(lid_8));
}

TEST_F(LoopTableTest, testUpdateLidSize2) {
  auto lt = dp::LoopTable{};

  const auto first_entry = dp::LoopTableEntry{1, 2, 3, 0};
  const auto second_entry = dp::LoopTableEntry{4, 5, 6, 0};

  lt.Push(first_entry);
  lt.Push(second_entry);

  const auto lid_1 = 0b0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000LL;
  const auto lid_2 = 0b1111'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000LL;
  const auto lid_3 = 0b0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'1111LL;
  const auto lid_4 = 0b0000'1111'0000'1111'0000'1111'0000'1111'0000'1111'0000'1111'0000'1111'0000'1111LL;
  const auto lid_5 = 0b1111'0000'1111'0000'1111'0000'1111'0000'1111'0000'1111'0000'1111'0000'1111'0000LL;
  const auto lid_6 = 0b0000'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111LL;
  const auto lid_7 = 0b1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'0000LL;
  const auto lid_8 = 0b1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111LL;

  const auto expected_lid_1 = 0b0000'0010'1000'0110'1000'0011'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000LL;
  const auto expected_lid_2 = 0b1111'0010'1000'0110'1000'0011'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000LL;
  const auto expected_lid_3 = 0b0000'0010'1000'0110'1000'0011'0000'0000'0000'0000'0000'0000'0000'0000'0000'1111LL;
  const auto expected_lid_4 = 0b0000'1111'1000'1111'1000'1111'0000'1111'0000'1111'0000'1111'0000'1111'0000'1111LL;
  const auto expected_lid_5 = 0b1111'0010'1111'0110'1111'0011'1111'0000'1111'0000'1111'0000'1111'0000'1111'0000LL;
  const auto expected_lid_6 = 0b0000'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111LL;
  const auto expected_lid_7 = 0b1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'0000LL;
  const auto expected_lid_8 = 0b1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111LL;

  ASSERT_EQ(expected_lid_1, lt.UpdateLid(lid_1));
  ASSERT_EQ(expected_lid_2, lt.UpdateLid(lid_2));
  ASSERT_EQ(expected_lid_3, lt.UpdateLid(lid_3));
  ASSERT_EQ(expected_lid_4, lt.UpdateLid(lid_4));
  ASSERT_EQ(expected_lid_5, lt.UpdateLid(lid_5));
  ASSERT_EQ(expected_lid_6, lt.UpdateLid(lid_6));
  ASSERT_EQ(expected_lid_7, lt.UpdateLid(lid_7));
  ASSERT_EQ(expected_lid_8, lt.UpdateLid(lid_8));
}

TEST_F(LoopTableTest, testUpdateLidSize3) {
  auto lt = dp::LoopTable{};

  const auto first_entry = dp::LoopTableEntry{1, 2, 3, 0};
  const auto second_entry = dp::LoopTableEntry{4, 5, 6, 0};
  const auto third_entry = dp::LoopTableEntry{7, 8, 9, 0};

  lt.Push(first_entry);
  lt.Push(second_entry);
  lt.Push(third_entry);

  const auto lid_1 = 0b0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000LL;
  const auto lid_2 = 0b1111'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000LL;
  const auto lid_3 = 0b0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'1111LL;
  const auto lid_4 = 0b0000'1111'0000'1111'0000'1111'0000'1111'0000'1111'0000'1111'0000'1111'0000'1111LL;
  const auto lid_5 = 0b1111'0000'1111'0000'1111'0000'1111'0000'1111'0000'1111'0000'1111'0000'1111'0000LL;
  const auto lid_6 = 0b0000'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111LL;
  const auto lid_7 = 0b1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'0000LL;
  const auto lid_8 = 0b1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111LL;

  const auto expected_lid_1 = 0b0000'0010'1000'1001'1000'0110'1000'0011'0000'0000'0000'0000'0000'0000'0000'0000LL;
  const auto expected_lid_2 = 0b1111'0010'1000'1001'1000'0110'1000'0011'0000'0000'0000'0000'0000'0000'0000'0000LL;
  const auto expected_lid_3 = 0b0000'0010'1000'1001'1000'0110'1000'0011'0000'0000'0000'0000'0000'0000'0000'1111LL;
  const auto expected_lid_4 = 0b0000'1111'1000'1111'1000'1111'1000'1111'0000'1111'0000'1111'0000'1111'0000'1111LL;
  const auto expected_lid_5 = 0b1111'0010'1111'1001'1111'0110'1111'0011'1111'0000'1111'0000'1111'0000'1111'0000LL;
  const auto expected_lid_6 = 0b0000'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111LL;
  const auto expected_lid_7 = 0b1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'0000LL;
  const auto expected_lid_8 = 0b1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111LL;

  ASSERT_EQ(expected_lid_1, lt.UpdateLid(lid_1));
  ASSERT_EQ(expected_lid_2, lt.UpdateLid(lid_2));
  ASSERT_EQ(expected_lid_3, lt.UpdateLid(lid_3));
  ASSERT_EQ(expected_lid_4, lt.UpdateLid(lid_4));
  ASSERT_EQ(expected_lid_5, lt.UpdateLid(lid_5));
  ASSERT_EQ(expected_lid_6, lt.UpdateLid(lid_6));
  ASSERT_EQ(expected_lid_7, lt.UpdateLid(lid_7));
  ASSERT_EQ(expected_lid_8, lt.UpdateLid(lid_8));
}

TEST_F(LoopTableTest, testUpdateLidSize4) {
  auto lt = dp::LoopTable{};

  const auto first_entry = dp::LoopTableEntry{1, 2, 3, 0};
  const auto second_entry = dp::LoopTableEntry{4, 5, 6, 0};
  const auto third_entry = dp::LoopTableEntry{7, 8, 9, 0};
  const auto fourth_entry = dp::LoopTableEntry{10, 11, 12, 0};

  lt.Push(first_entry);
  lt.Push(second_entry);
  lt.Push(third_entry);
  lt.Push(fourth_entry);

  const auto lid_1 = 0b0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000LL;
  const auto lid_2 = 0b1111'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000LL;
  const auto lid_3 = 0b0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'1111LL;
  const auto lid_4 = 0b0000'1111'0000'1111'0000'1111'0000'1111'0000'1111'0000'1111'0000'1111'0000'1111LL;
  const auto lid_5 = 0b1111'0000'1111'0000'1111'0000'1111'0000'1111'0000'1111'0000'1111'0000'1111'0000LL;
  const auto lid_6 = 0b0000'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111LL;
  const auto lid_7 = 0b1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'0000LL;
  const auto lid_8 = 0b1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111LL;

  const auto expected_lid_1 = 0b0000'0010'1000'1100'1000'1001'1000'0110'0000'0000'0000'0000'0000'0000'0000'0000LL;
  const auto expected_lid_2 = 0b1111'0010'1000'1100'1000'1001'1000'0110'0000'0000'0000'0000'0000'0000'0000'0000LL;
  const auto expected_lid_3 = 0b0000'0010'1000'1100'1000'1001'1000'0110'0000'0000'0000'0000'0000'0000'0000'1111LL;
  const auto expected_lid_4 = 0b0000'1111'1000'1111'1000'1111'1000'1111'0000'1111'0000'1111'0000'1111'0000'1111LL;
  const auto expected_lid_5 = 0b1111'0010'1111'1100'1111'1001'1111'0110'1111'0000'1111'0000'1111'0000'1111'0000LL;
  const auto expected_lid_6 = 0b0000'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111LL;
  const auto expected_lid_7 = 0b1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'0000LL;
  const auto expected_lid_8 = 0b1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111LL;

  ASSERT_EQ(expected_lid_1, lt.UpdateLid(lid_1));
  ASSERT_EQ(expected_lid_2, lt.UpdateLid(lid_2));
  ASSERT_EQ(expected_lid_3, lt.UpdateLid(lid_3));
  ASSERT_EQ(expected_lid_4, lt.UpdateLid(lid_4));
  ASSERT_EQ(expected_lid_5, lt.UpdateLid(lid_5));
  ASSERT_EQ(expected_lid_6, lt.UpdateLid(lid_6));
  ASSERT_EQ(expected_lid_7, lt.UpdateLid(lid_7));
  ASSERT_EQ(expected_lid_8, lt.UpdateLid(lid_8));
}

TEST_F(LoopTableTest, testUpdateLidSize5) {
  auto lt = dp::LoopTable{};

  const auto first_entry = dp::LoopTableEntry{1, 2, 3, 0};
  const auto second_entry = dp::LoopTableEntry{4, 5, 6, 0};
  const auto third_entry = dp::LoopTableEntry{7, 8, 9, 0};
  const auto fourth_entry = dp::LoopTableEntry{10, 11, 12, 0};
  const auto fifth_entry = dp::LoopTableEntry{13, 14, 15, 0};

  lt.Push(first_entry);
  lt.Push(second_entry);
  lt.Push(third_entry);
  lt.Push(fourth_entry);
  lt.Push(fifth_entry);

  const auto lid_1 = 0b0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000LL;
  const auto lid_2 = 0b1111'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000LL;
  const auto lid_3 = 0b0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'1111LL;
  const auto lid_4 = 0b0000'1111'0000'1111'0000'1111'0000'1111'0000'1111'0000'1111'0000'1111'0000'1111LL;
  const auto lid_5 = 0b1111'0000'1111'0000'1111'0000'1111'0000'1111'0000'1111'0000'1111'0000'1111'0000LL;
  const auto lid_6 = 0b0000'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111LL;
  const auto lid_7 = 0b1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'0000LL;
  const auto lid_8 = 0b1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111LL;

  const auto expected_lid_1 = 0b0000'0010'1000'1111'1000'1100'1000'1001'0000'0000'0000'0000'0000'0000'0000'0000LL;
  const auto expected_lid_2 = 0b1111'0010'1000'1111'1000'1100'1000'1001'0000'0000'0000'0000'0000'0000'0000'0000LL;
  const auto expected_lid_3 = 0b0000'0010'1000'1111'1000'1100'1000'1001'0000'0000'0000'0000'0000'0000'0000'1111LL;
  const auto expected_lid_4 = 0b0000'1111'1000'1111'1000'1111'1000'1111'0000'1111'0000'1111'0000'1111'0000'1111LL;
  const auto expected_lid_5 = 0b1111'0010'1111'1111'1111'1100'1111'1001'1111'0000'1111'0000'1111'0000'1111'0000LL;
  const auto expected_lid_6 = 0b0000'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111LL;
  const auto expected_lid_7 = 0b1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'0000LL;
  const auto expected_lid_8 = 0b1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111LL;

  ASSERT_EQ(expected_lid_1, lt.UpdateLid(lid_1));
  ASSERT_EQ(expected_lid_2, lt.UpdateLid(lid_2));
  ASSERT_EQ(expected_lid_3, lt.UpdateLid(lid_3));
  ASSERT_EQ(expected_lid_4, lt.UpdateLid(lid_4));
  ASSERT_EQ(expected_lid_5, lt.UpdateLid(lid_5));
  ASSERT_EQ(expected_lid_6, lt.UpdateLid(lid_6));
  ASSERT_EQ(expected_lid_7, lt.UpdateLid(lid_7));
  ASSERT_EQ(expected_lid_8, lt.UpdateLid(lid_8));
}

TEST_F(LoopTableTest, testUpdateLidSize6) {
  auto lt = dp::LoopTable{};

  const auto first_entry = dp::LoopTableEntry{1, 2, 3, 0};
  const auto second_entry = dp::LoopTableEntry{4, 5, 6, 0};
  const auto third_entry = dp::LoopTableEntry{7, 8, 9, 0};
  const auto fourth_entry = dp::LoopTableEntry{10, 11, 12, 0};
  const auto fifth_entry = dp::LoopTableEntry{13, 14, 15, 0};
  const auto sixth_entry = dp::LoopTableEntry{16, 17, 18, 0};

  lt.Push(first_entry);
  lt.Push(second_entry);
  lt.Push(third_entry);
  lt.Push(fourth_entry);
  lt.Push(fifth_entry);
  lt.Push(sixth_entry);

  const auto lid_1 = 0b0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000LL;
  const auto lid_2 = 0b1111'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000LL;
  const auto lid_3 = 0b0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'1111LL;
  const auto lid_4 = 0b0000'1111'0000'1111'0000'1111'0000'1111'0000'1111'0000'1111'0000'1111'0000'1111LL;
  const auto lid_5 = 0b1111'0000'1111'0000'1111'0000'1111'0000'1111'0000'1111'0000'1111'0000'1111'0000LL;
  const auto lid_6 = 0b0000'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111LL;
  const auto lid_7 = 0b1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'0000LL;
  const auto lid_8 = 0b1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111LL;

  const auto expected_lid_1 = 0b0000'0010'1001'0010'1000'1111'1000'1100'0000'0000'0000'0000'0000'0000'0000'0000LL;
  const auto expected_lid_2 = 0b1111'0010'1001'0010'1000'1111'1000'1100'0000'0000'0000'0000'0000'0000'0000'0000LL;
  const auto expected_lid_3 = 0b0000'0010'1001'0010'1000'1111'1000'1100'0000'0000'0000'0000'0000'0000'0000'1111LL;
  const auto expected_lid_4 = 0b0000'1111'1001'1111'1000'1111'1000'1111'0000'1111'0000'1111'0000'1111'0000'1111LL;
  const auto expected_lid_5 = 0b1111'0010'1111'0010'1111'1111'1111'1100'1111'0000'1111'0000'1111'0000'1111'0000LL;
  const auto expected_lid_6 = 0b0000'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111LL;
  const auto expected_lid_7 = 0b1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'0000LL;
  const auto expected_lid_8 = 0b1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111'1111LL;

  ASSERT_EQ(expected_lid_1, lt.UpdateLid(lid_1));
  ASSERT_EQ(expected_lid_2, lt.UpdateLid(lid_2));
  ASSERT_EQ(expected_lid_3, lt.UpdateLid(lid_3));
  ASSERT_EQ(expected_lid_4, lt.UpdateLid(lid_4));
  ASSERT_EQ(expected_lid_5, lt.UpdateLid(lid_5));
  ASSERT_EQ(expected_lid_6, lt.UpdateLid(lid_6));
  ASSERT_EQ(expected_lid_7, lt.UpdateLid(lid_7));
  ASSERT_EQ(expected_lid_8, lt.UpdateLid(lid_8));
}

TEST_F(LoopTableTest, testNonConstTop) {
  auto lt = dp::LoopTable{};
  lt.Push(dp::LoopTableEntry{1, 2, 3, 4});

  lt.NonConstTop().IncrementCount();

  ASSERT_EQ(lt.Top().GetCount(), 4);
}

TEST_F(LoopTableTest, testCorrectFunctionLevelKeepsAMatchingLevel) {
  auto lt = dp::LoopTable{};
  const auto entry = dp::LoopTableEntry{1, 2, 3, 4};
  lt.Push(entry);

  const DebugFlag debug{true};
  const CoutCapture capture{};

  lt.CorrectFuncLevel(1);

  ASSERT_EQ(lt.Top(), entry);
  ASSERT_TRUE(capture.str().empty());
}

TEST_F(LoopTableTest, testCorrectFunctionLevelReportsTheChange) {
  auto lt = dp::LoopTable{};
  lt.Push(dp::LoopTableEntry{1, 2, 3, 4});

  const DebugFlag debug{true};
  const CoutCapture capture{};

  lt.CorrectFuncLevel(7);

  ASSERT_EQ(lt.Top().func_level, 7);
  ASSERT_EQ(capture.str(), "WARNING: changing funcLevel of Loop 2 from 1 to 7\n");
}

TEST_F(LoopTableTest, testDebugOutputOfAnEmptyTable) {
  const auto lt = dp::LoopTable{};

  const DebugFlag debug{true};
  const CoutCapture capture{};

  lt.DebugOutput();

  ASSERT_EQ(capture.str(), "Loop Stack is empty.\n");
}

TEST_F(LoopTableTest, testDebugOutputOfTheTopEntry) {
  auto lt = dp::LoopTable{};
  lt.Push(dp::LoopTableEntry{1, 2, 3, 4});
  lt.Push(dp::LoopTableEntry{5, 6, 7, 8});

  const DebugFlag debug{true};
  const CoutCapture capture{};

  lt.DebugOutput();

  ASSERT_EQ(capture.str(), "TOP: (5)Loop 6.\n");
}

TEST_F(LoopTableTest, testDebugOutputStaysSilentWithoutTheFlag) {
  auto lt = dp::LoopTable{};
  lt.Push(dp::LoopTableEntry{1, 2, 3, 4});

  const DebugFlag debug{false};
  const CoutCapture capture{};

  lt.DebugOutput();
  lt.CorrectFuncLevel(7);

  ASSERT_EQ(lt.Top().func_level, 7);
  ASSERT_TRUE(capture.str().empty());
}
