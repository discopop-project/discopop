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

#include "Enums.hpp"
#include "Globals.hpp"
#include "lid_constants.hpp"

#include "llvm/Analysis/LoopInfo.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/Instruction.h"
#include "llvm/IR/Instructions.h"
#include <map>
#include <set>
#include <string>
#include <vector>

// the identity of a loop in the output of the pass, as written to loopstate_positions.txt: the id of its
// loop node in Data.xml and its start location (file_id:line)
struct LoopIdentity {
  std::string pet_node_id;
  std::string start_location;
};

using Variable = struct Variable_struct {
  std::string name;
  std::string type;
  std::string defLine;
  std::string isArray;
  bool readAccess;
  bool writeAccess;

  Variable_struct(const Variable_struct &other)
      : name(other.name), type(other.type), defLine(other.defLine), readAccess(other.readAccess),
        writeAccess(other.writeAccess) {}

  Variable_struct(std::string n, std::string t, std::string d, bool readAccess, bool writeAccess)
      : name(n), type(t), defLine(d), readAccess(readAccess), writeAccess(writeAccess) {}

  // We have a set of this struct. The set doesn't know how to order the
  // elements.
  inline bool operator<(const Variable_struct &rhs) const { return name < rhs.name; }

  inline bool operator>(const Variable_struct &rhs) const { return name > rhs.name; }

};

using Node = struct Node_struct {
  std::string ID;
  nodeTypes type;
  LID startLine;
  LID endLine;
  llvm::BasicBlock *BB;

  // Only for func type
  std::string name;
  std::vector<Variable> argumentsList;
  std::set<LID> returnLines;

  std::vector<Node_struct *> childrenNodes;
  Node_struct *parentNode;

  // isRecursive function (Mo 5.11.2019)
  std::string recursiveFunctionCall = "";

  Node_struct() {
    ID = std::to_string(fileID) + ":" + std::to_string(CUIDCounter++);
    parentNode = nullptr;
    BB = nullptr;
  }
};

using CU = struct CU_struct : Node_struct {

  std::string BBID; // BasicBlock Id where the CU appears in

  unsigned readDataSize;  // number of bytes read from memory by the cu
  unsigned writeDataSize; // number of bytes written into memory during the cu
  unsigned instructionsCount;

  // basic block id & successor basic blocks for control dependence
  std::vector<std::string> successorCUs; // keeps IDs of control dependent CUs
  std::string basicBlockName;

  std::set<LID> instructionsLineNumbers;
  std::set<LID> readPhaseLineNumbers;
  std::set<LID> writePhaseLineNumbers;
  std::set<LID> returnInstructions;

  std::set<Variable> localVariableNames;
  std::set<Variable> globalVariableNames;

  bool performsFileIO;

  // Map to record function call line numbers
  std::map<LID, std::vector<Node *>> callLineTofunctionMap;
  // Map to record function call instruction ids
  std::map<LID, std::vector<llvm::Instruction*>> callLineToCallInstructionMap;

  CU_struct() {
    type = nodeTypes::cu;
    readDataSize = 0;
    writeDataSize = 0;
    instructionsCount = 0;
    // BB = NULL;
    performsFileIO = false;
  }

  void removeCU() {
    CUIDCounter--; // if a CU does not contain any instruction, e.g. entry
                   // basic blocks, then remove it.
  }

};

struct instr_info_t {
  std::string var_name_;
  std::string var_type_;
  int loop_line_nr_;
  int file_id_;
  llvm::StoreInst *store_inst_;
  llvm::LoadInst *load_inst_;
  char operation_ = ' ';
};

struct loop_info_t {
  unsigned int line_nr_;
  int file_id_;
  llvm::Instruction *first_body_instr_;
  std::string start_line;
  std::string end_line;
  std::string function_name;
  int loop_id;
};

// The CU graph of one function: built by DiscoPoP::buildCUGraph, written to Data.xml by
// DiscoPoP::writeCUGraph once the function is instrumented (see DiscoPoP::runOnFunction).
struct FunctionCUGraph {
  Node *root = nullptr; // the function node; like the loop nodes, never freed
  std::vector<CU *> CUs; // freed by writeCUGraph
  std::map<std::string, std::vector<CU *>> BBIDToCUs;
  // variables which appear in more than one basic block
  std::set<std::string> globalVariables;
  // id of the loop node in Data.xml per llvm::Loop (read by CFA for loopstate_positions.txt)
  std::map<llvm::Loop *, std::string> loopToPETNodeID;
};
