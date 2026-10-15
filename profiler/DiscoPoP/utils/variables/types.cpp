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

using llvm::GetElementPtrInst;
using llvm::Instruction;
using llvm::PointerType;
using llvm::StoreInst;
using llvm::Type;
using llvm::Value;
using llvm::cast;
using llvm::isa;
using llvm::raw_string_ostream;

std::string DiscoPoP::DetermineVariableType(Instruction *i) {
  std::string s = "";
  std::string type_str;
  int index = isa<StoreInst>(i) ? 1 : 0;
  raw_string_ostream rso(type_str);
  (*((i->getOperand(index))->getType())).print(rso);

  Value *operand = i->getOperand(index);

  if (operand->hasName()) {
    if (isa<GetElementPtrInst>(*operand)) {
      GetElementPtrInst *gep = cast<GetElementPtrInst>(operand);
      Value *ptr_operand = gep->getPointerOperand();
      PointerType *p_ty = cast<PointerType>(ptr_operand->getType());
      // we've found a struct/class
      Type *struct_type = PointsToStruct(p_ty);
      if (struct_type && gep->getNumOperands() > 2) {
        s = "STRUCT,";
      }

      // we've found an array
      // Note (25-10-30) Simplified for LLVM19 compatibility
      //if (PTy->getPointerElementType()->getTypeID() == Type::ArrayTyID) {
      //  s = "ARRAY,";
      //} else {
        // check if previous instruction is a GEP as well. If so, an Array has
        // been found (e.g. double**)
        Value *prev_inst = cast<Instruction>(gep)->getOperand(0);
        if (isa<GetElementPtrInst>(prev_inst)) {
          s = "ARRAY,";
        } else if (prev_inst->getType()->isPointerTy()) {
          s = "ARRAY,";
        }
      //}
    }
  }

  s = s + rso.str();
  return s;
}
