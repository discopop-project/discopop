#include <gtest/gtest.h>

#include "utils/output.hpp"

// Tests for profiler/DiscoPoP/utils/output.cpp
//
// xmlEscape is the entry point of everything the pass writes into Data.xml. It needs no LLVM
// module and no output files, which makes it the smallest piece of the pass that can be tested
// in isolation.

TEST(OutputTest, testXmlEscapeLeavesHarmlessTextUnchanged) {
  EXPECT_EQ(cu_output::xmlEscape(""), "");
  EXPECT_EQ(cu_output::xmlEscape("int"), "int");
  EXPECT_EQ(cu_output::xmlEscape("a b c 123 _-.:"), "a b c 123 _-.:");
}

TEST(OutputTest, testXmlEscapeReplacesEveryReservedCharacter) {
  EXPECT_EQ(cu_output::xmlEscape("\""), "&quot;");
  EXPECT_EQ(cu_output::xmlEscape("&"), "&amp;");
  EXPECT_EQ(cu_output::xmlEscape("<"), "&lt;");
  EXPECT_EQ(cu_output::xmlEscape(">"), "&gt;");

  // ' is legal in XML attribute values delimited by ", so it is deliberately not escaped
  EXPECT_EQ(cu_output::xmlEscape("'"), "'");
}

TEST(OutputTest, testXmlEscapeDoesNotEscapeItsOwnReplacements) {
  // Every replacement introduces a fresh '&'. If the scan resumed before it, "<" would turn into
  // "&amp;lt;" and the generated Data.xml would be wrong.
  EXPECT_EQ(cu_output::xmlEscape("<>"), "&lt;&gt;");
  EXPECT_EQ(cu_output::xmlEscape("&amp;"), "&amp;amp;");
}

TEST(OutputTest, testXmlEscapeHandlesTypeNamesAsTheyAppearInDataXml) {
  // The types the pass records for variables are the realistic input for this function
  EXPECT_EQ(cu_output::xmlEscape("std::vector<int>"), "std::vector&lt;int&gt;");
  EXPECT_EQ(cu_output::xmlEscape("std::map<int, std::vector<char *>>"), "std::map&lt;int, std::vector&lt;char *&gt;&gt;");
  EXPECT_EQ(cu_output::xmlEscape("int &"), "int &amp;");
}
