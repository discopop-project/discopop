/*
 * This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
 *
 * Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
 *
 * This software may be modified and distributed under the terms of
 * the 3-Clause BSD License. See the LICENSE file in the package base
 * directory for details.
 *
 */

#pragma once

#include <llvm/Analysis/LoopInfo.h>
#include <llvm/IR/CallingConv.h>
#include <llvm/IR/DebugInfo.h>
#include <llvm/IR/Function.h>
#include <llvm/IR/IRBuilder.h>
#include <llvm/IR/InstIterator.h>
#include <llvm/IR/Instruction.h>
#include <llvm/IR/Instructions.h>
#include <llvm/IR/Module.h>
#include <llvm/IR/Type.h>
#include <llvm/IR/Verifier.h>
#include <llvm/Pass.h>
#include <llvm/PassSupport.h>
#include <llvm/Support/CommandLine.h>
#include <llvm/Support/Debug.h>
#include <llvm/Support/raw_ostream.h>
#include <string>

#define OLD_CLANG_VER ((__clang_major__ < 4))

namespace util {

bool init_util(std::string fmap_path);
unsigned get_file_id(llvm::Function* func);

// returns a char describing the opcode, e.g. '+' for Add or FAdd
// returns char describing the opcode of the instruction, for rust check if llvm intrinsic instruction
//was generated and return char accordingly
char get_char_for_opcode(llvm::Instruction *cur_instr);

// return true if 'operand' is an operand of the instruction 'instr'
bool is_operand(llvm::Instruction* instr, llvm::Value* operand);

// finds the previous use of 'val'
llvm::Instruction* get_prev_use(llvm::Instruction* instr, llvm::Value* val);

// Get the value that is stored or loaded by a store / load instruction.
llvm::Value* get_var(llvm::Instruction* instr);
llvm::Value* get_var_rec(llvm::Value* val);

// returns the value that the GetElementPtrInst ultimately points to
llvm::Value* points_to_var(llvm::GetElementPtrInst* instr);

inline bool loc_exists(llvm::DebugLoc const& loc) {
  return static_cast<bool>(loc);
}

}  // namespace util
