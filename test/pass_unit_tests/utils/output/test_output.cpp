#include <gtest/gtest.h>

#include "utils/output.hpp"

// Tests for profiler/DiscoPoP/utils/output.cpp
//
// xmlEscape is the entry point of everything the pass writes into Data.xml. It needs no LLVM
// module and no output files, which makes it the smallest piece of the pass that can be tested
// in isolation.

TEST(OutputTest, testXmlEscapeLeavesHarmlessTextUnchanged) {
  EXPECT_EQ(cu_output::XmlEscape(""), "");
  EXPECT_EQ(cu_output::XmlEscape("int"), "int");
  EXPECT_EQ(cu_output::XmlEscape("a b c 123 _-.:"), "a b c 123 _-.:");
}

TEST(OutputTest, testXmlEscapeReplacesEveryReservedCharacter) {
  EXPECT_EQ(cu_output::XmlEscape("\""), "&quot;");
  EXPECT_EQ(cu_output::XmlEscape("&"), "&amp;");
  EXPECT_EQ(cu_output::XmlEscape("<"), "&lt;");
  EXPECT_EQ(cu_output::XmlEscape(">"), "&gt;");

  // ' is legal in XML attribute values delimited by ", so it is deliberately not escaped
  EXPECT_EQ(cu_output::XmlEscape("'"), "'");
}

TEST(OutputTest, testXmlEscapeDoesNotEscapeItsOwnReplacements) {
  // Every replacement introduces a fresh '&'. If the scan resumed before it, "<" would turn into
  // "&amp;lt;" and the generated Data.xml would be wrong.
  EXPECT_EQ(cu_output::XmlEscape("<>"), "&lt;&gt;");
  EXPECT_EQ(cu_output::XmlEscape("&amp;"), "&amp;amp;");
}

TEST(OutputTest, testXmlEscapeHandlesTypeNamesAsTheyAppearInDataXml) {
  // The types the pass records for variables are the realistic input for this function
  EXPECT_EQ(cu_output::XmlEscape("std::vector<int>"), "std::vector&lt;int&gt;");
  EXPECT_EQ(cu_output::XmlEscape("std::map<int, std::vector<char *>>"), "std::map&lt;int, std::vector&lt;char *&gt;&gt;");
  EXPECT_EQ(cu_output::XmlEscape("int &"), "int &amp;");
}
