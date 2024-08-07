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

#include "../DiscoPoP.hpp"

bool DiscoPoP::doFinalization(Module &M) {
  // CUGeneration

  // write the current count of CUs to a file to avoid duplicate CUs.
  outCUIDCounter = new std::ofstream();
  std::string tmp(getenv("DOT_DISCOPOP_PROFILER"));
  tmp += "/DP_CUIDCounter.txt";
  outCUIDCounter->open(tmp.data(), std::ios_base::out);
  if (outCUIDCounter && outCUIDCounter->is_open()) {
    *outCUIDCounter << CUIDCounter;
    outCUIDCounter->flush();
    outCUIDCounter->close();
  }
  // CUGeneration end

  // DPInstrumentationOmission
  for (Function &F : M) {
    if (!F.hasName() || F.getName() != "main")
      continue;
    for (BasicBlock &BB : F) {
      for (Instruction &I : BB) {
        if (CallInst *call_inst = dyn_cast<CallInst>(&I)) {
          if (Function *Fun = call_inst->getCalledFunction()) {
            if (Fun->getName() == "__dp_finalize") {
              IRBuilder<> builder(call_inst);
              Value *V = builder.CreateGlobalStringPtr(StringRef(bbDepString), ".dp_bb_deps");
              CallInst::Create(F.getParent()->getOrInsertFunction("__dp_add_bb_deps", Void, CharPtr), V, "", call_inst);
            }
          }
        }
      }
    }
  }
  // write the current count of BBs to a file to avoid duplicate BBids
  outBBDepCounter = new std::ofstream();
  std::string tmp2(getenv("DOT_DISCOPOP_PROFILER"));
  tmp2 += "/DP_BBDepCounter.txt";
  outBBDepCounter->open(tmp2.data(), std::ios_base::out);
  if (outBBDepCounter && outBBDepCounter->is_open()) {
    *outBBDepCounter << bbDepCount;
    outBBDepCounter->flush();
    outBBDepCounter->close();
  }

  // DPInstrumentationOmission end
  return true;
}
