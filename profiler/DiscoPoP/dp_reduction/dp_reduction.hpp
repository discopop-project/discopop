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
llvm::Instruction *find_reduction_instr(llvm::Value *val);

// Retrieves the reduction operation for the operand that is stored by the 'store_instr' (if such a reduction
// operation exists). 'load_instr' will point to the load instruction that actually loads the value.
llvm::Instruction *get_reduction_instr(llvm::Instruction *store_instr, llvm::Instruction **load_instr);

// Finds the load instruction that actually loads the value from the address 'load_val'.
llvm::Instruction *get_load_instr(llvm::Value *load_val, llvm::Instruction *cur_instr,
                                  std::vector<char> &reduction_operations);

// the value that is stored or loaded by a store / load instruction
llvm::Value *get_var(llvm::Instruction *instr);
llvm::Value *get_var_rec(llvm::Value *val);

// returns the value that the GetElementPtrInst ultimately points to
llvm::Value *points_to_var(llvm::GetElementPtrInst *instr);

// finds the previous use of 'val'
llvm::Instruction *get_prev_use(llvm::Instruction *instr, llvm::Value *val);

// a char describing the opcode, e.g. '+' for Add or FAdd, and the order of the operations
char get_char_for_opcode(llvm::Instruction *instr);
int get_op_order(char c);

std::string determineVariableType(llvm::Instruction *I);
llvm::Type *pointsToStruct(llvm::PointerType *PTy);

inline bool loc_exists(llvm::DebugLoc const &loc) { return static_cast<bool>(loc); }

// the location of an instruction as a LID of the line only, and whether a block has an instruction with one
LID getLID(llvm::Instruction *BI, int32_t &fileID);
bool sanityCheck(llvm::BasicBlock *BB, int file_id);

// true, if searchedValue is used within the computation of parentValue
bool check_value_usage(llvm::Value *parentValue, llvm::Value *searchedValue);

// true, if the function contains inlined code
bool inlinedFunction(llvm::Function *F);

// the line at which the loop L of the function F ends, as a string, or "LOOPENDNOTFOUND"
std::string CFA(llvm::Function &F, llvm::Loop *L, int file_id);

} // namespace dp_reduction
