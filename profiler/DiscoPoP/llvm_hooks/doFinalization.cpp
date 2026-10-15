/*
 * This file is part of the DiscoPoP software
 * (http://www.discopop.tu-darmstadt.de)
 *
 * Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
 *
 * This software may be modified and distributed under the terms of
 * the 3-Clause BSD License. See the LICENSE file in the package base
 * directory for details.
 *
 */

#include "DiscoPoP.hpp"

#include "llvm/Transforms/Utils/ModuleUtils.h"

using namespace llvm;
using namespace std;
using namespace dputil;

bool DiscoPoP::doFinalization(Module &M) {
  // unique InstructionID assignment
  // write the current count of unique instructions to a file to avoid duplication between modules.
  profiler_files::writeCounter("DP_InstructionIDCounter.txt", InstructionIDCounter);
  // unique InstructionID assignment end

  // unique CallpathStateID assignment
  // write the current count of unique callpath states to a file to avoid duplication between modules.
  profiler_files::writeCounter("DP_CallpathStateIDCounter.txt", CallpathStateIDCounter);
  // unique CallpathStateID assignment end

  // CUGeneration
  // write the current count of CUs to a file to avoid duplicate CUs.
  profiler_files::writeCounter("DP_CUIDCounter.txt", CUIDCounter);
  // CUGeneration end

  // DPInstrumentationOmission
  // Hand the dependencies of the instructions whose profiling was omitted over
  // to the runtime. Their __dp_read / __dp_write / __dp_alloca calls have been
  // erased (see runOnFunction), so this string is the only remaining record of
  // those dependencies.
  //
  // bbDepString covers the functions of THIS module only, and a module which
  // does not define main has no __dp_finalize call to attach the handover to.
  // Attaching it there therefore silently dropped the dependencies of every
  // translation unit but one, which turned e.g. a reduction variable in a
  // non-main file into an apparently private one. Registering from a module
  // constructor reaches every translation unit regardless of compilation order;
  // the runtime only records the string there and parses it during
  // __dp_finalize, once it knows which basic blocks were executed.
  if (!bbDepString.empty()) {
    Function *registration =
        Function::Create(FunctionType::get(Void, false), GlobalValue::InternalLinkage,
                         "__dp_register_bb_deps." + M.getModuleIdentifier(), &M);
    IRBuilder<> builder(BasicBlock::Create(M.getContext(), "entry", registration));
    Value *V = builder.CreateGlobalStringPtr(StringRef(bbDepString), ".dp_bb_deps");
    builder.CreateCall(M.getOrInsertFunction("__dp_add_bb_deps", Void, CharPtr), {V});
    builder.CreateRetVoid();
    appendToGlobalCtors(M, registration, 0);
  }
  // write the current count of BBs to a file to avoid duplicate BBids
  profiler_files::writeCounter("DP_BBDepCounter.txt", bbDepCount);

  // DPInstrumentationOmission end
  return true;
}
