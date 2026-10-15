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

#pragma once

#include "DPUtils.hpp"

#include "llvm/Analysis/LoopInfo.h"
#include "llvm/IR/DebugLoc.h"
#include "llvm/IR/DerivedTypes.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/Value.h"

#include <cstdint>
#include <string>
#include <vector>

// The analysis of the reduction pass: finding the reduction operation of a store and the variable it
// accumulates into. None of it depends on the state of the pass.
namespace dp_reduction {

// returns the reduction instruction where 'val' is the operand if it can find such an operation
llvm::Instruction *FindReductionInstr(llvm::Value *val);

// Retrieves the reduction operation for the operand that is stored by the 'store_instr' (if such a reduction
// operation exists). 'load_instr' will point to the load instruction that actually loads the value.
llvm::Instruction *GetReductionInstr(llvm::Instruction *store_instr, llvm::Instruction **load_instr);

// Finds the load instruction that actually loads the value from the address 'load_val'.
llvm::Instruction *GetLoadInstr(llvm::Value *load_val, llvm::Instruction *cur_instr,
                                  std::vector<char> &reduction_operations);

// the value that is stored or loaded by a store / load instruction
llvm::Value *GetVar(llvm::Instruction *instr);
llvm::Value *GetVarRec(llvm::Value *val);

// returns the value that the GetElementPtrInst ultimately points to
llvm::Value *PointsToVar(llvm::GetElementPtrInst *instr);

// finds the previous use of 'val'
llvm::Instruction *GetPrevUse(llvm::Instruction *instr, llvm::Value *val);

// a char describing the opcode, e.g. '+' for Add or FAdd, and the order of the operations
char GetCharForOpcode(llvm::Instruction *instr);
int GetOpOrder(char c);

std::string DetermineVariableType(llvm::Instruction *i);
llvm::Type *PointsToStruct(llvm::PointerType *p_ty);

inline bool LocExists(llvm::DebugLoc const &loc) { return static_cast<bool>(loc); }

// the location of an instruction as a LID of the line only, and whether a block has an instruction with one
LID GetLid(llvm::Instruction *bi, int32_t &file_id);
bool SanityCheck(llvm::BasicBlock *bb, int file_id);

// true, if searchedValue is used within the computation of parentValue
bool CheckValueUsage(llvm::Value *parent_value, llvm::Value *searched_value);

// true, if the function contains inlined code
bool InlinedFunction(llvm::Function *f);

// the line at which the loop L of the function F ends, as a string, or "LOOPENDNOTFOUND"
std::string CFA(llvm::Function &f, llvm::Loop *l, int file_id);

} // namespace dp_reduction
