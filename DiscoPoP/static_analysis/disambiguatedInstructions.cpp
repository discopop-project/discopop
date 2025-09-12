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

#include "../DiscoPoP.hpp"

// builds a call tree for the given Module on the basis of the statically available information
void DiscoPoP::buildStaticCalltree(Module &M) {
  StaticCalltree calltree;

  for (Function &F : M) {
    StaticCalltreeNode* function_node_ptr = calltree.get_or_insert_function_node(F.getName().str());
    for (Function::iterator FI = F.begin(), FE = F.end(); FI != FE; ++FI) {
      BasicBlock &BB = *FI;
      for (BasicBlock::iterator BI = BB.begin(), E = BB.end(); BI != E; ++BI) {
        auto instruction = &*BI;
        Function *F = nullptr;
        if(isa<CallInst>(BI)){
          F = (cast<CallInst>(BI))->getCalledFunction();
        }
        else if(isa<InvokeInst>(BI)){
          F = (cast<InvokeInst>(BI))->getCalledFunction();
        }
        // check if a call was encountered
        if (F) {
          // ignore instrumentation functions
          auto fn = F->getName();
          if (fn.find("__dp_") != string::npos) // avoid instrumentation calls
          {
            continue;
          }
          if (fn.find("__clang_") != string::npos) // clang helper calls
          {
            continue;
          }
          if (fn.find("llvm.dbg.declare") != string::npos) // llvm debug helper calls
          {
            continue;
          }
          cout << "called: " << F->getName().str() << "\n";
          // register CallInstruction Node in StaticCalltree
          MDNode* md = BI->getMetadata("dp.md.instr.id");
          if(md){
            // Metadata exists
            std::string callInstructionID_str = cast<MDString>(md->getOperand(0))->getString().str();
            cout << "Metadata: ID: " << callInstructionID_str << "\n";
            callInstructionID_str.erase(0, 15);
            cout << "--> cleaned ID: " << callInstructionID_str << "\n";
            int callInstructionID = stoi(callInstructionID_str);
            StaticCalltreeNode* callInstructionNode_ptr = calltree.get_or_insert_instruction_node(callInstructionID);
            calltree.addEdge(function_node_ptr, callInstructionNode_ptr);
            StaticCalltreeNode* calleeNode_ptr = calltree.get_or_insert_function_node(F->getName().str());
            calltree.addEdge(callInstructionNode_ptr, calleeNode_ptr);
          }
        }
      }
    }
  }
  calltree.printToDOT();
}


// create a complete list of callpaths and intermediate states based on the static call tree of the module
// and assign unique identifiers to every state



// prepare a lookup table for every state in the static call tree to allow transitions between states in constant time
// Keys of the lookup tables should be the instructionIDs of call instructions.

// prepare a lookup table to map from a unique instructionID and the current state pointer to the disambiguatedInstructionID, i.e.
// the instruction indentifier, that also encodes the call path taken to execute the instruction
