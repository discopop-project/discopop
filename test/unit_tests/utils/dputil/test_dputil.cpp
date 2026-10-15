#include <gtest/gtest.h>

#include <climits>
#include <cstdio>
#include <cstdlib>
#include <fstream>
#include <sstream>
#include <string>
#include <unistd.h>
#include <vector>

#include "lid_utils.hpp"

// The helpers the runtime and the LLVM pass share. A location id packs a file id and a line
// number into one integer -- the lower kLidSize bits hold the line, the bits above it the file --
// and the upper 32 bits carry the call path state the runtime adds, which decoding drops again.
class DPUtilsTest : public ::testing::Test {
protected:
  // A file the test owns for the duration of one test case. GetFileId() and FileExists() take paths,
  // so there is no way around touching the file system for them.
  class TemporaryFile {
  public:
    explicit TemporaryFile(const std::string &contents) {
      char pattern[] = "/tmp/discopop_dputil_test_XXXXXX";
      const int descriptor = ::mkstemp(pattern);
      EXPECT_NE(descriptor, -1);
      ::close(descriptor);
      path_ = pattern;

      std::ofstream file(path_);
      file << contents;
    }

    ~TemporaryFile() { std::remove(path_.c_str()); }

    TemporaryFile(const TemporaryFile &) = delete;
    TemporaryFile &operator=(const TemporaryFile &) = delete;

    const std::string &path() const { return path_; }

  private:
    std::string path_;
  };

  // split() hands out ownership of the vector it allocates
  static std::vector<std::string> split_into(const std::string &input, const char delimiter) {
    std::vector<std::string> *const substrings = dputil::Split(input, delimiter);
    const std::vector<std::string> result = *substrings;
    delete substrings;
    return result;
  }

  static std::int64_t make_lid(const std::int64_t file_id, const std::int64_t line) {
    return (file_id << kLidSize) | line;
  }
};

// LID 0 is the runtime's "no source location": it is what __dp_finalize reports for the end of a
// program that no longer terminates at a call site.
TEST_F(DPUtilsTest, testTheEmptyLocationDecodesToAnAsterisk) { EXPECT_EQ(dputil::DecodeLid(0), "*"); }

TEST_F(DPUtilsTest, testALocationDecodesToFileAndLine) { EXPECT_EQ(dputil::DecodeLid(make_lid(3, 42)), "3:42"); }

TEST_F(DPUtilsTest, testTheFirstLineOfTheFirstFileDecodes) { EXPECT_EQ(dputil::DecodeLid(make_lid(0, 1)), "0:1"); }

TEST_F(DPUtilsTest, testTheLastLineAFileCanHoldDecodes) {
  EXPECT_EQ(dputil::DecodeLid(make_lid(7, kMaxLno - 1)), "7:" + std::to_string(kMaxLno - 1));
}

TEST_F(DPUtilsTest, testTheLastFileAProjectCanHoldDecodes) {
  // the file id occupies the bits above the line, up to bit 31: it must not be read as a sign
  EXPECT_EQ(dputil::DecodeLid(make_lid(kMaxFileId, kMaxLno - 1)),
            std::to_string(kMaxFileId) + ":" + std::to_string(kMaxLno - 1));
  EXPECT_EQ(dputil::DecodeLid(make_lid(kMaxFileId, 1)), std::to_string(kMaxFileId) + ":1");
}

// the lines of a file must not leak into its file id, and the other way round: this was the case for
// the lines above 2^kLidSize - 1 of a layout that gave the line fewer bits
TEST_F(DPUtilsTest, testTheLineOfALocationDoesNotChangeItsFile) {
  EXPECT_EQ(dputil::DecodeLid(make_lid(5, 16384)), "5:16384");
  EXPECT_EQ(dputil::DecodeLid(make_lid(5, 100000)), "5:100000");
}

// the call path state the runtime packs into the upper half is not part of the location
TEST_F(DPUtilsTest, testTheCallPathStateIsStrippedBeforeDecoding) {
  const std::int64_t with_state = make_lid(3, 42) | (static_cast<std::int64_t>(17) << 32);

  EXPECT_EQ(dputil::DecodeLid(with_state), "3:42");
}

TEST_F(DPUtilsTest, testDecodingIntoAStreamMatchesDecodingIntoAString) {
  std::ostringstream stream;

  dputil::DecodeLid(make_lid(3, 42), stream);

  EXPECT_EQ(stream.str(), dputil::DecodeLid(make_lid(3, 42)));
}

TEST_F(DPUtilsTest, testDecodingTheEmptyLocationIntoAStreamWritesAnAsterisk) {
  std::ostringstream stream;

  dputil::DecodeLid(0, stream);

  EXPECT_EQ(stream.str(), "*");
}

TEST_F(DPUtilsTest, testSplittingSeparatesAtEveryDelimiter) {
  EXPECT_EQ(split_into("a=b=c", '='), (std::vector<std::string>{"a", "b", "c"}));
}

TEST_F(DPUtilsTest, testSplittingInputWithoutTheDelimiterYieldsTheInput) {
  EXPECT_EQ(split_into("abc", '='), (std::vector<std::string>{"abc"}));
}

TEST_F(DPUtilsTest, testSplittingKeepsEmptyFieldsBetweenDelimiters) {
  EXPECT_EQ(split_into("a==c", '='), (std::vector<std::string>{"a", "", "c"}));
}

// getline() reports no field after a trailing delimiter, which is why a dp.conf line ending in
// '=' parses as one field and is skipped by readRuntimeInfo()
TEST_F(DPUtilsTest, testSplittingDropsAnEmptyFieldAtTheEnd) {
  EXPECT_EQ(split_into("a=", '='), (std::vector<std::string>{"a"}));
}

TEST_F(DPUtilsTest, testSplittingEmptyInputYieldsNoFields) { EXPECT_TRUE(split_into("", '=').empty()); }

TEST_F(DPUtilsTest, testAnExistingFileIsReported) {
  const TemporaryFile file("");

  EXPECT_TRUE(dputil::FileExists(file.path()));
}

TEST_F(DPUtilsTest, testAMissingFileIsNotReported) { EXPECT_FALSE(dputil::FileExists("/nonexistent/discopop/test/file")); }

// The file mapping is what dp-fmap writes: one "<id>\t<path>" line per source file of the target.
TEST_F(DPUtilsTest, testTheFileIdOfAMappedPathIsFound) {
  const TemporaryFile mapping("1\t/tmp/first.cpp\n2\t/tmp/second.cpp\n");

  EXPECT_EQ(dputil::GetFileId(mapping.path(), "/tmp/second.cpp"), 2);
}

TEST_F(DPUtilsTest, testAnUnmappedPathHasNoFileId) {
  const TemporaryFile mapping("1\t/tmp/first.cpp\n");

  EXPECT_EQ(dputil::GetFileId(mapping.path(), "/tmp/other.cpp"), 0);
}

TEST_F(DPUtilsTest, testAMissingFileMappingHasNoFileId) {
  EXPECT_EQ(dputil::GetFileId("/nonexistent/discopop/test/FileMapping.txt", "/tmp/first.cpp"), 0);
}

// lines that are not "<id>\t<path>" are skipped rather than taken apart
TEST_F(DPUtilsTest, testLinesWithoutExactlyTwoFieldsAreIgnored) {
  const TemporaryFile mapping("garbage\n1\t/tmp/first.cpp\t/tmp/extra.cpp\n2\t/tmp/second.cpp\n");

  EXPECT_EQ(dputil::GetFileId(mapping.path(), "/tmp/second.cpp"), 2);
}

TEST_F(DPUtilsTest, testTheFirstMatchingLineDecidesTheFileId) {
  const TemporaryFile mapping("1\t/tmp/first.cpp\n2\t/tmp/first.cpp\n");

  EXPECT_EQ(dputil::GetFileId(mapping.path(), "/tmp/first.cpp"), 1);
}

// readRuntimeInfo() looks for dp.conf next to the executable, so the directory has to be the one
// the running binary lives in
TEST_F(DPUtilsTest, testTheExecutableDirectoryIsTheOneOfTheRunningBinary) {
  char resolved[PATH_MAX];
  const ssize_t length = ::readlink("/proc/self/exe", resolved, sizeof(resolved) - 1);
  ASSERT_NE(length, -1);
  resolved[length] = '\0';

  const std::string expected = std::string(resolved).substr(0, std::string(resolved).find_last_of('/'));

  EXPECT_EQ(dputil::GetExeDir(), expected);
}

TEST_F(DPUtilsTest, testTheExecutableDirectoryHasNoTrailingSeparator) {
  const std::string directory = dputil::GetExeDir();

  ASSERT_FALSE(directory.empty());
  EXPECT_NE(directory.back(), '/');
}
