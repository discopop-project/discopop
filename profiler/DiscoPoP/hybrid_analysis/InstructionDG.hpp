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
#include "InstructionCFG.hpp"
#include "unordered_map"
#include <string>

class InstructionDG : public Graph<llvm::Instruction *> {

private:
  dputil::VariableNameFinder *VNF;
  InstructionCFG *CFG;
  std::set<llvm::Instruction *> highlightedInstructionNodes;
  int32_t fid;

  void recursiveDepChecker(std::set<llvm::Instruction *> *checkedInstructions, llvm::Instruction *I, llvm::Instruction *C);

  void recursiveDepFinder(std::set<llvm::Instruction *> *checkedInstructions, llvm::Instruction *I);

public:
  InstructionDG(dputil::VariableNameFinder *_VNF, InstructionCFG *_CFG, int32_t _fid);

  bool edgeIsINIT(Edge<llvm::Instruction *> *e);

  std::string edgeToDPDep(Edge<llvm::Instruction *> *e, std::unordered_map<std::string, std::pair<std::string, std::string>> &staticValueNameToMemRegIDMap);
  std::string edgeToInstructionBasedDPDep(Edge<llvm::Instruction *> *e, std::unordered_map<std::string, std::pair<std::string, std::string>> &staticValueNameToMemRegIDMap);

  void highlightInstructionNode(llvm::Instruction *instr);

  void dumpToDot(const std::string targetPath);

  std::string getInstructionLine(llvm::Instruction *I);

  std::string getInitEdgeInstructionLine(Edge<llvm::Instruction *> *e);

  std::string getValueNameAndMemRegIDFromEdge(Edge<llvm::Instruction *> *e, std::unordered_map<std::string, std::pair<std::string, std::string>> &staticValueNameToMemRegIDMap);

};
