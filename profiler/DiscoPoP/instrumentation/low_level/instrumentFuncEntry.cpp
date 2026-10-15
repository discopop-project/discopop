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

using llvm::ArrayType;
using llvm::BasicBlock;
using llvm::ConstantInt;
using llvm::Function;
using llvm::GlobalVariable;
using llvm::IRBuilder;
using llvm::Instruction;
using llvm::PHINode;
using llvm::StringRef;
using llvm::Type;
using llvm::Value;
using llvm::cast;
using llvm::errs;
using llvm::isa;

void DiscoPoP::InstrumentFuncEntry(Function &f) {
  BasicBlock &entry_bb = f.getEntryBlock();
  LID lid = 0;
  std::int32_t is_start = 0;

  StringRef fn = f.getName();
  if (fn.str() == "main"){
    is_start = 1;
    // insert 'allocations' of global variables
    Instruction *insert_before = &*entry_bb.begin();

    auto tmp_end = f.getParent()->global_end();
    tmp_end--; // necessary, since the list of Globals is modified when e.g. new
               // strings are created.
    for (auto global_it = f.getParent()->global_begin(); global_it != tmp_end; global_it++) {
      // ignore globals which make use of "Appending Linkage", since they are
      // system internal and do not behave like regular values. An example for
      // such a value is @llvm.global_ctors
      if (cast<GlobalVariable>(&*global_it)->hasAppendingLinkage()) {
        continue;
      }

      IRBuilder<> irb(insert_before->getNextNode());

      std::vector<Value *> args;
      args.push_back(LidConstant(lid));
      args.push_back(GetOrInsertVarNameDynamic(global_it->getName().str(), irb));

      // Value *startAddr = PtrToIntInst::CreatePointerCast(toInstrument, Int64,
      // "", toInstrument->getNextNonDebugInstruction());
      Value *start_addr = irb.CreatePtrToInt(cast<Value>(&*global_it), int64_, "");
      args.push_back(start_addr);

      Value *end_addr = start_addr;
      std::uint64_t num_elements = 1;
      std::uint64_t allocated_size = global_it->getValueType()->getScalarSizeInBits();
      if (global_it->getValueType()->isArrayTy()) {
        // unpack potentially multidimensional allocations
        Type *type_to_parse = global_it->getValueType();
        Type *element_type;

        // unpack multidimensional allocations
        while (type_to_parse->isArrayTy()) {
          // extract size from current dimension and multiply to numElements
          num_elements *= cast<ArrayType>(type_to_parse)->getNumElements();
          // proceed one dimension
          type_to_parse = type_to_parse->getArrayElementType();
        }
        // typeToParse now contains the element type
        element_type = type_to_parse;

        // allocated size = Element size in Bytes * Number of elements
        auto element_size_in_bytes = element_type->getScalarSizeInBits() / 8;
        allocated_size = element_size_in_bytes * num_elements;

        // endAddr = startAddr + allocated size
        end_addr = irb.CreateAdd(start_addr, ConstantInt::get(int64_, allocated_size));
      }

      args.push_back(end_addr);
      args.push_back(ConstantInt::get(int64_, allocated_size));
      args.push_back(ConstantInt::get(int64_, num_elements));
      // REMOVED TO FIX INCORRECT STACK ADDRESS TRACKING
      // TODO: maybe replace with explicit registration of global variables
      // IRB.CreateCall(DpAlloca, args, "");
    }
  }

  // We always want to insert __dp_func_entry at the beginning
  // of the basic block, but we need the first valid LID to
  // get the entry line of the function.
  for (BasicBlock::iterator bi = entry_bb.begin(), ei = entry_bb.end(); bi != ei; ++bi) {
    lid = dputil::GetLid(&*bi, file_id);
    if (lid > 0 && !isa<PHINode>(bi)) {
      IRBuilder<> irb(&*entry_bb.begin());
      // the third argument (function entry id) is set to the call's own instruction id in
      // update_argument_instruction_ids
      irb.CreateCall(dp_func_entry_, {LidConstant(lid), ConstantInt::get(int32_, is_start), ConstantInt::get(int32_, 0)});
      if (kDpDebug) {
        errs() << "DiscoPoP: funcEntry instrumented\n";
      }
      break;
    }
  }
  assert((lid > 0) && "Function entry is not instrumented because LID are all "
                      "invalid for the entry block.");
}
