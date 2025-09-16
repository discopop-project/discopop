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
// Encodes nesting via inner vectors
std::vector<std::vector<int32_t>> get_loopIDs_in_function_body(Function &F){
  std::vector<std::vector<int32_t>> nested_loop_ids;
  std::vector<int32_t> loop_ids;
  int32_t nesting_counter = 0;

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
              nesting_counter++;
            }
            else {
              // operand was not a ConstantInt
            }

          }
          else{
            if (fn.find("__dp_loop_exit") != string::npos) // avoid instrumentation calls
            {
              nesting_counter--;
              if(nesting_counter == 0){
                nested_loop_ids.push_back(loop_ids);
                std::vector<int32_t> tmp;
                loop_ids = tmp;
              }
            }
          }
        }
      }
    }
  }

  // DEBUG
  cout << "Nested loop ids:\n";
  for(auto entry: nested_loop_ids){
    cout << "--> ";
    for(auto inner: entry){
      cout << inner << " ";
    }
    cout << "\n";
  }

  // !DEBUG

  return nested_loop_ids;
}

// returns all combinations of allowed loop iteration counters for the given loop ids
// contained in the parent function
std::vector<std::vector<int32_t>> get_loop_iteration_instances(std::vector<std::vector<int32_t>> contained_loops){
  std::vector<std::vector<int32_t>> loop_iteration_instances;

    // initialize
    std::vector<int32_t> init_vector;
    for(auto outer: contained_loops){
      for(auto inner: outer){
        init_vector.push_back(0);
      }
    }
    int32_t loop_count = init_vector.size();

//    if(init_vector.size() > 0){
//      loop_iteration_instances.push_back(init_vector);
//    }


    // instantiate loop iterations
    int32_t offset = 0;
    for(auto outer : contained_loops){
      // fill base state with don't cares
      std::vector<int32_t> base_state;
      for(int i = 0; i < loop_count; ++i){
        base_state.push_back(3);
      }

      // create instances
      std::vector<std::vector<int32_t>> instances;
      instances.push_back(base_state);
      for(auto inner: outer){
        std::vector<std::vector<int32_t>> new_instances;
        for(auto instance: instances){
          // "iteration index '3', i.e. dont care already represented by initialization
          auto instance_copy_0 = instance;
          auto instance_copy_1 = instance;
          auto instance_copy_2 = instance;
          instance_copy_0[offset] = 0;
          instance_copy_1[offset] = 1;
          instance_copy_2[offset] = 2;
          new_instances.push_back(instance_copy_0);
          new_instances.push_back(instance_copy_1);
          new_instances.push_back(instance_copy_2);
        }
        for(auto instance_vector: new_instances){
          instances.push_back(instance_vector);
        }
        offset++;
      }
      for(auto instance_vector: instances){
        // only push "interesting" states, i.e., such, that contain not only don't cares
        for(auto elem: instance_vector){
          if(elem != 3){
            loop_iteration_instances.push_back(instance_vector);
            break;
          }
        }
      }

/*
      for(auto inner: outer){



        std::vector<std::vector<int32_t>> new_instances;
        for(auto instance: loop_iteration_instances){
          // "iteration index '0'" already represented by initialization
          auto instance_copy_1 = instance;
          auto instance_copy_2 = instance;
          instance_copy_1[offset] = 1;
          instance_copy_2[offset] = 2;
          new_instances.push_back(instance_copy_1);
          new_instances.push_back(instance_copy_2);
        }
        for(auto instance_vector: new_instances){
          loop_iteration_instances.push_back(instance_vector);
        }
        offset++;
      }

*/
    }

    // DEBUG
    cerr << "States: " << "\n";
    for(auto outer_entry: loop_iteration_instances){
      cerr << "---> ";
      for(auto inner_entry: outer_entry){
        cerr << inner_entry;
      }
     cerr << "\n";
    }

    // !DEBUG
    return loop_iteration_instances;
}


// returns a map from loopID to a vector of callInstructionIDs contained in the loop
std::unordered_map<int32_t, std::vector<int32_t>> get_loop_callInstruction_affectance(Function &F){
  std::unordered_map<int32_t, std::vector<int32_t>> result_map;

  std::vector<int32_t> entered_loops;

  for (Function::iterator FI = F.begin(), FE = F.end(); FI != FE; ++FI) {
    BasicBlock &BB = *FI;
    for (BasicBlock::iterator BI = BB.begin(), E = BB.end(); BI != E; ++BI) {
      auto instruction = &*BI;
      // modify entered loops if required
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
              entered_loops.push_back(loop_id);
              // DEBUG
              cout << "entered_loops:\n";
              for(auto elem: entered_loops){
                cout << "--> " << elem << "\n";
              }
              // !DEBUG
            }
            else {
              // operand was not a ConstantInt
            }
          }
          else{
            if (fn.find("__dp_loop_exit") != string::npos) // avoid instrumentation calls
            {
              int32_t loop_id;
              // get id of entered loop
              if (llvm::ConstantInt* CI = dyn_cast<llvm::ConstantInt>(ci->getArgOperand(1))) {
                // operand is a ConstantInt, we can use CI here
                if (CI->getBitWidth() <= 32) {
                  loop_id = CI->getSExtValue();
                }
                // Erase loop_id from entered loops
                for (auto it = entered_loops.begin(); it != entered_loops.end();)
                {
                    if (*it == loop_id)
                        it = entered_loops.erase(it);
                    else
                        ++it;
                }
              }
              else {
                // operand was not a ConstantInt
              }
            }
          }
        }
      }

      // register relation between loop and call instruction
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
        // Get InstructionID of callinstruction
        MDNode* md = BI->getMetadata("dp.md.instr.id");
        if(md){
          // Metadata exists
          std::string callInstructionID_str = cast<MDString>(md->getOperand(0))->getString().str();
          callInstructionID_str.erase(0, 15);
          int callInstructionID = stoi(callInstructionID_str);

          // extend map
          for(auto loop_id: entered_loops){
            if(result_map.count(loop_id) == 0){
              std::vector<int32_t> tmp;
              result_map[loop_id] = tmp;
            }
            result_map[loop_id].push_back(callInstructionID);
          }
        }
      }
    }
  }

  // DEBUG
  cout << "Loop->CallInst affectance:\n";
  for(auto pair: result_map){
    cout << "--> " << pair.first << "\n";
    for(auto call_inst_id: pair.second){
      cout << "-----> " << call_inst_id << "\n";
    }
  }
  // !DEBUG

  return result_map;
}

// inverts the given map. Returns a map from CallInstructionID to LoopIDs which affect it.
std::unordered_map<int32_t, std::vector<int32_t>> get_inverted_loop_callInstruction_affectance(std::unordered_map<int32_t, std::vector<int32_t>> loop_call_affectance){
  std::unordered_map<int32_t, std::vector<int32_t>> result_map;
  for(auto pair: loop_call_affectance){
    auto loop_id = pair.first;
    for(auto call_inst_id: pair.second){
      if(result_map.count(call_inst_id) == 0){
        std::vector<int32_t> tmp;
        result_map[call_inst_id] = tmp;
      }
      result_map[call_inst_id].push_back(loop_id);
    }
  }

  // DEBUG
  cout << "CallInst->Loop affectance:\n";
  for(auto pair: result_map){
    cout << "--> " << pair.first << "\n";
    for(auto call_inst_id: pair.second){
      cout << "-----> " << call_inst_id << "\n";
    }
  }
  // !DEBUG

  return result_map;
}

std::vector<int32_t> sequentialize_contained_loops(std::vector<std::vector<int32_t>> contained_loops){
  std::vector<int32_t> loops;
    for(auto outer: contained_loops){
      for(auto inner: outer){
        loops.push_back(inner);
      }
    }
  return loops;
}

// builds a call tree for the given Module on the basis of the statically available information
StaticCalltree DiscoPoP::buildStaticCalltree(Module &M) {
  StaticCalltree calltree;
  for (Function &F : M) {
    cerr << "Iter FUNC..." << F.getName().str() << "\n";
    // get loops contained in F
    cerr << "DBG: Function: " << F.getName().str() << " getting loop ids..." << "\n";
    auto contained_loops = get_loopIDs_in_function_body(F);
    auto sequentialized_contained_loops = sequentialize_contained_loops(contained_loops);
    // DEBUG
    cerr << "DBG: Function: " << F.getName().str() << " Loops: " << contained_loops.size() << "\n";
    // !DEBUG

    // for each loop, allow 3 values to represent the currently executed iteration
    // create one instance of the function_node in the calltree per combination of iterations.
    // In case of 4 contained loops, this creates 4^3=64 nodes for the function F.
    // The value 3 is chosen to keep the amount of total states somewhat concise, while still allowing to distinguish between
    // intra- and inter-iteration dependencies with a comparatively high probability.
    // Valid Iteration counters are 0, 1, and 2. A value of 3 acts as a "dont care" symbol.
    // --> calculate iteration instances and thus the amount of states
    cerr << "DBG: " << "getting loop iteration instances... contained loops: " << contained_loops.size() << "\n";
    auto iteration_instances = get_loop_iteration_instances(contained_loops);
    cerr << "DBG: " << "Done... size: " << iteration_instances.size() << "\n";

    // create StaticCalltreeNode instances for function F
    std::vector<StaticCalltreeNode*> function_node_instances;

    StaticCalltreeNode* original_function_node_ptr = calltree.get_or_insert_function_node(F.getName().str());
    //function_node_instances.push_back(original_function_node_ptr);

    cerr << "Create inst.. : " << iteration_instances.size() << "\n";


    std::unordered_map<int32_t, std::vector<StaticCalltreeNode*>> loop_activity_map;
    for(auto instance: iteration_instances){
      StaticCalltreeNode* function_node_ptr = calltree.get_or_insert_function_node(F.getName().str(), instance);
      function_node_instances.push_back(function_node_ptr);
      calltree.addEdge(original_function_node_ptr, function_node_ptr);

      // register loop activity for later use (loop active, if iteration count != 3 (i.e. don't care))
      for(int idx = 0; idx < instance.size(); ++idx){
        if(instance[idx] != 3){
          // get loop id from position via lookup in sequentialized_contained_loops
          auto active_loop_id = sequentialized_contained_loops[idx];
          if(loop_activity_map.count(active_loop_id) == 0){
            std::vector<StaticCalltreeNode*> tmp;
            loop_activity_map[active_loop_id] = tmp;
          }
          loop_activity_map[active_loop_id].push_back(function_node_ptr);
        }
      }
    }
    cerr << "Done\n";

    // get connection between loops and called functions inside the loops
    cerr << "Get loop call affectance..\n";
    auto loop_call_affectance = get_loop_callInstruction_affectance(F);
    auto inverted_loop_call_affectance = get_inverted_loop_callInstruction_affectance(loop_call_affectance);


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
            int32_t callInstructionID = stoi(callInstructionID_str);
            StaticCalltreeNode* callInstructionNode_ptr = calltree.get_or_insert_instruction_node(callInstructionID);
            calltree.addEdge(original_function_node_ptr, callInstructionNode_ptr);
            // connect to nodes if the loop contains the call and the loop is "active"
            auto parent_loops = inverted_loop_call_affectance[callInstructionID];
            for(auto parent_loop_id : parent_loops){
              for(auto node_ptr: loop_activity_map[parent_loop_id]){
                calltree.addEdge(node_ptr, callInstructionNode_ptr);
              }
            }
            StaticCalltreeNode* calleeNode_ptr = calltree.get_or_insert_function_node(F->getName().str());
            calltree.addEdge(callInstructionNode_ptr, calleeNode_ptr);
          }
        }
      }
    }
    cerr << "Done Iter func...\n";
  }
//  calltree.printToDOT();
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

  // DEBUG
  // print paths
/*
  std::cout << "PATH lengths:\n";
  for(auto p: paths){
    std::string path_str = "";
    for(auto node_ptr: p){
      path_str += node_ptr->get_label() + "-->";
    }
    std::cout << path_str << "\n";
  }
*/
  // !DEBUG


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
