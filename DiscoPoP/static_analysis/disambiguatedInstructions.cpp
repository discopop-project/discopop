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


// collect loops in the given function and return the listof loop ids
// Ignores nesting
std::vector<int32_t> get_loopIDs_in_function_body(Function &F){
  std::vector<int32_t> loop_ids;
  for (Function::iterator FI = F.begin(), FE = F.end(); FI != FE; ++FI) {
    BasicBlock &BB = *FI;
    for (BasicBlock::iterator BI = BB.begin(), E = BB.end(); BI != E; ++BI) {
      auto instruction = &*BI;
      if(isa<CallInst>(instruction)){
        auto ci = cast<CallInst>(BI);
        Function* F = ci->getCalledFunction();
        if(F){
          auto fn = F->getName();
          if (fn.find("__dp_loop_entry") != string::npos) // avoid instrumentation calls
          {
            // get id of entered loop
            if (llvm::ConstantInt* CI = dyn_cast<llvm::ConstantInt>(ci->getArgOperand(1))) {
              // operand is a ConstantInt, we can use CI here
              int32_t loop_id;
              if (CI->getBitWidth() <= 32) {
                loop_id = CI->getSExtValue();
              }
              loop_ids.push_back(loop_id);
            }
            else {
              // operand was not a ConstantInt
            }

          }
        }
      }
    }
  }
  return loop_ids;
}

// builds a call tree for the given Module on the basis of the statically available information
StaticCalltree DiscoPoP::buildStaticCalltree(Module &M) {
  StaticCalltree calltree;
  for (Function &F : M) {
    // DEBUG
    cout << "DBG: Function: " << F.getName().str() << " Loops: " << get_loopIDs_in_function_body(F).size() << "\n";
    // !DEBUG

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
          // register CallInstruction Node in StaticCalltree
          MDNode* md = BI->getMetadata("dp.md.instr.id");
          if(md){
            // Metadata exists
            std::string callInstructionID_str = cast<MDString>(md->getOperand(0))->getString().str();
            callInstructionID_str.erase(0, 15);
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
  return calltree;
}



// create a complete list of callpaths and intermediate states based on the static call tree of the module
// and assign unique identifiers to every state
std::vector<std::vector<StaticCalltreeNode*>> DiscoPoP::enumerate_paths(StaticCalltree& calltree){
  std::cout << "Enumerating Paths...\n";
  std::vector<std::vector<StaticCalltreeNode*>> paths;
  // select entry nodes
  std::vector<StaticCalltreeNode*> entry_nodes;
  for(auto pair: calltree.function_map){
    if(pair.second->predecessors.size() == 0){
      entry_nodes.push_back(pair.second);
    }
  }
  // show entry nodes
  std::cout << "Entry nodes:\n";
  for(auto node_ptr: entry_nodes){
    std::cout << "--> " << node_ptr->get_label() << "\n";
  }
  // traverse the static calltree to build the paths
  std::stack<std::vector<StaticCalltreeNode*>> stack;
  // -> initialize
  for(auto node_ptr: entry_nodes){
    std::vector<StaticCalltreeNode*> v;
    v.push_back(node_ptr);
    stack.push(v);
  }
  // -> process stack
  while(!stack.empty()){
    auto current_path = stack.top();
    stack.pop();
    paths.push_back(current_path);
    for(auto succ: current_path.back()->successors){
      // check for cycles
      if(std::find(current_path.begin(), current_path.end(), succ) != current_path.end()){
        // already contained in current_path
        std::cout << "FOUND CYCLE!\n";
        continue;
      }
      auto tmp_path = current_path;
      tmp_path.push_back(succ);
      stack.push(tmp_path);
    }
  }

  // print paths
  std::cout << "PATH lengths:\n";
  for(auto p: paths){
    std::string path_str = "";
    for(auto node_ptr: p){
      path_str += node_ptr->get_label() + "-->";
    }
    std::cout << path_str << "\n";
  }


  return paths;
}

void DiscoPoP::save_enumerated_paths(std::vector<std::vector<StaticCalltreeNode*>> paths){
  for(auto path: paths){
    // construct path string
    std::string path_str = "";
    for(auto node_ptr: path){
      path_str += node_ptr->get_label() + "-->";
    }
    // save path string to file
    *stateID_to_callpath_file << to_string(unique_callpath_state_id++) << " " << path_str << "\n";
  }
}


// prepare a lookup table for every state in the static call tree to allow transitions between states in constant time
// Keys of the lookup tables should be the instructionIDs of call instructions.

// prepare a lookup table to map from a unique instructionID and the current state pointer to the disambiguatedInstructionID, i.e.
// the instruction indentifier, that also encodes the call path taken to execute the instruction
