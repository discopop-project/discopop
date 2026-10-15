#include <gtest/gtest.h>

#include "DPUtils.hpp"
#include "lid_constants.hpp"

#include "llvm/IR/DIBuilder.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Module.h"

#include <cstdlib>
#include <fstream>
#include <string>

// Tests for dputil::getLID (profiler/share/lib/DPUtils.cpp): how the file id and the line of an
// instruction are packed into a LID.
//
// getLID reads the file mapping through DOT_DISCOPOP / DP_PROJECT_ROOT_DIR and caches it for the
// rest of the process, so the suite writes its mapping once, before the first call.

namespace {

constexpr const char *PROJECT_DIR = "/dp_test_project";

class LidTest : public ::testing::Test {
protected:
  static void SetUpTestSuite() {
    char dir_template[] = "/tmp/dp_pass_ut_XXXXXX";
    const char *dir = mkdtemp(dir_template);
    ASSERT_NE(dir, nullptr);
    setenv("DOT_DISCOPOP", dir, 1);
    setenv("DP_PROJECT_ROOT_DIR", PROJECT_DIR, 1);

    std::ofstream mapping(std::string(dir) + "/FileMapping.txt");
    mapping << "1\t" << PROJECT_DIR << "/a.cpp\n";
    mapping << MAXFILEID << "\t" << PROJECT_DIR << "/last.cpp\n";
    mapping << MAXFILEID + 1 << "\t" << PROJECT_DIR << "/one_too_many.cpp\n";
  }

  // An instruction located at `line` of `directory`/`file`.
  llvm::Instruction *makeInstruction(const std::string &directory, const std::string &file, unsigned line) {
    llvm::DIBuilder dib(module);
    llvm::DIFile *di_file = dib.createFile(file, directory);
    llvm::DISubroutineType *type = dib.createSubroutineType(dib.getOrCreateTypeArray({}));
    llvm::DISubprogram *subprogram = dib.createFunction(di_file, "f", "f", di_file, line, type, line,
                                                        llvm::DINode::FlagZero, llvm::DISubprogram::SPFlagZero);

    llvm::Function *function = llvm::Function::Create(llvm::FunctionType::get(llvm::Type::getVoidTy(context), false),
                                                      llvm::GlobalValue::ExternalLinkage, "f", module);
    function->setSubprogram(subprogram);
    llvm::IRBuilder<> builder(llvm::BasicBlock::Create(context, "entry", function));
    llvm::Instruction *instruction = builder.CreateRetVoid();
    instruction->setDebugLoc(llvm::DILocation::get(context, line, 0, subprogram));
    return instruction;
  }

  llvm::LLVMContext context;
  llvm::Module module{"lid_test", context};
};

} // namespace

TEST_F(LidTest, testLidOfAMappedFileIsFileIdAndLine) {
  llvm::Instruction *instruction = makeInstruction(PROJECT_DIR, "a.cpp", 42);
  int32_t file_id = 0;

  EXPECT_EQ(dputil::getLID(instruction, file_id), (static_cast<int64_t>(1) << LIDSIZE) + 42);
  EXPECT_EQ(file_id, 1);
}

TEST_F(LidTest, testInstructionWithoutDebugLocationHasNoLid) {
  llvm::Instruction *instruction = makeInstruction(PROJECT_DIR, "a.cpp", 42);
  instruction->setDebugLoc(llvm::DebugLoc());
  int32_t file_id = 0;

  EXPECT_EQ(dputil::getLID(instruction, file_id), 0);
}

TEST_F(LidTest, testFileOutsideOfTheProjectHasNoLid) {
  // 0 means "no location" and the callers do not instrument the instruction. The result used to be -1,
  // which was instrumented as the location 262143:16383.
  llvm::Instruction *instruction = makeInstruction("/elsewhere", "b.cpp", 7);
  int32_t file_id = 0;

  EXPECT_EQ(dputil::getLID(instruction, file_id), 0);
  EXPECT_EQ(file_id, 0);
}

TEST_F(LidTest, testTheLastLineOfAFileHasALid) {
  llvm::Instruction *instruction = makeInstruction(PROJECT_DIR, "a.cpp", MAXLNO - 1);
  int32_t file_id = 0;

  const int64_t lid = dputil::getLID(instruction, file_id);

  EXPECT_EQ(lid, (static_cast<int64_t>(1) << LIDSIZE) + MAXLNO - 1);
  EXPECT_EQ(dputil::decodeLID(lid), "1:" + std::to_string(MAXLNO - 1));
}

TEST_F(LidTest, testALineTheLidCannotHoldHasNoLid) {
  // the line would have changed the file id of the location
  llvm::Instruction *instruction = makeInstruction(PROJECT_DIR, "a.cpp", MAXLNO);
  int32_t file_id = 0;

  EXPECT_EQ(dputil::getLID(instruction, file_id), 0);
}

TEST_F(LidTest, testTheLastFileIdHasALidWithoutASign) {
  // file id and line fill the 32 bits of the location: the highest file id sets bit 31, which must neither
  // turn the LID negative nor be lost by decoding
  llvm::Instruction *instruction = makeInstruction(PROJECT_DIR, "last.cpp", MAXLNO - 1);
  int32_t file_id = 0;

  const int64_t lid = dputil::getLID(instruction, file_id);

  EXPECT_EQ(file_id, MAXFILEID);
  EXPECT_EQ(lid, 0xFFFFFFFFLL);
  EXPECT_EQ(dputil::decodeLID(lid), std::to_string(MAXFILEID) + ":" + std::to_string(MAXLNO - 1));
}

TEST_F(LidTest, testAFileIdTheLidCannotHoldHasNoLid) {
  llvm::Instruction *instruction = makeInstruction(PROJECT_DIR, "one_too_many.cpp", 1);
  int32_t file_id = 0;

  EXPECT_EQ(dputil::getLID(instruction, file_id), 0);
}

TEST(EncodeLidTest, testEncodeLidPacksFileAndLine) {
  EXPECT_EQ(dputil::encodeLID(3, 42), (static_cast<int64_t>(3) << LIDSIZE) + 42);
  EXPECT_EQ(dputil::encodeLID(MAXFILEID, MAXLNO - 1), 0xFFFFFFFFLL);
}

TEST(EncodeLidTest, testEncodeLidRejectsWhatDoesNotFit) {
  EXPECT_EQ(dputil::encodeLID(3, MAXLNO), 0);
  EXPECT_EQ(dputil::encodeLID(3, -1), 0);
  EXPECT_EQ(dputil::encodeLID(MAXFILEID + 1, 1), 0);
  EXPECT_EQ(dputil::encodeLID(-1, 1), 0);
}
