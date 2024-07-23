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

string DiscoPoP::determineVariableDefLine(Instruction *I) {
  string varDefLine{"LineNotFound"};

  bool isGlobal = false;
  string varName = determineVariableName_static(&*I, isGlobal, true, "");
  // varName = refineVarName(varName);
  varName = (varName.find(".addr") == varName.npos) ? varName : varName.erase(varName.find(".addr"), 5);
  // varName.erase(varName.find(".addr"), 5);
  // size_t pos = varName.find(".addr");
  // if (pos != varName.npos)
  //     varName.erase(varName.find(".addr"), 5);

  string varType = determineVariableType(&*I);

  if (programGlobalVariablesSet.count(varName)) {
    varDefLine = "GlobalVar";
    // Find definition line of global variables
    GlobalVariable *globalVariable = I->getParent()->getParent()->getParent()->getGlobalVariable(StringRef(varName));
    if (globalVariable) {
      MDNode *metadata = globalVariable->getMetadata("dbg");
      if (metadata) {
        if (isa<DIGlobalVariableExpression>(metadata)) {
          varDefLine =
              to_string(fileID) + ":" +
              to_string(cast<DIGlobalVariableExpression>(globalVariable->getMetadata("dbg"))->getVariable()->getLine());
        }
      }
    }
  }

  // Start from the beginning of a function and look for the variable
  Function *F = I->getFunction();
  for (Function::iterator FI = F->begin(), FE = F->end(); FI != FE; ++FI) {
    BasicBlock &BB = *FI;
    for (BasicBlock::iterator BI = BB.begin(), E = BB.end(); BI != E; ++BI) {
      if (DbgDeclareInst *DI = dyn_cast<DbgDeclareInst>(BI)) {

        if (auto *N = dyn_cast<MDNode>(DI->getVariable())) {
          if (auto *DV = dyn_cast<DILocalVariable>(N)) {
            if (varType.find("ARRAY") != string::npos || varType.find("STRUCT") != string::npos) {
              if (DV->getName() == varName) {
                varDefLine = to_string(fileID) + ":" + to_string(DV->getLine());
                break;
              }
            } else {
              string vn = "----";
              bool isGlobal;
              AllocaInst *AI = dyn_cast_or_null<AllocaInst>(DI->getAddress());
              if (AI) {
                for (User *U : AI->users()) {
                  if (StoreInst *SI = dyn_cast<StoreInst>(U)) {
                    vn = determineVariableName_static(&*SI, isGlobal, true, "");
                    break;
                  } else if (LoadInst *LI = dyn_cast<LoadInst>(U)) {
                    vn = determineVariableName_static(&*LI, isGlobal, true, "");
                    break;
                  }
                }
                if (vn == varName || vn == varName + ".addr") {
                  varDefLine = to_string(fileID) + ":" + to_string(DV->getLine());
                  break;
                }
              }
            }
          }
        }
      }
    }
  }
  return varDefLine;
}