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
#include "llvm_compat.hpp"

using llvm::CallBase;
using llvm::CallInst;
using llvm::IRBuilder;
using llvm::Instruction;
using llvm::InvokeInst;
using llvm::PtrToIntInst;
using llvm::Value;
using llvm::cast;
using llvm::isa;

void DiscoPoP::instrumentCalloc(CallBase *toInstrument) {
  // add instrumentation for calls to calloc
  LID lid = dputil::getLID(toInstrument, fileID);
  if (lid == 0) {
    return;
}

  // Determine correct placement for the call to __dp_new
  Instruction *nextInst = nullptr;
  if (isa<CallInst>(toInstrument)) {
    nextInst = llvmcompat::nextInstruction(toInstrument);
  } else if (isa<InvokeInst>(toInstrument)) {
    // Invoke instructions are always located at the end of a basic block.
    // Invoke instructions may throw errors, in which case the successor is a
    // "landing pad" basic block. If no error is thrown, the control flow is
    // resumed at a "normal destination" basic block. Set the first instruction
    // of the normal destination as nextInst in order to add the Instrumentation
    // at the correct location.
    nextInst = &*cast<InvokeInst>(toInstrument)->getNormalDest()->getFirstNonPHIOrDbg();
  }

  IRBuilder<> IRB(nextInst);

  std::vector<Value *> args;
  args.push_back(lidConstant(lid));

  Value *startAddr = PtrToIntInst::CreatePointerCast(toInstrument, Int64, "", nextInst->getIterator());
  Value *endAddr = startAddr;
  Value *numBytes = IRB.CreateMul(toInstrument->getArgOperand(0), toInstrument->getArgOperand(1));

  args.push_back(startAddr);
  args.push_back(endAddr); // currently unused
  args.push_back(numBytes);

  IRB.CreateCall(DpNew, args, "");
}
