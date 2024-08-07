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

void DiscoPoP::instrumentStore(StoreInst *toInstrument, int32_t llvm_ir_instruction_id) {

  LID lid = getLID(toInstrument, fileID);
  if (lid == 0)
    return;

  vector<Value *> args;

  // TODO ADD FLAG TO CHECK FOR PERFOGRAPH EXPORT
  // replaced: args.push_back(ConstantInt::get(Int32, lid));
  args.push_back(ConstantInt::get(Int32, llvm_ir_instruction_id));

  Value *memAddr = PtrToIntInst::CreatePointerCast(toInstrument->getPointerOperand(), Int64, "", toInstrument);
  args.push_back(memAddr);

  args.push_back(determineVariableName_dynamic(toInstrument, ""));

#ifdef SKIP_DUP_INSTR
  Twine name = Twine("S").concat(Twine(uniqueNum));

  GlobalVariable *addrTracker = new GlobalVariable(*this->ThisModule,
                                                   Int64, // trackerType
                                                   false, GlobalVariable::PrivateLinkage,
                                                   Constant::getNullValue(Int64), // trackerType
                                                   name);
  GlobalVariable *countTracker = new GlobalVariable(*this->ThisModule, Int64, false, GlobalVariable::PrivateLinkage,
                                                    Constant::getNullValue(Int64), name.concat(Twine("count")));
  uniqueNum++;

  // Load current values before instr
  LoadInst *currentAddrTracker = new LoadInst::LoadInst(addrTracker, Twine(), toInstrument);
  LoadInst *currentCount = new LoadInst::LoadInst(countTracker, Twine(), toInstrument);

  // add instr before before
  args.push_back(currentAddrTracker);
  args.push_back(currentCount);
#endif

  CallInst::Create(DpWrite, args, "", toInstrument);

#ifdef SKIP_DUP_INSTR
  // Post instrumentation call
  // Create updates
  StoreInst *addrUpdate = new StoreInst::StoreInst(memAddr, addrTracker);
  BinaryOperator::BinaryOperator *incCount =
      BinaryOperator::Create(Instruction::Add, currentCount, ConstantInt::get(Int64, 1));
  StoreInst *countUpdate = new StoreInst::StoreInst(incCount, countTracker);

  // add updates after before
  addrUpdate->insertAfter(toInstrument);
  incCount->insertAfter(toInstrument);
  countUpdate->insertAfter(incCount);
#endif
}
