#include <gtest/gtest.h>

#include "loop/VarInfo.hpp"

// Tests for old version (i.e., capturing functionality)

class VarInfoTest : public ::testing::Test {};

TEST_F(VarInfoTest, testZeroInitialization) {
  const auto vi = dp::VarInfoT{};

  ASSERT_TRUE(vi.var_name.empty());
  ASSERT_EQ(vi.file_id, 0);
  ASSERT_EQ(vi.instr_id, 0);
  ASSERT_EQ(vi.loop_line_nr, 0);
  ASSERT_EQ(vi.instr_line, 0);
  ASSERT_EQ(vi.operation, 0);
}

TEST_F(VarInfoTest, testInitialization) {
  const auto vi = dp::VarInfoT{"var", 1, 2, 3, 4, 'a'};

  ASSERT_EQ(vi.var_name, "var");
  ASSERT_EQ(vi.file_id, 1);
  ASSERT_EQ(vi.instr_id, 2);
  ASSERT_EQ(vi.loop_line_nr, 3);
  ASSERT_EQ(vi.instr_line, 4);
  ASSERT_EQ(vi.operation, 'a');
}

TEST_F(VarInfoTest, testNegativeInitialization) {
  const auto vi = dp::VarInfoT{"negative", -1, -2, -3, -4, 'n'};

  ASSERT_EQ(vi.var_name, "negative");
  ASSERT_EQ(vi.file_id, -1);
  ASSERT_EQ(vi.instr_id, -2);
  ASSERT_EQ(vi.loop_line_nr, -3);
  ASSERT_EQ(vi.instr_line, -4);
  ASSERT_EQ(vi.operation, 'n');
}

TEST_F(VarInfoTest, testEquality) {
  const auto vi1 = dp::VarInfoT{"var", 1, 2, 3, 4, 'a'};
  const auto vi2 = dp::VarInfoT{"var", 1, 2, 3, 4, 'a'};
  const auto vi3 = dp::VarInfoT{"var", 1, 2, 3, 4, 'b'};
  const auto vi4 = dp::VarInfoT{"var", 1, 2, 3, 5, 'a'};
  const auto vi5 = dp::VarInfoT{"var", 1, 2, 4, 4, 'a'};
  const auto vi6 = dp::VarInfoT{"var", 1, 3, 3, 4, 'a'};
  const auto vi7 = dp::VarInfoT{"var", 2, 2, 3, 4, 'a'};
  const auto vi8 = dp::VarInfoT{"var", 1, 2, 3, 4, 'c'};
  const auto vi9 = dp::VarInfoT{"VAR", 1, 2, 3, 4, 'c'};

  ASSERT_EQ(vi1, vi1);

  ASSERT_EQ(vi1, vi2);
  ASSERT_NE(vi1, vi3);
  ASSERT_NE(vi1, vi4);
  ASSERT_NE(vi1, vi5);
  ASSERT_NE(vi1, vi6);
  ASSERT_NE(vi1, vi7);
  ASSERT_NE(vi1, vi8);
  ASSERT_NE(vi1, vi9);

  ASSERT_EQ(vi2, vi1);
  ASSERT_NE(vi3, vi1);
  ASSERT_NE(vi4, vi1);
  ASSERT_NE(vi5, vi1);
  ASSERT_NE(vi6, vi1);
  ASSERT_NE(vi7, vi1);
  ASSERT_NE(vi8, vi1);
  ASSERT_NE(vi9, vi1);
}
