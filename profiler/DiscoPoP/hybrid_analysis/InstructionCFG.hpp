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

#include "Graph.hpp"
#include "llvm/IR/DebugInfoMetadata.h"
#include "llvm/IR/DebugLoc.h"
#include "llvm/IR/Instructions.h"
#include "llvm/Support/Debug.h"
#include <llvm/Support/raw_ostream.h>
#include <cstdint>
#include <string>

#include "DPUtils.hpp"

class InstructionCFG : public Graph<llvm::Instruction *> {

private:
  // the artificial instructions the CFG starts and ends with: ids, not addresses of instructions
  static constexpr std::uintptr_t ENTRY = 1000000;
  static constexpr std::uintptr_t EXIT = 2000000;

  InstructionNode<llvm::Instruction *> *entry;
  InstructionNode<llvm::Instruction *> *exit;
  dputil::VariableNameFinder *VNF;
  std::set<llvm::Instruction *> highlightedInstructionNodes;

  void findAndAddFirstRelevantInstructionInSuccessorBlocks(llvm::BasicBlock *BB, llvm::Instruction *previousInstruction, std::set<std::pair<llvm::BasicBlock*, llvm::Instruction*>> *visited);

public:
  InstructionCFG(dputil::VariableNameFinder *_VNF, llvm::Function &F);

  InstructionNode<llvm::Instruction *> *getEntry() { return entry; }

  InstructionNode<llvm::Instruction *> *getExit() { return exit; }

  bool isEntryOrExit(llvm::Instruction *I) {
    return Graph::getInstructionNode(I) == entry || Graph::getInstructionNode(I) == exit;
  }

  void highlightInstructionNode(llvm::Instruction *instr);

  void dumpToDot(const std::string targetPath);
};
