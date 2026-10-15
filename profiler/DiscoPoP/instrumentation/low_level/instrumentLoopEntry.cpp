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

#include <string>
#include <vector>

#include "DiscoPoP.hpp"

using llvm::BasicBlock;
using llvm::CallInst;
using llvm::cast;
using llvm::ConstantInt;
using llvm::Function;
using llvm::isa;
using llvm::PHINode;
using llvm::StringRef;
using llvm::Value;

void DiscoPoP::InstrumentLoopEntry(BasicBlock* bb, std::int32_t id) {
  BasicBlock* current_bb = bb;
  std::vector<Value*> args;
  LID lid = 0;

  // Take care of the order of instrumentation functions for loop entry
  // and exit. Loop exit must appear before the next loop entry.
  // Usually every loop has a .end block as the exit block, thus the
  // exit of a loop will not be the entry of another loop. The first if
  // check is just in case the blocks are organized in a abnormal way.
  for (BasicBlock::iterator bi = current_bb->begin(), ei = current_bb->end(); bi != ei; ++bi) {
    if (isa<CallInst>(bi)) {
      Function* tmp_f = (cast<CallInst>(bi))->getCalledFunction();
      StringRef tmp_fn = tmp_f->getName();
      if (tmp_fn.find("__dp_loop_exit") != std::string::npos) {
        continue;
      }
    }
    lid = dputil::GetLid(&*bi, file_id);
    if (lid > 0 && !isa<PHINode>(bi)) {
      args.push_back(LidConstant(lid));
      args.push_back(ConstantInt::get(int32_, id));
      args.push_back(ConstantInt::get(
          int32_, 0));  // instruction id will be replaced after the assignment of unique instruction ids
      CallInst::Create(dp_loop_entry_, args, "", bi);
      break;
    }
  }
  // assert((lid > 0) && "Loop entry is not instrumented because LID are all
  // invalid for the whole basic block.");
}
