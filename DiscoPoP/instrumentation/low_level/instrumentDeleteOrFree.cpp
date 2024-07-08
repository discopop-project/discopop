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

#include "../../DiscoPoP.hpp"

void DiscoPoP::instrumentDeleteOrFree(CallBase *toInstrument) {
  // add instrumentation for delete instructions or calls to free
  LID lid = getLID(toInstrument, fileID);
  if (lid == 0)
    return;
  IRBuilder<> IRB(toInstrument->getNextNonDebugInstruction());

  vector<Value *> args;
  args.push_back(ConstantInt::get(Int32, lid));

  Value *startAddr =
      PtrToIntInst::CreatePointerCast(toInstrument->getArgOperand(0), Int64, "", toInstrument->getNextNode());

  args.push_back(startAddr);

  IRB.CreateCall(DpDelete, args, "");
}