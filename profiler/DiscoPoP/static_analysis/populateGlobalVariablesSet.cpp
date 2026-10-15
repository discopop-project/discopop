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

using llvm::BasicBlock;
using llvm::CallInst;
using llvm::LoadInst;
using llvm::Region;
using llvm::StoreInst;
using llvm::isa;

// recieves the region and outputs all variables and variables crossing basic
// block boundaries in the region.
void DiscoPoP::populateGlobalVariablesSet(Region *TopRegion, std::set<std::string> &globalVariablesSet) {

  std::map<std::string, BasicBlock *> variableToBBMap;
  bool isGlobalVariable = false;
  for (Region::block_iterator bb = TopRegion->block_begin(); bb != TopRegion->block_end(); ++bb) {
    for (BasicBlock::iterator instruction = (*bb)->begin(); instruction != (*bb)->end(); ++instruction) {
      if (isa<LoadInst>(instruction) || isa<StoreInst>(instruction) || isa<CallInst>(instruction)) {

        // NOTE: changed 'instruction' to '&*instruction'
        std::string varName = determineVariableName_static(&*instruction, isGlobalVariable, false, "");

        if (isGlobalVariable) // add it if it is a global variable in the
                              // program
        {
          programGlobalVariablesSet.insert(varName);
        }

        if (variableToBBMap.find(varName) != variableToBBMap.end()) {
          // this var has already once recordded. check for bb id
          if (variableToBBMap[varName] != *bb) {
            // global variable found. Insert into the globalVariablesSet
            globalVariablesSet.insert(varName);
          }
        } else {
          // record usage of the variable.
          variableToBBMap.insert(std::pair<std::string, BasicBlock *>(varName, *bb));
        }
      }
    }
  }
}
