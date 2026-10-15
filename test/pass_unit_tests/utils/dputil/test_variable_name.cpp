#include <gtest/gtest.h>

#include "DPUtils.hpp"

#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Module.h"

// Tests for dputil::VariableNameFinder::getVarName (profiler/share/lib/DPUtils.cpp): the names the
// hybrid analysis identifies the memory regions of a function by.

namespace {

class VariableNameTest : public ::testing::Test {
protected:
  VariableNameTest() {
    function = llvm::Function::Create(llvm::FunctionType::get(llvm::Type::getVoidTy(context), {llvm::Type::getInt64Ty(context)}, false),
                                      llvm::GlobalValue::ExternalLinkage, "f", module);
    builder.SetInsertPoint(llvm::BasicBlock::Create(context, "entry", function));
    struct_type = llvm::StructType::create(context, {builder.getInt32Ty(), builder.getInt32Ty()}, "struct.S");
  }

  llvm::LLVMContext context;
  llvm::Module module{"variable_name_test", context};
  llvm::IRBuilder<> builder{context};
  llvm::Function *function;
  llvm::StructType *struct_type;
  dputil::VariableNameFinder finder{module};
};

} // namespace

TEST_F(VariableNameTest, testAnAllocaIsNamedLikeItsValue) {
  llvm::Value *s = builder.CreateAlloca(struct_type, nullptr, "s");

  EXPECT_EQ(finder.getVarName(s), "s");
}

TEST_F(VariableNameTest, testAnElementIsNamedLikeTheObjectItBelongsTo) {
  llvm::Value *s = builder.CreateAlloca(struct_type, nullptr, "s");
  llvm::Value *member = builder.CreateStructGEP(struct_type, s, 1);

  EXPECT_EQ(finder.getVarName(member), "s");
}

TEST_F(VariableNameTest, testAnElementOfAnArrayOfStructsWithAVariableIndexIsNamedLikeTheArray) {
  // a[i].y: the first index is not a constant, which getVarName used to dereference as one
  llvm::Value *a = builder.CreateAlloca(struct_type, builder.getInt32(8), "a");
  llvm::Value *index = function->getArg(0);
  llvm::Value *member = builder.CreateGEP(struct_type, a, {index, builder.getInt32(1)});

  EXPECT_EQ(finder.getVarName(member), "a");
}
