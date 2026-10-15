#include <gtest/gtest.h>

#include "utils/profiler_files.hpp"

#include <cstdlib>
#include <fstream>
#include <sstream>
#include <string>

// Tests for profiler/DiscoPoP/utils/profiler_files.hpp: the files the pass writes into the profiler
// directory, which close (and so flush) themselves.

namespace {

class ProfilerFilesTest : public ::testing::Test {
protected:
  void SetUp() override {
    char dir_template[] = "/tmp/dp_pass_ut_files_XXXXXX";
    const char *created = mkdtemp(dir_template);
    ASSERT_NE(created, nullptr);
    dir = created;
    const char *previous = getenv("DOT_DISCOPOP_PROFILER");
    had_previous = previous != nullptr;
    if (had_previous) {
      previous_value = previous;
    }
    setenv("DOT_DISCOPOP_PROFILER", dir.c_str(), 1);
  }

  void TearDown() override {
    if (had_previous) {
      setenv("DOT_DISCOPOP_PROFILER", previous_value.c_str(), 1);
    } else {
      unsetenv("DOT_DISCOPOP_PROFILER");
    }
    std::string command = "rm -rf '" + dir + "'";
    ASSERT_EQ(std::system(command.c_str()), 0);
  }

  std::string read(const std::string &name) {
    std::ifstream in(dir + "/" + name);
    std::stringstream content;
    content << in.rdbuf();
    return content.str();
  }

  std::string dir;
  std::string previous_value;
  bool had_previous = false;
};

} // namespace

TEST_F(ProfilerFilesTest, testPathIsInTheProfilerDirectory) {
  EXPECT_EQ(profiler_files::Path("a.txt"), dir + "/a.txt");
}

TEST_F(ProfilerFilesTest, testPathFallsBackToTheDefaultDirectory) {
  unsetenv("DOT_DISCOPOP_PROFILER");
  EXPECT_EQ(profiler_files::Path("a.txt"), ".discopop/profiler/a.txt");
}

TEST_F(ProfilerFilesTest, testStreamIsFlushedAndClosedWhenItGoesOutOfScope) {
  {
    std::ofstream stream = profiler_files::Open("out.txt");
    ASSERT_TRUE(stream.is_open());
    stream << "written\n";
  }
  EXPECT_EQ(read("out.txt"), "written\n");
}

TEST_F(ProfilerFilesTest, testStreamAppendsToAnExistingFile) {
  {
    std::ofstream first = profiler_files::Open("out.txt");
    first << "first\n";
  }
  {
    std::ofstream second = profiler_files::Open("out.txt");
    second << "second\n";
  }
  EXPECT_EQ(read("out.txt"), "first\nsecond\n");
}

TEST_F(ProfilerFilesTest, testStreamCanBeAssignedToAMember) {
  // the pass keeps its files as members that are opened per module
  std::ofstream member;
  member = profiler_files::Open("out.txt");
  EXPECT_TRUE(member.is_open());
  member << "x";
  member.close();
  EXPECT_FALSE(member.is_open());
  EXPECT_EQ(read("out.txt"), "x");
}

TEST_F(ProfilerFilesTest, testUnopenableFileIsAStreamThatIgnoresWrites) {
  setenv("DOT_DISCOPOP_PROFILER", (dir + "/missing").c_str(), 1);
  std::ofstream stream = profiler_files::Open("out.txt");
  EXPECT_FALSE(stream.is_open());
  stream << "ignored";
  stream.close();
  EXPECT_FALSE(stream.is_open());
}

TEST_F(ProfilerFilesTest, testAssigningAnOpenMemberClosesItsFile) {
  std::ofstream member = profiler_files::Open("first.txt");
  member << "first";
  member = profiler_files::Open("second.txt");
  member << "second";
  member.close();
  EXPECT_EQ(read("first.txt"), "first");
  EXPECT_EQ(read("second.txt"), "second");
}

TEST_F(ProfilerFilesTest, testWriteCounterReplacesTheContent) {
  profiler_files::WriteCounter("counter.txt", 17);
  EXPECT_EQ(read("counter.txt"), "17");
  profiler_files::WriteCounter("counter.txt", 4);
  EXPECT_EQ(read("counter.txt"), "4");
}

TEST_F(ProfilerFilesTest, testWriteCounterWithoutADirectoryDoesNothing) {
  setenv("DOT_DISCOPOP_PROFILER", (dir + "/missing").c_str(), 1);
  profiler_files::WriteCounter("counter.txt", 17);
  EXPECT_EQ(read("counter.txt"), "");
}
