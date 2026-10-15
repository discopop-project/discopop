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
using llvm::IRBuilder;
using llvm::PtrToIntInst;
using llvm::Value;

void DiscoPoP::instrumentDeleteOrFree(CallBase *toInstrument) {
  // add instrumentation for delete instructions or calls to free
  LID lid = dputil::getLID(toInstrument, fileID);
  if (lid == 0) {
    return;
}
  IRBuilder<> IRB(llvmcompat::nextInstruction(toInstrument));

  std::vector<Value *> args;
  args.push_back(lidConstant(lid));

  Value *startAddr =
      PtrToIntInst::CreatePointerCast(toInstrument->getArgOperand(0), Int64, "", toInstrument->getNextNode()->getIterator());

  args.push_back(startAddr);

  IRB.CreateCall(DpDelete, args, "");
}
